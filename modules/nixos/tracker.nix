{ config, lib, pkgs, modulesPath, ... }:

{
  environment.systemPackages = with pkgs; [
    owntracks-recorder
  ];

  systemd.services.owntracks-recorder = {
    enable = true;
    description = "Store and access data published by OwnTracks apps";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      DynamicUser = true;
      StateDirectory = "owntracks";
      StateDirectoryMode = "0775";
      WorkingDirectory = "/var/lib/owntracks";
      ExecStart = "${pkgs.owntracks-recorder}/bin/ot-recorder -S /var/lib/owntracks --doc-root ${pkgs.owntracks-recorder}/share/docroot --port 0";
    };
  };

  services.nginx = {
    enable = true;
    
    virtualHosts."tracking.example.com" = {
      # enableACME = true;
      # forceSSL = true;

      # owntracks frontend
      locations."/".extraConfig = ''
        # auth_basic "OwnTracks pub";
        # auth_basic_user_file  /etc/nginx/htpasswd;
        root ${pkgs.owntracks-frontend}/share;
      '';

      # # use to serve owntracks basic ui (not owntracks/frontend)
      # locations."/rec".extraConfig = ''
      #   # auth_basic "OwnTracks pub";
      #   # auth_basic_user_file  /etc/nginx/htpasswd; # sudo htpasswd /etc/nginx/htpasswd owntracks
      #   proxy_pass http://localhost:8083;
      #   proxy_http_version 1.1;
      #   proxy_set_header Host $host;
      #   proxy_set_header X-Real-IP $remote_addr;
      #   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      # '';

      locations."/pub".extraConfig = ''
        # auth_basic "OwnTracks pub";
        # auth_basic_user_file  /etc/nginx/htpasswd;
        proxy_pass http://localhost:8083;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';

      locations."/api".extraConfig = ''
        # auth_basic "OwnTracks pub";
        # auth_basic_user_file  /etc/nginx/htpasswd;
        proxy_pass http://localhost:8083;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';
    };
  };

  # security.acme.acceptTerms = true;

  networking.firewall = {
    allowedTCPPorts = [ 80 443 8083 ]; # owntracks-recorder
  };
}
