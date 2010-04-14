############################################################
# $Id: Makefile.am 6999 2009-09-18 13:54:23Z hugues $
# Makefile for the PolyORB HI User's Guide
###########################################################

SRC_CODE = $(srcdir)/polyorb_hi-periodic_task.ads \
	$(srcdir)/polyorb_hi-sporadic_task.ads \
	$(srcdir)/polyorb_hi-hybrid_task.ads \
	$(srcdir)/polyorb_hi-marshallers_g.ads \
	$(srcdir)/polyorb_hi-messages.ads \
	$(srcdir)/polyorb_hi-output.ads \
	$(srcdir)/polyorb_hi-thread_interrogators.ads \
	$(srcdir)/polyorb_hi-protocols.ads \
	$(srcdir)/polyorb_hi-transport_low_level.ads \
	$(srcdir)/gnat.adc \
	$(srcdir)/native.adc \
	$(srcdir)/hi-e.adc

DOC_CODE = $(srcdir)/bounded_array.ada \
	$(srcdir)/bounded_str.ada \
	$(srcdir)/data_struct.ada \
	$(srcdir)/node_a_marshallers.ads \
	$(srcdir)/node_a_activity.ads \
	$(srcdir)/node_a_activity_full.ads \
	$(srcdir)/node_a_code.adb \
	$(srcdir)/node_a_deployment.ads \
	$(srcdir)/node_a_deployment_full.ads \
	$(srcdir)/node_a_full.adb \
	$(srcdir)/node_a_naming.ads \
	$(srcdir)/node_a_subprograms.ads \
	$(srcdir)/node_a_transport.ads \
	$(srcdir)/protected_obj_body.ada \
	$(srcdir)/protected_obj_spec.ada \
	$(srcdir)/node_a_types.ads

AADL_MODELS = $(srcdir)/complex_types.aadl \
	$(srcdir)/asn1_types.aadl \
	$(srcdir)/do_ping_spg.aadl \
	$(srcdir)/hardware.aadl \
	$(srcdir)/node_a_model.aadl \
	$(srcdir)/ping.aadl \
	$(srcdir)/port_cnx.aadl \
	$(srcdir)/processor_binding.aadl \
	$(srcdir)/protected_object_types.aadl \
	$(srcdir)/simple_types.aadl \
	$(srcdir)/thread_a.aadl \
	$(srcdir)/thread_a_full.aadl \
	$(srcdir)/scenario_sample.aadl \
	$(srcdir)/scenario_local_gnat.aadl \
	$(srcdir)/device_drivers.aadl \
	$(srcdir)/ping_native.aadl

FIGURES = $(srcdir)/fig/ping.eps \
	$(srcdir)/fig/ping.pdf  \
	$(srcdir)/fig/ping.png

GUIDE = polyorb-hi-ada_ug

SRC_CODE_TEXIFILES = ${notdir $(SRC_CODE:.ads=.texi) $(SRC_CODE:.adc=.texi)}
DOC_CODE_TEXIFILES = ${notdir $(DOC_CODE:.ads=.texi) \
	$(DOC_CODE:.ada=.texi) \
	$(DOC_CODE:.adb=-body.texi)}
AADL_TEXIFILES = ${notdir $(AADL_MODELS:.aadl=.texi)}

GUIDE_TEXIFILES = polyorb-hi_ug_ref.texi			\
	$(srcdir)/polyorb-hi-ada_api.texi $(SRC_CODE_TEXIFILES)	\
	$(DOC_CODE_TEXIFILES) $(AADL_TEXIFILES)

EXTRA_DIST=\
	$(GUIDE_TEXIFILES) \
	$(SRC_CODE) \
	$(DOC_CODE) \
	$(AADL_MODELS) \
	$(srcdir)/CODING_GUIDELINES \
	$(srcdir)/CONTRIBUTING \
	$(srcdir)/polyorb_hi.css \
	$(srcdir)/gfdl.texi \
	$(srcdir)/conventions.texi \
	$(srcdir)/polyorb-hi_ug_ref.tex \
	polyorb-hi_ug_ref.bbl \
	polyorb-hi_ug_ref.aux \
	$(srcdir)/polyorb-hi_ug.bib \
	$(FIGURES)

