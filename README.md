kct.sh
======

pTeX/upTeX/XeTeX/LuaTeX-ja の非漢字部の
\kcatcode（XeTeX, LuaTeX-ja の場合は \catcode）を比較する．

 * kct-out.pdf（kct.sh で生成）: 
   JIS X 0208 1--8区，pTeX/upTeX/LuaTeX-ja
 * kct-uni-out.pdf（kct-uni.sh で生成）: 
   JIS X 0213 1--13区，upTeX/XeTeX/LuaTeX-ja

##使い方
適当なディレクトリで ./kct[-uni].sh を実行すると，
そのディレクトリに kct[-uni]-out.pdf が出力される．
 * /tmp を作業領域とします．
 * 作業ファイル (kcto.*, euptex-{c,u}.{fmt,log}) は自動消去されます．
 * Lua スクリプト実行に，texlua を使用します．
 * [u]ptex-ipa.map と IPA フォントを使用します．
    TeX Live をフルインストールしていれば大丈夫でしょう．

このリポジトリ内にある kct[-uni]-out.pdf は以下の環境で作りました：
 * pTeX: '3.1415926-p3.4 (utf8.euc) (TeX Live 2014/dev)'
 * upTeX: '3.1415926-p3.4-u1.11 (utf8.uptex) (TeX Live 2014/dev)'
 * XeTeX: '3.1415926-2.5-0.9999.3 (TeX Live 2013)'
 * LuaTeX-ja: commit e5a7e05 (Revert previous two commits, and updated manuals.)

