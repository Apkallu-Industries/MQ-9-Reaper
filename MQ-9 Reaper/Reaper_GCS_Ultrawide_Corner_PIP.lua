_  = function(p) return p; end;
name = _('Reaper GCS - Ultrawide Overlay (Full Screen + Sensor PiP)');
Description = 'Full 5120x1440 Flight View with 1440x1080 Live MTS-B Sensor PiP in the lower-right corner'
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

-- Picture-in-Picture MTS-B Optical Gimbal / Shkval Camera in lower-right corner
Shkval =
{
     x = 3680;
     y = 360;
     width = 1440;
     height = 1080;
}

RIGHT_MFCD = Shkval
TGP = Shkval

UIMainView = Viewports.Center
GU_MAIN_VIEWPORT = Viewports.Center
