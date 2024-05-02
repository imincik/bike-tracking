{ pkgs, modulesPath, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    tmux
    vim
  ];

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
    };
  };

}
