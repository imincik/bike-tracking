{ config, pkgs, ... }:

{

  # Define a user account and don't forget to set a password with ‘passwd’.
  users.users.imincik = {
    description = "Ivan Mincik";
    isNormalUser = true;
    createHome = true;
    uid = 1000;
    extraGroups = [ "wheel" "sudo" ];
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCes7p4B65EyGXS3i5RqtD2gw2P1GPkSNnYDnAND2CcweGzZUh+464MG/ZUtveJjH+rGf/uiQ2WHe0mCmZhTUtzlEhDqFcn3xnInGAbDMGIc46xMrf6sNXzEqeTWn2HfS6vUZwHQgwMNghhnm24fSXhDNmT4i/UzAJl3BGGoYrVy1uEySBg+JzxS/IIdk52ukwczPX0cj7oRZFAEZ09labK/TdGNod6appmXVAXXCMVTnnxTkrAbFE8BERoAb8e9w5Jt1J2ilOmP5jHQTzwqh0O0Utt9uXYLodRz59X8hNoIBAwoVUe3+/cGDgU40nTXnNeSes/DY0/ciBx0eOtOQK05PEgL4kp+0mhMQjDlle0mNqr3QiNgPxXMT7Vv5m+QF+LpHDJTlbAbhXpdNzDfjuwNJFjtCxeaJd+gwzuDW0WttrqqtcZOIjH2tKkCf0E3/bDGntRz2VI7j574wBDq11BvjPwmwtz1ke8iiwL0Dd8cCNEKfrRfGNIq2umnHyI+z5Q6+1Ta1e2nCic3s91/8AzBxOecKAPcjm+N3A5ulNXjiVg/o7Xf0bW5ay1tWgRm5T6v7DWLw0v7yFqWH4ZiBi1l4zVmLKAdhc3eE8n/V9FWbxEKEy1ggnpUWWFKRNi4/KM1Yrir4X7x4SfUDrv/eDRpz+1emJHCoG5GjEHACo5Rw== ivan.mincik@gmail.com" ];
  };
  security.sudo.wheelNeedsPassword = false; # don't require sudo password for wheel users

}

# vim: set ts=2 sts=2 sw=2 et:
