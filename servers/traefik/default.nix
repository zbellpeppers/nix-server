{ ... }:
{
  # Create networks before containers start
  virtualisation.oci-containers.containers = {
    traefik = {
      image = "traefik:latest";
      autoStart = true;
      ports = [
        "80:80"
        "443:443"
        "8080:8080"
      ];
      environmentFiles = [
        /run/secrets/traefik.env
      ];
      volumes = [
        "/etc/nixos/servers/traefik/traefik.yml:/etc/traefik/traefik.yml:ro"
        "/etc/nixos/servers/traefik/letsencrypt:/letsencrypt"
        "/run/podman/podman.sock:/var/run/docker.sock:ro"
      ];
      networks = [
        "traefik"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.api.rule" = "Host(`traefik.bell-peppers.com`)";
        "traefik.http.routers.api.service" = "api@internal";
        "traefik.http.routers.api.entrypoints" = "websecure";
        "traefik.http.routers.api.tls.certresolver" = "letsencrypt";
      };
    };
  };
}
