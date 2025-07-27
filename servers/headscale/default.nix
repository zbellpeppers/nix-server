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
        "/run/user/1000/podman/podman.sock:/var/run/docker.sock:ro"
      ];
      environmentFiles = [
        /run/secrets/headplane.env
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
        "me.tale.headplane.target" = "headscale";
      };
    };
  };
}
