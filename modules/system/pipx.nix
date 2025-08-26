{config, pkgs, inputs, ...}:

{
  environment.systemPackages = with pkgs; [
    pipx
  ];
}