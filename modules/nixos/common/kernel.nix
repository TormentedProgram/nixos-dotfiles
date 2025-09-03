{ pkgs, ... }:
{
  boot.kernelParams = [
    "systemd.mask=systemd-vconsole-setup.service"
    "systemd.mask=dev-tpmrm0.device" #this is to mask that stupid 1.5 mins systemd bug
    "nowatchdog" 
    "modprobe.blacklist=sp5100_tco" #watchdog for AMD
    "modprobe.blacklist=iTCO_wdt" #watchdog for Intel
    "kvm.enable_virt_at_load=0" #allow virtual machines to work
  ];

  boot.initrd = { 
    availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ ];
  };
}
