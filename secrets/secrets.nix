let
  user-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIK/Dq6lUa0Vjhz9G38T1k3FmO9sQTd4iXpQx9yYOuyV";
  user-debian = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAiBbREJW37Mnp1bYUp1boVZYTVOTDQoI7t5gxsgEjlr";
  users = [
    user-nixos
    user-debian
  ];

  root-nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFTGMooTZYyW0Fv2iqJsQTNzlYW97KuFPATj21CU/nWb";
  root-debian = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1ltDTXpr8dLS6RNIzyuLCiF2+b4f+Sp+5F54xuiNHN";
  systems = [
    root-nixos
    root-debian
  ];
in
{
  "ddclient.age".publicKeys = [
    user-nixos
    user-debian
  ];
  "acme.age".publicKeys = [
    user-nixos
    user-debian
  ];
  "headplane.age".publicKeys = [
    user-debian
    user-nixos
  ];
  # "secret2.age".publicKeys = users ++ systems;
}
