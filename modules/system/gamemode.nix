{ pkgs, ...}:

{
  environment.systemPackages = with pkgs; [
    gamemode
  ];
}