// Offline 6-DOF rig for BNS_MQ9_EFM.dll: loads the DLL as DCS does (same exports, same body axes), integrates
// rigid-body motion with gravity and an ISA atmosphere, and checks the MQ-9A against its public numbers
// (USAF fact sheet: 900 shp, cruise about 200 kt, ceiling up to 50,000 ft, 4,000 lb of fuel) and against the
// behaviour its flight control computer must show. No ground, gear or wind (DCS does those).
// Derived from the BNS B-2 and B-17G rigs.
#include <windows.h>
#include <cmath>
#include <cstdio>
#include <functional>
#include <string>
#include "FM/wHumanCustomPhysicsAPI.h"

typedef void (*F_SIM)(double);
typedef void (*F_FORCE)(double&, double&, double&, double&, double&, double&);
typedef void (*F_MOM)(double&, double&, double&);
typedef void (*F_ATMO)(double, double, double, double, double, double, double, double);
typedef void (*F_MASS)(double, double, double, double, double, double, double);
typedef void (*F_BODY)(double, double, double, double, double, double, double, double, double, double, double, double,
                       double, double, double, double, double, double, double, double);
typedef void (*F_CMD)(int, float);
typedef void (*F_VOID)();
typedef void (*F_FUEL)(double);
typedef double (*F_PARAM)(unsigned);
typedef void (*F_DMG)(int, double);

struct DLL {
    HMODULE h; F_SIM sim; F_FORCE force; F_MOM mom; F_ATMO atmo; F_MASS mass; F_BODY body; F_CMD cmd;
    F_VOID hot_air; F_FUEL fuel; F_PARAM param; F_DMG dmg; F_VOID repair;
    bool load(const char* p) {
        h = LoadLibraryA(p); if (!h) return false;
        sim = (F_SIM)GetProcAddress(h, "ed_fm_simulate"); force = (F_FORCE)GetProcAddress(h, "ed_fm_add_local_force");
        mom = (F_MOM)GetProcAddress(h, "ed_fm_add_local_moment"); atmo = (F_ATMO)GetProcAddress(h, "ed_fm_set_atmosphere");
        mass = (F_MASS)GetProcAddress(h, "ed_fm_set_current_mass_state"); body = (F_BODY)GetProcAddress(h, "ed_fm_set_current_state_body_axis");
        cmd = (F_CMD)GetProcAddress(h, "ed_fm_set_command"); hot_air = (F_VOID)GetProcAddress(h, "ed_fm_hot_start_in_air");
        fuel = (F_FUEL)GetProcAddress(h, "ed_fm_set_internal_fuel"); param = (F_PARAM)GetProcAddress(h, "ed_fm_get_param");
        dmg = (F_DMG)GetProcAddress(h, "ed_fm_on_damage"); repair = (F_VOID)GetProcAddress(h, "ed_fm_repair");
        return dmg && repair && sim && force && mom && atmo && mass && body && cmd && hot_air && fuel && param;
    }
};

struct V { double x = 0, y = 0, z = 0; };
static V mk(double x, double y, double z) { V v; v.x = x; v.y = y; v.z = z; return v; }
static V operator+(V a, V b) { return mk(a.x + b.x, a.y + b.y, a.z + b.z); }
static V operator-(V a, V b) { return mk(a.x - b.x, a.y - b.y, a.z - b.z); }
static V operator*(V a, double k) { return mk(a.x * k, a.y * k, a.z * k); }
static V cr(V a, V b) { return mk(a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x); }
static double dt_(V a, V b) { return a.x * b.x + a.y * b.y + a.z * b.z; }
struct M3 { V c0, c1, c2; };
static V mulT(const M3& R, V w) { return mk(dt_(R.c0, w), dt_(R.c1, w), dt_(R.c2, w)); }
static V mulR(const M3& R, V b) { return R.c0 * b.x + R.c1 * b.y + R.c2 * b.z; }
static V nrm(V a) { double l = std::sqrt(dt_(a, a)); return a * (1.0 / l); }

