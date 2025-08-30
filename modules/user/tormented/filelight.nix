{ pkgs, ...}:

{
  users.users.tormented = {
    packages = with pkgs.kdePackages; [
      filelight
    ];
  };
}