{ ... }:
{
  # Create networks before containers start
  virtualisation.oci-containers.containers = {
    budget = {
      image = "ghcr.io/actualbudget/actual-server:latest";
      autoStart = true;
      pull = "newer";
      ports = [
        "5006:5006"
      ];
      volumes = [
        "/home/zachary/samba/docker/actual-budget/data:/data"
      ];
      environment = {
        ACTUAL_SERVER_URL = "https://budget.bell-peppers.com";
      };
      networks = [
        "traefik"
      ];
      labels = {
        "traefik.enable" = "true";
        "traefik.http.routers.headscale.rule" = "Host(`budget.bell-peppers.com`)";
        "traefik.http.routers.headscale.entrypoints" = "websecure";
        "traefik.http.routers.headscale.tls.certresolver" = " letsencrypt";
        "traefik.http.services.headscale.loadbalancer.server.port" = "5006";
      };
    };
  };
}
