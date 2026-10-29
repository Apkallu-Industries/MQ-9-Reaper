# Agent notes

Read README.md first.

## BNS stencil rule (2026-10-17, branch `bns/stencil-mark-2026-10-17`)
All four places are tracked in `docs/BNS_STENCIL.md`. Re-apply with `python tools/bns_stencil_mark.py`; `--check` must PASS.
Never paint the mark onto exported DDS by hand.

## Clean-room rule (2026-10-29, mq9-head, main)
- The mod ships no ED file. The cockpit shape is the BNS library part BNS-AV-GCS-0001 (sensor view, no geometry),
  declared by `MQ-9 Reaper/Cockpit/Scripts/mainpanel_init.lua` + `MainPanel` in `device_init.lua`. Never mount or copy
  an ED cockpit, texture archive or Options page again; the exterior shape `mq-9_reaper` resolves from the DCS install.
- Before every install: forge audit (`donor_scan` fails on ED donor names), the library `Tools/release/forum_check_all.py
  --only "MQ-9 Reaper Flyable"`, then `install_drift.py --stage` + `--install` (see docs/HANDOFF.md).
- Start from `docs/HANDOFF.md` (RESUME HERE). Shipped folder `MQ-9 Reaper/` = install: dev docs go in `Documents/`.
