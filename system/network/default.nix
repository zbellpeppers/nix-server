{
  pkgs,
  lib,
  ...
}:
{
  systemd.services."NetworkManager-wait-online" = {
    enable = true;
  };
  networking = {
    hostName = "n-server";
    networkmanager = {
      enable = true;
    };
    nameservers = [
      "9.9.9.9"
      "149.112.112.112"
      "2620:fe::fe"
      "2620:fe::9"
    ];
    nftables.enable = true;
    firewall = {
      enable = true;
      trustedInterfaces = [
        "podman1"
      ];
      allowedTCPPorts = [
        80
        443
      ];
    };
  };
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  services = {
    networkd-dispatcher = {
      enable = true;
      rules."50-tailscale" = {
        onState = [ "routable" ];
        script = ''
          ${lib.getExe pkgs.ethtool} -K eno1 rx-udp-gro-forwarding on rx-gro-list off
        '';
      };
    };
  };
}
