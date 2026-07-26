{ pkgs, ... }:

{
  programs.fish.enable = true;

  users.users.phxo = {
    isNormalUser = true;
    description = "phxo";

    shell = pkgs.fish;

    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "plugdev"
      "video"
      "docker"
      "uinput"
      "input"
    ];

    hashedPassword = "$6$BGpMuiWGKziFosz1$7q/C5eiFhsf2smLqclvBFjUyBRqEoS.NonUQpAW4SEHzLCzdfNTAZUUsOIfPs5Bcve9ewCb7JZZ.8P6JNGsSp1";

    packages = with pkgs; [
      tree
    ];
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
}
