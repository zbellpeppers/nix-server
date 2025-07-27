{ ... }:
{
  age.identityPaths = [ "/home/zachary/.ssh/id_ed25519" ];
  age.secrets = {
    headplane = {
      file = ./headplane.age;
      path = "/run/secrets/headplane.env";
    };
    cfddns = {
      file = ./cloudflare-dydns.age;
    };
    traefik = {
      file = ./traefik.age;
      path = "/run/secrets/traefik.env";
    };
  };
}
