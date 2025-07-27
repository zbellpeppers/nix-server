{ ... }:
{
  # Create networks before containers start
  virtualisation.oci-containers.containers = {
    headplane = {
      image = "ghcr.io/tale/headplane:latest";
      autoStart = true;
      pull = "newer";
      ports = [
        "3000:3000"
      ];
      volumes = [
        "/home/zachary/samba/docker/headscale/headplane-config/config.yaml:/etc/headplane/config.yaml"
        "/home/zachary/samba/docker/headscale/headscale-config/config.yaml:/etc/headscale/config.yaml"
        "/home/zachary/samba/docker/headscale/headscale-config/dns_records.json:/etc/headscale/dns_records.json"
        "/home/zachary/samba/docker/headscale/headplane-data:/var/lib/headplane"
        "/run/podman/podman.sock:/var/run/docker.sock:ro"
      ];
      environmentFiles = [
        /run/secrets/headplane.env
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.headscale.rule" = "Host(`hs.bell-peppers.com`) && PathPrefix(`/admin`)";
        "traefik.http.routers.headscale.priority" = "10";
        "traefik.http.routers.headscale.entrypoints" = "websecure";
        "traefik.http.routers.headscale.tls.certresolver" = " letsencrypt";
        "traefik.http.services.headscale.loadbalancer.server.port" = "3000";
      };
      networks = [
        "traefik"
      ];
    };
    headscale = {
      image = "ghcr.io/juanfont/headscale:latest";
      cmd = [ "serve" ];
      autoStart = true;
      pull = "newer";
      ports = [
        "8070:8070"
      ];
      volumes = [
        "/home/zachary/samba/docker/headscale/headscale-data:/var/lib/headscale"
        "/home/zachary/samba/docker/headscale/headscale-config:/etc/headscale"
      ];
      environmentFiles = [
        /run/secrets/headplane.env
      ];
      labels = {
        # This is needed for Headplane to find it and signal it
        "me.tale.headplane.target" = "headscale";
        # Traefik config
        "traefik.enable" = "true";
        "traefik.http.routers.headscale.rule" = "Host(`hs.bell-peppers.com`)";
        "traefik.http.routers.headscale.priority" = "9";
        "traefik.http.routers.headscale.entrypoints" = "websecure";
        "traefik.http.routers.headscale.tls.certresolver" = " letsencrypt";
        "traefik.http.services.headscale.loadbalancer.server.port" = "8070";
      };
      networks = [
        "traefik"
      ];
    };
  };
}
