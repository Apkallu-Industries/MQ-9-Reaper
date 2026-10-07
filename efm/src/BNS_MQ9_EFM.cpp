// BNS MQ-9A Reaper external flight model (ED wHumanCustomPhysicsAPI). Derived from the BNS B-2 EFM.
// Body axes (DCS): x forward, y up, z right. Angular rates: omega.x roll (+ right wing down), omega.y yaw
// (+ nose left), omega.z pitch (+ nose up). Moments use the same senses.
// One TPE331 turboprop driving a pusher propeller; V-tail ruddervators mixed into pitch and yaw. The ground control
// station flies it through the flight control computer, modelled as pitch-rate command / attitude hold with alpha and
// g limits, roll-rate command / bank hold, and a yaw damper with sideslip suppression. Data and sources: mq9_data.h.
#include <windows.h>
#include <cmath>
#include <cstdio>
#include <cstdarg>
#include <string>
#include "FM/wHumanCustomPhysicsAPI.h"
#include "mq9_data.h"

#define EXP extern "C" __declspec(dllexport)
using namespace mq9;

namespace {
struct V3 { double x = 0, y = 0, z = 0; };
V3 v3(double x, double y, double z) { V3 v; v.x = x; v.y = y; v.z = z; return v; }
double clampd(double v, double a, double b) { return v < a ? a : (v > b ? b : v); }
double approach(double v, double target, double up, double dn, double dt) {
    return v < target ? std::fmin(target, v + up * dt) : std::fmax(target, v - dn * dt);
}

struct Engine {
    bool on = false, starting = false; double start_t = 0;
    double thr = 0;          // power lever 0 idle .. 1 max
    double p = 0;            // power state, fraction of P0
    double rpm = 0, power = 0, thrust = 0, ff = 0, phase = 0;
    double health = 1.0;
};

struct State {
    double rho = 1.225, a = 340.3, alt = 0, h_agl = 100, pres = 101325, tempK = 288.15;
    V3 v_body, wind_body, omega; double pitch = 0, roll = 0, yaw = 0;
    double mass = 4500, Ix = 7.3e4, Iy = 9.3e4, Iz = 2.2e4; V3 cg;
    double pitch_in = 0, roll_in = 0, yaw_in = 0; int p_disc = 0, r_disc = 0, y_disc = 0;
    bool p_an = true, r_an = true, y_an = true;
    double wb_l = 0, wb_r = 0, wb_both = 0;
    Engine eng;
    double gear = 1, gear_cmd = 1, flap = 0, flap_cmd = 0;
    double fuel = 1000, burnt = 0; bool unlimited = false;
    double de = 0, da = 0, dr = 0, iq = 0, ip = 0;
    double V = 0, M = 0, alpha = 0, beta = 0, qbar = 0, nz = 1, CL = 0, CD = 0;
    V3 F, Mo;
    double wing_l = 1, wing_r = 1, ail_l = 1, ail_r = 1, tail = 1; bool damaged = false, immortal = false;
};
State st;

FILE* g_log = nullptr; double g_log_t = 0; std::string g_path = ".";
void logf(const char* f, ...) {
    if (!g_log) {
        char buf[MAX_PATH]; std::string p;
        if (GetEnvironmentVariableA("BNS_EFM_LOG", buf, MAX_PATH)) p = buf;               // the offline rig sets this
        else if (GetEnvironmentVariableA("USERPROFILE", buf, MAX_PATH)) p = std::string(buf) + "\\Saved Games\\DCS\\Logs\\BNS_MQ9_EFM.log";
        else p = "BNS_MQ9_EFM.log";
        g_log = std::fopen(p.c_str(), "w"); if (!g_log) g_log = std::fopen("BNS_MQ9_EFM.log", "w"); if (!g_log) return;
    }
    va_list ap; va_start(ap, f); std::vfprintf(g_log, f, ap); va_end(ap); std::fputc('\n', g_log); std::fflush(g_log);
}

// ---- engine and propeller: power flat-rated to FLAT_RATE_SIGMA, then falling with density [EST];
//      thrust = efficiency * power / V, capped by momentum-theory static thrust
void engine(double dt) {
    Engine& e = st.eng;
    double sigma = st.rho / 1.225;
    if (e.health < 0.25 && e.on) { e.on = false; e.starting = false; logf("engine failed (damage)"); }
    if (e.starting) {
        e.start_t += dt; e.rpm = 0.7 * PROP_RPM * clampd(e.start_t / START_TIME, 0, 1);
        if (e.start_t >= START_TIME) { e.starting = false; e.on = true; e.p = IDLE_POWER; logf("engine running"); }
        e.power = e.thrust = 0; e.ff = 0.002;
    } else if (!e.on) {
        e.p = approach(e.p, 0, 0, 0.5, dt); e.rpm = approach(e.rpm, 0, 0, 100.0, dt); e.power = e.thrust = e.ff = 0;
    } else {
        double target = IDLE_POWER + (1.0 - IDLE_POWER) * clampd(e.thr, 0, 1);
        e.p = approach(e.p, target, POWER_RATE, POWER_RATE, dt);
        e.rpm = PROP_RPM * (0.7 + 0.3 * clampd((e.p - IDLE_POWER) / (1 - IDLE_POWER), 0, 1));
        double avail = std::fmin(1.0, sigma / FLAT_RATE_SIGMA);
        e.power = e.p * P0 * avail * e.health;
        double A = PI * PROP_D * PROP_D / 4.0;
        double t_static = 0.8 * std::cbrt(e.power * e.power * 2.0 * st.rho * A);
        double V = std::fmax(st.V, 1.0);
        e.thrust = std::fmin(t_static, PROP_ETA * e.power / V);
        // part-power fuel flow on a Willans line: BSFC is the rated-point figure, and a gas turbine still burns
        // FF_ZERO of its rated flow at zero shaft power, so specific consumption rises as power comes back
        double rated_shp = P0 * avail / 745.7;
        double pf = rated_shp > 0 ? e.power / (P0 * avail) : 0.0;
        e.ff = std::fmax(0.004, rated_shp * BSFC / 2.2046 / 3600.0 * (FF_ZERO + (1.0 - FF_ZERO) * pf));   // kg/s
    }
    e.phase = std::fmod(e.phase + e.rpm / 60.0 * dt, 1.0);
}
void start_eng() { Engine& e = st.eng; if (!e.on && !e.starting && e.health >= 0.25) { e.starting = true; e.start_t = 0; } }
void stop_eng() { st.eng.on = false; st.eng.starting = false; }

double g_comp[3] = {0, 0, 0};
bool on_ground() { return g_comp[0] > 0.005 || g_comp[1] > 0.005 || g_comp[2] > 0.005; }
double g_roll_hold = 0; bool g_roll_holding = false;

void sim(double dt) {
    V3 va = v3(st.v_body.x - st.wind_body.x, st.v_body.y - st.wind_body.y, st.v_body.z - st.wind_body.z);
    st.V = std::sqrt(va.x * va.x + va.y * va.y + va.z * va.z);
    st.M = st.V / std::fmax(st.a, 1.0);
    st.alpha = std::atan2(-va.y, std::fmax(va.x, 0.1));
    st.beta = st.V > 1 ? std::asin(clampd(va.z / st.V, -1, 1)) : 0;
    st.qbar = 0.5 * st.rho * st.V * st.V;
    const double V = std::fmax(st.V, 5.0), q = st.qbar;
    const double p = st.omega.x, r = st.omega.y, qr = st.omega.z;
    const double phat = p * B / (2 * V), rhat = r * B / (2 * V), qhat = qr * CBAR / (2 * V);

    if (on_ground() && st.gear_cmd < 0.5) st.gear_cmd = 1;            // squat switch
    st.gear = approach(st.gear, st.gear_cmd, 1.0 / 8.0, 1.0 / 8.0, dt);
    st.flap = approach(st.flap, st.flap_cmd, 1.0 / 6.0, 1.0 / 6.0, dt);
    engine(dt);

    // ---- flight control computer
    double stick_p = st.p_an ? st.pitch_in : st.p_disc;
    double stick_r = st.r_an ? st.roll_in : st.r_disc;
    double pedal = st.y_an ? st.yaw_in : st.y_disc;
    const double tail = st.tail, ail = 0.5 * (st.ail_l + st.ail_r);
    if (on_ground() && st.V < 30.0) {                                  // ground: direct law
        st.de = clampd(stick_p, -1, 1); st.da = clampd(stick_r, -1, 1); st.iq = st.ip = 0; g_roll_holding = false;
    } else if (q > 20) {
        double q_cmd = stick_p * Q_CMD_MAX;
        q_cmd = std::fmin(q_cmd, 4.0 * (ALPHA_LIMIT - st.alpha));      // alpha limiter
        if (st.nz > NZ_MAX) q_cmd = std::fmin(q_cmd, -0.3 * (st.nz - NZ_MAX));
        double kz = q * S * CBAR / st.Iz, be = kz * CM_DE * std::fmax(tail, 0.1);
        double e = q_cmd - qr;
        double de = (3.0 * e + st.iq - kz * (CMA * st.alpha + CMQ * qhat + CM0)) / be;
        if (std::fabs(de) < 1.0) st.iq += 2.0 * e * dt;
        st.de = clampd(de, -1, 1);
        double p_cmd = stick_r * P_CMD_MAX;
        if (std::fabs(stick_r) < 0.02) {
            if (!g_roll_holding) { g_roll_holding = true; g_roll_hold = std::fabs(st.roll) < 5 * D2R ? 0.0 : st.roll; }
            p_cmd = clampd(-0.8 * (st.roll - g_roll_hold), -0.15, 0.15);
        } else g_roll_holding = false;
        double kx = q * S * B / st.Ix, ba = kx * CL_DA * std::fmax(ail, 0.1);
        double ep = p_cmd - p;
        double da = (4.0 * ep + st.ip - kx * ((CLB0 + CLB_CL * st.CL) * st.beta + CLP * phat)) / ba;
        if (std::fabs(da) < 1.0) st.ip += 1.5 * ep * dt;
        st.da = clampd(da, -1, 1);
    }
    st.dr = clampd(pedal + 2.0 * st.beta + 0.5 * r, -1, 1);

    // ---- aerodynamics
    double pg = 1.0 / std::sqrt(1.0 - std::pow(std::fmin(st.M, 0.7), 2));
    double cla = CLA * pg, clmax = CL0 + cla * ALPHA_STALL;
    double a = st.alpha, CL;
    if (a > ALPHA_STALL) CL = std::fmax(0.6 * clmax, clmax - 2.0 * (a - ALPHA_STALL));
    else if (a < -0.6 * ALPHA_STALL) CL = std::fmin(-0.4, CL0 - cla * 0.6 * ALPHA_STALL + 2.0 * (-0.6 * ALPHA_STALL - a));
    else CL = CL0 + cla * a;
    CL += CL_DE * st.de * tail + CL_FLAP * st.flap;
    const double wing = 0.5 * (st.wing_l + st.wing_r);
    CL *= wing;
    double hb = std::fmax(st.h_agl, 0.0) / B, ge = (16 * hb) * (16 * hb), phi = ge / (1 + ge);
    double CD = CD0 + phi * CL * CL / (PI * AR * OSWALD) + CD_GEAR * st.gear + CD_FLAP * st.flap
              + (st.eng.on ? 0.0 : CD_PROP_STOPPED) + 0.04 * (2.0 - st.wing_l - st.wing_r) + 0.02 * (1.0 - tail);
    if (std::fabs(a) > ALPHA_STALL) CD += 1.0 * std::pow(std::sin(a), 2);
    st.CL = CL; st.CD = CD;

    V3 F, Mo;
    if (st.V > 3) {
        double L = q * S * CL, D = q * S * CD, Y = q * S * CYB * st.beta * tail;
        F.x = L * std::sin(a) - D * va.x / st.V;
        F.y = L * std::cos(a) - D * va.y / st.V;
        F.z = Y - D * va.z / st.V;
        Mo.x = q * S * B * ((CLB0 + CLB_CL * CL) * st.beta + CLP * phat + CL_DA * st.da * ail - CLR_CL * CL * rhat)
             + 0.5 * q * S * CL * (st.wing_l - st.wing_r) * 0.2 * B;
        Mo.y = q * S * B * (-CNB * tail * st.beta - CNR * rhat - CN_DR * st.dr * tail);
        Mo.z = q * S * CBAR * (CM0 + CMA * a + CM_DE * st.de * tail + CMQ * qhat);
    }
    st.nz = F.y / (st.mass * 9.80665);
    if (st.eng.thrust > 0) {
        double T = st.eng.thrust, ry = ENG_Y - st.cg.y, rz = ENG_Z - st.cg.z;
        F.x += T; Mo.y += rz * T; Mo.z += -ry * T;
    }
    st.F = F; st.Mo = Mo;
    if (!st.unlimited) st.burnt += st.eng.ff * dt;

    g_log_t += dt;
    if (g_log_t >= 1.0) {
        g_log_t = 0;
        logf("V %.1f a %.1f b %.1f nz %.2f CL %.3f CD %.4f de %+.2f da %+.2f dr %+.2f gear %.2f flap %.2f "
             "P %.0f kW T %.0f N rpm %.0f ff %.1f kg/h fuel %.0f agl %.1f wow %d%d%d",
             st.V, a / D2R, st.beta / D2R, st.nz, CL, CD, st.de, st.da, st.dr, st.gear, st.flap,
             st.eng.power / 1000, st.eng.thrust, st.eng.rpm, st.eng.ff * 3600, st.fuel, st.h_agl,
             g_comp[0] > 0.005, g_comp[1] > 0.005, g_comp[2] > 0.005);
    }
}
} // namespace

