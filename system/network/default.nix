{
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
        "tailscale0"
      ];
      allowedTCPPorts = [
        80
        443
      ];
    };
  };
}
