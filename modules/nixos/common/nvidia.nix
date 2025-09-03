{ pkgs, ... }:
{
  boot.kernelParams = [
    "nvidia-drm.modeset=1" # Enables kernel modesetting for the proprietary NVIDIA driver.
    "nouveau.modeset=0" # Disables modesetting for the open-source Nouveau driver, preventing conflicts with proprietary NVIDIA drivers.
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];

  graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau
      libvdpau-va-gl 
      nvidia-vaapi-driver
      vdpauinfo
      libva
      libva-utils	
    ];
  };

  nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.beta; # needed beta driver for nvidia cuda package alignment
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
  };
}