// ==================================================================================== DCS entry points
EXP void ed_fm_simulate(double dt) { if (dt > 0 && dt < 1.0) sim(dt); }
EXP void ed_fm_add_local_force(double& x, double& y, double& z, double& px, double& py, double& pz) {
    x = st.F.x; y = st.F.y; z = st.F.z; px = st.cg.x; py = st.cg.y; pz = st.cg.z;
}
EXP void ed_fm_add_local_moment(double& x, double& y, double& z) { x = st.Mo.x; y = st.Mo.y; z = st.Mo.z; }
EXP void ed_fm_add_global_force(double& x, double& y, double& z, double& px, double& py, double& pz) { x = y = z = 0; px = py = pz = 0; }
EXP void ed_fm_add_global_moment(double& x, double& y, double& z) { x = y = z = 0; }
EXP bool ed_fm_add_local_force_component(double&, double&, double&, double&, double&, double&) { return false; }
EXP bool ed_fm_add_global_force_component(double&, double&, double&, double&, double&, double&) { return false; }
EXP bool ed_fm_add_local_moment_component(double&, double&, double&) { return false; }
EXP bool ed_fm_add_global_moment_component(double&, double&, double&) { return false; }
EXP void ed_fm_set_atmosphere(double h, double t, double a, double ro, double p, double, double, double) {
    st.alt = h; st.tempK = t; st.a = a; st.rho = ro; st.pres = p;
}
EXP void ed_fm_set_surface(double h, double h_obj, unsigned, double, double, double) { st.h_agl = st.alt - std::fmax(h, h_obj); }
EXP void ed_fm_set_clouds_density(const atmo_clouds_and_precipation&) {}
EXP void ed_fm_set_current_mass_state(double mass, double cx, double cy, double cz, double ix, double iy, double iz) {
    st.mass = mass; st.cg = v3(cx, cy, cz);
    if (ix > 1) st.Ix = ix; if (iy > 1) st.Iy = iy; if (iz > 1) st.Iz = iz;
}
EXP void ed_fm_set_current_state(double, double, double, double, double, double, double, double, double,
                                 double, double, double, double, double, double, double, double, double, double) {}
