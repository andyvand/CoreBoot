\ See license at end of file
\ " dcon" device-name

also forth definitions
: has-dcon-ram?  ( -- flag )
   board-revision h# 1b18 =  if  true exit  then
   board-revision h# 1b48 >=  if  true exit  then
   false
;
previous definitions

new-device
" dcon" device-name
" olpc,xo1-dcon" +compatible
" olpc,xo1.75-dcon" +compatible
finish-device

stand-init:
   has-dcon-ram?  0=  if
      " /dcon? find-device
      0 0 " no-freeze" property
      device-end
   then
;

\ DCON internal registers, accessed via I2C
\ 0 constant DCON_ID
\ 1 constant DCON_MODE
\ 2 constant DCON_HRES
\ 3 constant DCON_HTOTAL
\ 4 constant DCON_HSYNC_WIDTH
\ 5 constant DCON_VRES
\ 6 constant DCON_VTOTAL
\ 7 constant DCON_VSYNC_WIDTH
\ 8 constant DCON_TIMEOUT
\ 9 constant DCON_SCAN_INT
\ d# 10 constant DCON_BRIGHT

\ Mode register bits
\ h#    1 constant DM_PASSTHRU
\ h#    2 constant DM_SLEEP
\ h#    4 constant DM_SLEEP_AUTO
\ h#    8 constant DM_BL_ENABLE
\ h#   10 constant DM_BLANK
\ h#   20 constant DM_CSWIZZLE
\ h#   40 constant DM_COL_AA
\ h#   80 constant DM_MONO_LUMA
\ h#  100 constant DM_SCAN_INT
\ h#  200 constant DM_CLOCKDIV
\ h# 4000 constant DM_DEBUG
\ h# 8000 constant DM_SELFTEST

: set-dcon-slave  ( -- )
[ifdef] cl2-a1
   d# 162 to smb-clock-gpio#
   d# 163 to smb-data-gpio#
[else]
   d# 161 to smb-clock-gpio#
   d# 110 to smb-data-gpio#
[then]
   h# 1a to smb-slave
;

: smb-init    ( -- )  set-dcon-slave  smb-on  smb-pulses  ;

