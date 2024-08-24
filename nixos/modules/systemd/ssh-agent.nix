{ pkgs, ... }:
{
  description = "SSH key agent";
  wantedBy = [ "default.target" ];
  serviceConfig = {
    Type = "simple";
    Environment = "SSH_AUTH_SOCK=%t/ssh-agent.socket";
    ExecStart = "${pkgs.openssh}/bin/ssh-agent -D -a $SSH_AUTH_SOCK";
  };
}
