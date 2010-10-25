h# d101c000 constant load-base
: dl
   load-base   ( adr )
   begin  key dup control d <> while   ( adr char )
      over c! 1+                       ( adr' )
   repeat                              ( adr char )
   drop                                ( adr )
   load-base tuck - evaluate
;
: \ h# d parse 2drop  ; immediate

: init-mem
   d0004d56 d0000010 l! \ CONFIG_DECODE_ADDR
   000c0001 d0000100 l! \ MMAP0
   100c0001 d0000110 l! \ MMAP1
   00006420 d0000020 l! \ SDRAM_CONFIG_TYPE1-CS0
   00006420 d0000030 l! \ SDRAM_CONFIG_TYPE1-CS1
   00000000 d0000b40 l! \ SDRAM_CONFIG_TYPE2-CS0
   00000000 d0000b50 l! \ SDRAM_CONFIG_TYPE2-CS1
   488700c5 d0000050 l! \ SDRAM_TIMING1 !4cda00c5 tRTP 2>3, tWTR 2>3, tRC 7>1a (7>26)
   323300d2 d0000060 l! \ SDRAM_TIMING2 !94860342 tRP 3>9, tRRD 2>4, tRCD 3>8, tWR 3>6, tRFC d>34
   20000e12 d0000190 l! \ SDRAM_TIMING3 !2000381b ACS_EXIT_DLY 0>3, ACS_TIMER e>8, OUTEN 0>1, RSVD 0>1
   3023009d d00001c0 l! \ SDRAM_TIMING4
   00050082 d0000650 l! \ SDRAM_TIMING5 !  110142 tRAS 5>11, tFAW 8>14
   00909064 d0000660 l! \ SDRAM_TIMING6 ! 2424190 tZQCS 9>24, tZQOPER 24>90, tZQINIT 64>190
   00005000 d0000080 l! \ SDRAM_CTRL1
   00080010 d0000090 l! \ SDRAM_CTRL2
   c0000000 d00000f0 l! \ SDRAM_CTRL3
   20c08115 d00001a0 l! \ SDRAM_CTRL4
   01010101 d0000280 l! \ SDRAM_CTRL5_ARB_WEIGHTS
   00000000 d0000760 l! \ SDRAM_CTRL6_SDRAM_ODT_CTRL
   03000000 d0000770 l! \ SDRAM_CTRL7_SDRAM_ODT_CTRL2
   00000133 d0000780 l! \ SDRAM_CTRL8_SDRAM_ODT_CTRL2
   01010101 d00007b0 l! \ SDRAM_CTRL11_ARB_WEIGTHS_FAST_QUEUE
   0000000f d00007d0 l! \ SDRAM_CTRL13
   00000000 d00007e0 l! \ SDRAM_CTRL14
   00000000 d0000540 l! \ MCB_CTRL4
   00000001 d0000570 l! \ MCB_SLFST_SEL
   00000000 d0000580 l! \ MCB_SLFST_CTRL0
   00000000 d0000590 l! \ MCB_SLFST_CTRL1
   00000000 d00005a0 l! \ MCB_SLFST_CTRL2
   00000000 d00005b0 l! \ MCB_SLFST_CTRL3
   00000000 d0000180 l! \ CM_WRITE_PROTECTION
   00000000 d0000210 l! \ PHY_CTRL11
   80000000 d0000240 l! \ PHY_CTRL14 - PHY sync enable
   2000ce00 d0000240 l! \ PHY_CTRL14 - PHY DLL Reset (20000000)
   0000ce00 d0000240 l! \ PHY_CTRL14 - release reset
   0011ce00 d0000200 l! \ PHY_CTRL10
   0010311c d0000200 l! \ PHY_CTRL10
   20004422 d0000140 l! \ PHY_CTRL3  !20004444  PHY_RFIFO_RPTR_DLY_VAL 2>4, DQ_EXT_DLY 2>4
   13300559 d00001d0 l! \ PHY_CTRL7  (0x2330_0339 / 0x133C_2559)
   03300990 d00001e0 l! \ PHY_CTRL8
   00000077 d00001f0 l! \ PHY_CTRL9
   20000088 d0000230 l! \ PHY_CTRL13  (0x2000_0108 / 0x2024_0109)
   00000080 d0000e10 l! \ PHY_DLL_CTRL1
   00000080 d0000e20 l! \ PHY_DLL_CTRL2
   00000080 d0000e30 l! \ PHY_DLL_CTRL3
   00000000 d0000e40 l! \ PHY_CTRL_WL_SELECT
   00000000 d0000e50 l! \ PHY_CTRL_WL_CTRL0
   03000001 d0000120 l! \ USER_INITIATED_COMMAND0 - init command to both CS (need to wait 200 us for tINIT3)
   0302003f d0000410 l! \ USER_INITIATED_COMMAND1 - MRW MR63 (RESET) to both CS (need to wait RESET_COUNT)
   01001000 d0000120 l! \ USER_INITIATED_COMMAND0 - MRW MR10 (ZQ long cal) to CS0 (need 360 ns delay for tZQCS)
   02001000 d0000120 l! \ USER_INITIATED_COMMAND0 - MRW MR10 (ZQ long cal) to CS1 (need 360 ns delay for tZQCS)
   03020001 d0000410 l! \ USER_INITIATED_COMMAND1 - MRW MR1 to both CS
   03020002 d0000410 l! \ USER_INITIATED_COMMAND1 - MRW MR2 to both CS
   03020003 d0000410 l! \ USER_INITIATED_COMMAND1 - MRW MR3 to both CS
;