: dcon@  ( reg# -- word )  set-dcon-slave  smb-word@  ;
: dcon!  ( word reg# -- )  set-dcon-slave  smb-word!  ;

[ifdef] cl2-a1
: dcon-load  ( -- )  d# 151 gpio-set  ;
: dcon-unload  ( -- )  d# 151 gpio-clr  ;
[else]
: dcon-load  ( -- )  d# 142 gpio-set  ;
: dcon-unload  ( -- )  d# 142 gpio-clr  ;
[then]
\ : dcon-blnk?  ( -- flag )  ;  \ Not hooked up
: dcon-stat@  ( -- n )  h# 019100 io@ 4 rshift 3 and  ;
: setup-dcon-irq  ( -- )  d# 124 dup gpio-set-fer  gpio-clr-edge  ;
: dcon-irq?  ( -- flag )  d# 124 gpio-edge@  ;

\ DCONSTAT values:  0 SCANINT  1 SCANINT_DCON  2 DISPLAYLOAD  3 MISSED

1 value vga? \ VGA
0 value color? \ COLOUR

d# 905 value resumeline  \ Configurable; should be set from args

: wait-output  ( -- )  d# 40 ms  ;

: mark-time  ( -- start-time )  get-msecs  ;
: delta-ms  ( start-time -- elapsed-ms )  mark-time  swap -   ;
: wait-dcon-mode  ( -- retry? )
   mark-time                            ( start-time )
   begin                                ( start-time )
      dcon-irq?  if                     ( start-time )
         dcon-stat@  2 =  if  \ DCONSTAT=10  ( start-time )
            \ Sometimes the DCON ack's the UNLOAD command sooner than it
            \ should.  When that happens, it doesn't really capture the
            \ new frame data.  The workaround is to detect the case and
            \ retry the sequence.
            delta-ms  d# 20 <           ( retry? )
            exit   
         then                           ( start-time )
      then                              ( start-time )
      dup delta-ms  d# 100 >            ( start-time reached? )    \ 100 ms timeout
   until                                ( start-time )
   drop
   ." Timeout entering DCON mode" cr
   \ We say false here because we don't want to retry; it probably won't succeed
   false
;

: set-source ( vga? -- )  \ true to unfreeze display, false to freeze it
   dup vga? =  if  drop exit  then  ( source )
   dup to vga?                      ( source )
   if
\      unblank-display
      d# 50 ms
      wait-output
      dcon-load  \ Put the DCON in VGA-refreshed mode
      d# 25 ms   \ Ensure that that DCON sees the DCONLOAD high
\      display-on
   else
      has-dcon-ram?  if
         begin                             ( )
            setup-dcon-irq
            dcon-unload  \ Put the DCON in self-refresh mode
            wait-dcon-mode                 ( retry? )
            \        display-off           ( retry? )
         while                             ( )
            \ We got a false ack from the DCON so start over from LOAD state
            dcon-load  d# 25 ms            ( )
         repeat                            ( )
      then
   then
;

\ gx_configure_tft(info);

: try-dcon!  ( w reg# -- )
   ['] dcon!  catch  if  2drop  smb-stop 1 ms  smb-off  1 ms  smb-on  then
;

: mode@    ( -- mode )    1 dcon@  ;
: mode!    ( mode -- )    1 dcon!  ;
: hres!    ( hres -- )    2 dcon!  ;  \ def: h#  458 d# 1200
: htotal!  ( htotal -- )  3 dcon!  ;  \ def: h#  4e8 d# 1256
: hsync!   ( sync -- )    4 dcon!  ;  \ def: h# 1808 d# 24,8
: vres!    ( vres -- )    5 dcon!  ;  \ def: h#  340 d# 900
: vtotal!  ( htotal -- )  6 dcon!  ;  \ def: h#  390 d# 912
: vsync!   ( sync -- )    7 dcon!  ;  \ def: h#  403 d# 4,3
: timeout! ( to -- )      8 dcon!  ;  \ def: h# ffff
: scanint! ( si -- )      9 dcon!  ;  \ def: h# 0000
: bright!  ( level -- ) d# 10 dcon! ; \ def: h# xxxF
: bright@  ( -- level ) d# 10 dcon@ ;
: brighter  ( -- )  bright@ 1+  h# f min  bright!  ;
: dimmer    ( -- )  bright@ 1-  0 max  bright!  ;

: backlight-off  ( -- )  mode@  8 invert and  mode!  ;
: backlight-on   ( -- )  mode@  8 or  mode!  ;

\ Color swizzle, AA, no passthrough, backlight
: set-color ( color? -- )
   dup to color?
   if  h# 69  else  h# 89  then  mode!
;

\ Setup so it can be called by execute-device-method
: dcon-off  ( -- )  smb-init  h# 12 ['] mode!  catch  if  drop  then  ;

: dcon2?  ( -- flag )
   5 0  do
      0 ['] dcon@ catch  0=  if    ( x )
         h# dc02 =  unloop exit
      then                         ( x )
      drop   d# 50 ms  smb-init    ( )
   loop
   false
;

: dcon-setup  ( -- error? )
   dcon2?  0=  if  ." Can't init DCON"  true exit  then

[ifdef] notdef
   d# 1200 2 dcon!  \ HResolution
   d# 1240 3 dcon!  \ HTotal
   h# 0608 4 dcon!  \ HSyncstart (6+900=906), HSyncwidth (8)
   d#  900 5 dcon!  \ VResolution
   d#  912 6 dcon!  \ VTotal
   h# 0502 7 dcon!  \ VSyncstart (5+900=905), VSyncwidth (2)
[then]
   
   \ Switch to OLPC mode
   h# c040  h# 3a dcon!   \ SDRAM Setup/Hold time.  Default of e040 fails
   h# 0000  h# 41 dcon!   \ Himax suggested this sequence (0 then 0101)

   h# 0101  h# 41 dcon!
   h# 0101  h# 42 dcon!

   h# 12 mode!
   false
;
: dcon-enable  ( -- )
   dcon-setup  if  exit  then
   true set-color
   h# f bright!
;

: video-save
   0 set-source  \ Freeze image
;

: video-restore
   smb-init
   1 set-source  \ Unfreeze image
;

0 value dcon-found?

: maybe-set-cmos  ( -- )  ;

: init-xo-display  ( -- )
   smb-init

   dcon-load
   dcon-enable  ( maybe-set-cmos )
   \ dcon-enable leaves mode set to 69 - 40:antialias, 20:swizzle, 8:backlight on, 1:passthru off
;
: dcon-power-on   ( -- )  1 h# 26 ec-cmd-b!  ;
: dcon-power-off  ( -- )  0 h# 26 ec-cmd-b!  ;
0 value saved-dcon-mode
0 value saved-brightness
: dcon-suspend  ( -- )
   bright@ to saved-brightness
   mode@ to saved-dcon-mode
   h# 12 mode!
   dcon-power-off
;
: dcon-resume  ( -- )
   ['] dcon-power-on catch  if
      ." dcon-power-on failed" cr
      exit
   then
   d# 80 ms   
   dcon-setup  if  exit  then
   saved-dcon-mode  mode!
   saved-brightness bright!
;

\ LICENSE_BEGIN
\ Copyright (c) 2010 FirmWorks
\ 
\ Permission is hereby granted, free of charge, to any person obtaining
\ a copy of this software and associated documentation files (the
\ "Software"), to deal in the Software without restriction, including
\ without limitation the rights to use, copy, modify, merge, publish,
\ distribute, sublicense, and/or sell copies of the Software, and to
\ permit persons to whom the Software is furnished to do so, subject to
\ the following conditions:
\ 
\ The above copyright notice and this permission notice shall be
\ included in all copies or substantial portions of the Software.
\ 
\ THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
\ EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
\ MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
\ NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
\ LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
\ OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
\ WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
\
\ LICENSE_END