static void isa(double h, double& T, double& p, double& rho, double& a) {
    if (h < 11000) { T = 288.15 - 0.0065 * h; p = 101325 * std::pow(T / 288.15, 5.2559); }
    else { T = 216.65; p = 22632 * std::exp(-(h - 11000) / 6341.6); }
    rho = p / (287.05 * T); a = std::sqrt(1.4 * 287.05 * T);
}
static double mach_tas(double h, double M) { double T, p, rho, a; isa(h, T, p, rho, a); return M * a; }

struct Sim {
    DLL* d; double m = 4500, Ix = 7.3e4, Iy = 9.3e4, Iz = 2.2e4;
    V pos, vb, w; M3 R; double t = 0;
    void set_mass(double kg) { double k = kg / 4500.0; m = kg; Ix = 7.3e4 * k; Iy = 9.3e4 * k; Iz = 2.2e4 * k; }
    double pitch() const { return std::asin(R.c0.y); }
    double roll() const { return std::atan2(-R.c2.y, R.c1.y); }
    double heading() const { return std::atan2(R.c0.z, R.c0.x); }
    double V_() const { return std::sqrt(dt_(vb, vb)); }
    double aoa() const { return std::atan2(-vb.y, vb.x); }
    double aos() const { return std::asin(vb.z / V_()); }
    double vs() const { return mulR(R, vb).y; }
    double mach() const { double T, p, rho, a; isa(pos.y, T, p, rho, a); return V_() / a; }
    void init(double h, double v, double pitch_rad) {
        pos = mk(0, h, 0); w = V();
        R.c0 = mk(std::cos(pitch_rad), std::sin(pitch_rad), 0); R.c1 = mk(-std::sin(pitch_rad), std::cos(pitch_rad), 0); R.c2 = mk(0, 0, 1);
        vb = mulT(R, mk(v, 0, 0));
    }
    void step(double dt) {
        double T, p, rho, a; isa(pos.y, T, p, rho, a);
        d->atmo(pos.y, T, a, rho, p, 0, 0, 0);
        d->mass(m, 0, 0, 0, Ix, Iy, Iz);
        d->body(0, 0, 0, vb.x, vb.y, vb.z, 0, 0, 0, 0, 0, 0, w.x, w.y, w.z, heading(), pitch(), roll(), aoa(), aos());
        d->sim(dt);
        double fx, fy, fz, px, py, pz, mx, my, mz; d->force(fx, fy, fz, px, py, pz); d->mom(mx, my, mz);
        V F = mk(fx, fy, fz) + mulT(R, mk(0, -9.80665 * m, 0));
        V dv = F * (1.0 / m) - cr(w, vb);
        V Iw = mk(Ix * w.x, Iy * w.y, Iz * w.z);
        V dw = mk(mx, my, mz) - cr(w, Iw); dw = mk(dw.x / Ix, dw.y / Iy, dw.z / Iz);
        vb = vb + dv * dt; w = w + dw * dt;
        pos = pos + mulR(R, vb) * dt;
        V c0 = R.c0 + (R.c1 * w.z - R.c2 * w.y) * dt;
        V c1 = R.c1 + (R.c2 * w.x - R.c0 * w.z) * dt;
        c0 = nrm(c0); V c2 = nrm(cr(c0, c1)); c1 = cr(c2, c0);
        R.c0 = c0; R.c1 = c1; R.c2 = c2; t += dt;
    }
};

static int g_fail = 0;
static void check(bool ok, const char* name, const std::string& detail) {
    std::printf("  %s  %-55s %s\n", ok ? "PASS" : "FAIL", name, detail.c_str()); if (!ok) ++g_fail;
}
static std::string fmt(const char* f, double a = 0, double b = 0, double c = 0, double e = 0) {
    char buf[256]; std::snprintf(buf, sizeof buf, f, a, b, c, e); return buf;
}
static const double D = 57.29577951308232;
struct Rec { double maxp = 0, maxq = 0, maxaoa = -99, maxbeta = 0, maxroll = 0, minv = 1e9; bool nan = false; };

