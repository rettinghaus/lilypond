depth = ../..

STEPMAKE_TEMPLATES=podir
LOCALSTEPMAKE_TEMPLATES=lilypond

include $(depth)/make/stepmake.make

doc-localedir=$(outdir)
LANGS = $(shell $(PYTHON) $(top-src-dir)/python/langdefs.py)
DOMAIN=lilypond-doc
DOC_PO_SOURCES = python/auxiliar/postprocess_html.py \
 scripts/auxiliar/tely-gettext.py scripts/auxiliar/translations-status.py
TELY_FILES = $(shell ls $(depth)/Documentation/*.tely)
TELY_FILES += $(foreach l, $(LANGS), $(shell ls $(depth)/Documentation/$(l)/*.tely))
LSR_LYS = $(shell ls $(depth)/Documentation/snippets/*.ly)
TELY_FILES += $(LSR_LYS:%.ly=../%.ly)

messages: $(outdir)/messages

$(outdir)/messages: $(MO_FILES)
	for i in $(CATALOGS); do \
	  rm -rf $(doc-localedir)/$$i/LC_MESSAGES; \
	  mkdir -p $(doc-localedir)/$$i/LC_MESSAGES; \
	  $(LN) $(outdir)/$$i.mo $(doc-localedir)/$$i/LC_MESSAGES/$(DOMAIN).mo; \
	done
	touch $@

po-update:
	$(PYTHON) $(auxscript-dir)/texi-langutils.py -d $(outdir) -o texi.pot --gettext $(TELY_FILES:%.tely=../%.tely)
	$(foreach i, $(DOC_PO_SOURCES), cp $(top-src-dir)/$(i) $(outdir) &&) true
	cd $(outdir) && xgettext --keyword=_doc -cjn -L Python -o buildscripts.pot $(foreach i, $(DOC_PO_SOURCES), $(notdir $(i)))
	msgcat -o $(outdir)/doc.pot $(outdir)/buildscripts.pot $(outdir)/texi.pot
	msgmerge -U lilypond-doc.pot $(outdir)/doc.pot
	for i in $(CATALOGS); do \
	  msgmerge -U $$i.po lilypond-doc.pot; \
	done

ifeq ($(out),www)
local-WWW-1: messages
endif
