{ ... }:
{
  imports = [
    ./budget
    ./cloudflare
    ./frigate
    ./headscale
    #./nginx
    ./samba
    ./traefik
  ];
  virtualisation.containers.enable = true;
  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
      dockerSocket.enable = true;
    };
  };
}
