{ ... }:
{
  # Create networks before containers start
  virtualisation.oci-containers.containers = {
    traefik = {
      image = "traefik:latest";
      autoStart = true;
      user = "1000:993";
      ports = [
        "80:80"
        "443:443"
        "8080:8080"
      ];
      environmentFiles = [
        /run/secrets/traefik.env
      ];
      volumes = [
        "/home/zachary/samba/docker/traefik/traefik.yml:/etc/traefik/traefik.yml:ro"
        "/home/zachary/samba/docker/traefik/letsencrypt:/letsencrypt"
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
