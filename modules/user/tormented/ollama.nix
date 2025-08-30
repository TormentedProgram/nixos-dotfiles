{ nixpkgs, lib, pkgs, ...}:

{
  users.users.tormented = {
    packages = with pkgs; [
      ollama-cuda
    ];
  };
}