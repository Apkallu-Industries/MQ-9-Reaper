-- =====================================================================================
-- GENERAL ATOMICS MQ-9 REAPER — TACTICAL GROUND CONTROL STATION (GCS) MENU
-- Autonomous Drone Asset Pack (ADAP) & DCS World Mission Environment
-- =====================================================================================

local function initReaperGCS()
    local blueSide = coalition.side.BLUE
    local datalinkMarkId = 99100

    -- =================================================================================
    -- TACTICAL STATE DATASTORE
    -- =================================================================================
    local reaperState = {
        -- Flight State
        flightMode      = "MANUAL FLIGHT",
        assignedAlt     = 2500,       -- meters (approx 8,200 ft)
        assignedHeading = 90,         -- degrees
        assignedSpeed   = 65,         -- m/s (approx 126 kts)
        orbitDirection  = "LEFT",
        waypointIndex   = 1,
        waypointName    = "WP 1 (TARGET AREA OVERWATCH)",

        -- Weapons State
        selectedWeapon  = "AGM-114K Hellfire (SAL-2)",
        warheadArmed    = false,
        seekerArmed     = false,
        masterArm       = false,
        stations = {
            [1] = { name = "Station 1 (Left Outboard)", store = "2x AGM-114K Hellfire", count = 2, status = "STANDBY" },
            [2] = { name = "Station 2 (Left Inboard)",  store = "1x GBU-12 Paveway II", count = 1, status = "STANDBY" },
            [3] = { name = "Station 3 (Right Inboard)", store = "1x GBU-12 Paveway II", count = 1, status = "STANDBY" },
            [4] = { name = "Station 4 (Right Outboard)",store = "2x AGM-114K Hellfire", count = 2, status = "STANDBY" },
        },

        -- Laser & Sensor State
        gimbalCamera    = true,
        laserActive     = false,
        laserCode       = 1688,
        irPointer       = false,
        targetMarked    = false,
        targetCoord     = "N 42 14.28'  E 042 18.45' (ELEV 128m)",

        -- Datalink State
        datalinkActive  = true,
        roverFreq       = "5.250 GHz (C-Band)",
        link16TrackId   = "AA-0492",
        satcomLink      = "Ku-Band SATCOM (100% NOMINAL)",
    }

    local function getMissionTimeString()
        local t = 0
        if timer and timer.getTime then
            t = timer.getTime()
        end
        local hrs = math.floor(t / 3600)
        local mins = math.floor((t % 3600) / 60)
        local secs = math.floor(t % 60)
        return string.format("%02d:%02d:%02d", hrs, mins, secs)
    end

    -- =================================================================================
    -- REAL DCS CONTROLLER TASK INTEGRATION
    -- Connects F10 menu commands directly to DCS Flight Director and AI Controller
    -- =================================================================================
    local function getReaperController()
        local unit = Unit.getByName("Reaper-1-1")
        if unit and unit:isExist() then
            return unit:getController(), unit
        end
        local blueGroups = coalition.getGroups(coalition.side.BLUE, Group.Category.AIRPLANE)
        for _, g in ipairs(blueGroups) do
            for _, u in ipairs(g:getUnits()) do
                if u:isExist() and (u:getTypeName() == "MQ-9_Reaper_Flyable" or u:getTypeName() == "MQ-9_Reaper" or u:getTypeName() == "MQ-9 Reaper") then
                    return u:getController(), u
                end
            end
        end
        return nil, nil
    end

    local function applyOrbitTask(clockwise)
        local con, unit = getReaperController()
        if con and unit then
            local uPos = unit:getPosition()
            local pos = uPos.p
            local fwd = uPos.x

            -- Use current altitude to maintain exact height
            local altToUse = reaperState.assignedAlt or 2500
            if pos and pos.y and pos.y > 200 then
                altToUse = math.floor(pos.y)
                reaperState.assignedAlt = altToUse
            end

            local spdToUse = math.max(reaperState.assignedSpeed or 70, 70)
            reaperState.assignedSpeed = spdToUse

            -- Calculate circle center 2,500m to the side so the aircraft starts tangent to the circle
            -- This results in a gentle, level 12-degree bank angle that perfectly holds altitude
            local fx = (fwd and fwd.x) or 1
            local fz = (fwd and fwd.z) or 0
            local len = math.sqrt(fx * fx + fz * fz)
            if len > 0.001 then
                fx = fx / len
                fz = fz / len
            else
                fx = 1
                fz = 0
            end

            local orbitRadius = 2500
            local centerX, centerZ
            if clockwise then
                -- Right turn: center is 90 deg right
                centerX = pos.x + fz * orbitRadius
                centerZ = pos.z - fx * orbitRadius
            else
                -- Left turn: center is 90 deg left
                centerX = pos.x - fz * orbitRadius
                centerZ = pos.z + fx * orbitRadius
            end

            local orbitTask = {
                id = 'Orbit',
                params = {
                    pattern = 'Circle',
                    point = { x = centerX, y = centerZ },
                    altitude = altToUse,
                    speed = spdToUse,
                    clockwise = clockwise or false
                }
            }
            con:setTask(orbitTask)
            return true
        end
        return false
    end

    local function clearFlightTask()
        local con, unit = getReaperController()
        if con then
            con:resetTask()
            return true
        end
        return false
    end

    local function getTargetGroundPoint(distanceMeters)
        distanceMeters = distanceMeters or 4000
        local con, unit = getReaperController()
        if unit and unit.getPosition then
            local uPos = unit:getPosition()
            local pos = uPos.p
            local fwd = uPos.x
            local fx = (fwd and fwd.x) or 1
            local fz = (fwd and fwd.z) or 0
            local len = math.sqrt(fx * fx + fz * fz)
            if len > 0.001 then
                fx = fx / len
                fz = fz / len
            else
                fx = 1
                fz = 0
            end
            local gx = pos.x + fx * distanceMeters
            local gz = pos.z + fz * distanceMeters
            local gy = 0
            if land and land.getHeight then
                gy = land.getHeight({x = gx, y = gz}) or 0
            end
            return {x = gx, y = gy, z = gz}
        end
        return nil
    end

    -- =================================================================================
    -- OVER-ENLARGED TACTICAL DISPLAY BANNER
    -- Formatted with standard ASCII borders (100% compatible with DCS World fonts)
    -- =================================================================================
    local function showOverEnlargedBanner(systemTag, commandTitle, statusLine, detailLines, duration)
        duration = duration or 14

        local border  = "================================================================================"
        local divider = "--------------------------------------------------------------------------------"

        local banner = "\n" .. border .. "\n"
        banner = banner .. string.format("   [ MQ-9 REAPER TACTICAL GCS ]   ::   %s\n", string.upper(systemTag))
        banner = banner .. border .. "\n"
        banner = banner .. string.format("   COMMAND : %s\n", string.upper(commandTitle))
        banner = banner .. string.format("   STATUS  : %s\n", statusLine)
        banner = banner .. divider .. "\n"
        banner = banner .. "   TACTICAL ADVISORY & TELEMETRY:\n"

        if detailLines and #detailLines > 0 then
            for _, line in ipairs(detailLines) do
                banner = banner .. "   * " .. line .. "\n"
            end
        end

        banner = banner .. divider .. "\n"
        local footer = string.format("   TIME: %s UTC | ALT: %dm (%dft) | SPD: %dm/s (%dkts) | CAM: %s | PRF: %d | ARM: %s\n",
            getMissionTimeString(),
            reaperState.assignedAlt,
            math.floor(reaperState.assignedAlt * 3.28084),
            reaperState.assignedSpeed,
            math.floor(reaperState.assignedSpeed * 1.94384),
            reaperState.gimbalCamera and "ACTIVE" or "STOWED",
            reaperState.laserCode,
            (reaperState.masterArm and reaperState.warheadArmed) and "LIVE" or "SAFE"
        )
        banner = banner .. footer
        banner = banner .. border .. "\n"

        trigger.action.outText(banner, duration)
    end

    -- =================================================================================
    -- INITIAL WELCOME BANNER
    -- =================================================================================
    showOverEnlargedBanner(
        "MQ-9 REAPER GCS ONLINE & TACTICAL LINK ESTABLISHED",
        "ALL SYSTEMS NOMINAL - READY FOR TASKING",
        "[ XBOX CONTROLLER & KEYBOARD QUICK REFERENCE ]",
        {
            "CONTROLLER CONTROLS:",
            "  [ D-Pad ]         : Slew Gimbal Camera (Look Around)",
            "  [ LS Click ]      : (7) Combat / Air-to-Ground Mode",
            "  [ B ]             : Toggle Sensor Camera / MFD Screen (EOS)",
            "  [ X ]             : Target Lock (Ground Stabilize / Track)",
            "  [ Y ]             : Laser Ranger & Designator On/Off",
            "  [ A ]             : Weapon Fire / Launch Hellfire (Hold 1-2s)",
            "  [ LB ] / [ RB ]   : Throttle Down / Throttle Up",
            "  [ Back ]          : Center Gimbal Camera",
            "  [ Start ]         : Autopilot (Level Flight & Altitude Hold)",
            "  [ RS Click ]      : Target Unlock / Reset Sensor",
            "KEYBOARD SHORTCUTS:",
            "  [ 7 ] Combat Mode | [ O ] Camera On/Off | [ RShift+O ] Laser On/Off",
            "  [ Space ] Fire    | [ Enter ] Lock      | [ Backspace ] Unlock",
            "  [ W / S ] Throttle| [ H ] Altitude Hold | [ \\ ] F10 GCS Menu"
        },
        25
    )

    -- =================================================================================
    -- =================================================================================
    -- MENU F1: FLIGHT & AUTOPILOT
    -- =================================================================================
    -- =================================================================================
    local flightMenu = missionCommands.addSubMenu("[ F1: FLIGHT & AUTOPILOT ]")

    -- F1-1: Maintain Heading
    missionCommands.addCommand("F1: Maintain Heading (Compass / Vector Hold)", flightMenu, function()
        reaperState.flightMode = "HEADING HOLD (ACTIVE)"
        showOverEnlargedBanner(
            "FLIGHT CONTROL & AUTOPILOT",
            "AUTOPILOT: MAINTAIN HEADING",
            "[ ENGAGED: BORESIGHT COMPASS VECTOR LOCKED ]",
            {
                "Autopilot commanded to maintain current magnetic heading.",
                "Yaw damper and roll stabilization engaged (Wings Level).",
                "Rudder and aileron actuators trimmed for zero drift.",
                "DCS HOTAS Sync: Press [Left Alt + 2] to lock autopilot heading to current nose vector."
            },
            14
        )
    end)

    -- F1-2: Maintain Altitude
    missionCommands.addCommand("F2: Maintain Altitude (Barometric Hold)", flightMenu, function()
        reaperState.flightMode = "ALTITUDE HOLD (ACTIVE)"
        showOverEnlargedBanner(
            "FLIGHT CONTROL & AUTOPILOT",
            "AUTOPILOT: MAINTAIN ALTITUDE",
            string.format("[ ENGAGED: BARO HOLD AT %d METERS (%d FT MSL) ]", reaperState.assignedAlt, math.floor(reaperState.assignedAlt * 3.28084)),
            {
                string.format("Barometric pressure reference locked at %d meters MSL.", reaperState.assignedAlt),
                "Pitch trim automatically adjusted by flight control computer.",
                "Engine power modulated to preserve constant cruise airspeed.",
                "DCS HOTAS Sync: Press [Left Alt + 2] or [Left Alt + 5] for instant barometric hold."
            },
            14
        )
    end)

    -- F1-3: Maintain Orbit
    missionCommands.addCommand("F3: Maintain Orbit (Loiter Over Target Area)", flightMenu, function()
        reaperState.flightMode = string.format("ORBIT LOITER (%s)", reaperState.orbitDirection)
        local isRight = (reaperState.orbitDirection == "RIGHT")
        applyOrbitTask(isRight)
        showOverEnlargedBanner(
            "FLIGHT CONTROL & AUTOPILOT",
            "AUTOPILOT: MAINTAIN ORBIT",
            string.format("[ ENGAGED: SUSTAINED %s PYLON TURN ]", reaperState.orbitDirection),
            {
                "Autonomous Orbit Task committed to DCS Flight Computer.",
                "ENGAGE AUTOPILOT: Press [ O ] or [ Left Alt + 6 ] to let Autopilot fly the orbit!",
                "ALTITUDE HOLD   : Press [ H ] for Barometric Altitude Hold.",
                "ALT & ROLL HOLD : Press [ Left Alt + 2 ] to lock bank angle and altitude.",
                "MTS-B sensor turret compensated for orbit turn rate."
            },
            14
        )
    end)

    -- F1-4: Fly to Next Waypoint
    missionCommands.addCommand("F4: Fly to Next Waypoint (Route Navigation)", flightMenu, function()
        reaperState.waypointIndex = reaperState.waypointIndex + 1
        if reaperState.waypointIndex > 4 then reaperState.waypointIndex = 1 end
        local wpNames = {
            [1] = "WP 1 (INGRESS / PATROL SECTOR ALPHA)",
            [2] = "WP 2 (TARGET COMPOUND OVERWATCH)",
            [3] = "WP 3 (STANDOFF WEAPON RELEASE BASKET)",
            [4] = "WP 4 (EGRESS / RECOVERY HOLD)"
        }
        reaperState.waypointName = wpNames[reaperState.waypointIndex]
        reaperState.flightMode = string.format("NAV ROUTE -> WP %d", reaperState.waypointIndex)
        clearFlightTask()
        showOverEnlargedBanner(
            "NAVIGATION & MISSION COMPUTER",
            "NAV ROUTE: FLY TO NEXT WAYPOINT",
            string.format("[ ACTIVE LEG: STEERPOINT %d - %s ]", reaperState.waypointIndex, reaperState.waypointName),
            {
                string.format("Flight director steering commanded toward Waypoint %d.", reaperState.waypointIndex),
                string.format("Designation: %s", reaperState.waypointName),
                "HUD waypoint diamond and steering bug re-indexed.",
                "ENGAGE AUTOPILOT: Press [ O ] or [ Left Alt + 6 ] to follow route automatically."
            },
            14
        )
    end)

    -- F1-5: Orbit Left
    missionCommands.addCommand("F5: Orbit Left (Counter-Clockwise Recon Circle)", flightMenu, function()
        reaperState.orbitDirection = "LEFT"
        reaperState.flightMode = "ORBIT LEFT (COUNTER-CLOCKWISE)"
        applyOrbitTask(false)
        showOverEnlargedBanner(
            "FLIGHT CONTROL & AUTOPILOT",
            "AUTOPILOT: ORBIT LEFT",
            "[ ENGAGED: COUNTER-CLOCKWISE PYLON TURN ]",
            {
                "Left-hand 5km diameter recon orbit engaged by Flight Director.",
                "Autonomous bank angle stabilized - holding constant altitude and speed.",
                "Sensor turret optimized for left-wing surveillance geometry.",
                "To disengage and resume manual flight: F10 Menu -> F1 -> F7 Disengage."
            },
            12
        )
    end)

    -- F1-6: Orbit Right
    missionCommands.addCommand("F6: Orbit Right (Clockwise Recon Circle)", flightMenu, function()
        reaperState.orbitDirection = "RIGHT"
        reaperState.flightMode = "ORBIT RIGHT (CLOCKWISE)"
        applyOrbitTask(true)
        showOverEnlargedBanner(
            "FLIGHT CONTROL & AUTOPILOT",
            "AUTOPILOT: ORBIT RIGHT",
            "[ ENGAGED: CLOCKWISE PYLON TURN ]",
            {
                "Right-hand 5km diameter recon orbit engaged by Flight Director.",
                "Autonomous bank angle stabilized - holding constant altitude and speed.",
                "Sensor turret compensated for clockwise orbit trajectory.",
                "To disengage and resume manual flight: F10 Menu -> F1 -> F7 Disengage."
            },
            12
        )
    end)

    -- F1-7: Cancel Autopilot
    missionCommands.addCommand("F7: Disengage Autopilot (Manual Stick & Rudder)", flightMenu, function()
        reaperState.flightMode = "MANUAL FLIGHT (PILOT CONTROL)"
        clearFlightTask()
        showOverEnlargedBanner(
            "FLIGHT CONTROL & AUTOPILOT",
            "AUTOPILOT: DISENGAGED",
            "[ MANUAL FLIGHT: PILOT HAS TOTAL FLIGHT CONTROL ]",
            {
                "All orbit and route tasks cleared from Flight Computer.",
                "Full manual control restored to pilot stick, rudder, and throttle.",
                "AUTOPILOT DISCONNECT: Press [ Left Alt + 9 ] to release any FC3 holds."
            },
            12
        )
    end)

    -- Submenu for Altitudes
    local altMenu = missionCommands.addSubMenu("F8: Altitude Presets (Angel 08 / 15 / 25)", flightMenu)

    missionCommands.addCommand("F1: Angel 08 - Low Loiter (2,500m / 8,200ft)", altMenu, function()
        reaperState.assignedAlt = 2500
        showOverEnlargedBanner(
            "FLIGHT CONTROL & AUTOPILOT",
            "ALTITUDE PRESET: ANGEL 08",
            "[ COMMANDED: 2,500 METERS (8,200 FT MSL) ]",
            {
                "Optimal altitude for Hellfire visual tracking under cloud ceilings.",
                "Low-noise acoustic loiter configuration.",
                "Baro altitude hold reference set to 2,500m."
            },
            12
        )
    end)

    missionCommands.addCommand("F2: Angel 15 - Medium Surveillance (4,500m / 15,000ft)", altMenu, function()
        reaperState.assignedAlt = 4500
        showOverEnlargedBanner(
            "FLIGHT CONTROL & AUTOPILOT",
            "ALTITUDE PRESET: ANGEL 15",
            "[ COMMANDED: 4,500 METERS (15,000 FT MSL) ]",
            {
                "Standard medium-altitude combat surveillance ceiling.",
                "Above small-arms and MANPADS surface threats.",
                "Optimal laser glide profile for GBU-12 releases."
            },
            12
        )
    end)

    missionCommands.addCommand("F3: Angel 25 - Standoff Service Ceiling (7,600m / 25,000ft)", altMenu, function()
        reaperState.assignedAlt = 7600
        showOverEnlargedBanner(
            "FLIGHT CONTROL & AUTOPILOT",
            "ALTITUDE PRESET: ANGEL 25",
            "[ COMMANDED: 7,600 METERS (25,000 FT MSL) ]",
            {
                "Operational maximum service ceiling.",
                "Maximum sensor line of sight and wide-area radar surveillance.",
                "Extended glide range for precision guided munitions."
            },
            12
        )
    end)

    -- Submenu for Speed
    local speedMenu = missionCommands.addSubMenu("F9: Speed Profiles (Loiter 65 m/s / Dash 95 m/s)", flightMenu)

    missionCommands.addCommand("F1: Max Endurance Loiter (65 m/s / 126 kts)", speedMenu, function()
        reaperState.assignedSpeed = 65
        showOverEnlargedBanner(
            "PROPULSION & ENGINE MANAGEMENT",
            "SPEED PROFILE: MAX ENDURANCE LOITER",
            "[ THROTTLE TRIMMED: 65 M/S (126 KTS CAS) ]",
            {
                "Minimum fuel consumption configuration (Honeywell TPE331).",
                "Loiter endurance extended to 14+ hours on station.",
                "Low engine RPM minimizes ground acoustic detection."
            },
            12
        )
    end)

    missionCommands.addCommand("F2: Fast Transit Dash (95 m/s / 185 kts)", speedMenu, function()
        reaperState.assignedSpeed = 95
        showOverEnlargedBanner(
            "PROPULSION & ENGINE MANAGEMENT",
            "SPEED PROFILE: FAST TRANSIT DASH",
            "[ FULL POWER CRUISE: 95 M/S (185 KTS CAS) ]",
            {
                "Maximum continuous cruise power commanded.",
                "Rapid ingress/egress transit between operational sectors.",
                "Monitor exhaust gas temperature and fuel burn."
            },
            12
        )
    end)

    -- F1-10: Telemetry Report
    missionCommands.addCommand("F10: [!] Full Flight Telemetry Status", flightMenu, function()
        showOverEnlargedBanner(
            "FULL FLIGHT TELEMETRY REPORT",
            "FLIGHT DYNAMICS & AUTOPILOT STATUS",
            string.format("MODE: %s  |  ALT: %dm  |  SPD: %dm/s", reaperState.flightMode, reaperState.assignedAlt, reaperState.assignedSpeed),
            {
                string.format("Autopilot State           : %s", reaperState.flightMode),
                string.format("Assigned Baro Altitude    : %d meters (%d ft MSL)", reaperState.assignedAlt, math.floor(reaperState.assignedAlt * 3.28084)),
                string.format("Commanded Cruise Airspeed : %d m/s (%d KIAS)", reaperState.assignedSpeed, math.floor(reaperState.assignedSpeed * 1.94384)),
                string.format("Active Navigation Leg     : %s", reaperState.waypointName),
                string.format("Orbit Pattern             : %s (30 deg standard bank)", reaperState.orbitDirection),
                "Powerplant Configuration  : Honeywell TPE331-10GD Turboprop (900 SHP)",
                "DCS Autopilot Keys        : [Left Alt + 1] Route | [Left Alt + 2] Alt+Heading | [Left Alt + 4] Orbit"
            },
            16
        )
    end)

    -- =================================================================================
    -- =================================================================================
    -- MENU F2: WEAPONS & COMBAT STORES
    -- =================================================================================
    -- =================================================================================
    local weaponsMenu = missionCommands.addSubMenu("[ F2: WEAPONS & COMBAT STORES ]")

    -- F2-1: Weapon Selection Submenu
    local selectWeaponMenu = missionCommands.addSubMenu("F1: Weapon Selection (Hellfire / GBU-12 / Cycle)", weaponsMenu)

    missionCommands.addCommand("F1: Select AGM-114K Hellfire (Pylons 1 & 4)", selectWeaponMenu, function()
        reaperState.selectedWeapon = "AGM-114K Hellfire (SAL-2)"
        showOverEnlargedBanner(
            "WEAPONS MANAGEMENT SYSTEM",
            "ORDNANCE SELECTED: AGM-114K HELLFIRE",
            "[ ACTIVE STORES: STATIONS 1 & 4 (4x MISSILES LOADED) ]",
            {
                "Semi-Active Laser Guidance (SAL-2) seeker locked to PRF Code.",
                "Targeting Envelopes: LOBL (Lock-On Before Launch) / LOAL (After Launch).",
                "Effective Range: 2 to 8 km | Release Alt: 1,500m to 4,500m.",
                "Targeting: Right Mouse Click (RMB) Marks Target | Left Click (LMB) Fires Missile.",
                "Ensure Laser Designator (F3 Menu) is active prior to impact."
            },
            14
        )
    end)

    missionCommands.addCommand("F2: Select GBU-12 Paveway II (Pylons 2 & 3)", selectWeaponMenu, function()
        reaperState.selectedWeapon = "GBU-12 Paveway II (500lb LGB)"
        showOverEnlargedBanner(
            "WEAPONS MANAGEMENT SYSTEM",
            "ORDNANCE SELECTED: GBU-12 PAVEWAY II",
            "[ ACTIVE STORES: STATIONS 2 & 3 (2x 500LB BOMBS LOADED) ]",
            {
                "Laser-guided glide bomb configured for reinforced targets & structures.",
                "Delivery Mode: Level CCRP optical release cue on boresight HUD.",
                "Targeting: Right Mouse Click (RMB) Marks Target | Left Click (LMB) Releases Bomb.",
                "Lase target during final 10-12 seconds of bomb time-of-fall.",
                "Minimum recommended release altitude: 3,000 meters MSL."
            },
            14
        )
    end)

    missionCommands.addCommand("F3: Cycle Weapon (Hellfire <-> GBU-12)", selectWeaponMenu, function()
        if reaperState.selectedWeapon:find("Hellfire") then
            reaperState.selectedWeapon = "GBU-12 Paveway II (500lb LGB)"
        else
            reaperState.selectedWeapon = "AGM-114K Hellfire (SAL-2)"
        end
        showOverEnlargedBanner(
            "WEAPONS MANAGEMENT SYSTEM",
            "WEAPON CYCLED",
            string.format("[ CURRENTLY SELECTED: %s ]", reaperState.selectedWeapon),
            {
                string.format("Selected Store: %s", reaperState.selectedWeapon),
                "HUD Reticle and CCIP/CCRP symbology synchronized.",
                "Firing Circuits linked to Left Mouse Button (LMB) / Trigger."
            },
            12
        )
    end)

    -- F2-2: Available Payload Status
    missionCommands.addCommand("F2: Available Payload & Station Status", weaponsMenu, function()
        local s1 = reaperState.stations[1]
        local s2 = reaperState.stations[2]
        local s3 = reaperState.stations[3]
        local s4 = reaperState.stations[4]
        showOverEnlargedBanner(
            "AVAILABLE COMBAT PAYLOAD REPORT",
            "STORES INVENTORY & STATION DIAGNOSTICS",
            string.format("SELECTED: %s  |  ARM STATE: %s", reaperState.selectedWeapon, reaperState.masterArm and "ARMED" or "SAFE"),
            {
                string.format("Station 1 (Left Outboard) : %s [%s]", s1.store, s1.status),
                string.format("Station 2 (Left Inboard)  : %s [%s]", s2.store, s2.status),
                string.format("Station 3 (Right Inboard) : %s [%s]", s3.store, s3.status),
                string.format("Station 4 (Right Outboard): %s [%s]", s4.store, s4.status),
                "Total Explosive Payload   : 4x AGM-114K Shaped-Charge Warheads + 2x Mk-82 500lb LGBs",
                "Gross Ordnance Weight     : Approx 1,740 lbs (789 kg) external stores",
                string.format("Seeker Laser Code Set     : PRF %d", reaperState.laserCode)
            },
            16
        )
    end)

    -- F2-3: Arm Warhead & Seeker Submenu
    local armMenu = missionCommands.addSubMenu("F3: Arm Warhead & Seeker (Live / Safe)", weaponsMenu)

    missionCommands.addCommand("F1: [!] ARM WARHEAD & SEEKER (WEAPONS HOT / LIVE)", armMenu, function()
        reaperState.masterArm = true
        reaperState.warheadArmed = true
        reaperState.seekerArmed = true
        for i = 1, 4 do reaperState.stations[i].status = "ARMED (LIVE)" end
        showOverEnlargedBanner(
            "WEAPONS ARMING & FUZING SYSTEM",
            "WARHEAD & SEEKER ARMED",
            "[ !!! DANGER: WARHEADS ARMED - SEEKERS HOT - WEAPONS LIVE !!! ]",
            {
                "All safety interlocks removed. Warhead fuzes armed.",
                "Semi-Active Laser seekers uncaged and cooled.",
                "Left Mouse Button (LMB) or [Return] will instantly release/fire ordnance.",
                "Confirm friendly troop standoff distance (minimum 500m danger close).",
                "Ensure target is designated via Laser (F3 Menu or RMB)."
            },
            15
        )
    end)

    missionCommands.addCommand("F2: SAFE WARHEAD & SEEKER (WEAPONS SAFE / INHIBITED)", armMenu, function()
        reaperState.masterArm = false
        reaperState.warheadArmed = false
        reaperState.seekerArmed = false
        for i = 1, 4 do reaperState.stations[i].status = "SAFE (STANDBY)" end
        showOverEnlargedBanner(
            "WEAPONS ARMING & FUZING SYSTEM",
            "WARHEAD & SEEKER SAFED",
            "[ SAFE: WARHEADS INHIBITED - SEEKERS STOWED - WEAPONS SAFE ]",
            {
                "All firing interlocks locked. Release signals inhibited.",
                "Warhead electrical fuzes disarmed and grounded.",
                "Safe configuration for loiter, reconnaissance, transit, and recovery.",
                "Optics, laser ranging, and telemetry continue normal operation."
            },
            12
        )
    end)

    -- F2-4: Emergency Jettison
    missionCommands.addCommand("F4: Emergency Stores Jettison", weaponsMenu, function()
        reaperState.masterArm = false
        reaperState.warheadArmed = false
        reaperState.seekerArmed = false
        for i = 1, 4 do
            reaperState.stations[i].store = "EMPTY (JETTISONED)"
            reaperState.stations[i].count = 0
            reaperState.stations[i].status = "JETTISONED"
        end
        showOverEnlargedBanner(
            "EMERGENCY STORES MANAGEMENT",
            "EMERGENCY STORES JETTISON",
            "[ ALL EXTERNAL PYLON STORES JETTISONED ]",
            {
                "Emergency release commanded for all wing stations (Pylons 1-4).",
                "All external munitions cleared from airframe.",
                "Aircraft gross weight reduced by 1,740 lbs; drag minimized.",
                "Maximum climb performance, service ceiling, and glide range restored."
            },
            14
        )
    end)

    -- =================================================================================
    -- =================================================================================
    -- MENU F3: LASER, OPTICS & DATALINK
    -- =================================================================================
    -- =================================================================================
    local laserMenu = missionCommands.addSubMenu("[ F3: GIMBAL CAMERA & LASER ]")

    -- F3-1: Open Gimbal Camera
    missionCommands.addCommand("F1: Open MTS-B Gimbal Camera (Activate Optical Sensor)", laserMenu, function()
        reaperState.gimbalCamera = true
        showOverEnlargedBanner(
            "MTS-B TARGETING SENSOR",
            "MTS-B GIMBAL CAMERA: DEPLOYED & ACTIVE",
            "[ GIMBAL ONLINE :: 3-AXIS GYRO STABILIZATION LOCKED ]",
            {
                "Raytheon MTS-B Electro-Optical / Infrared Gimbal Turret un-stowed.",
                "Primary Sensor View Controls:",
                "  * Hotkey: Press [ O ] (or Controller [ B ]) to toggle camera optics feed",
                "  * View Angle: Press [ F1 ] or [ Tab ] for clean zero-cockpit HUD/Sensor view",
                "  * Slew Gimbal: D-Pad or Keyboard [ ; ] Up, [ . ] Down, [ , ] Left, [ / ] Right",
                "  * Zoom: Controller [ RB ] / [ LB ] or Keyboard [ = ] / [ - ]",
                "  * FLIR Thermal Night Vision: Controller [ RS Click ] or Keyboard [ RCtrl + O ]",
                "  * Target Lock: Controller [ X ] or Keyboard [ Enter ] / Right Mouse Button (RMB)"
            },
            16
        )
    end)

    -- F3-2: Stow / Close Gimbal Camera
    missionCommands.addCommand("F2: Stow / Close MTS-B Gimbal Camera", laserMenu, function()
        reaperState.gimbalCamera = false
        showOverEnlargedBanner(
            "MTS-B TARGETING SENSOR",
            "MTS-B GIMBAL CAMERA: STOWED",
            "[ GIMBAL CAMERA STOWED :: TURRET IN TRANSIT LOCK ]",
            {
                "MTS-B sensor turret commanded to forward aerodynamic stow position.",
                "Optical lenses locked behind protective ballistic shroud.",
                "Press [ O ] (or Controller [ B ]) or use F10 menu to re-deploy camera."
            },
            12
        )
    end)

    -- F3-3: Laser ON
    missionCommands.addCommand("F3: Laser Designator - [ EMIT LASER ON ]", laserMenu, function()
        reaperState.laserActive = true
        showOverEnlargedBanner(
            "MTS-B TARGETING SENSOR",
            "MTS-B TARGETING LASER: DESIGNATING",
            string.format("[ LASER FIRING :: PRF CODE %d ACTIVE ]", reaperState.laserCode),
            {
                "Continuous laser designator beam active on optical crosshair.",
                string.format("Broadcasting NATO PRF Code: %d.", reaperState.laserCode),
                "=== COMBAT CONTROLS ENGAGED ===",
                ">> RIGHT MOUSE BUTTON (RMB) = MARKS / LOCKS TARGET SPOT <<",
                ">> LEFT MOUSE BUTTON (LMB)  = FIRES SELECTED WEAPON      <<",
                "Laser Spot Tracker (LST) visible to friendly strike aircraft & JTACs."
            },
            15
        )
    end)

    -- F3-4: Laser OFF
    missionCommands.addCommand("F4: Laser Designator - [ CEASE LASER OFF ]", laserMenu, function()
        reaperState.laserActive = false
        showOverEnlargedBanner(
            "MTS-B TARGETING SENSOR",
            "MTS-B TARGETING LASER: CEASE LASING",
            "[ LASER DESIGNATOR INACTIVE / STANDBY ]",
            {
                "Laser emission ceased. Diode cooling cycle active.",
                "Target marking laser deactivated.",
                "Electro-optical daylight TV and infrared FLIR remain in passive surveillance."
            },
            12
        )
    end)

    -- F3-5: Mark Target Ground Spot
    missionCommands.addCommand("F5: [!] Mark Target Ground Spot (Deploy Red Smoke & F10 Map SPI)", laserMenu, function()
        reaperState.targetMarked = true
        datalinkMarkId = datalinkMarkId + 1
        local targetPt = getTargetGroundPoint(4000)
        if targetPt then
            if trigger and trigger.action then
                if trigger.action.markToAll then
                    trigger.action.markToAll(datalinkMarkId, string.format("MQ-9 SPI: TARGET GROUND POINT (PRF %d)", reaperState.laserCode), targetPt, false)
                end
                if trigger.action.smoke then
                    trigger.action.smoke(targetPt, trigger.smokeColor.Red)
                end
            end
            showOverEnlargedBanner(
                "MTS-B TARGETING SENSOR",
                "TARGET GROUND SPOT MARKED",
                "[ VISUAL RED SMOKE & F10 MAP SPI MARKER DEPLOYED ]",
                {
                    "Target spot designated on optical crosshair boresight.",
                    "Red phosphorus marking smoke ignited at ground impact point.",
                    string.format("F10 map marker #%d placed for all coalition assets.", datalinkMarkId),
                    string.format("Active NATO Laser PRF Code: %d.", reaperState.laserCode),
                    "All friendly CAS aircraft cleared for cooperative laser engagement."
                },
                14
            )
        end
    end)

    -- F3-6: Change Laser Code Submenu
    local codeMenu = missionCommands.addSubMenu("F6: Change Laser PRF Code (1688 / 1681 / 1685 / Custom)", laserMenu)

    missionCommands.addCommand("F1: Set Code 1688 (Standard NATO CAS / JTAC Primary)", codeMenu, function()
        reaperState.laserCode = 1688
        showOverEnlargedBanner(
            "MTS-B LASER CONFIGURATION",
            "LASER PRF CODE CHANGED",
            "[ PRF CODE SET: 1688 (PRIMARY NATO COMBAT) ]",
            {
                "Synchronized with coalition standard CAS / JTAC frequency.",
                "Compatible with F/A-18C, F-16C, A-10C, AH-64, and AGM-114K default seekers.",
                "New seeker code updated in weapons computer and datalink."
            },
            12
        )
    end)

    missionCommands.addCommand("F2: Set Code 1681 (ADAP Ghost Sniper UGV Sync)", codeMenu, function()
        reaperState.laserCode = 1681
        showOverEnlargedBanner(
            "MTS-B LASER CONFIGURATION",
            "LASER PRF CODE CHANGED",
            "[ PRF CODE SET: 1681 (ADAP GHOST SNIPER UGV) ]",
            {
                "Synchronized with ASD-1 'Ghost' ground sniper UGV droid.",
                "Enables cooperative multi-domain ground/air laser spot handoff.",
                "Autonomous drone coordinated strike network synchronized."
            },
            12
        )
    end)

    missionCommands.addCommand("F3: Set Code 1685 (ADAP Tactical Recon Drone Sync)", codeMenu, function()
        reaperState.laserCode = 1685
        showOverEnlargedBanner(
            "MTS-B LASER CONFIGURATION",
            "LASER PRF CODE CHANGED",
            "[ PRF CODE SET: 1685 (ADAP RECON DRONE RELAY) ]",
            {
                "Synchronized with RQ-28A tactical overwatch drone.",
                "Air-to-air drone relay designation enabled."
            },
            12
        )
    end)

    missionCommands.addCommand("F4: Set Code 1111 (CAS Priority Alpha)", codeMenu, function()
        reaperState.laserCode = 1111
        showOverEnlargedBanner(
            "MTS-B LASER CONFIGURATION",
            "LASER PRF CODE CHANGED",
            "[ PRF CODE SET: 1111 (CAS PRIORITY ALPHA) ]",
            {
                "Emergency Close Air Support designated frequency.",
                "High pulse repetition rate for rapid seeker acquisition."
            },
            12
        )
    end)

    missionCommands.addCommand("F5: Set Code 1511 (SOF / JTAC Tactical Infill)", codeMenu, function()
        reaperState.laserCode = 1511
        showOverEnlargedBanner(
            "MTS-B LASER CONFIGURATION",
            "LASER PRF CODE CHANGED",
            "[ PRF CODE SET: 1511 (SPECIAL FORCES JTAC) ]",
            {
                "Synchronized with ground Special Operations Forces laser designators.",
                "Enables covert Buddy-Lasing between ground operator and MQ-9."
            },
            12
        )
    end)

    -- F3-6: DATALINK Submenu
    local datalinkMenu = missionCommands.addSubMenu("F6: DATALINK (Broadcast Target / ROVER VDL / Network)", laserMenu)

    missionCommands.addCommand("F1: [!] Broadcast Target SPI to Coalition (Link-16 / SADL)", datalinkMenu, function()
        reaperState.targetMarked = true
        datalinkMarkId = datalinkMarkId + 1

        -- Broadcast tactical text to all Blue coalition units
        local dlMsg = string.format(
            "\n>>> [DATALINK LINK-16 / SADL BROADCAST] <<<\n" ..
            "FROM   : MQ-9 REAPER (CALLSIGN: REAPER 1-1)\n" ..
            "TARGET : HOSTILE HIGH-VALUE COMPOUND / ARMOR\n" ..
            "COORD  : %s\n" ..
            "LASER  : PRF CODE %d (ACTIVE SPOT)\n" ..
            "ALL STRIKE PACKAGES CLEARED FOR COOPERATIVE ENGAGEMENT",
            reaperState.targetCoord,
            reaperState.laserCode
        )
        trigger.action.outTextForCoalition(blueSide, dlMsg, 15)

        local targetPt = getTargetGroundPoint(4000)
        if targetPt and trigger and trigger.action and trigger.action.markToAll then
            trigger.action.markToAll(datalinkMarkId, string.format("MQ-9 SPI: TARGET DESIGNATION (LSR %d)", reaperState.laserCode), targetPt, false)
        end

        showOverEnlargedBanner(
            "TACTICAL DATALINK MANAGEMENT (LINK-16)",
            "DATALINK: TARGET BROADCAST TRANSMITTED",
            "[ TARGET SPI BROADCAST TO ALL COALITION STRIKE ASSETS ]",
            {
                string.format("Target Coordinates Transmitted: %s", reaperState.targetCoord),
                string.format("Laser Designator Frequency    : PRF %d", reaperState.laserCode),
                "Tactical Network Distribution : Link-16 (JREAP-C) + SADL Network Active",
                "Receiving Assets              : F/A-18C, F-16C, A-10C, AH-64D, Ground JTACs",
                "F10 Map Marker Placed         : 'MQ-9 SPI: TARGET DESIGNATION'"
            },
            15
        )
    end)

    missionCommands.addCommand("F2: Target Hand-Off to ADAP Ghost Sniper UGV", datalinkMenu, function()
        showOverEnlargedBanner(
            "AUTONOMOUS DRONE ASSET PACK (ADAP)",
            "DATALINK: UGV GROUND HAND-OFF",
            "[ TARGET SPOT TELEMETRY TRANSMITTED TO ASD-1 GHOST UGV ]",
            {
                "Coordinated Air-to-Ground Autonomous Strike Link active.",
                "ASD-1 Ghost Sniper UGV locked onto MQ-9 laser spot (PRF 1681).",
                "Ground robot computing firing solution for high-caliber sniper engagement.",
                "Cooperative cross-domain strike synchronization nominal."
            },
            14
        )
    end)

    missionCommands.addCommand("F3: Video Data Link (ROVER / VDL Stream) Status", datalinkMenu, function()
        showOverEnlargedBanner(
            "TACTICAL VIDEO DATA LINK (VDL)",
            "ROVER 5 / DIGITAL VDL STREAM",
            "[ VIDEO DOWNLINK: STREAMING HIGH-DEF EO/FLIR FEED ]",
            {
                string.format("Carrier Frequency         : %s", reaperState.roverFreq),
                "Stream Protocol           : ROVER 5 Digital Metadata + HD H.264 Video",
                "Ground User Terminals     : JTAC Ruggedized Tablet, TOC Command Center",
                "Video Feed Content        : Real-Time MTS-B Sensor Turret Optical Boresight",
                "Encryption                : Type-1 NSA Cryptographic Enclave Active"
            },
            14
        )
    end)

    missionCommands.addCommand("F4: Datalink Network Diagnostics & SATCOM Link", datalinkMenu, function()
        showOverEnlargedBanner(
            "COMMUNICATIONS & AVIONICS",
            "DATALINK NETWORK DIAGNOSTICS",
            "[ NETWORK HEALTH: 100% NOMINAL - ZERO LATENCY ]",
            {
                string.format("Primary Uplink/Downlink   : %s", reaperState.satcomLink),
                "Backup Line-of-Sight Link : C-Band LOS Antenna Array (Active)",
                string.format("Link-16 Network Track ID  : %s", reaperState.link16TrackId),
                "Telemetry Packet Loss Rate: 0.00% (Sub-millisecond synchronization)",
                "Cyber Security Interlocks : NSA High-Assurance IP Encryptor (HAIPE)"
            },
            16
        )
    end)

    -- F3-7: Toggle IR Pointer
    missionCommands.addCommand("F7: Toggle Infrared Marker / Pointer (Covert NVG Beam)", laserMenu, function()
        reaperState.irPointer = not reaperState.irPointer
        local ptrStatus = reaperState.irPointer and "ACTIVATED (ILLUMINATING TARGET)" or "DEACTIVATED (OFF)"
        showOverEnlargedBanner(
            "MTS-B TARGETING SENSOR",
            "MTS-B INFRARED POINTER (COVERT NVG)",
            string.format("[ IR POINTER: %s ]", ptrStatus),
            {
                "830nm covert infrared beam visible to Night Vision Goggles (NVGs).",
                "Permits friendly ground assault teams and JTACs to visually pinpoint targets at night.",
                "Completely invisible to the naked human eye."
            },
            14
        )
    end)

    -- F3-8: Sensor & Laser Status Report
    missionCommands.addCommand("F8: [!] Display Full Sensor, Laser & Datalink Status", laserMenu, function()
        local laseText = reaperState.laserActive and string.format("FIRING (PRF %d)", reaperState.laserCode) or "STANDBY (OFF)"
        local irText   = reaperState.irPointer and "ON (ILLUMINATING)" or "OFF"
        showOverEnlargedBanner(
            "FULL SENSOR, LASER & DATALINK REPORT",
            "MTS-B SENSOR & TACTICAL NETWORK",
            string.format("LASER: %s  |  CODE: %d  |  DATALINK: ACTIVE", laseText, reaperState.laserCode),
            {
                "Primary Sensor Turret    : Raytheon MTS-B Multi-Spectral Targeting System",
                "Optics Spectrum          : Mid-Wave IR (FLIR) + High-Def Color Daylight TV",
                string.format("Laser Designator State   : %s", laseText),
                string.format("Active NATO PRF Code     : %d", reaperState.laserCode),
                string.format("Covert NVG IR Pointer    : %s", irText),
                "Targeting Mouse Controls : RMB = Mark / Lock Target  |  LMB = Fire Weapon",
                "Tactical Datalink        : Link-16 / SADL Broadcast Active & ROVER VDL Streaming",
                "Stabilization Gimbal     : Gyroscopic 3-Axis Horizon & Target Lock Active"
            },
            16
        )
    end)

    -- F3-9: Toggle Live Combat HUD Overlay (AH-64D CPG / Drone Telemetry)
    local liveCombatHudActive = false
    local function combatHudLoop()
        if not liveCombatHudActive then return end
        local u = getPlayerReaper()
        local altM = 2420
        local spdKts = 130
        local hdg = 0
        if u and u.getPosition and u.getVelocity then
            local pos = u:getPosition()
            local vel = u:getVelocity()
            if pos and pos.p then altM = math.floor(pos.p.y) end
            if vel then
                local spdMs = math.sqrt(vel.x * vel.x + vel.y * vel.y + vel.z * vel.z)
                spdKts = math.floor(spdMs * 1.94384)
            end
            if pos and pos.x then
                hdg = math.floor((math.atan2(pos.x.z, pos.x.x) * 180 / math.pi) % 360)
            end
        end

        local laseStatus = reaperState.laserActive and string.format("EMITTING [PRF %d]", reaperState.laserCode) or "STANDBY (OFF)"
        local hudMsg = string.format(
            "================================================================================\n" ..
            "  MQ-9 REAPER COMBAT GCS :: SENSOR OPERATOR STATION (AH-64D CPG TADS)\n" ..
            "--------------------------------------------------------------------------------\n" ..
            "  FLIGHT  : %s | ALT: %dm (%dft) | SPD: %dkts | HDG: %03d\n" ..
            "  OPTICS  : MTS-B EO/IR GIMBAL ONLINE | ZOOM: 1x WIDE / 23x TELEPHOTO\n" ..
            "  LASER   : %s | NATO PRF CODE: %d | COVERT IR: %s\n" ..
            "  WEAPONS : %s | 4x AGM-114K HELLFIRE, 2x GBU-12 PAVEWAY II\n" ..
            "  HOTAS   : [D-Pad] Slew | [X] Lock Target | [Y] Laser On | [A] Pickle Hellfire\n" ..
            "================================================================================",
            reaperState.flightMode,
            altM, math.floor(altM * 3.28084),
            spdKts, hdg,
            laseStatus, reaperState.laserCode,
            reaperState.irPointer and "ACTIVE" or "OFF",
            reaperState.selectedWeapon
        )
        trigger.action.outTextForGroup(playerGroupId or 1, hudMsg, 3, true)
        timer.scheduleFunction(combatHudLoop, nil, timer.getTime() + 2.5)
    end

    missionCommands.addCommand("F9: Toggle Live Combat HUD Overlay (AH-64D CPG Style)", laserMenu, function()
        liveCombatHudActive = not liveCombatHudActive
        local stateText = liveCombatHudActive and "ACTIVATED (CONTINUOUS REFRESH)" or "DEACTIVATED (OFF)"
        if liveCombatHudActive then
            combatHudLoop()
        end
        showOverEnlargedBanner(
            "COMBAT HUD OVERLAY",
            "LIVE SENSOR TELEMETRY DISPLAY",
            string.format("[ REAL-TIME COMBAT HUD: %s ]", stateText),
            {
                "Provides persistent, real-time CPG TADS telemetry across the top of your screen.",
                "Updates altitude, airspeed, heading, selected weapon, and laser status live.",
                "Designed for full situational awareness while slewing the MTS-B targeting gimbal."
            },
            6
        )
    end)

end

-- Execute GCS Menu registration
initReaperGCS()
