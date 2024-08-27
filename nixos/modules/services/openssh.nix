{ ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      ChallengeResponseAuthentication = false;
      X11Forwarding = true;
    };
  };
}
