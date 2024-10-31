# ------------------------------------------------------------------------
# Makefile:
# ------------------------------------------------------------------------
# written by:	Gunar Schirner 
# External References:
#   http://kriemhild.uft.uni-bremen.de/viewvc/vim/Makefile.pdflatex
#   http://www.tex.ac.uk/tex-archive/help/uk-tex-faq/Makefile
# last update:	$id$
#
# Help screen (start every help line with #h)
#
#h make        builds ALL_REF
#h
#h make publish 
#h             publish the build output to HTML publish directory  
#h
# --- names --------------------------------------------------------------

PROJECT	=	thesis

SRCNAME	=	$(PROJECT)_SRC.tar.gz
BINNAME	=	$(PROJECT)_BIN.tar.gz
ORIG	=	

TMP	=	/tmp
# own name
MAKEF   =       Makefile

# path for automatic publishing, put into your public_html directory`
PUBLISH_PATH = /home/student/<studentName>/public_html/thesis
VERSION_FILE = svnRev.tex

# set automatically by hook script (Post commit hook)
# SVN_REPO_PATH 
# SVN_REV

# --- lists --------------------------------------------------------------

ALL	=	$(PROJECT).pdf



# auto use all *.tex file in the own and in pi directory as dependency input 
INCLUDE	:=	$(shell [ -d tex ] && echo tex/*.tex )

SOURCES =	$(PROJECT).tex	\
		$(INCLUDE)

#BIBFILES :=  macro/bib-strings.bib macro/IEEEabrv.bib $(shell [ -d bib ] && echo bib/*.bib )

FIGFILES =

PPTFILES =	

PRNFILES =

# auto use all *.eps files in the fig directory as a dependency input 
#  FIGURES directory may not exist
# uncomment once first eps is added 
EPSFILES :=	$(shell [ -d fig ] && echo fig/*.eps) 


# auto use all *.pdf files in the fig directory as a dependency input 
#  FIGURES directory may not exist
# uncomment once first pdf is added 
#PDFFIGS :=	$(shell [ -d fig ] && echo fig/*.pdf) 


FIGURES	=	$(EPSFILES:.eps=.pdf) $(PDFFIGS)

#MACROS	=	macro/macros.tex

OTHERS	=	Makefile	


ORIGS	=	$(SOURCES) $(MACROS) $(OTHERS)

SRCTAR	=	$(SOURCES) $(MACROS) $(OTHERS)	\
		$(FIGFILES) $(PPTFILES) $(PRNFILES) $(EPSFILES)

BINTAR	=	$(ALL)

# --- environment --------------------------------------------------------

TEXINPUTS =	TEXINPUTS=.:MACROS:

TEXENV	=	$(TEXINPUTS)

# --- commands -----------------------------------------------------------

FIGPS	=	fig2dev -L ps
PRN2EPS	=	PATH=bin:$$PATH prn2eps
LATEX	=	$(TEXENV) latex
PDFLATEX =      pdflatex --interaction nonstopmode
BIBTEX	=	bibtex
DVIPS	=	dvips -Z -D 600 -t letter -Ppdf
PS2PDF	=	ps2pdf
EPS2PDF	=	epstopdf
PSSEL	=	psselect
TAR	=	gtar cvzf
RM	=	rm -f
MV	=	mv -f
MAKEIDX	=	makeindex
GV	=	ghostview
ECHO	=	echo
GREP	=	grep
WC	=	wc
CD	=	cd
CAT	=	cat
XLESS	=	xless
SPELL	=	nspell -t
SORT	=	sort -f
MAKEIDX	=	makeindex
DISTILL =       GS_OPTIONS="-dAutoFilterColorImages=false \
                            -dColorImageFilter=/FlateEncode" ps2pdf14
THUMBPDF=       thumbpdf --modes=dvips

# parse string to cause rebuild of latex
RERUN = "(There were undefined references|Rerun to get (cross-references|the bars) right|Table widths have changed. Rerun LaTeX.|Linenumber reference failed)"

# parse string to cause rebuild of bibtex
RERUNBIB = "No file.*\.bbl|Citation.*undefined"



# --- general rules ------------------------------------------------------

.SUFFIXES:
.SUFFIXES:	.fig .ps .prn .eps .tex .bbl .pdf

.fig.ps:
	$(FIGPS) $*.fig $*.ps

.prn.eps:
	$(PRN2EPS) $*.prn $*.eps

#GS added automatic conversion for eps files, epstopdf packages seems
# not installed on this linux installation
.eps.pdf:
	$(EPS2PDF) $*.eps

.tex.bbl:
	$(LATEX) $*.tex
	$(BIBTEX) $*

# run pdflatex once and bib + subsequent pdflatex conditionally
%.pdf: %.tex
	$(PDFLATEX) $<
	@egrep -c $(RERUNBIB) $*.log && (bibtex $*;$(PDFLATEX) $<); true
	@egrep $(RERUN) $*.log && ($(PDFLATEX) $<) ; true
	@egrep $(RERUN) $*.log && ($(PDFLATEX) $<) ; true


# --- rules --------------------------------------------------------------

all:		$(ALL)

# automatically produce help message by grep for sepcial comment lines 
help:;	@sed -n -e 's/^#h//p'  < $(MAKEF) | sed -e 's/ALL_REF/$(ALL)/g'

# second phase of the publish requires to get the current SVN version 
ifdef SECOND_PHASE
SVN_REV := $(shell svn info | sed -n -e 's/.*Revision: //p')
endif

# debug rule to print current version 
echo_ver:
	@echo $(SVN_REV)

# paste the current version information into tex file so that it 
# can be included into build
create_version_file: 
	@echo "\\newcommand{\\svnRevRef}{$(SVN_REV)}" > $(VERSION_FILE)


# actual publishing action 
autobuild_publish_2nd: create_version_file
	make >  $(PUBLISH_PATH)/z_buildlog.r$(SVN_REV).log
	set -e ; for f in $(basename $(filter %.pdf, $(ALL))); do        \
		rm -f $(PUBLISH_PATH)/$$f.r*.pdf;                         \
		cp $$f.pdf $(PUBLISH_PATH)/$$f.r$(SVN_REV).pdf;   \
		rm -f $(PUBLISH_PATH)/$$f.pdf; \
		ln -s $(PUBLISH_PATH)/$$f.r$(SVN_REV).pdf $(PUBLISH_PATH)/$$f.pdf ;  \
	done

# if the revision is already passed in as a parameter, we do not 
# need to trieve it again 
ifneq ("$(SVN_REV)", "")
# clean update build and publish 
publish: clean svn_up autobuild_publish_2nd
else
# cleanup, svn update and kick off second phase
publish: 
	make clean
	svn up
	make autobuild_publish_2nd SECOND_PHASE=1
endif

# helper rule to call svn update 
svn_up: 
	svn up


clean:
	$(RM) $(ALL)
	$(RM) *.ps *.pdf
	$(RM) *.dvi
	$(RM) *.toc *.lot *.lof *.log *.aux
	$(RM) *.idx *.ind *.ilg
	$(RM) *.inx *.srt
	$(RM) *.blg *.bbl
	$(RM) *.out
	$(RM) *.BAK *.bak *~
	$(RM) macro/*.BAK macro/*.bak macro/*~
	$(RM) texput.log
	$(RM) $(ORIG)

tar:
	-$(MV) $(SRCNAME) $(SRCNAME).bak
	-$(MV) $(BINNAME) $(BINNAME).bak
	-$(TAR) $(SRCNAME) $(SRCTAR)
	-$(TAR) $(BINNAME) $(BINTAR)

spell:
	$(SPELL) $(SOURCES)

orig:	$(ORIG)

todo:	$(ORIG)
	-$(GREP) -n "\.\.\.\." `$(CAT) $(ORIG)` >$(TMP)/todo
	$(WC) -l $(TMP)/todo ; $(XLESS) $(TMP)/todo ; $(RM) $(TMP)/todo &

1:
	$(LATEX) $(PROJECT).tex
	$(DVIPS) $(PROJECT).dvi -o $(PROJECT).ps

2:
	$(LATEX) $(PROJECT).tex
	$(LATEX) $(PROJECT).tex
	$(DVIPS) $(PROJECT).dvi -o $(PROJECT).ps


# --- project rules ---

$(PROJECT).pdf:  $(PROJECT).tex $(MACROS) $(INCLUDE) $(FIGURES) $(BIBFILES) 


summary.pdf:	summary.tex

$(PROJECT).ps: $(PROJECT).pdf
	pdf2ps $<

Description.ps: $(PROJECT).ps
	$(PSSEL) 1-15 $(PROJECT).ps Description.ps

Description.pdf:	Description.ps
	$(DISTILL) Description.ps Description.pdf


References.ps: $(PROJECT).ps
	$(PSSEL) 16- $(PROJECT).ps References.ps

References.pdf:	References.ps
	$(DISTILL) References.ps References.pdf


# --- other rules ---

$(ORIG):	$(ORIGS)
	$(ECHO) >$(ORIG) $(ORIGS)



#h dbgPrint   VAR=<varName> print content of variable <varName>
dbgPrint:
	@echo "$(VAR)=$($(VAR))"
# --- EOF ----------------------------------------------------------------
