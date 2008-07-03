purpose: Diagnostics for AC97 Driver for Geode CS5536 companion chip
\ See license at end of file

0 value record-base
h# 80000 value record-len

0 value mic-boost?
h# 808 value rlevel
: set-rlevel  ( db -- )
   dup d# 20 >=  if  d# 20 -  true  else  false then  ( db' boost? )
   to mic-boost?                                       ( db )
   h# 22 min  1+ 2* 3 /  dup bwjoin  to rlevel
;

: establish-level  ( -- )
   mic-boost?   if  mic+20db  else  mic+0db  then
   rlevel set-record-gain
   d# 250 ms    \ Settling time for DC offset filter
;

: record  ( -- )
   open-in  establish-level
   record-base  record-len  audio-in drop
   close-in
;

: play  ( -- )
   open-out
   record-base  record-len  audio-out drop  write-done
;

d# 500 value tone-freq

: /cycle  ( -- #bytes )  #cycle /l*  ;

: make-cycle  ( adr -- adr' )
   #quarter-cycle 1+  0  do               ( adr )
      i isin                              ( adr isin )
      2dup  swap  i la+ w!                ( adr isin )
      2dup  swap  #half-cycle i - la+ w!  ( adr isin )
      negate                              ( adr -isin )
      2dup  swap  #half-cycle i + la+ w!  ( adr -isin )
      over  #cycle i - la+ w!             ( adr )
   loop                                   ( adr )
   /cycle +
;

: make-tone  ( freq -- )
   sample-rate to fs  ( freq )  set-freq

   \ Start with everything quiet
   record-base record-len erase

   record-base  make-cycle  drop

   \ Copy the wave template into the left channel
   record-base /cycle +   record-len 2/  /cycle -  bounds  ?do
      record-base  i  /cycle  move
   /cycle +loop

   \ Copy the wave template into the right channel
   record-base record-len 2/ + wa1+  record-len 2/ /cycle -   bounds  ?do
      record-base  i  /cycle  move
   /cycle +loop
;

: tone  ( freq -- )
   record-len la1+  " dma-alloc" $call-parent  to record-base
   make-tone
   d# -9 set-volume  play
   record-base record-len la1+  " dma-free" $call-parent
;

: copy-cycle  ( adr #copies -- adr' )
   1  ?do                      ( adr )
      dup  /cycle -  over      ( adr adr- adr )
      /cycle move              ( adr )
      /cycle +                 ( adr+ )
   loop                        ( adr' )
;

: make-sweep  ( -- )
   \ Start with everything quiet
   record-base record-len erase

   sample-rate to fs

   record-base
   1  d# 30  do            ( adr )
      i set-period         ( adr )
      make-cycle           ( adr )
      d# 35 copy-cycle     ( adr' )
   -1 +loop
   drop

\   record-base   record-base record-len 2/ + wa1+  record-len 2/ /w -  move
   \ Copy the left channel into the right channel in reverse order
   record-base   record-len /w -  bounds   ( end start )
   begin  2dup u>  while                   ( end start )
      2dup w@ swap w!                      ( end start )
      swap /w -  swap wa1+                 ( end' start' )
   repeat                                  ( end start )
   2drop
;


: selftest-args  ( -- arg$ )  my-args ascii : left-parse-string 2drop  ;

: wav-test  ( -- )
   selftest-args dup 0=  if  2drop exit  then
   " $play-wav-loop" $find 0=  if  2drop  else  catch drop  then
;

: sweep-test  ( -- )
   ." Playing sweep" cr
   make-sweep
   d# -9 set-volume  play
;

: mic-test  ( -- )
   ." Recording ..." cr
   record
   ." Playing ..." cr
   d# -3 set-volume  play
;

: selftest  ( -- error? )
   open 0=  if  ." Failed to open /audio" cr true exit  then
   wav-test
   record-len la1+  " dma-alloc" $call-parent to record-base
   sweep-test
   mic-test
   record-base record-len la1+  " dma-free" $call-parent
   close false
;

\ LICENSE_BEGIN
\ Copyright (c) 2007 FirmWorks
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