EXP void ed_fm_set_current_state_body_axis(double, double, double, double vx, double vy, double vz,
                                           double wvx, double wvy, double wvz, double, double, double,
                                           double ox, double oy, double oz, double yaw, double pitch, double roll,
                                           double, double) {
    st.v_body = v3(vx, vy, vz); st.wind_body = v3(wvx, wvy, wvz); st.omega = v3(ox, oy, oz);
    st.yaw = yaw; st.pitch = pitch; st.roll = roll;
}
EXP void ed_fm_suspension_feedback(int idx, const ed_fm_suspension_info* info) {
    if (idx < 0 || idx > 2 || !info) return;
    g_comp[idx] = info->struct_compression;
}

EXP void ed_fm_set_command(int command, float value) {
    switch (command) {
    case 2001: st.pitch_in = clampd(value, -1, 1); st.p_an = true; break;
    case 2002: st.roll_in = clampd(value, -1, 1); st.r_an = true; break;
    case 2003: st.yaw_in = clampd(value, -1, 1); st.y_an = true; break;
    case 195: st.p_disc = 1; st.p_an = false; break;   case 196: st.p_disc = 0; break;
    case 193: st.p_disc = -1; st.p_an = false; break;  case 194: st.p_disc = 0; break;
    case 197: st.r_disc = -1; st.r_an = false; break;  case 198: st.r_disc = 0; break;
    case 199: st.r_disc = 1; st.r_an = false; break;   case 200: st.r_disc = 0; break;
    case 201: st.y_disc = -1; st.y_an = false; break;  case 202: st.y_disc = 0; break;
    case 203: st.y_disc = 1; st.y_an = false; break;   case 204: st.y_disc = 0; break;
    case 93: case 94: case 95: case 96: case 97: case 98: case 99: break;   // the FCC trims itself
    case 2004: case 2005: case 2006: st.eng.thr = clampd(0.5 * (1.0 - value), 0, 1); break;
    case 1032: st.eng.thr = clampd(st.eng.thr + 0.05, 0, 1); break;
    case 1033: st.eng.thr = clampd(st.eng.thr - 0.05, 0, 1); break;
    case 309: case 311: case 312: start_eng(); logf("ENGINE START"); break;
    case 310: case 313: case 314: stop_eng(); logf("ENGINE STOP"); break;
    case 68: st.gear_cmd = st.gear_cmd > 0.5 ? 0.0 : 1.0; break;
    case 430: st.gear_cmd = 0.0; break;   case 431: st.gear_cmd = 1.0; break;
    case 72: st.flap_cmd = st.flap_cmd > 0.25 ? 0.0 : 1.0; break;
    case 145: st.flap_cmd = 0.0; break;   case 146: st.flap_cmd = 1.0; break;
    case 74: st.wb_both = 1.0; break;     case 75: st.wb_both = 0.0; break;
    case 961: st.wb_l = 1.0; break;       case 962: st.wb_l = 0.0; break;
    case 963: st.wb_r = 1.0; break;       case 964: st.wb_r = 0.0; break;
    case 2111: st.wb_l = clampd(0.5 * (1.0 + value), 0, 1); break;
    case 2112: st.wb_r = clampd(0.5 * (1.0 + value), 0, 1); break;
    default: break;
    }
}

