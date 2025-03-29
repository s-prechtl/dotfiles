{...}: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "data";
        source = ''
                  ;dd,
                 xdoo'
                0oooo'
              ,ko:.oo' .
             xdo. .oo':od0
            0oo   .oo';oook,
          'koc    .oo';oo,odx
         oxo'     .oo';oo  oo0
        Ooo       .oo';oo   ;oxc
      'Ool        .oo';oo    .od0
     odo'         .oo';oo      cok,
    0oo.          .oo';oo       'odx
  .Ooc            .oo';oo         lo0.
 cxo,              cl ;oo          ;oxc
kdo.   'XXXXXXXXXXX0K.;oo lXXXXXXXX0oodO
 ooOd             .oo,;oo
   loOx    x0O 00o.oo';oo x0O    d00,
     cok0         .oo';oo      kOoo
       :oxxxxxxxxxdoo',oo oxxxxoc
        'ooooooooooo.  '   :ooo,
          '';
      };
    modules = [
        "os"
        "host"
        "kernel"
        "cpu"
        "cpuusage"
        "gpu"
        "memory"
        "disk"
        "swap"
        "uptime"
        "packages"
        "display"
        "wm"
        "cursor"
        "shell"
        "terminal"
        "localip"
        "battery"
        "locale"
        "editor"
      ];
    };
  };
}
