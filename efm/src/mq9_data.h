// BNS MQ-9A Reaper external flight model: aircraft data.
// Public figures (USAF MQ-9 Reaper fact sheet, Creech AFB): Honeywell TPE331-10GD turboprop, 900 shp maximum;
// span 66 ft (20.1 m); length 36 ft (11 m); empty 4,900 lb (2,223 kg); max take-off 10,500 lb (4,760 kg);
// fuel 4,000 lb (1,814 kg); payload 3,750 lb; cruise about 200 kt; ceiling up to 50,000 ft (15,240 m).
// Wing area 23.52 m^2 and the gear geometry come from MQ-9.lua. Everything else is ESTIMATED [EST]: derivatives from
// planform theory (AR 17), control laws, power lapse, propeller, fuel consumption (TPE331 class BSFC 0.56 lb/shp/h).
#pragma once

namespace mq9 {
const double PI = 3.14159265358979323846;
const double D2R = PI / 180.0;

// geometry
const double S = 23.52;              // m^2 (MQ-9.lua)
const double B = 20.1;               // m
const double CBAR = S / B;           // 1.17 m [EST, mean geometric chord]
const double AR = B * B / S;         // 17.2

// lift [EST]
const double CL0 = 0.35;             // cambered laminar section
const double CLA = 5.6;              // per rad (AR 17)
const double ALPHA_STALL = 13.0 * D2R;
const double CL_DE = 0.02;           // ruddervators: small lift change
const double CL_FLAP = 0.35;

// drag [EST]: CD0 set so max power gives 240 KTAS at 25,000 ft (GA-ASI and NAVAIR MQ-9A data: max 240 KTAS).
// 0.030 gave 260 KTAS in the rig (2026-10-07); 0.038 brings it to the published figure.
const double CD0 = 0.038;          // sensor ball, antennas, pylons
const double OSWALD = 0.85;
const double CD_GEAR = 0.012;
const double CD_FLAP = 0.020;
const double CD_PROP_STOPPED = 0.010; // feathered propeller and dead engine
const double CD_SPEEDBRAKE = 0.0;     // none

// pitch [EST]: conventional, about 10 % static margin
const double CM0 = 0.02;
const double CMA = -0.60;
const double CMQ = -15.0;
const double CM_DE = 0.90;            // per unit ruddervator pitch command, + = nose up

// lateral / directional [EST]
const double CYB = -0.40;
const double CLB0 = -0.06, CLB_CL = 0.0;
const double CLP = -0.55;
const double CLR_CL = 0.25;
const double CL_DA = 0.12;
const double CNB = 0.06;
const double CNR = 0.12;
const double CN_DR = 0.05;

// engine and propeller
const double P0 = 671000.0;           // W, 900 shp
const double FLAT_RATE_SIGMA = 0.476; // [EST] full power held up to about 7,700 m (25,000 ft)
const double PROP_D = 2.6;            // m [EST]
const double PROP_ETA = 0.80;         // cruise efficiency [EST]
const double IDLE_POWER = 0.07;       // [EST]
const double POWER_RATE = 0.8;        // fraction per second [EST]
const double START_TIME = 40.0;       // s [EST]
const double BSFC = 0.56;             // lb / shp / h at rated power [EST, TPE331 class]
const double FF_ZERO = 0.12;          // [EST] Willans-line fuel flow at zero shaft power, fraction of rated flow; set
                                      // so a 20,000 ft / 110 KTAS loiter gives the published 27 h (rig check [9])
const double ENG_X = -4.5, ENG_Y = 0.15, ENG_Z = 0.0;   // pusher propeller [EST]
const double PROP_RPM = 2000.0;       // [EST] for the rpm gauges

// mass
const double M_EMPTY = 2223.0;
const double FUEL_MAX = 1814.0;       // fact sheet; MQ-9.lua M_fuel_max matches since 2026-10-07 (was 1300)

// flight control computer [EST]
const double Q_CMD_MAX = 12.0 * D2R;
const double P_CMD_MAX = 45.0 * D2R;
const double ALPHA_LIMIT = 11.0 * D2R;
const double NZ_MAX = 3.0;
}
