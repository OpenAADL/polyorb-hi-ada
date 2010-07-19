# BEGIN: DO NOT DELETE THIS LINE
ADA_SPECS_WITH_BODY = $(srcdir)/ping.ads			\
	$(srcdir)/pinged.ads $(srcdir)/gr_rasta_fpga.ads

ADA_SPECS = $(ADA_SPECS_WITH_BODY)

ADA_BODIES = $(ADA_SPECS_WITH_BODY:.ads=.adb)

AADL_SOURCES = $(srcdir)/generic_bus.aadl $(srcdir)/grspw.aadl	\
	$(srcdir)/generic_native.aadl $(srcdir)/gruart.aadl	\
	$(srcdir)/software.aadl $(srcdir)/gr_cpci_x4cv.aadl	\
	$(srcdir)/native_uart.aadl $(srcdir)/system_demo.aadl	\
	 $(srcdir)/grrastafpga.aadl

# END: DO NOT DELETE THIS LINE

include $(srcdir)/../../Makefile.common

SCENARIO_FILES=	

CHECKABLE_SCENARIO_FILES=

if HAS_GNATMAKE_FOR_LEON
   SCENARIO_FILES+= $(srcdir)/scenario_spw.aadl			\
	 $(srcdir)/scenario.aadl $(srcdir)/scenario_uart.aadl	\
	 $(srcdir)/scenario_uart_2.aadl				\
	 $(srcdir)/scenario_uart_native.aadl			\
	 $(srcdir)/scenario_no_cnx_leon.aadl			\
	 $(srcdir)/scenario_no_cnx_native.aadl			\
	 $(srcdir)/scenario_fpga.aadl
endif

# Note: we may not package $(srcdir)/scenario_uart_2.aadl because some
# platforms do not support g-sercom

EXTRA_DIST = $(ADA_SPECS) $(ADA_BODIES) $(AADL_SOURCES) $(SCENARIO_FILES)

CLEANDIRS=the_demo_full the_demo_uart the_demo_uart_2 the_demo_spw
