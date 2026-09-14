_  = function(p) return p; end;
name = _('Reaper GCS - Full Screen CPG Combat Station (Optic Main)');
Description = 'Press O to switch entire 5120x1440 screen between Flight View and Full-Screen MTS-B Targeting Camera (AH-64D CPG Style)'
Viewports =
{
     Center =
     {
          x = 0;
          y = 0;
          width  = 5120;
          height = 1440;
          viewDx = 0;
          viewDy = 0;
          aspect = 5120 / 1440;
     }
}

-- Full-Screen MTS-B Optical Gimbal / CPG TADS Targeting Camera
Shkval =
{
     x = 0;
     y = 0;
     width = 5120;
     height = 1440;
}

RIGHT_MFCD = Shkval
TGP = Shkval

UIMainView = Viewports.Center
GU_MAIN_VIEWPORT = Viewports.Center
