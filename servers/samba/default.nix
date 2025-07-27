{ ... }:
{
  networking.firewall = {
    allowPing = true;
  };
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "network_files";
        "netbios name" = "n-server";
        "security" = "user";
        "hosts allow" = " 192.168.50.0/24 127.0.0.1";
        "hosts deny" = "0.0.0.0/0";
        "map to guest" = "bad user";
      };
      bpf = {
        path = "/home/zachary/samba";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "valid users" = "@sambashare";
        "force user" = "zachary";
        "force group" = "sambashare";
      };
    };
  };
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
}
