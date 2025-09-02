{ inputs, pkgs, ... }:

{
  users.users.tormented = {
    packages = with pkgs; [
      inputs.doxx.packages.${pkgs.system}.default
    ];
  };
}
