# MS Thesis and PhD Dissertation LaTeX Templates, [COE](https://coe.northeastern.edu/), Northeastern University [^1]


The same template is used for MS thesis and PhD dissertation. By default, an MS thesis is produced. To change to a PhD Dissertation modify the file thesis_dissertation.tex and change the line:

```LaTeX
\documentclass[]{macro/neu_msthesis}
```
to
```LaTeX
\documentclass[PHD]{macro/neu_msthesis}
```

To make it easier, give your thesis/dissertation a descriptive name (the pdf will have the same name by default). A naming suggestion is: 

```<LastName>-<PhD|MS>.tex```, e.g. ```Husky-PhD.tex```.

The main template file allows easy configuration of all common aspects of the thesis/dissertation. Examples include: author name, title, etc. Please see the definitions and descriptions tex source file. 

**Please note that this template DOES NOT generate the signature page!**

The signature page is generated through a separate form process including getting electronic signatures. Please see the instructions on COE's web page: [PhD Dissertation/MS Thesis Instructions](https://coe.northeastern.edu/academics-experiential-learning/graduate-school-of-engineering/graduate-student-services/dissertation-thesis-instructions/).

Please put all style files that you need to use in the macro folder and call them using the macro.tex file in this folder.

All latex source files corresponding to different chapters go in the tex folder. All figures go in the fig folder and all bibliography-related files in the bib folder.

For editing / compilation, you can use the online LaTeX platform [overleaf](https://www.overleaf.com) (select ```<LastName>-<PhD|MS>.tex``` as a [main file](https://www.overleaf.com/learn/how-to/Can_I_choose_which_file_is_the_main_tex_file_in_a_project_on_Overleaf%3F)). 

The [LaTeX WikiBooks](https://en.wikibooks.org/wiki/LaTeX) is a great resource about syntax and tricks. 

To compile locally, check out [The LaTeX Project](https://www.latex-project.org/get/). [latexmk](https://github.com/debian-tex/latexmk), avaiable for many Linux systems, is convenient for  LaTeX compilation on a Linux system. The Makefile in this template is horribly outdated (it refers to SVN ...).   


[^1]: Source: https://github.com/neu-ece-esl/neu-ece-ms-phd-latex
