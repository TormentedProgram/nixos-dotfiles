{ pkgs, ... }:
{
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    # Screenshot tools
    qimgv # Image viewer
    grimblast # Screenshot Tool
    swappy # Screenshot Editor
    krita

    # Video tools
    imagemagick # Convert image files
    ffmpeg # Convert video files
    ffmpegthumbnailer
    yt-dlp # Download Videos
  ];

  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
  programs = {
    mpv = {
      enable = true;

      package = (
        pkgs.mpv-unwrapped.wrapper {
          scripts = with pkgs.mpvScripts; [
            uosc
            sponsorblock-minimal
            thumbfast
            memo
            chapterskip
            visualizer
            evafast
          ];

          mpv = pkgs.mpv-unwrapped.override {
            waylandSupport = true;
          };
        }
      );
    };
  };

  # Services natively supported by home-manager.
  # They can be configured in `services.*` instead of using home.packages.
  services = {
  };
}
