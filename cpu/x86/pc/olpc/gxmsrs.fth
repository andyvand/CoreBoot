purpose: Table of MSR values to setup Geode GX processor on OLPC

create gx-msr-init
\ Memsize-dependent MSRs are set in the early startup code

\ CPU
msr: 0000.1210 00000000.00000001.  \ GX p 121 Suspend on halt
msr: 0000.1900 00000000.00001131.  \ GX p 174 Default + SUSP + TSC_SUSP
msr: 0000.1a00 00000000.00000001.  \ GX p 178 Imprecise exceptions

\ northbridgeinit: GLIUS
\ Already mapped in early startup
\ msr: 1000.0020 20000000.000fff80.   \ 0 - 7.ffff low RAM
msr: 1000.0022 a00000fe.000ffffc.   \ fe00.0000 - fe00.3fff GP
msr: 1000.0023 c00000fe.008ffffc.   \ fe00.8000 - fe00.bfff VP
\ msr: 1000.0024 80000000.0a0fffe0.   \ 000a.0000 - 000b.ffff DC Don't need EGA frame buffer

\ msr: 1000.0025 000000ff.fff00000.   \ Unmapped - default

\ SMM memory (fbe) (40. is SMM_OFFSET)
\ msr: 1000.0026 2c7be040.400fffe0.   \ 4040.0000 - 405f.ffff relocated to 7fe.0000 - Memsize dependent
\ msr: 1000.0027 000000ff.fff00000.   \ Unmapped - default
\ msr: 1000.0028 20000007.7df00100.   \ 10.000 - 077d.f000 High RAM - Memsize dependent

\ Graphics
\ msr: 1000.0029 20a7e0fd.7fffd000.   \ fd00.0000 - fd7f.ffff mapped to 77e.0000 Memsize dependent (Frame Buffer)
msr: 1000.002a 801ffcfe.007fe004.   \ fe00.4000 - fe00.7fff mapped to 0 in DC space

\ msr: 1000.002b 00000000.000fffff.   \ Unmapped - default
\ msr: 1000.002c 20000000.f0000003.   \ f.0000 - f.ffff Read only to expansion ROM XXX

msr: 1000.0080 00000000.00000003.   \ Coherency
msr: 1000.0083 00000000.0000ff00.   \ Disable SMIs
msr: 1000.0084 00000000.0000ff00.   \ Disable Async errors

\ msr: 1000.00e0 80000000.3c0ffff0.   \ IOD_BM DC - VGA registers
\ msr: 1000.00e1 80000000.3d0ffff0.   \ IOD_BM DC - VGA registers
\ msr: 1000.00e3 00000000.f030ac18.   \ IOD_SC - Virtual Register - ac1c-ac1f

msr: 1000.2002 0000001f.0000001f.   \ Disables SMIs
msr: 1000.2004 00000000.00000005.   \ Clock gating

\ DMA incoming maps
\ X msr: 4000.0020 20000000.000fff80.   \ 0 - 7.ffff low RAM
\ X msr: 4000.0021 20000000.080fffe0.   \ 8.0000 - 9.ffff low RAM
msr: 4000.0020 20000000.000fff00.   \ 0 - f.ffff low RAM, route to GLIU0
msr: 4000.0022 200000fe.000ffffc.   \ fe00.0000 - fe00.03ff GP, route to GLIU0
\ msr: 4000.0023 20000040.400fffe0.   \ 4040.0000 - 4041.ffff SMM memory, route to GLIU0
msr: 4000.0024 200000fe.004ffffc.   \ fe00.4000 - fe00.7fff DC, route to GLIU0
msr: 4000.0025 200000fe.008ffffc.   \ fe00.8000 - fe00.bfff VP, route to GLIU0
\ msr: 4000.0026 20000000.0a0fffe0.   \ 000a.0000 - 000b.ffff DC in low mem;  XXX - no DOS frame  buffer
\ msr: 4000.0027 000000ff.fff00000.   \ Unmapped - default
\ msr: 4000.0028 000000ff.fff00000.   \ Unmapped - default
\ msr: 4000.0029 20000007.7df00100.   \ 10.0000 - 0f7d.f000 High RAM - Memsize dependent
msr: 4000.002a 200000fd.7fffd000.   \ frame buffer - fd00.0000 .. fd7f.ffff, route to GLIU0, fbsize
\ msr: 4000.002d 20000000.f0000003.   \ 000f.0000 - 000f.ffff expansion ROM; XXX - no expansion ROM
msr: 4000.0080 00000000.00000001.   \ Route coherency snoops from GLIU1 to GLIU0
msr: 4000.0083 00000000.0000ff00.   \ Disable SMIs

