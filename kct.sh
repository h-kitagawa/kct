#!/bin/bash

NOW=`pwd`

cd /tmp
euptex -kanji-internal=euc -etex -ini \
  -jobname=euptex-c eptex.ini  &>/dev/null
euptex -kanji-internal=uptex -etex -ini \
  -jobname=euptex-u eptex.ini &>/dev/null

SRC=`mktemp kcto.XXXXXX`
cat << 'EOF' > $SRC
\catcode`\@=11
\newcount\@tempcnta
\newcount\@tempcntb
\newcount\@tempcntc
\immediate\openout15=\outfile
\@tempcnta=0
\loop
\advance\@tempcnta1
{
  \@tempcntb=0
  \loop
  \advance\@tempcntb1 
  \@tempcntc=\@tempcnta
  \multiply\@tempcntc by256
  \advance\@tempcntc\@tempcntb
  \advance\@tempcntc8224
  \@tempcntc=\jis\@tempcntc\relax
  \ifnum\@tempcntc=0
    \immediate\write15{0,  0}
  \else
    \immediate\write15{\the\kcatcode\@tempcntc, \the\@tempcntc}
  \fi
  \ifnum\@tempcntb<94\repeat
}
\ifnum\@tempcnta<14\repeat
\closeout15
\end
EOF

POUT=`mktemp kcto.XXXXXX`
echo "A) e-pTeX:                                  $POUT"
eptex "\\def\\outfile{$POUT}\\input $SRC" &>/dev/null
UPCCOUT=`mktemp kcto.XXXXXX`
echo "B) e-upTeX (format: euc,   runtime: euc)  : $UPCCOUT"
euptex -fmt=euptex-c -kanji-internal=euc \
    "\\def\\outfile{$UPCCOUT}\\input $SRC" &>/dev/null
UPCUOUT=`mktemp kcto.XXXXXX`
echo "C) e-upTeX (format: euc,   runtime: uptex): $UPCUOUT"
euptex -fmt=euptex-c -kanji-internal=uptex \
    "\\def\\outfile{$UPCUOUT}\\input $SRC" &>/dev/null
UPUCOUT=`mktemp kcto.XXXXXX`
echo "D) e-upTeX (format: uptex, runtime: euc)  : $UPUCOUT"
euptex -fmt=euptex-u -kanji-internal=euc \
    "\\def\\outfile{$UPUCOUT}\\input $SRC" &>/dev/null
UPUUOUT=`mktemp kcto.XXXXXX`
echo "E) e-upTeX (format: uptex, runtime: uptex): $UPUUOUT"
euptex -fmt=euptex-u -kanji-internal=uptex \
    "\\def\\outfile{$UPUUOUT}\\input $SRC" &>/dev/null

rm $SRC
SRC=`mktemp kcto.XXXXXX`
cat << 'EOF' > $SRC
\input luatexja.sty
\catcode`\@=11
\newcount\@tempcnta
\newcount\@tempcntb
\newcount\@tempcntc
\immediate\openout15=\outfile
\@tempcnta=0
\loop
\advance\@tempcnta1
{
  \@tempcntb=0
  \loop
  \advance\@tempcntb1 
  \@tempcntc=\@tempcnta
  \multiply\@tempcntc by256
  \advance\@tempcntc\@tempcntb
  \advance\@tempcntc8224
  \@tempcntc=\jis{\@tempcntc}
  \ifnum\@tempcntc=0
    \immediate\write15{0, 0}
  \else
    \immediate\write15{\the\catcode\@tempcntc, \the\@tempcntc }
  \fi
  \ifnum\@tempcntb<94\repeat
}
\ifnum\@tempcnta<14\repeat
\closeout15
\end
EOF
LTJOUT=`mktemp kcto.XXXXXX`
echo "F) LuaTeX-ja:                               $LTJOUT"
luatex "\\def\\outfile{$LTJOUT}\\input $SRC" &>/dev/null
rm $SRC

# Analyze
echo " "

SRC=`mktemp kcto.XXXXXX.lua`
cat << EOF > $SRC
local out = {}
out[1] = io.open('$POUT','r')
out[2] = io.open('$UPCCOUT','r')
out[3] = io.open('$UPCUOUT','r')
out[4] = io.open('$UPUCOUT','r')
out[5] = io.open('$UPUUOUT','r')
out[6] = io.open('$LTJOUT','r')

print('\\\\documentclass{jsarticle}')
print('\\\\usepackage[dvipdfmx]{xcolor}')
print('\\\\definecolor{green}{rgb}{0,0.5,0}')
print('\\\\usepackage[lines=40]{geometry}')
print('\\\\usepackage{longtable,booktabs}')
print('\\\\begin{document}\\\\fboxsep0pt')
print('\\\\begin{longtable}{cccllllll}')

print('\\\\toprule')
print('文字&区&点&\\\\pTeX&\\\\multicolumn{4}{c}{u\\\\pTeX}&Lua\\\TeX-ja\\\\\\\\')
print('\\\\cmidrule(lr){5-8}')
print('&&&\\\\hbox to 3em{\\\hss\\\\scriptsize{\\\\tt -kanji-internal} (format)→}')
print('   &\\\\multicolumn{2}{c}{\\\\tt euc}&\\\\multicolumn{2}{c}{\\\\tt uptex}&\\\\\\\\')
print('\\\\cmidrule(lr){5-6}\\\\cmidrule(lr){7-8}')
print('&&&\\\\hbox to 3em{\\\hss\\\\scriptsize{\\\\tt -kanji-internal} (runtime)→}')
print('   &\\\\tt euc&\\\\tt uptex&\\\\tt euc&\\\\tt uptex&\\\\\\\\')
print('\\\\midrule')
print('\\\\endhead')

local c = function(n,v)
  return '&\\\\textcolor{' .. 
         (((n==16 or n==17 or n==11) and  'green')
           or ((n==0) and 'blue' or 'red'))
         .. '}{\\\\bf' .. n 
         .. '}\$\_{\\\\mathtt{' .. string.format('%X',v)  .. '}}$'
end

local moji = function(i,j)
  return '\\\\fcolorbox{cyan}{white}{\\\\Large\\\\char\\\\jis'.. (256*i+j+8224) .. '}'
end

local z = {}
for i=1,14 do
  for j=1,94 do
    for k=1,6 do 
      z[k]=out[k]:read('*l') 
      z[k], z[10+k] = z[k]:match('(%w*), (%w*)')
      z[k] = tonumber(z[k])
    end
    if z[5]~=0 then
      print ( moji(i,j) .. '&' .. i .. '&' .. j 
       .. c(z[1],z[11]).. c(z[2],z[12]).. c(z[3],z[13])
       .. c(z[4],z[14]).. c(z[5],z[15]).. c(z[6],z[16])
       .. '\\\\\\\\'
      )
    end
  end
end
for k=1,6 do z[k]=out[k]:close() end

print('\\\\end{longtable}')
print('\\\\end{document}')


EOF
lua $SRC > kct-out.tex
platex kct-out.tex &> /dev/null
ptex2pdf -l -od '-f ptex-ipa.map' kct-out.tex &>/dev/null

mv kct-out.pdf $NOW
rm kcto.* kct-out.* euptex-?.{fmt,log}

