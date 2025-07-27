{ pkgs, ... }:
{
  users.groups.sambashare = { };
  users.users.zachary = {
    isNormalUser = true;
    description = "Zachary Bell Peppers";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "sambashare"
      "podman"
    ];
    openssh.authorizedKeys.keys = [
      # Zach's debian pc
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAiBbREJW37Mnp1bYUp1boVZYTVOTDQoI7t5gxsgEjlr"
    ];
  };
  environment.systemPackages = with pkgs; [
    fish
    micro
    tealdeer
    bat
    eza
  ];
}
