{ pkgs, ...}:

{
  users.users.tormented = {
    packages = with pkgs; [
      qbittorrent
    ];
  };
}