EXP bool ed_fm_change_mass(double& dm, double& x, double& y, double& z, double& ix, double& iy, double& iz) {
    if (st.burnt > 0.0) {
        double b = std::fmin(st.burnt, st.fuel); st.burnt = 0.0;
        if (b <= 0.0) return false;
        st.fuel -= b; dm = b;
        x = st.cg.x; y = st.cg.y; z = st.cg.z; ix = iy = iz = 0;
        return true;
    }
    return false;
}
EXP void   ed_fm_set_internal_fuel(double fuel) { st.fuel = fuel; logf("internal fuel set %.0f kg", fuel); }
EXP double ed_fm_get_internal_fuel() { return st.fuel; }
EXP void   ed_fm_refueling_add_fuel(double fuel) { st.fuel = std::fmin(FUEL_MAX, st.fuel + fuel); }
EXP void   ed_fm_set_external_fuel(int, double, double, double, double) {}
EXP double ed_fm_get_external_fuel() { return 0.0; }
EXP void   ed_fm_unlimited_fuel(bool v) { st.unlimited = v; }
EXP void   ed_fm_set_easy_flight(bool) {}
EXP void   ed_fm_set_immortal(bool v) { st.immortal = v; }

// ---- damage, by the DCS cell numbers of the names MQ-9.lua uses (Scripts\Aircrafts\_Common\Damage.lua):
//      ROTOR 63 (propeller / engine), WING_x_IN 35/36, WING_x_CENTER 29/30, WING_x_OUT 23/24, AILERON_x 25/26,
//      ELEVATOR_x_IN/OUT 51/52/49/50, RUDDER 53, RUDDER_R 54 (the V-tail surfaces)
EXP void ed_fm_on_damage(int element, double integrity) {
    if (st.immortal) return;
    double h = clampd(integrity, 0, 1);
    switch (element) {
    case 63: case 11: st.eng.health = std::fmin(st.eng.health, h); break;
    case 35: st.wing_l = std::fmin(st.wing_l, 0.4 + 0.6 * h); break;
    case 29: st.wing_l = std::fmin(st.wing_l, 0.6 + 0.4 * h); break;
    case 23: st.wing_l = std::fmin(st.wing_l, 0.8 + 0.2 * h); break;
    case 36: st.wing_r = std::fmin(st.wing_r, 0.4 + 0.6 * h); break;
    case 30: st.wing_r = std::fmin(st.wing_r, 0.6 + 0.4 * h); break;
    case 24: st.wing_r = std::fmin(st.wing_r, 0.8 + 0.2 * h); break;
    case 25: st.ail_l = h; break;  case 26: st.ail_r = h; break;
    case 49: case 50: case 51: case 52: case 53: case 54: st.tail = std::fmin(st.tail, 0.3 + 0.7 * h); break;
    default: return;
    }
    st.damaged = true;
    logf("damage cell %d integrity %.2f | wing %.2f %.2f ail %.2f %.2f tail %.2f eng %.2f",
         element, h, st.wing_l, st.wing_r, st.ail_l, st.ail_r, st.tail, st.eng.health);
}
EXP void ed_fm_repair() { st.wing_l = st.wing_r = st.ail_l = st.ail_r = st.tail = st.eng.health = 1.0; st.damaged = false; logf("repaired"); }
EXP bool ed_fm_need_to_be_repaired() { return st.damaged; }

