{ ... }:
{
  # Create networks before containers start
  virtualisation.oci-containers.containers = {
    frigate = {
      image = "ghcr.io/blakeblackshear/frigate:0.16.0-rc1";
      privileged = true;
      user = "1000:993";
      autoStart = true;
      extraOptions = [
        "--shm-size=512mb"
        "--tmpfs=/tmp/cache:size=1g"
      ];
      devices = [
        "/dev/dri/renderD128:/dev/dri/renderD128"
      ];
      pull = "newer";
      ports = [
        "8971:8971"
        "1984:1984"
        "8554:8554"
        "8555:8555/tcp"
        "8555:8555/udp"
      ];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/home/zachary/samba/docker/frigate/config:/config"
        "/home/zachary/samba/docker/frigate/storage:/media/frigate"
      ];
      environmentFiles = [
        /run/secrets/frigate.env
      ];
      networks = [
        "traefik"
      ];
    };
  };
}