\ msr: 4000.00e0 20000000.3c0fffe0.   \ IOD_BM DC - VGA
msr: 4000.00e3 60000000.033000f0.   \ GLCP - Ports f0 and f1 incoming (clear FP IRQ13)
msr: 4000.2002 0000001f.0000001f.   \ Disables SMIs
msr: 4000.2004 00000000.00000005.   \ Clock gating

\ GeodeLink Priority Table
msr: 0000.2001 00000000.00000220.
msr: 4c00.2001 00000000.00000001.
msr: 5000.2001 00000000.00000027.
msr: 5800.2001 00000000.00000000.
msr: 8000.2001 00000000.00000320.

msr: 5400.2001 00000000.00000000.  \ In GX, 5400.xxxx is FooGlue, in LX it is VIP
msr: c000.2001 00000000.00040f80.
msr: c000.2004 00000000.00000155.  \ Clock gating
\ msr: c000.2001 00000000.00040f80.  \ DF config.  - Already set

\ Region config
\ msr: 1808 25fff002.1077e000.  \ Memsize dependent
\ msr: 180a 00000000.00000000.
msr: 1800 00002000.00000022.  \ Data memory - 2 outstanding write ser.,
                              \ INVD => WBINVD, serialize load misses.
msr: 180a 00000000.00000011.  \ Disable cache for table walks
msr: 1810 fd7ff000.fd000111.  \ Video (write through)
msr: 1811 fe003000.fe000101.  \ GP
msr: 1812 fe007000.fe004101.  \ DC
msr: 1813 fe00b000.fe008101.  \ VP

\ PCI
\ msr: 50002000 00000000.00105001. \ RO
msr: 5000.2001 00000000.00000027. \ Priority 2, domain 7
msr: 5000.2002 00000000.003f003f. \ No SMIs, please
msr: 5000.2003 00000000.00370037. \ No ERRs, please
msr: 5000.2004 00000000.00000015. \ Clock gating for 3 clocks
msr: 5000.2005 00000000.00000000. \ Enable some PCI errors
msr: 5000.2010 fff030f8.001a0215.
msr: 5000.2011 00000300.00000100. \ GLPCI_ARB
msr: 5000.2014 00000000.00f000ff.
msr: 5000.2015 35353535.35353535.
msr: 5000.2016 35353535.35353535.
msr: 5000.2017 35353535.35353535.
msr: 5000.2018 0009f000.00000130.
\ msr: 5000.2019 077df000.00100130.  \ Memsize dependent
msr: 5000.201a 4041f000.40400120.
msr: 5000.201b 00000000.00000000.
msr: 5000.201c 00000000.00000000.
msr: 5000.201e 00000000.00000f00.
msr: 5000.201f 00000000.0000004b.
\ msr: 5000.201f 00000000.0000006b.  \ Set below in bug workaround
\ We don't need posted I/O writes to IDE, as we have no IDE

\ clockgating
\ msr: 5400.2004 00000000.00000000.  \ Clock gating - default
\ msr: 5400.2004 00000000.00000003.  \ Clock gating

\ cpu/amd/model_gx2/cpubug.c

\ pcideadlock();

\ CPU_DM_CONFIG0 - 1800 - already set correctly above
\ Interlock instruction fetches to WS regions with data accesses
msr: 00001700 00000000.00100000.

\ We set all these to 0 (cacheable) because we
\ don't use them for the traditional DOS legacy devices.
msr: 0000180b 00000000.00000000. \ Regions a0000..bffff
msr: 0000180c 00000000.00000000. \ Regions c0000..dffff
msr: 0000180d 00000000.00000000. \ Regions e0000..fffff

