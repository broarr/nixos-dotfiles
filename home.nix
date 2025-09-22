{ config, pkgs, ... }:

{
  home.username = "broarr";
  home.homeDirectory = "/home/broarr";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    _1password-cli
    _1password-gui
    helix
    neofetch
    nil
    nixpkgs-fmt
    obsidian
    osu-lazer-bin
    ripgrep
    tree
  ];

  programs.git.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild --upgrade --flake ~/.dotfiles#spoon switch";
    };
  };   

  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "bradford roarr";
        email = "bradford.barr@gmail.com";
      };
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.main = {
      modules-left = [ "niri/workspaces" ];
      modules-right = ["pulseaudio" "bluetooth" "network" "battery" "clock"];
    };
  };
}
