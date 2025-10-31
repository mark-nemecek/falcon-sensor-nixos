falcon-sensor-module: {
  testers
}:
testers.nixosTest {
  name = "falcon-sensor-module-nixosTest";
  nodes.machine = {pkgs, ...}: {
    imports = [falcon-sensor-module];

    services.falcon-sensor.enable = true;

    services.gnome.gnome-keyring.enable = true;

    # For driverInteractive
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

  };
  testScript =
    /*
    python
    */
    ''
      import time
      machine.start()
      machine.wait_for_unit("multi-user.target")
      machine.succeed("falcon-kernel-check")
      machine.wait_for_unit("falcon-sensor.service")
      assert "active (running)" in machine.succeed("systemctl status falcon-sensor.service")
      # Assert that it's not in reduced-functionality mode
      timeout = time.time() + 60 # 1 minute from now
      while "rfm-state=false" not in machine.succeed("falconctl -g --rfm-state"):
        assert time.time() < timeout, "falcon-sensor remained in rfm-state."
        time.sleep(1)
    '';
}
