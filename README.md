kct.sh
======

pTeX, upTeX, XeTeX, LuaTeX[-ja] の非漢字部（JIS X 0213 1--13区）の
`\kcatcode`（XeTeX, LuaTeX[-ja] の場合は `\catcode`）を比較する．

## 使い方

適当なディレクトリで `./kct.sh` を実行すると，
そのディレクトリに比較結果 `kct-out.pdf`, `kct-out.txt` が出力される．
 * `/tmp` を作業領域とします．
 * 作業ファイル (`kcto.*`, `kct-out.{dvi,log,...}`) は自動消去されます．
 * Lua スクリプト実行に，`texlua` を使用します．
 * 実行には `uptex-kozuka-pr6n.map` と小塚 Pr6N フォントを使用します．

このリポジトリ内にある `kct-out.pdf`, `kct-out.txt` は以下の環境で作りました：
 * pTeX:   `3.141592653-p3.9.0 (utf8.euc) (TeX Live 2022/dev)`
 * upTeX:  `3.141592653-p3.10.0-u1.27 (utf8.uptex) (TeX Live 2022/dev)`
 * XeTeX:  `3.141592653-2.6-0.999993 (TeX Live 2022/dev)`
 * LuaTeX: `1.14.0 (TeX Live 2022/dev)`
 * LuaTeX-ja: commit 8a210f0eb52e (`typo`)


