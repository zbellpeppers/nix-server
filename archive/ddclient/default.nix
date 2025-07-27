{ config, pkgs, ... }:

let
  getIPv4Script = pkgs.writeShellScript "get-ipv4" ''
    #!${pkgs.stdenv.shell}
    # Query Cloudflare’s trace endpoint *with IPv4 only* and on the
    # real interface (so the VPN tunnel is bypassed).
    EXTRACTED_IP=$(
      ${pkgs.curl}/bin/curl -s --fail -4 --interface enp3s0 \
        https://cloudflare.com/cdn-cgi/trace  | \
      ${pkgs.gnugrep}/bin/grep '^ip='           | \
      ${pkgs.coreutils}/bin/cut  -d= -f2
    )
    test -n "$EXTRACTED_IP" && echo "$EXTRACTED_IP"
  '';

  getIPv6Script = pkgs.writeShellScript "get-ipv6" ''
    #!${pkgs.stdenv.shell}
    EXTRACTED_IP=$(
      ${pkgs.curl}/bin/curl -s --fail -6 --interface enp3s0 \
        https://cloudflare.com/cdn-cgi/trace  | \
      ${pkgs.gnugrep}/bin/grep '^ip='           | \
      ${pkgs.coreutils}/bin/cut  -d= -f2
    )
    test -n "$EXTRACTED_IP" && echo "$EXTRACTED_IP"
  '';
in
{
  services.ddclient = {
    enable = true;
    usev4 = "cmd, cmd=${getIPv4Script}";
    usev6 = "cmd, cmd=${getIPv6Script}";
    protocol = "cloudflare";
    username = "token";
    passwordFile = config.age.secrets.ddclient.path;
    zone = "bell-peppers.com";
    domains = [
      "budget.bell-peppers.com"
      "hs.bell-peppers.com"
    ];
    ssl = true; # use HTTPS to talk to Cloudflare
    interval = "120m"; # how often ddclient re-checks the IP
    verbose = true;
    extraConfig = ''
      ttl=1
    '';
  };
}
