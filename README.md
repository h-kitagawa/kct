kct.sh
======

pTeX, upTeX, XeTeX, LuaTeX[-ja] の非漢字部（JIS X 0213 1--13区）の
\kcatcode（XeTeX, LuaTeX[-ja] の場合は \catcode）を比較する．

##使い方
適当なディレクトリで ./kct.sh を実行すると，
そのディレクトリに比較結果 kct-out.pdf, kct-out.txt が出力される．
 * /tmp を作業領域とします．
 * 作業ファイル (kcto.*, kct-out.{dvi,log,...}) は自動消去されます．
 * Lua スクリプト実行に，texlua を使用します．
 * 実行には uptex-kozuka-pr6n.map と小塚 Pr6N フォントを使用します．

このリポジトリ内にある kct-out.pdf, kct-out.txt は以下の環境で作りました：
 * pTeX:   '3.1415926-p3.4 (utf8.euc) (TeX Live 2014/dev)'
 * upTeX:  '3.1415926-p3.4-u1.11 (utf8.uptex) (TeX Live 2014/dev)'
 * XeTeX:  '3.1415926-2.5-0.9999.3 (TeX Live 2013)'
 * LuaTeX: 'beta-0.77.0-2013103021 (rev 4648) '
 * LuaTeX-ja: commit e5a7e05 (Revert previous two commits, and updated manuals.)

