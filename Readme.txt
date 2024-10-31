
These are the MS thesis and PhD dissertation LaTeX templates for
the ECE Department, Northeastern University.

1-Same template is used for MS thesis and PhD dissertation. The
option [PHD] after \documentclass generates a PhD dissertation.
Removing this option generates an MS thesis (see thesis.tex).

2-Please put all style files that you need to use in the macro
folder and call them using the macro.tex file in this folder.

3-All latex source files corresponding to different chapters go in
the tex folder. All figures go in the fig folder and all
bibliography-related files in the bib folder.

4-Both pdf and eps graphics can be used; although pdf is
preferable. If eps files are used, they will be converted to pdf on
the fly. It is recommended that you run your source file with
pdflatex (alternatively you can use latex+dvips+ps2pdf but you
should be aware that this path cannot handle pdf graphics files.)

5-You need to run bibtex and makeindex to generate the bibliography
and the index.

6-CTAN (the Comprehensive TeX Archive Network) is the source of
almost everything that you need for your thesis. You can access
CTAN at http://www.ctan.org. The following packages are needed,
if you do not already have them, make sure to download them from
CTAN and put them in a path that your LaTeX implementation can 
find them:
amsfonts
amssymb
amsmath
times
bm
multirow
makeidx
acronym
url
graphicx
epstopdf
hyperref
microtype

