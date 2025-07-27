{ ... }:
{
  imports = [
    # ./budget
    # ./cloudflare
    # ./frigate
    # ./headscale
    ./samba
    # ./traefik
  ];
  virtualisation.containers.enable = true;
  virtualisation = {
    oci-containers.backend = "docker";
    docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
