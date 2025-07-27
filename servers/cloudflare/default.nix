{ config, ... }:
{
  services.cloudflare-dyndns = {
    enable = true;
    frequency = "1 h";
    apiTokenFile = config.age.secrets.cfddns.path;
    domains = [
      "hs.bell-peppers.com"
      "budget.bell-peppers.com"
      "traefik.bell-peppers.com"
    ];
  };
}