// ---- draw args (DCS standard set, as the shell flight model drove them): flaps 9/10, ailerons 11/12,
//      ruddervators 15/16 (pitch) and 17 (yaw), propeller 407; plus the MQ-9 model's own tail args 354/355/357
EXP void ed_fm_set_draw_args(EdDrawArgument* a, size_t size) {
    auto set = [&](int i, double v) { if (i >= 0 && (size_t)i < size) a[i].f = (float)v; };
    set(9, st.flap); set(10, st.flap);
    set(11, st.da); set(12, -st.da);
    set(15, st.de); set(16, st.de); set(17, st.dr);          // DCS standard set, kept for other shapes
    // Mq-9_Reaper.EDM has no 15/16/17 nodes: its tail is keyed on 354 (right ruddervator, Dummy001/003), 355 (left,
    // Dummy005/006) and 357 (ventral rudder, Dummy018), each +/-15 deg about its hinge (read from the EDM on
    // 2026-10-07 with the dcs_edm_importer parser). V-tail mixing: pitch moves both ruddervators together; right
    // pedal puts the right trailing edge down and the left up, and moves the ventral rudder. The key sign of each
    // node against "trailing edge up" is not readable without the node's world frame: RV_SIGN / VR_SIGN are
    // ESTIMATED, flip them if the surfaces move the wrong way in DCS (test card: stick aft, right pedal).
    constexpr double RV_SIGN = 1.0, VR_SIGN = 1.0;
    set(354, RV_SIGN * clampd(st.de - st.dr, -1, 1));
    set(355, RV_SIGN * clampd(st.de + st.dr, -1, 1));
    set(357, VR_SIGN * st.dr);
    set(407, st.eng.phase);
}