static Rec run(Sim& s, double secs, const std::function<void(double)>& ctl = nullptr) {
    Rec r; const double dt = 0.01;
    for (int i = 0, n = (int)(secs / dt); i < n; ++i) {
        if (ctl) ctl(s.t);
        s.step(dt);
        r.maxp = std::fmax(r.maxp, std::fabs(s.w.x)); r.maxq = std::fmax(r.maxq, std::fabs(s.w.z));
        r.maxaoa = std::fmax(r.maxaoa, s.aoa() * D); r.minv = std::fmin(r.minv, s.V_());
        r.maxbeta = std::fmax(r.maxbeta, std::fabs(s.aos() * D)); r.maxroll = std::fmax(r.maxroll, std::fabs(s.roll() * D));
        if (!(s.V_() == s.V_()) || s.V_() > 250) { r.nan = true; break; }
    }
    return r;
}
static double clamp1(double v) { return std::fmax(-1, std::fmin(1, v)); }
static void throttle(DLL& d, double thr) { d.cmd(2004, (float)(1.0 - 2.0 * thr)); }
static const unsigned EBLK = ED_FM_ENGINE_1_RPM - ED_FM_ENGINE_0_RPM;
static double eng(DLL& d, int n, unsigned p1) { return d.param(p1 + (n - 1) * EBLK); }   // p1: the ENGINE_1 parameter
static double total_ff(DLL& d) { double f = 0; for (int n = 1; n <= 4; ++n) f += eng(d, n, ED_FM_ENGINE_1_FUEL_FLOW); return f; }

// Fly to trim: the rig's autopilot holds altitude through the FBW pitch-rate stick and, when v_hold > 0, holds speed
// with the throttles (autothrottle); otherwise the throttle stays at thr. Wings held level with roll stick.
static double g_stick = 0, g_thr = 0;
static void hold(DLL& d, Sim& s, double h0, double v_hold, double& integ, double& tint) {
    // outer loop: climb rate from the altitude error; inner: flight-path rate through the FBW pitch-rate stick
    double err = h0 - s.pos.y, vsp = s.vs();
    integ += err * 0.01;
    double vs_des = std::fmax(-15, std::fmin(15, 0.08 * err + 0.0005 * integ));
    g_stick = clamp1(4.0 * (vs_des - vsp) / std::fmax(s.V_(), 50.0));
    d.cmd(2001, (float)g_stick);
    d.cmd(2002, (float)clamp1(-2.0 * s.roll() - 1.0 * s.w.x));
    if (v_hold > 0) {
        double ev = v_hold - s.V_(); tint += ev * 0.01;
        g_thr = std::fmax(0, std::fmin(1, 0.5 + 0.08 * ev + 0.01 * tint));
        throttle(d, g_thr);
    }
}
static void start(DLL& d, Sim& s, double h, double v, double thr, double secs, double v_hold = 0) {
    d.repair(); d.hot_air(); d.fuel(1200); d.cmd(2002, 0); d.cmd(2003, 0); throttle(d, thr); g_thr = thr;
    d.cmd(430, 0);                                                   // gear up
    double T, p, rho, a; isa(h, T, p, rho, a);
    double M = v / a, pg = 1.0 / std::sqrt(1 - std::fmin(M, 0.7) * std::fmin(M, 0.7));
    double cl = s.m * 9.80665 / (0.5 * rho * v * v * 23.52), alpha = (cl - 0.35) / (5.6 * pg);
    s.t = 0; s.init(h, v, alpha);
    double integ = 0, tint = 0;
    run(s, secs, [&](double) { hold(d, s, h, v_hold, integ, tint); });
}

static const double KT = 0.514444;
// speed hold with the stick (glide, climb): pitch-rate stick from the speed error
static void speed_on_stick(DLL& d, Sim& s, double v, double& ii) {
    double e = v - s.V_(); ii += e * 0.01;
    d.cmd(2001, (float)clamp1(-0.08 * e - 0.004 * ii)); d.cmd(2002, (float)clamp1(-2.0 * s.roll() - 1.0 * s.w.x));
}