info_TEXINFOS = polyorb-hi-ada_ug.texi
polyorb_hi_ada_ug_TEXINFOS = $(GUIDE_TEXIFILES)

SUFFIXES = .ada .ads .adb .aadl .texi .sed .pdf .html

all-local: $(GUIDE_TEXIFILES) $(GUIDE).html $(GUIDE).pdf

# The 3 target above are active only in developper mode. In package
# mode, once the files in doc/ have been packaged, they are not
# overriden.

$(SRC_CODE):
	for file in $(SRC_CODE); do \
	  cp -f $(top_srcdir)/src/`basename $${file}` $(srcdir); \
	done

$(DOC_CODE):
	for file in $(DOC_CODE); do \
	  cp -f $(srcdir)/code/`basename $${file}` $(srcdir); \
	done

# Build the table of PolyORB-HI-Ada API files

$(srcdir)/polyorb-hi-ada_api.texi:
	echo "@c FILE GENERATED AUTOMATICALLY DO NOT EDIT" > $@
	echo "@menu" >> $@
	for file in $(API_CODE); do \
	echo "* " `basename $${file}`"::" >> $@; \
	done
	echo "@end menu" >> $@
	echo "" >> $@
	for file in $(API_CODE); do \
	echo "@node" `basename $${file}` >> $@; \
	echo "@section @code{" `basename $${file}`"}" >> $@; \
	echo "@include " `basename $${file} .ads`".texi" >> $@; \
	echo "" >> $@; \
	done

$(AADL_MODELS):
	for file in $(AADL_MODELS); do \
	  cp -f $(srcdir)/model/`basename $${file}` $(srcdir); \
	done

polyorb-hi_ug_ref.texi: polyorb-hi_ug_ref.bbl
	@sed -e 's/~/ /g' \
	-e 's/\\[-`'\''"c^]//g' \
	-e 's/\\emdash */---/g' \
	-e 's/metapost/MetaPost/g' \
	-e 's/\\MF/Metafont/g' \
	-e 's/\\METAFONT/METAFONT/g' \
	-e 's/\\TUB/TUGboat/g' \
	-e 's/\\LaTeX/La@TeX/g' \
	-e 's/\\AMSTEX/AMS@TeX/g' \
	-e 's/\\AmSTeX/AMS@TeX/g' \
	-e 's/\\TeX/@TeX/g' \
	-e 's/\\noopsort{[^}]*}//g' \
	-e 's/[{}\]//g' \
	-e 's/@\[/{/g' \
	-e 's/@\]/}/g' \
	-e 's/@TeX/@TeX{}/g' \
	$< >$@

polyorb-hi_ug_ref.bbl: polyorb-hi_ug_ref.aux
	-TEXINPUTS="$(srcdir):.:" \
	 BIBINPUTS="$(srcdir):.:" \
	 BSTINPUTS="$(srcdir):.:" \
	  $(BIBTEX) polyorb-hi_ug_ref

polyorb-hi_ug_ref.aux: $(srcdir)/polyorb-hi_ug_ref.tex $(srcdir)/polyorb-hi_ug.bib
	rm -f polyorb-hi_ug_ref.bbl
	-TEXINPUTS="$(srcdir):.:" \
	 BIBINPUTS="$(srcdir):.:" \
	 BSTINPUTS="$(srcdir):.:" \
	  $(TEX) '\nonstopmode \input $<'

# The PolyORB HI User's Guide texi file does not provide Up links in
# @node commands, but we want to force generation of HTML
# documentation anyway.

