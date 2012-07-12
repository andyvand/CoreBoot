create debug-startup
create olpc
create olpc-cl2
create trust-ec-keyboard
create use-null-nvram
create use-elf
create has-sp-kbd
create has-dcon

fload ${BP}/cpu/arm/mmp2/hwaddrs.fth
fload ${BP}/cpu/arm/olpc/addrs.fth

[ifdef] use-flash-nvram
h# d.0000 constant nvram-offset
[then]

h#  e.0000 constant mfg-data-offset     \ Offset to manufacturing data area in SPI FLASH
h#  f.0000 constant mfg-data-end-offset \ Offset to end of manufacturing data area in SPI FLASH
h#  f.ffd8 constant crc-offset

h# 10.0000 constant /rom           \ Total size of SPI FLASH

: signature$    " CL2"  ;
: model$        " olpc,XO-1.75"  ;
: compatible$   " olpc,xo-1.75"  ;

d#  9999 constant machine-type  \ Backwards compatibility with non-device-tree kernel

char 4 constant expected-ec-version
h# 8000 value /ec-flash

h# 10000 constant l2-#sets

fload ${BP}/cpu/arm/olpc/1.75/gpiopins.fth
