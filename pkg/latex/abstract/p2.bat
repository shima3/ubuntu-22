@echo off
set "w=%CD:C:\=/C/%"
set "w=%w:\=/%"
set "repo=kshima/latex:ubuntu24x86_64"
rem docker run -it --rm -v "C:\:/C" -w "%w%" kshima/texlive2017-emacs25-ubuntu18 tex2pdf.sh paper %1 %2 %3 %4 %5 %6 %7 %8 %9
rem docker run -it --rm -v "C:\:/C" -w "%w%" kshima/texlive2017-emacs25-ubuntu18 platex paper %1 %2 %3 %4 %5 %6 %7 %8 %9
rem docker run -it --rm -v "C:\:/C" -w "%w%" kshima/texlive2017-emacs25-ubuntu18 dvipdfmx paper %1 %2 %3 %4 %5 %6 %7 %8 %9
docker run --rm -v "C:\:/C" -w "%w%" -it "%repo%" tex2pdf.sh paper
