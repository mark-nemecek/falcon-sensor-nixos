# A simple test to quickly check kernel compatibility
{nixosTest}:
nixosTest {
  name = "falcon-sensor-kernel-check";
  nodes.machine = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.falcon-sensor
    ];
    boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_8;
  };
  testScript =
    /*
    python
    */
    ''
      machine.start()
      machine.wait_for_unit("multi-user.target")
      machine.succeed("falcon-kernel-check")
    '';
}
