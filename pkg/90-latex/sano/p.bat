@echo off
set "w=%CD:C:\=/C/%"
set "w=%w:\=/%"
docker run -it --rm -v "C:\:/C" -w "%w%" kshima/texlive2017-emacs25-ubuntu18 tex2pdf.sh paper %1 %2 %3 %4 %5 %6 %7 %8 %9
pause