\ eng1398();
msr: 2000.2004 00000000.00000003.  \ early setup uses 1, eng1398 changes to 3

\ eng2900();
msr: 0000.3003 0080a13d.00000000. \ Disables sysenter/sysexit in CPUID3

\ This is the Branch Target Buffer workaround
\ swapsif thing - don't do this stuff for use with FS2
msr: 4c00.005f 00000000.00000000. \ Disable enable_actions in DIAGCTL while setting up GLCP
msr: 4c00.0016 00000000.00000000. \ Changing DBGCLKCTL register to GeodeLink
msr: 4c00.0016 00000000.00000002. \ Changing DBGCLKCTL register to GeodeLink
msr: 1000.2005 00000000.80338041. \ Send mb0 port 3 requests to upper GeodeLink diag bits
msr: 4c00.0045 5ad68000.00000000. \ set5m watches request ready from mb0 to CPU (snoop)
msr: 4c00.0044 00000000.00000140. \ SET4M will be high when state is idle (XSTATE=11)
msr: 4c00.004d 00002000.00000000. \ SET5n to watch for processor stalled state
\ Writing action number 13: XSTATE=0 to occur when CPU is snooped unless we're stalled
msr: 4c00.0075 00000000.00400000.
msr: 4c00.0073 00000000.00030000. \ Writing action number 11: inc XSTATE every GeodeLink clock unless we're idle
msr: 4c00.006d 00000000.00430000. \ Writing action number 5: STALL_CPU_PIPE when exitting idle state or not in idle state
msr: 4c00.005f 00000000.80004000. \ Writing DIAGCTL Register to enable the stall action and to let set5m watch the upper GeodeLink diag bits.
\ End swapsif thing

\ bug118339();
msr: 4c00.005f 00000000.00000000. \ Disable enable_actions in DIAGCTL while setting up GLCP
msr: 4c00.0042 596b8000.00000a00. \ SET2M fires if VG pri is odd (3, not 2) and Ystate=0
msr: 4c00.0043 596b8040.00000000. \ SET3M fires if MBUS changed and VG pri is odd
msr: 1000.2005 00000000.80338041. \ Put VG request data on lower diag bus
msr: 4c00.0074 00000000.0000c000. \ Increment Y state if SET3M if true
msr: 4c00.0020 0000d863.20002000. \ Set up MBUS action to PRI=3 read of MBIU
msr: 4c00.0071 00000000.00000c00. \ Trigger MBUS action if VG=pri3 and Y=0, this blocks most PCI
msr: 4c00.005f 00000000.80004000. \ Writing DIAGCTL

\ Already set above, but to wrong value
msr: 4c00.0042 596b8008.00000a00. \ enable FS2 even when BTB and VGTEAR SWAPSiFs are enabled

\ bug784();  Put "Geode by NSC" in the ID
msr: 0000.3006 646f6547.80000006.
msr: 0000.3007 79622065.43534e20.
msr: 0000.3008 00000000.00000552.  \ Supposed to be same as msr 3002
msr: 0000.3009 c0c0a13d.00000000.

\ bug118253();
\ msr: 5000.201f 00000000.0000006b.  \ Disable GLPCI PIO Post Control
\ This is irrelevant because we don't use IDE, so posting to IDE ports is a don't care

\ disablememoryreadorder();
msr: 2000.0019 18000108.286332a3.

\ chipsetinit(nb);

\ set hd IRQ
\	outl	(GPIOL_2_SET, GPIOL_INPUT_ENABLE);
\	outl	(GPIOL_2_SET, GPIOL_IN_AUX1_SELECT);
\	/*  Allow IO read and writes during a ATA DMA operation.*/
\	/*   This could be done in the HD rom but do it here for easier debugging.*/
\	100 ATA_SB_GLD_MSR_ERR msr-bitclr
\	GLPCI_CRTL_PPIDE_SET GLPCI_SB_CTRL msr-bitset  \ Enable Post Primary IDE

\ Set the prefetch policy for various devices
msr: 5150.0001  0.00008f000.   \ AC97
msr: 5140.0001  0.00000f000.   \ DIVIL

