# MQ-9 Reaper — Build Status & Paper Trail

_Living tracker of what is fixed, where, and what is still open. Last updated: **2026-09-14**._

There are **two on-disk copies** of the mod — keep both in sync:
- **Saved Games** (what DCS actually loads): `C:\Users\danym\Saved Games\DCS\Mods\aircraft\MQ-9 Reaper`
- **Dev source** (canonical): `c:\Dev\AutonomousDronePack\MQ-9 Reaper\MQ-9 Reaper`
- **GitHub**: `github.com/Apkallu-Industries/MQ-9-Reaper` (`main`)

---

## ✅ Done & verified

| Fix | Why | Saved Games | Dev | GitHub |
|:--|:--|:--:|:--:|:--:|
| **entry.lua registration order** — `make_flyable` **before** `make_view_settings` | Old order aborted `entry.lua` before `plugin_done()` → "installed but not in ME" | ✅ | ✅ | ⬜ not pushed |
| **Mission spawn speed 65 → 90 m/s** (`MQ-9_Reaper_Combat_Patrol.miz`) | Loaded jet air-started below stall → sank on spawn | ✅ | ✅ | ✅ |
| **Branding** — Yutani Industries + motto (entry.lua `developerName`, README) | Studio identity | ✅ | ⬜ verify | ✅ |
| **README + hero banner** (432d patch) | Presentation | ✅ | ⬜ verify | ✅ |
| **ROADMAP** — North Star GCS container section | Paid flagship on record | ✅ | ⬜ verify | ✅ |
| **Acceptance test card** (`Documents/`) | Flight-test plan | ✅ | ⬜ verify | ✅ |
| **B-2: disabled duplicate mod** (`_B-2_Spirit_CONFLICT_BACKUP/entry.lua` → `.disabled`) | Two B-2 plugins → B-2 dropped from ME | ✅ (parent folder) | n/a | n/a |

---

## ⬜ Open — needs testing or a decision

| Item | Blocking? | Owner | Notes |
|:--|:--:|:--|:--|
| **MQ-9 flyable check** | 🔴 **YES** | Yutani | In ME, select MQ-9 → does **Skill** offer **Player/Client**, or AI-only? Decides if it's registered-but-not-flyable. |
| **Spawn-hold flight test** (§A) | — | Yutani | Confirm holds 2,500 m off spawn now. |
| **Weapon kills** (§C) — Hellfire + GBU-12 | — | Yutani | Last Phase-1 item. Laser-to-impact, end to end. |
| **Shkval thermal probe** | — | Yutani | Hot vehicle + IR channel: real heat or legacy low-light? Decides sensor path. |
| **Push entry.lua fix to GitHub** | — | Yutani/Wayland | Reorder fix is local only; push from ONE canonical repo. |
| **Consolidate two-repo pipeline** | — | Wayland | Make Dev canonical; deploy to Saved Games by copy, not a 2nd pushing repo. |

---

## 🧭 Known context / gotchas
- **Two copies + one GitHub remote** = clobber risk. Fix a bug in **both** until the pipeline is consolidated.
- **Registration order rule** (all homebrew flyables): `make_flyable` must run **before** `make_view_settings`, or the plugin aborts before `plugin_done()` and the aircraft is installed-but-missing-from-ME.
- **mapclasskey** is a shared MIL-STD-2525 symbol class — duplicates are **fine**, not a conflict.
- **F10 GCS menu is cosmetic** (info overlay only): real weapon employment + laser is the Su-25T cockpit chain.

---

_Update this file as items move from Open → Done._
