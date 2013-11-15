#!/bin/bash

NOW=`pwd`

cd /tmp
rm kcto.* kct-uni-out.* &>/dev/null

UTBL=`mktemp kcto.XXXXXX`
echo "A) Table:     $UTBL"
$NOW/kct-uni-1.lua "$NOW/jisx0213-2004-8bit-std.txt" "$UTBL"

### pTeX

SRC=`mktemp kcto.XXXXXX`
cat << 'EOF' > $SRC
\catcode`\@=11
\immediate\openout15=\outfile
EOF
cat $UTBL |sed 's/\(....\) \(....\)/\\immediate\\write15{\\the\\kcatcode\\jis"\1}/' >> $SRC
cat << 'EOF' >> $SRC
\closeout15
\end
EOF

POUT=`mktemp kcto.XXXXXX`
echo "B) pTeX:      $POUT"
ptex "\\def\\outfile{$POUT}\\input $SRC" &>/dev/null

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
echo "C) upTeX:     $UPOUT"
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
echo "D) XeTeX:     $XEOUT"
xetex "\\def\\outfile{$XEOUT}\\input $SRC" &>/dev/null

### LuaTeX

LTOUT=`mktemp kcto.XXXXXX`
echo "E) LuaTeX:    $LTOUT"
luatex "\\def\\outfile{$LTOUT}\\input $SRC" &>/dev/null

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

LJOUT=`mktemp kcto.XXXXXX`
echo "F) LuaTeX-ja: $LJOUT"
luatex "\\def\\outfile{$LJOUT}\\input $SRC" &>/dev/null


echo "generating output"
$NOW/kct-uni-2.lua "$UTBL" "$UPOUT" "$XEOUT" "$LTOUT" "$LJOUT" "$POUT" \
    "kct-out.tex" "$NOW/kct-out.txt"

echo "1st run of uplatex"
uplatex kct-out.tex &> /dev/null
echo "2nd run of uplatex"
uplatex kct-out.tex &> /dev/null
echo "dvipdfmx"
dvipdfmx -f uptex-kozuka-pr6n.map kct-out.dvi &>/dev/null
mv kct-out.pdf $NOW
rm kcto.* kct-out.*

cd $NOW
ls -l kct-out.{txt,pdf}