$(GUIDE).html: $(srcdir)/$(GUIDE).texi
	$(MAKEINFO) --css-include=$(srcdir)/polyorb_hi.css --html --number-sections $(srcdir)/$(GUIDE).texi -o $(GUIDE).html
	rm -rf $(GUIDE).html/fig
	mkdir -p $(GUIDE).html/fig
	cp $(srcdir)/fig/*.png $(GUIDE).html/fig/
	INDEX_FILE="$(GUIDE).html/index.html";\
	TMP_FILE="$$INDEX_FILE.tmp"; \
	cat "$$INDEX_FILE" | sed 's/$$LastChangedDate: \([^$$]*\) \$$/Last Modified: \1/g' > "$$TMP_FILE"; \
	mv -f "$$TMP_FILE" "$$INDEX_FILE"

$(GUIDE).pdf: $(srcdir)/$(GUIDE).texi
	-$(TEXI2DVI) -o $@ --pdf $<

po_hi_doc_dir=${shell $(CYGPATH_U) '$(OCARINA_PREFIX)/share/doc/ocarina'}

install-data-local: all
	$(INSTALL) -d  $(DESTDIR)$(po_hi_doc_dir)
	$(INSTALL) -d  $(DESTDIR)$(po_hi_doc_dir)/$(GUIDE).html
	$(INSTALL) -d  $(DESTDIR)$(po_hi_doc_dir)/$(GUIDE).html/fig
	if [ -r $(GUIDE).pdf ]; then \
	  $(INSTALL_DATA) $(GUIDE).pdf  $(DESTDIR)$(po_hi_doc_dir); \
	  for f in $(GUIDE).html/*.html; do \
            $(INSTALL_DATA) $$f  $(DESTDIR)$(po_hi_doc_dir)/$(GUIDE).html; \
          done; \
	  for f in $(GUIDE).html/fig/*.png; do \
            $(INSTALL_DATA) $$f  $(DESTDIR)$(po_hi_doc_dir)/$(GUIDE).html/fig; \
          done; \
	else \
	  $(INSTALL_DATA) $(srcdir)/$(GUIDE).pdf  $(DESTDIR)$(po_hi_doc_dir); \
	  for f in $(srcdir)/$(GUIDE).html/*.html; do \
            $(INSTALL_DATA) $$f  $(DESTDIR)$(po_hi_doc_dir)/$(GUIDE).html; \
          done; \
	  for f in $(srcdir)/$(GUIDE).html/fig/*.png; do \
            $(INSTALL_DATA) $$f  $(DESTDIR)$(po_hi_doc_dir)/$(GUIDE).html/fig; \
          done; \
	fi

uninstall-local:
	rm -f  $(DESTDIR)$(po_hi_doc_dir)/$(GUIDE).pdf
	rm -rf  $(DESTDIR)$(po_hi_doc_dir)/$(GUIDE).html

clean-local:
	@-rm -f *.aux *.log *.dvi *.bbl *.blg *~ *.bak *.toc 
	@-rm -f ${SRC_CODE} ${DOC_CODE} ${AADL_MODELS}

realclean: clean
	@-rm -f $(GUIDE).ps $(GUIDE).pdf $(GUIDE_TEXIFILES)

DISTCLEANFILES = $(GUIDE).ps $(GUIDE).pdf $(GUIDE_TEXIFILES) \
	ada.sed ada.sed-stamp aadl.sed aadl.sed-stamp

#
# Texi generation from source files
#

%.texi: %.ads $(top_srcdir)/support/gentexifile
	$(MAKE) ada.sed
	$(SHELL) $(top_srcdir)/support/gentexifile $< NOGROUP
	-@${RM} genout

%.texi: %.adc $(top_srcdir)/support/gentexifile
	$(MAKE) ada.sed
	$(SHELL) $(top_srcdir)/support/gentexifile $< NOGROUP
	-@${RM} genout

%.texi: %.ada $(top_srcdir)/support/gentexifile
	$(MAKE) ada.sed
	$(SHELL) $(top_srcdir)/support/gentexifile $< NOGROUP
	-@${RM} genout

%-body.texi: %.adb $(top_srcdir)/support/gentexifile
	$(MAKE) ada.sed
	$(SHELL) $(top_srcdir)/support/gentexifile $< NOGROUP
	-@${RM} genout

%.texi: %.aadl $(top_srcdir)/support/gentexifile
	$(MAKE) aadl.sed
	$(SHELL) $(top_srcdir)/support/gentexifile $< NOGROUP
	-@${RM} genout

ADA_KW= with while when use until type then terminate task tagged subtype \
	separate select reverse reverse return requeue renames rem record \
	range raise protected procedure private pragma package out others \
	or of null not new mod loop limited is in if goto generic function \
	for exit exception entry end elsif else do digits delta delay \
	declare constant configuration case body begin array and all aliased \
	access accept abstract abs abort

ada.sed: ada.sed-stamp
	echo "s/\([^@]\)@\([^@]\)/\1@@\2/g"                      >  ada.sed
	echo "s/-- \(.*\)$$/-- @i{\1}/"                          >> ada.sed
	echo "s/\([^-][^-][^\"]*\)\"\([^\"]*\)\"/\1\"@i{\2}\"/g" >> ada.sed
	echo "s/@@/@@@@/g"                                       >> ada.sed
	echo "s/_@_/_@@_/g"                                      >> ada.sed
	for kw in $(ADA_KW); do \
		echo "s/^\([^-]* \)$$kw/\1@b{$$kw}/g"            >> ada.sed; \
		echo "s/^\( *\)$$kw /\1@b{$$kw} /g"              >> ada.sed; \
		echo "s/^$$kw$$/@b{$$kw}/g"                      >> ada.sed; \
	done

ada.sed-stamp:
	touch ada.sed-stamp

AADL_KW=aadlboolean aadlinteger aadlreal aadlstring access all and annex \
	applies binding bus calls classifier connections constant data delta \
	device end enumeration event extends false features flow flows group \
	implementation in inherit initial inverse is list memory mode modes \
	none not of or out package parameter path port private process \
	processor properties property provides public range reference \
	refined refines requires server set sink source subcomponents \
	subprogram system thread to true type units value

aadl.sed: aadl-sed-stamp
	echo "s/\([^@]\)@\([^@]\)/\1@@\2/g"                      >  aadl.sed
	echo "s/@@/@@@@/g"                                       >> aadl.sed
	echo "s/_@_/_@@_/g"                                      >> aadl.sed
	echo "s/{/\@{/g"                                         >> aadl.sed
	echo "s/}/\@}/g"                                         >> aadl.sed
	echo "s/-- \(.*\)$$/-- @i{\1}/"                          >> aadl.sed
	echo "s/\([^-][^-][^\"]*\)\"\([^\"]*\)\"/\1\"@i{\2}\"/g" >> aadl.sed
	for kw in $(AADL_KW); do \
		echo "s/^\([^-]* \)$$kw/\1@b{$$kw}/g"            >> aadl.sed; \
		echo "s/^\( *\)$$kw /\1@b{$$kw} /g"              >> aadl.sed; \
		echo "s/^$$kw$$/@b{$$kw}/g"                      >> aadl.sed; \
	done

aadl-sed-stamp:
	touch aadl-sed-stamp

dist-hook: all
	cp -r $(srcdir)/$(GUIDE).html $(srcdir)/$(GUIDE).pdf $(distdir)

debug-makefile:
	@echo "SRC_CODE = $(SRC_CODE)"
	@echo "DOC_CODE = $(DOC_CODE)"
	@echo "AADL_MODELS = $(AADL_MODELS)"
	@echo "FIGURES = $(FIGURES)"
	@echo "SRC_CODE_TEXIFILES = $(SRC_CODE_TEXIFILES)"
	@echo "DOC_CODE_TEXIFILES = $(DOC_CODE_TEXIFILES)"
	@echo "AADL_TEXIFILES = $(AADL_TEXIFILES)"
	@echo "GUIDE_TEXIFILES = $(GUIDE_TEXIFILES)"
