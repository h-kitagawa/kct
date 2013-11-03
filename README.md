kct.sh
======

pTeX/upTeX/LuaTeX-ja の非漢字部（JIS X 0208 1区--8区）の
\kcatcode（LuaTeX-ja の場合は \catcode）を比較する．

##使い方
適当なディレクトリで ./kct.sh を実行すると，
そのディレクトリに kct-out.pdf が出力される．
 * /tmp を作業領域とします．
 * 作業ファイル (kcto.*, euptex-{c,u}.{fmt,log}) は自動消去されます．
 * ptex-ipa.map と IPA フォントを使用します．TeX Live をフルインストールしていれば大丈夫でしょう．

サンプルとして，私（北川）の環境で作成した kct-out.pdf を入れました．
 * pTeX: '3.1415926-p3.4 (utf8.euc) (TeX Live 2014/dev)'
 * upTeX: '3.1415926-p3.4-u1.11 (utf8.uptex) (TeX Live 2014/dev)'
 * LuaTeX-ja: commit e5a7e05 (Revert previous two commits, and updated manuals.)