EXP double ed_fm_get_param(unsigned i) {
    const unsigned blk = ED_FM_ENGINE_1_RPM - ED_FM_ENGINE_0_RPM;
    if (i < ED_FM_END_ENGINE_BLOCK) {
        unsigned n = i / blk, k = i % blk + blk;
        if (n != 1) return 0.0;
        const Engine& e = st.eng;
        switch (k) {
        case ED_FM_ENGINE_1_RPM: case ED_FM_ENGINE_1_CORE_RPM: return e.rpm;
        case ED_FM_ENGINE_1_RELATED_RPM: case ED_FM_ENGINE_1_CORE_RELATED_RPM: return e.rpm / PROP_RPM;
        case ED_FM_PROPELLER_1_RPM: return e.rpm;
        case ED_FM_PROPELLER_1_INTEGRITY_FACTOR: return e.health;
        case ED_FM_ENGINE_1_THRUST: case ED_FM_ENGINE_1_CORE_THRUST: return e.thrust;
        case ED_FM_ENGINE_1_RELATED_THRUST: case ED_FM_ENGINE_1_CORE_RELATED_THRUST: return e.power / P0;
        case ED_FM_ENGINE_1_TEMPERATURE: return e.on ? 450.0 + 400.0 * e.p : 20.0;   // [EST] deg C
        case ED_FM_ENGINE_1_OIL_PRESSURE: return e.on ? 4.0e5 : 0.0;
        case ED_FM_ENGINE_1_FUEL_FLOW: return e.ff;
        case ED_FM_ENGINE_1_COMBUSTION: return e.on ? 1.0 : 0.0;
        case ED_FM_ENGINE_1_TORQUE: return e.rpm > 1 ? e.power / (e.rpm * 2 * PI / 60.0) : 0.0;
        case ED_FM_ENGINE_1_RELATIVE_TORQUE: return e.power / P0;
        case ED_FM_ENGINE_1_FAN_PHASE: return e.phase * 2.0 * PI;
        case ED_FM_ENGINE_1_GAIN: return e.on ? 0.2 + 0.8 * e.p : 0.0;
        default: return 0.0;
        }
    }
    const unsigned sblk = ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT - ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT;
    if (i >= ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT && i < ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT + 3 * sblk) {
        unsigned s = (i - ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT) / sblk;   // 0 nose, 1 LH main, 2 RH main
        unsigned k = (i - ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT) % sblk + ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT;
        switch (k) {
        case ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT:
            if (s == 0) return 0.0;
            return std::fmax(st.wb_both, s == 1 ? st.wb_l : st.wb_r);
        case ED_FM_SUSPENSION_0_GEAR_POST_STATE: return st.gear;
        case ED_FM_SUSPENSION_0_UP_LOCK: return st.gear < 0.001 ? 1.0 : 0.0;
        case ED_FM_SUSPENSION_0_DOWN_LOCK: return st.gear > 0.999 ? 1.0 : 0.0;
        case ED_FM_SUSPENSION_0_WHEEL_YAW: return s == 0 ? clampd(st.V < 25 ? (st.y_an ? st.yaw_in : st.y_disc) : 0.0, -1, 1) * 0.52 : 0.0;
        default: return 0.0;
        }
    }
    switch (i) {
    case ED_FM_ANTI_SKID_ENABLE: return 0.0;
    case ED_FM_FUEL_INTERNAL_FUEL: case ED_FM_FUEL_TOTAL_FUEL: return st.fuel;
    case ED_FM_FUEL_LOW_SIGNAL: return st.fuel < 120.0 ? 1.0 : 0.0;
    case ED_FM_OXYGEN_SUPPLY: return 101000.0;
    case ED_FM_FLOW_VELOCITY: return 10.0 + st.eng.thrust / 100.0;
    case ED_FM_FC3_STICK_PITCH: return clampd(st.p_an ? st.pitch_in : st.p_disc, -1, 1);
    case ED_FM_FC3_STICK_ROLL: return clampd(st.r_an ? st.roll_in : st.r_disc, -1, 1);
    case ED_FM_FC3_RUDDER_PEDALS: return clampd(st.y_an ? st.yaw_in : st.y_disc, -1, 1);
    case ED_FM_FC3_THROTTLE_LEFT: case ED_FM_FC3_THROTTLE_RIGHT: return st.eng.thr;
    case ED_FM_FC3_GEAR_HANDLE_POS: return st.gear_cmd;
    case ED_FM_FC3_FLAPS_HANDLE_POS: return st.flap_cmd;
    default: return 0.0;
    }
}

