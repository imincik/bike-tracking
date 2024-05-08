# Bike tracking

Location tracking for my MTB adventures using [Owntracks](https://owntracks.org/).


## Test VM

* Launch test VM
```bash

```

## AWS EC2 deployment

* Launch NixOS [AMI](https://nixos.github.io/amis/)

* Enable Flakes
```bash
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

* Deploy
```bash
nixos-rebuild switch --flake github:imincik/bike-tracking#ec2
```

* Allow following SG inbound rules
```
  - TCP: port 80, 0.0.0.0/0
```


## Phone configuration

* Install Owntracks app (available for Android and iOS)

* Configuration
```
Preferences > Connection > Mode: HTTP

Preferences > Connection > Host: <URL>/pub

Preferences > Connection > Identification:
  - Username: <USERNAME>
  - Password: <PASSWORD>
  - Device ID: <ID>
  - Tracker ID: <ID>
```
