{
  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPorts = [ 7000
                                          7777
                                          8888
					                                5353
					                                9757
                                          25565
                                        ];
  networking.firewall.allowedUDPPorts = [ 7777
					                                9757
					                                ];

  networking.firewall.interfaces."br-d042f891e184".allowedTCPPorts = [ 11434 ];

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;

    publish = {
      enable = true;
      userServices = true;
      workstation = true;
    };
  };

  programs.localsend = {
    enable = true;
  };
}
