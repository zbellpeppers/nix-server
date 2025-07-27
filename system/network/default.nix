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
