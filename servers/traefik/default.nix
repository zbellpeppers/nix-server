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
        "./traefik.yml:/etc/traefik/traefik.yml:ro"
        "./letsencrypt:/letsencrypt"
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