\  Set up Hardware Clock Gating
msr: 5102.4004  0.000000004.  \ GLIU_SB_GLD_MSR_PM
msr: 5100.0004  0.000000005.  \ GLPCI_SB_GLD_MSR_PM
msr: 5170.0004  0.000000004.  \ GLCP_SB_GLD_MSR_PM
\ SMBus clock gating errata (PBZ 2226 & SiBZ 3977)
msr: 5140.0004  0.050554111.  \ DIVIL
msr: 5130.0004  0.000000005.  \ ATA
msr: 5150.0004  0.000000005.  \ AC97

\ setup_gx2();

\ Don't need this, RCONF is already set, cache is already on
\ .. size_kb = setup_gx2_cache();

\ 1000.0026 is already set

\ For now we will skip the real mode IDT setup and see if
\ we can get away with it - no real mode interrupts.
\ src/cpu/amd/model_gx2/vsmsetup.c:setup_realmode_idt();

\ do_vsmbios();

\ Graphics init
msr: a000.2001 00000000.00000010.  \ GP config (priority)
msr: a000.2002 00000001.00000001.  \ Disable GP SMI
msr: a000.2003 00000003.00000003.  \ Disable GP ERR
msr: a000.2004 00000000.00000001.  \ Clock gating
msr: 8000.2001 00000000.00000320.  \ VG config (priority)
msr: 8000.2002 0000001f.0000001f.  \ Disable SMIs
msr: 8000.2003 0000000f.0000000f.  \ Disable ERRs
\ msr: 8000.2004 00000000.00000000.  \ Clock gating - default
\ msr: 8000.2004 00000000.00000055.  \ Clock gating
msr: 8000.2011 00000000.00000001.  \ VG SPARE - VG fetch state machine hardware fix off
msr: 8000.2012 00000000.06060202.  \ VG DELAY

\ msr: 4c00.0015 00000037.00000001.  \ MCP DOTPLL reset; unnecessary because of later video init

\ More GLCP stuff
msr: 4c00.0021 00000000.0000001b.   \ GLD Action Data Control - undocumented
msr: 4c00.0022 00000000.00001001.   \ GLD Action Data
msr: 4c00.2004 00000000.00000005.   \ ( 15 GLCP_GLD_MSR_PM )

msr: 5000.2014 00000000.00ffffff.  \ Enables PCI access to low mem

\ 5536 region configs
msr: 5100.0002 00000000.007f0000.  \ Disable SMIs
msr: 5101.0002 0000000f.0000000f.  \ Disable SMIs

\ msr: 5100.0010 44000020.00020013.  \ PCI timings - already set
msr: 5100.0020 018b4001.018b0001.  \ Region configs
msr: 5100.0021 010fc001.01000001.  \ GPIO
msr: 5100.0022 0183c001.01800001.  \ MFGPT
msr: 5100.0023 0189c001.01880001.  \ IRQ mapper
msr: 5100.0024 0147c001.01400001.  \ PMS
msr: 5100.0025 0187c001.01840001.  \ ACPI
msr: 5100.0026 014fc001.01480001.  \ AC97 128 bytes (0x80)
msr: 5100.0027 fe01a000.fe01a001. \ OHCI
msr: 5100.0028 fe01b000.fe01b001. \ EHCI
msr: 5100.0029 efc00000.efc00001. \ UOC
msr: 5100.002b 018ac001.018a0001. \ IDE bus master
msr: 5100.002f 00084001.00084009. \ Port 84 (what??)
msr: 5101.0020 400000ef.c00fffff. \ P2D_BM0 UOC
msr: 5101.0023 500000fe.01afffff. \ P2D_BMK Descriptor 0 OHCI
msr: 5101.0024 400000fe.01bfffff. \ P2D_BMK Descriptor 1 EHCI
msr: 5101.0083 00000000.0000ff00. \ Disable SMIs
msr: 5101.00e0 60000000.1f0ffff8. \ IOD_BM Descriptor 0 ATA IO address
msr: 5101.00e1 a0000001.480fff80. \ IOD_BM Descriptor 1 AC97
msr: 5101.00e2 80000001.400fff80. \ IOD_BM Descriptor 2 PMS
msr: 5101.00e3 80000001.840fffe0. \ IOD_BM Descriptor 3 ACPI
\ msr: 5101.00e4 00000001.858ffff8. \ IOD_BM Descriptor 4 Don't carve ACPI into partially-emulated ranges
msr: 5101.00e5 60000001.8a0ffff0. \ IOD_BM Descriptor 5
\ msr: 5101.00eb 00000000.f0301850. \ IOD_SC Descriptor 1 Don't carve ACPI into partially-emulated ranges

