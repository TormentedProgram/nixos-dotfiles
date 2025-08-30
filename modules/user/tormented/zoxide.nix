{ pkgs, ...}:

{
  users.users.tormented = {
    packages = with pkgs; [
      zoxide
    ];
  };
}