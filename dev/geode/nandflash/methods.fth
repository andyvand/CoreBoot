\ See license at end of file
purpose: Interface methods for AMD CS5536 NAND controller

external

: msr@  ( adr -- d )  " rdmsr" eval  ;
: open  ( -- okay? )
   \ We assume that LinuxBIOS has already set up the address map
   \ and the timing MSRs.
   set-lmove
   h# 51400010 msr@ drop to nand-base
   configure 0=  if  false exit  then

   get-bbt

   my-args  dup  if   ( arg$ )
      " jffs2-file-system" find-package  if  ( arg$ xt )
         interpose  true   ( okay? )
      else                 ( arg$ )
         ." Can't find jffs2-file-system package" cr
         2drop  false      ( okay? )
      then                 ( okay? )
   else                    ( arg$ )
      2drop  true          ( okay? )
   then                    ( okay? )
;
: close  ( -- )  ;

: size  ( -- d )  pages/chip /page um*  ;

: dma-alloc  ( len -- adr )  " dma-alloc" $call-parent  ;

: dma-free  ( adr len -- )  " dma-free" $call-parent  ;

headers

[then]
\ LICENSE_BEGIN
\ Copyright (c) 2006 FirmWorks
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
