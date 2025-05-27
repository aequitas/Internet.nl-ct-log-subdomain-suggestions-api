{ ... }: {
  system.stateVersion = "24.11";

  # Configure networking
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;

  # Create user "test"
  services.getty.autologinUser = "test";
  users.users.test.isNormalUser = true;

  # Enable passwordless ‘sudo’ for the "test" user
  users.users.test.extraGroups = [ "wheel" ];
  security.sudo.wheelNeedsPassword = false;

  # make boot a little less verbose
  boot.kernelParams = [ "quiet" ];
  boot.consoleLogLevel = 0;
}