static void common_start(double gear, bool running, double thr) {
    st.gear = st.gear_cmd = gear; st.flap = st.flap_cmd = 0;
    st.iq = st.ip = 0; st.de = st.da = st.dr = 0; g_roll_holding = false;
    Engine& e = st.eng; e.starting = false; e.on = running; e.thr = thr;
    e.p = running ? IDLE_POWER + (1 - IDLE_POWER) * thr : 0; e.rpm = running ? PROP_RPM : 0;
}
EXP void ed_fm_cold_start() { common_start(1, false, 0); logf("cold start"); }
EXP void ed_fm_hot_start() { common_start(1, true, 0); logf("hot start"); }
EXP void ed_fm_hot_start_in_air() { common_start(0, true, 0.6); logf("hot start in air"); }
EXP void ed_fm_configure(const char*) {}
EXP void ed_fm_set_plugin_data_install_path(const char* path) { if (path) g_path = path; logf("BNS MQ-9 EFM loaded from %s", g_path.c_str()); }
EXP size_t ed_fm_debug_watch(int level, char* buffer, size_t maxlen) {
    if (level <= 0 || !buffer || maxlen == 0) return 0;
    int n = std::snprintf(buffer, maxlen, "MQ-9 EFM V %.0f a %.1f nz %.2f de %+.2f da %+.2f dr %+.2f P %.0f kW T %.0f N fuel %.0f",
                          st.V, st.alpha / D2R, st.nz, st.de, st.da, st.dr, st.eng.power / 1000, st.eng.thrust, st.fuel);
    return n > 0 ? (size_t)n : 0;
}
EXP void ed_fm_release() { if (g_log) { std::fclose(g_log); g_log = nullptr; } }