msr: 5130.0008 00000000.000018a1. \ IDE_IO_BAR - IDE bus master registers

msr: 5140.0002 0000fbff.00000000. \ Disable SMIs

msr: 5140.0008 0000f001.00001880. \ LBAR_IRQ
msr: 5140.0009 fffff001.fe01a000. \ LBAR_KEL (USB)
msr: 5140.000b     f001.000018b0. \ LBAR_SMB
msr: 5140.000c     f001.00001000. \ LBAR_GPIO
msr: 5140.000d     f001.00001800. \ LBAR_MFGPT
msr: 5140.000e     f001.00001840. \ LBAR_ACPI
msr: 5140.000f     f001.00001400. \ LBAR_PMS
msr: 5140.0010 fffff007.20000000. \ LBAR_FLSH0
\ msr: 5140.0011  \ LBAR_FLSH1
\ msr: 5140.0012  \ LBAR_FLSH2
\ msr: 5140.0013  \ LBAR_FLSH3
\ msr: 5140.0014 00000000.80070003. \ LEG_IO already set in romreset
msr: 5140.0015 00000000.00000f7c. \ BALL_OPTS
msr: 5140.001b 00000000.00100010. \ NANDF_DATA
msr: 5140.001c 00000000.00000010. \ NANDF_CTL
msr: 5140.001f 00000000.00000011. \ KEL_CTRL
msr: 5140.0020 00000000.bb350a00. \ IRQM_YLOW NAND distract, NAND ready, PM SCI OR, AC97, RTC Alarm, USB, -, SW IRQ
msr: 5140.0021 00000000.04000000. \ IRQM_YHIGH UART1
msr: 5140.0022 00000000.00002222. \ IRQM_ZLOW MFGPTs
msr: 5140.0023 00000000.33b00600. \ IRQM_ZHIGH SCI-3, LID-3, CaFe-11, DCON-6
msr: 5140.0025 00000000.00001002. \ IRQM_LPC Enable mouse(12) and kbd (1)
\ msr: 5140.0028 00000000.000000ff. \ MFGPT_IRQ Leave this off
\ msr: 5140.0040 00000000.00000000. \ DMA_MAP - default
\ msr: 5140.004e 00000000.ef2500c0. \ LPC_SIRQ
\ msr: 5140.004e 00000000.effd0080. \ LPC_SIRQ
msr: 5140.004e 00000000.effd00c0. \ LPC_SIRQ - Active high bit 12 (mouse) and 2 (kbd), Enable, Quiet, 17 frames
msr: 5140.0055 00000000.0000003d.  \ RTC alarm day (offset into CMOS RAM)
msr: 5140.0056 00000000.0000003e.  \ RTC alarm month (offset into CMOS RAM)
msr: 5140.0057 00000000.00000032.  \ RTC century (offset into CMOS RAM)

\ USB host controller
msr: 5120.0001 0000000b.00000000.  \ USB_GLD_MSR_CONFIG - 5536 page 262
msr: 5120.0008 0000000e.fe01a000.  \ USB OHC Base Address - 5536 page 266
msr: 5120.0009 0000000e.fe01b000.  \ USB EHC Base Address - 5536 page 266
msr: 5120.000b 00000002.efc00000.  \ USB UOC Base Address - 5536 page 266

\ Clear possible spurious USB Short Serial detect bit per 5536 erratum 57
msr: 5120.0015 00000010.00000000.  \ USB_GLD_MSR_DIAG

here gx-msr-init - constant /gx-msr-init
