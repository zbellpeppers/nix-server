{ ... }:
{
  age.identityPaths = [ "/home/zachary/.ssh/id_ed25519" ];
  age.secrets = {
    ddclient = {
      file = ./ddclient.age;
    };
    acme = {
      file = ./acme.age;
    };
    headplane = {
      file = ./headplane.age;
      path = "/run/secrets/headplane.env";
    };
  };
}
