{ config, lib, pkgs, modulesPath, ... }:

let
  trackerPasswordFile = "/etc/tracker/htpasswd";

  trackerGenPasswordScript = pkgs.writeShellScriptBin "tracker-generate-password" ''
    set -eEuo pipefail

    username="tracker"
    password=$(${pkgs.pwgen}/bin/pwgen --num-passwords 1)

    mkdir -p /etc/tracker
    echo $password | ${pkgs.apacheHttpd}/bin/htpasswd -ic ${trackerPasswordFile} tracker

    echo -e "\nUsername: $username"
    echo "Password: $password"

    if [ -d /etc/ec2-metadata ]; then
      # is AWS EC2 instance
      token=$(curl --silent -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
      ip_address=$(curl --silent -H "X-aws-ec2-metadata-token: $token" http://169.254.169.254/latest/meta-data/public-ipv4)
    else
      # is VM
      ip_address="unknown"
    fi

    echo -e "\nPhone configuration file (save in phone-config.otrc):"
    cat <<EOF
    {
      "_type": "configuration",
      "auth": true,
      "deviceId": "default",
      "username": "tracker",
      "password": "$password",
      "mode": 3,
      "host": "http://$ip_address/pub",
      "port": 80,
      "monitoring": 2,
      "locatorInterval": 300,
      "autostartOnBoot": true,
      "extendedData": true
    }
    EOF
  '';
in
{

  environment.systemPackages = with pkgs; [
    owntracks-recorder
    trackerGenPasswordScript
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
        auth_basic "Bike tracker";
        auth_basic_user_file  ${trackerPasswordFile};
        root ${pkgs.owntracks-frontend}/share;
      '';

      # # use to serve owntracks basic ui (not owntracks/frontend)
      # locations."/rec".extraConfig = ''
      #   # auth_basic "Bike tracker";
      #   # auth_basic_user_file  /etc/nginx/htpasswd; # sudo htpasswd /etc/nginx/htpasswd owntracks
      #   proxy_pass http://localhost:8083;
      #   proxy_http_version 1.1;
      #   proxy_set_header Host $host;
      #   proxy_set_header X-Real-IP $remote_addr;
      #   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      # '';

      locations."/pub".extraConfig = ''
        auth_basic "Bike tracker";
        auth_basic_user_file  ${trackerPasswordFile};
        proxy_pass http://localhost:8083;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      '';

      locations."/api".extraConfig = ''
        # auth_basic "OwnTracks pub";
        # auth_basic_user_file  ${trackerPasswordFile};
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
