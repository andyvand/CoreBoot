\ See license at end of file
purpose: Configuration for loading from a USB key via Syslinux

\ --- The environment that "boots" OFW ---
\ - Image Format - Example Media - previous stage bootloader

\ - (Syslinux) COM32 format - USB Key w/ FAT FS - Syslinux
create syslinux-loaded

create serial-console
create pc

\ create pseudo-nvram
create resident-packages
create addresses-assigned  \ Don't reassign PCI addresses
\ create virtual-mode
create use-root-isa
create use-isa-ide
create use-ega
create use-elf
create use-ne2000
create use-watch-all
create use-null-nvram
create no-floppy-node

fload ${BP}/cpu/x86/pc/biosload/addrs.fth

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
