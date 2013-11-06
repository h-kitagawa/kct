#!/bin/bash

NOW=`pwd`

cd /tmp
rm kcto.* kct-uni-out.*

UTBL=`mktemp kcto.XXXXXX`
echo "0) Table:     $UTBL"
$NOW/kct-uni-1.lua "$NOW/jisx0213-2004-8bit-std.txt" "$UTBL"

SRC=`mktemp kcto.XXXXXX`
cat << 'EOF' > $SRC
\catcode`\@=11
\immediate\openout15=\outfile
EOF

cat $UTBL |sed 's/^\(....\) \(....\)/\\immediate\\write15{\\the\\catcode"\2}/' >> $SRC

cat << 'EOF' >> $SRC
\closeout15
\end
EOF

USRC=`mktemp kcto.XXXXXX`
cat << 'EOF' > $USRC
\catcode`\@=11
\immediate\openout15=\outfile
EOF

cat $UTBL |sed 's/\(....\) \(....\)/\\immediate\\write15{\\the\\kcatcode"\2}/' >> $USRC

cat << 'EOF' >> $USRC
\closeout15
\end
EOF

UPOUT=`mktemp kcto.XXXXXX`
echo "A) upTeX:     $UPOUT"
uptex "\\def\\outfile{$UPOUT}\\input $USRC" &>/dev/null

XEOUT=`mktemp kcto.XXXXXX`
echo "B) XeTeX:     $XEOUT"
xetex "\\def\\outfile{$XEOUT}\\input $SRC" &>/dev/null

LTOUT=`mktemp kcto.XXXXXX`
echo "C) LuaTeX-ja: $LTOUT"
luatex "\\input luatexja.sty \\def\\outfile{$LTOUT}\\input $SRC" &>/dev/null
rm /tmp/luatexja.pdf


$NOW/kct-uni-2.lua "$UTBL" "$UPOUT" "$XEOUT" "$LTOUT" > kct-uni-out.tex
uplatex kct-uni-out.tex &> /dev/null
ptex2pdf -l -u -od '-f uptex-ipa.map' kct-uni-out.tex &>/dev/null
mv kct-uni-out.pdf $NOW
rm kcto.* kct-uni-out.*
