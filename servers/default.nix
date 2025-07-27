{ ... }:
{
  imports = [
    # ./budget
    # ./cloudflare
    # ./frigate
    # ./headscale
    ./samba
    ./traefik
  ];
  virtualisation.containers.enable = true;
  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
