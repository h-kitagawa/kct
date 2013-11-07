#!/bin/bash

NOW=`pwd`

cd /tmp
rm kcto.* kct-uni-out.* &>/dev/null

UTBL=`mktemp kcto.XXXXXX`
echo "0) Table:     $UTBL"
$NOW/kct-uni-1.lua "$NOW/jisx0213-2004-8bit-std.txt" "$UTBL"

### upTeX

SRC=`mktemp kcto.XXXXXX`
cat << 'EOF' > $SRC
\catcode`\@=11
\immediate\openout15=\outfile
EOF
cat $UTBL |sed 's/\(....\) \(....\)/\\immediate\\write15{\\the\\kcatcode"\2}/' >> $SRC
cat << 'EOF' >> $SRC
\closeout15
\end
EOF

UPOUT=`mktemp kcto.XXXXXX`
echo "A) upTeX:     $UPOUT"
uptex "\\def\\outfile{$UPOUT}\\input $SRC" &>/dev/null

### XeTeX

cat << 'EOF' > $SRC
\catcode`\@=11
\immediate\openout15=\outfile
EOF
cat $UTBL |sed 's/^\(....\) \(....\)/\\immediate\\write15{\\the\\catcode"\2}/' >> $SRC
cat << 'EOF' >> $SRC
\closeout15
\end
EOF

XEOUT=`mktemp kcto.XXXXXX`
echo "B) XeTeX:     $XEOUT"
xetex "\\def\\outfile{$XEOUT}\\input $SRC" &>/dev/null

### LuaTeX-ja

cat << 'EOF' > $SRC
\catcode`\@=11
\input luatexja.sty
\immediate\openout15=\outfile
EOF
cat $UTBL |sed 's/^\(....\) \(....\)/\\edef\\temp{\\ltjgetparameter{chartorange}{"\2}}\\edef\\temp{\\ltjgetparameter{jacharrange}{\\temp}}\\immediate\\write15{\\the\\catcode"\2-\\temp}/' >> $SRC
cat << 'EOF' >> $SRC
\closeout15
\end
EOF


LTOUT=`mktemp kcto.XXXXXX`
echo "C) LuaTeX-ja: $LTOUT"
luatex "\\def\\outfile{$LTOUT}\\input $SRC" 
rm /tmp/luatexja.pdf

echo "sorting..."
$NOW/kct-uni-2.lua "$UTBL" "$UPOUT" "$XEOUT" "$LTOUT" > kct-uni-out.tex

echo "1st run of uplatex"
uplatex kct-uni-out.tex #&> /dev/null
echo "2nd run of uplatex"
ptex2pdf -l -u -od '-f uptex-kozuka-pr6n.map' kct-uni-out.tex &>/dev/null
mv kct-uni-out.pdf $NOW
rm kcto.* kct-uni-out.*
TMP=`mktemp -t kct-uni.sh.XXXXXX`
trap "rm $TMP* 2>/dev/null" EXIT