int main(int argc, char** argv) {
    const char* dll = argc > 1 ? argv[1] : "..\\bin\\BNS_MQ9_EFM.dll";
    SetEnvironmentVariableA("BNS_EFM_LOG", "rig_efm.log");            // keep the rig out of Saved Games\DCS\Logs
    DLL d; if (!d.load(dll)) { std::printf("cannot load %s (or missing exports)\n", dll); return 2; }
    Sim s; s.d = &d;
    std::printf("BNS_MQ9_EFM offline rig\n");

    std::printf("[1] cruise 7,600 m (25,000 ft), 200 KTAS, 4,500 kg on the autothrottle\n");
    s.set_mass(4500);
    start(d, s, 7600, 200 * KT, 0.6, 180, 200 * KT);
    check(std::fabs(s.pos.y - 7600) < 30, "holds 7,600 m", fmt("h %.0f m, AoA %.1f deg, V %.0f kt", s.pos.y, s.aoa() * D, s.V_() / KT));
    check(g_thr < 0.95, "200 kt needs less than max power", fmt("throttle %.2f", g_thr));
    double ff = total_ff(d) * 3600;
    check(ff > 50 && ff < 180, "fuel flow 50..180 kg/h (10..36 h on 1,814 kg)", fmt("%.0f kg/h", ff));
    Rec r = run(s, 60, [&](double) { d.cmd(2001, 0); d.cmd(2002, 0); });
    check(!r.nan && std::fabs(s.pos.y - 7600) < 150 && r.maxroll < 5, "hands-off 60 s: FCC holds attitude and wings level",
          fmt("dh %+.0f m, max |roll| %.1f deg", s.pos.y - 7600, r.maxroll));

    std::printf("[2] top speed: max power, 7,600 m, 4,200 kg, level\n");
    s.set_mass(4200);
    start(d, s, 7600, 200 * KT, 1.0, 300);
    check(s.V_() / KT > 228 && s.V_() / KT < 252, "240 KTAS +/- 5 % (GA-ASI / NAVAIR max 240 KTAS)", fmt("%.0f KTAS", s.V_() / KT));

    std::printf("[3] ceiling: max power, 15,240 m (50,000 ft), 3,300 kg\n");
    s.set_mass(3300);
    start(d, s, 15240, 115, 1.0, 300);
    check(std::fabs(s.pos.y - 15240) < 100 && s.V_() > 95, "holds 50,000 ft level at light weight",
          fmt("h %.0f m, V %.0f m/s TAS, AoA %.1f", s.pos.y, s.V_(), s.aoa() * D));

    std::printf("[4] climb: sea level, 4,760 kg, max power, 120 KTAS\n");
    s.set_mass(4760);
    start(d, s, 300, 120 * KT, 1.0, 10);
    double hc = s.pos.y, ii = 0;
    run(s, 60, [&](double) { speed_on_stick(d, s, 120 * KT, ii); });
    double roc = (s.pos.y - hc) / 60.0;
    check(roc > 3.0 && roc < 12.0, "climb 3..12 m/s at max take-off weight [EST]", fmt("%.1f m/s (%.0f ft/min)", roc, roc * 196.85));

    std::printf("[5] slow flight: 4,500 kg, 3,000 m, idle, full aft stick 150 s (alpha limiter)\n");
    s.set_mass(4500);
    start(d, s, 3000, 70, 0.1, 10); throttle(d, 0);
    r = run(s, 150, [&](double) { d.cmd(2001, 1.0f); d.cmd(2002, (float)clamp1(-2.0 * s.roll() - 1.0 * s.w.x)); });
    check(r.maxaoa < 12.5, "alpha limiter holds AoA under 12.5 deg", fmt("max AoA %.1f deg", r.maxaoa));
    check(!r.nan && r.maxroll < 20, "no departure at the limiter", fmt("max |roll| %.1f deg", r.maxroll));
    check(s.V_() > 30 && s.V_() < 60, "settled speed at the limiter 30..60 m/s TAS", fmt("V %.1f m/s (%.0f kt), sink %.1f m/s", s.V_(), s.V_() / KT, -s.vs()));

    std::printf("[6] pitch, roll, yaw senses at 160 KTAS, 4,000 m\n");
    start(d, s, 4000, 160 * KT, 0.6, 60, 160 * KT); double p0 = s.pitch();
    run(s, 2, [&](double) { d.cmd(2001, 0.5f); d.cmd(2002, 0); });
    check(s.pitch() - p0 > 4.0 / D, "stick aft = nose up", fmt("dpitch %+.1f deg in 2 s", (s.pitch() - p0) * D));
    run(s, 10, [&](double) { d.cmd(2001, 0); d.cmd(2002, 0); });
    check(std::fabs(s.w.z) * D < 0.5, "released: pitch rate back to zero", fmt("q %.2f deg/s", s.w.z * D));
    start(d, s, 4000, 160 * KT, 0.6, 60, 160 * KT);
    r = run(s, 2, [&](double) { d.cmd(2001, (float)g_stick); d.cmd(2002, 1.0f); });
    check(s.roll() > 0 && r.maxp * D > 20 && r.maxp * D < 50, "right stick = right roll, 20..50 deg/s", fmt("bank %+.0f deg, max p %.0f deg/s", s.roll() * D, r.maxp * D));
    double bank = s.roll();
    run(s, 15, [&](double) { d.cmd(2001, 0); d.cmd(2002, 0); });
    check(std::fabs(s.roll() - bank) * D < 4, "released: bank held", fmt("bank %+.1f deg (was %+.1f)", s.roll() * D, bank * D));
    start(d, s, 4000, 160 * KT, 0.6, 60, 160 * KT); double hd0 = s.heading();
    run(s, 3, [&](double) { d.cmd(2001, (float)g_stick); d.cmd(2002, 0); d.cmd(2003, 1.0f); });
    check(s.heading() - hd0 > 0.5 / D, "right pedal = nose right", fmt("heading %+.1f deg, slip %.1f deg", (s.heading() - hd0) * D, s.aos() * D));
    d.cmd(2003, 0);

    std::printf("[7] engine failure: 3,000 m, 4,000 kg, glide at 90 KTAS\n");
    s.set_mass(4000);
    start(d, s, 3000, 90 * KT, 0.5, 30, 90 * KT);
    d.cmd(310, 0); ii = 0;
    run(s, 20, [&](double) { speed_on_stick(d, s, 90 * KT, ii); });
    double hg = s.pos.y;
    run(s, 60, [&](double) { speed_on_stick(d, s, 90 * KT, ii); });
    double sink = (hg - s.pos.y) / 60.0, ld = s.V_() / std::fmax(sink, 0.01);
    check(eng(d, 1, ED_FM_ENGINE_1_THRUST) < 1, "engine stopped", "");
    check(ld > 14 && ld < 28, "glide ratio 14..28 (high-aspect-ratio wing) [EST]", fmt("L/D %.1f, sink %.2f m/s", ld, sink));

    std::printf("[8] damage: propeller hit (ROTOR 63), left outer wing gone (WING_L_OUT 23)\n");
    s.set_mass(4500);
    start(d, s, 4000, 160 * KT, 0.6, 30, 160 * KT);
    d.dmg(63, 0.1);
    run(s, 2, [&](double) { d.cmd(2001, 0); d.cmd(2002, 0); });
    check(eng(d, 1, ED_FM_ENGINE_1_THRUST) < 1, "propeller hit stops the engine", "");
    start(d, s, 4000, 160 * KT, 0.6, 30, 160 * KT);
    d.dmg(23, 0.0); double hh = s.pos.y, i8 = 0, t8 = 0;
    r = run(s, 20, [&](double) { hold(d, s, hh, 0, i8, t8); d.cmd(2002, 0); });
    check(!r.nan && r.maxroll < 25, "rolls left but the FCC catches it", fmt("max |roll| %.1f deg, now %+.1f", r.maxroll, s.roll() * D));

    // [9] loiter endurance. GA-ASI and NAVAIR quote "over 27 hours" / max endurance 27 h for the MQ-9A (NAVAIR fuel
    // 3,900 lb; the EFM keeps the USAF fact sheet's 4,000 lb = 1,814 kg). Loiter at 6,100 m (20,000 ft), clean, at a
    // mid-mission weight of 3,300 kg (empty 2,223 kg + about half the fuel + internal sensors), 110 KTAS [EST: loiter
    // speed and altitude are not published]. Endurance = 1,814 kg / loiter fuel flow; the band allows the drop in
    // flow as weight burns off and the climb/descent fuel that a constant-weight point leaves out.
    std::printf("[9] loiter: 6,100 m (20,000 ft), 3,300 kg, 110 KTAS on the autothrottle\n");
    s.set_mass(3300);
    start(d, s, 6100, 110 * KT, 0.3, 240, 110 * KT);
    double ffl = total_ff(d) * 3600, endur = 1814.0 / std::fmax(ffl, 1e-3);
    check(std::fabs(s.pos.y - 6100) < 30 && std::fabs(s.V_() / KT - 110) < 3, "holds 6,100 m at 110 KTAS",
          fmt("h %.0f m, V %.0f kt, throttle %.2f, AoA %.1f deg", s.pos.y, s.V_() / KT, g_thr, s.aoa() * D));
    check(endur > 22 && endur < 40, "loiter endurance 22..40 h on 1,814 kg (published: 27 h)", fmt("%.0f kg/h, %.1f h", ffl, endur));

    // [10] draw args on the MQ-9 model's own tail arguments (Mq-9_Reaper.EDM keys 354 right / 355 left ruddervator,
    // 357 ventral rudder; it has no 15/16/17). Checks the V-tail mixing, not the visual sign (ESTIMATED, see EFM).
    std::printf("[10] draw args: Mq-9_Reaper.EDM tail (354/355 ruddervators, 357 ventral rudder)\n");
    typedef void (*F_DRAW)(EdDrawArgument*, size_t);
    F_DRAW draw = (F_DRAW)GetProcAddress(d.h, "ed_fm_set_draw_args");
    check(draw != nullptr, "ed_fm_set_draw_args exported", "");
    if (draw) {
        static EdDrawArgument a[512];
        s.set_mass(4000);
        start(d, s, 4000, 160 * KT, 0.6, 30, 160 * KT);
        run(s, 0.5, [&](double) { d.cmd(2001, 0.6f); d.cmd(2002, 0); d.cmd(2003, 0); });
        for (auto& x : a) x.f = 0; draw(a, 512);
        double p354 = a[354].f, p355 = a[355].f;
        check(std::fabs(p354) > 0.05 && std::fabs(p354 - p355) < 0.05 * std::fabs(p354) + 0.02,
              "stick: both ruddervators move together", fmt("354 %+.2f, 355 %+.2f, 15 %+.2f", p354, p355, a[15].f));
        start(d, s, 4000, 160 * KT, 0.6, 30, 160 * KT);
        run(s, 0.3, [&](double) { d.cmd(2001, (float)g_stick); d.cmd(2002, 0); d.cmd(2003, 1.0f); });
        for (auto& x : a) x.f = 0; draw(a, 512);
        check(a[355].f - a[354].f > 0.2 && a[357].f > 0.2 && std::fabs(a[357].f - a[17].f) < 1e-4,
              "right pedal: ruddervators split (right minus), ventral rudder follows arg 17",
              fmt("354 %+.2f, 355 %+.2f, 357 %+.2f", a[354].f, a[355].f, a[357].f));
        d.cmd(2003, 0);
    }

    // [11] autopilot: the input profile binds A = 62 (autopilot) and H = 59 (barometric altitude hold); the Su-25T
    //      shell flew them, the EFM must now (408 / 538 off, 61 level flight).
    std::printf("[11] autopilot: H (59) after a zoom, A (62) attitude hold, 61 level flight, 408 off, stick override\n");
    {
        auto speed_only = [&](double vh, double& ti) {
            double ev = vh - s.V_(); ti += ev * 0.01;
            throttle(d, std::fmax(0, std::fmin(1, 0.5 + 0.08 * ev + 0.01 * ti)));
            d.cmd(2001, 0); d.cmd(2002, 0); d.cmd(2003, 0);
        };
        auto bank_to = [&](double deg) {
            run(s, 30, [&](double) {                                  // level turn: zero vertical speed on the stick
                d.cmd(2001, (float)clamp1(-4.0 * s.vs() / std::fmax(s.V_(), 50.0)));
                d.cmd(2002, (float)clamp1(1.5 * (deg / D - s.roll()) - 0.8 * s.w.x)); });
            d.cmd(2002, 0);
        };
        s.set_mass(4000);
        start(d, s, 4000, 160 * KT, 0.6, 60, 160 * KT);
        run(s, 4, [&](double) { d.cmd(2001, 0.4f); d.cmd(2002, 0); });
        double ti = 0, vs0 = s.vs(); d.cmd(59, 0); double h0 = s.pos.y;
        Rec rr = run(s, 90, [&](double) { speed_only(160 * KT, ti); });
        check(!rr.nan && std::fabs(s.pos.y - h0) < 30 && std::fabs(s.vs()) < 1.0 && rr.maxroll < 5, "H: holds the altitude it was engaged at",
              fmt("engaged climbing %.1f m/s; after 90 s dh %+.0f m, vs %+.2f m/s", vs0, s.pos.y - h0, s.vs()));
        start(d, s, 4000, 160 * KT, 0.6, 60, 160 * KT);
        run(s, 4, [&](double) { d.cmd(2001, 0.4f); d.cmd(2002, 0); });
        ti = 0; h0 = s.pos.y; run(s, 90, [&](double) { speed_only(160 * KT, ti); });
        check(s.pos.y - h0 > 100, "without it the same zoom climbs away", fmt("dh %+.0f m", s.pos.y - h0));
        start(d, s, 4000, 160 * KT, 0.6, 60, 160 * KT);
        bank_to(20); double bk = s.roll(); d.cmd(62, 0); double th = s.pitch();
        rr = run(s, 30, [&](double) { speed_only(160 * KT, ti); });
        check(!rr.nan && std::fabs(s.roll() - bk) * D < 3 && std::fabs(s.pitch() - th) * D < 1.0, "A: pitch and bank held",
              fmt("bank %+.1f (engaged %+.1f), pitch %+.1f (engaged %+.1f)", s.roll() * D, bk * D, s.pitch() * D, th * D));
        d.cmd(408, 0);
        start(d, s, 4000, 160 * KT, 0.6, 60, 160 * KT);
        bank_to(20); bk = s.roll(); d.cmd(61, 0); h0 = s.pos.y; ti = 0;
        run(s, 60, [&](double) { speed_only(160 * KT, ti); });
        check(std::fabs(s.roll()) * D < 2 && std::fabs(s.pos.y - h0) < 30, "61: wings level, altitude kept",
              fmt("bank %+.1f (was %+.1f), dh %+.0f m", s.roll() * D, bk * D, s.pos.y - h0));
        d.cmd(538, 0);
        start(d, s, 4000, 160 * KT, 0.6, 60, 160 * KT);
        d.cmd(59, 0); d.cmd(408, 0);
        run(s, 4, [&](double) { d.cmd(2001, 0.4f); d.cmd(2002, 0); });
        ti = 0; h0 = s.pos.y; run(s, 60, [&](double) { speed_only(160 * KT, ti); });
        check(s.pos.y - h0 > 50, "408 off: the stick flies it again", fmt("dh %+.0f m", s.pos.y - h0));
        start(d, s, 4000, 160 * KT, 0.6, 60, 160 * KT);
        d.cmd(59, 0); h0 = s.pos.y;
        run(s, 3, [&](double) { d.cmd(2001, 1.0f); d.cmd(2002, 0); });
        ti = 0; run(s, 60, [&](double) { speed_only(160 * KT, ti); });
        check(s.pos.y - h0 > 50, "full stick overrides H", fmt("dh %+.0f m from the captured altitude", s.pos.y - h0));
    }

    std::printf("\n%s - %d failed\n", g_fail ? "SIM_TEST_FAIL" : "SIM_TEST_PASS", g_fail);
    return g_fail ? 1 : 0;
}
