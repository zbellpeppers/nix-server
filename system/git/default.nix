{ pkgs, ... }:

{
  programs.git = {
    enable = true;

    # System-wide Git configuration
    config = {
      user = {
        name = "zbellpeppers";
        email = "github@bell-peppers.com";
      };

      # Signing configuration
      user.signingkey = "F7E5BA5079615BD334F49EECFE05A68DD80D1FF3";
      commit.gpgsign = true;
      tag.gpgsign = true;

      # GPG configuration
      gpg = {
        format = "openpgp";
        program = "${pkgs.gnupg}/bin/gpg2";
      };

      # Core settings
      core = {
        editor = "codium";
        autocrlf = "input";
      };

      # Color settings
      color.ui = "auto";

      # Pull/push behavior
      pull.rebase = false;
      push.default = "simple";
      init.defaultBranch = "master";

      # URL rewrites
      url."git@github.com:".insteadOf = "https://github.com/";
    };
  };

  # Ensure required packages are available
  environment.systemPackages = with pkgs; [
    git
    gnupg
  ];
}
