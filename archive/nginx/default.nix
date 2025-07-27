{ ... }:
{
  # Required for nginx to be able to read acme certs
  users.users.nginx.extraGroups = [ "acme" ];
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "acme@bell-peppers.com";
    };
  };

  # 2. Configure NGINX to use the certificate from Certbot
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."budget.bell-peppers.com" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:5006";
        proxyWebsockets = true;
      };
    };
    virtualHosts."hs.bell-peppers.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/admin/" = {
        # Must include / at end of url
        proxyPass = "http://127.0.0.1:3000/";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
      locations."/" = {
        proxyPass = "http://127.0.0.1:8070";
        proxyWebsockets = true;
      };
    };
  };
}
