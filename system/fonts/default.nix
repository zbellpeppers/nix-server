{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      roboto
      nerd-fonts.roboto-mono
      roboto-serif
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Roboto Serif" ];
        sansSerif = [ "Roboto" ];
        monospace = [ "RobotoMono Nerd Font Mono" ];
      };
    };
  };
}
