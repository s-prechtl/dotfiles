{
  lib,
  pkgs,
  ...
}: {
  # Disables spindown on all disks of /dev/sd* format. -S might be used later not sure if needed yet.
  services.udev.extraRules = let
    mkRule = as: lib.concatStringsSep ", " as;
    mkRules = rs: lib.concatStringsSep "\n" rs;
  in
    mkRules [
      (mkRule [
        ''ACTION=="add|change"''
        ''SUBSYSTEM=="block"''
        ''KERNEL=="sd[a-z]"''
        ''ATTR{queue/rotational}=="1"''
        ''RUN+="${pkgs.hdparm}/bin/hdparm -B 254 /dev/%k"''
      ])
    ];
}
