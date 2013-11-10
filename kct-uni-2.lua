#!/usr/bin/env texlua
local out = {}
out[0] = io.open(arg[1],'r')
out[1] = io.open(arg[2],'r')
out[2] = io.open(arg[3],'r')
out[3] = io.open(arg[4],'r')

print('\\documentclass[uplatex,twocolumn,landscape]{jsarticle}')
print('\\usepackage[dvipdfmx]{graphicx,xcolor}')
print('\\definecolor{green}{rgb}{0,0.5,0}')
print('\\usepackage[width=80zw,lines=30]{geometry}')
print('\\usepackage{supertabular,booktabs,metalogo}')
print('\\begin{document}\\fboxsep0pt\\centering')

print('\\tablehead{%')
print('\\toprule')
print('文字&JIS&Unicode&u\\pTeX&\\XeTeX&Lua\\TeX-ja&備考\\\\')
print('\\midrule')
print('}%')
print('\\tabletail{\\bottomrule}')
print('\\begin{supertabular}{ccccccp{5em}}')

local cx = function(n)
  return '&\\textcolor{' .. 
         (((n==16 or n==17 or n==11) and  'green')
           or ((n==15) and 'blue' or 'red'))
     .. '}{' .. tostring(n) .. '}'
end
local cy = function(n, x)
   return cx(n) .. '（\\textcolor{'
      .. (x==0 and 'black}{\\bf 和}' or 'blue}{\\bf 欧}' )
      .. '）'
end

local moji = function(c)
  return '\\fcolorbox{cyan}{white}{\\Large\\kchar"'.. c .. '}'
end

local z = {}
local zu, zx, zlc, zlj
for il in out[0]:lines() do
    zu = out[1]:read('*n')
    zx = out[2]:read('*n')
    zlc, zlj = (out[3]:read('*l')):match('(%w*)-(%w*)')
    zlc, zlj = tonumber(zlc), tonumber(zlj)
    local za, zb, zc = il:match('(%w*) (%w*) (.)')
--    if (zlc==11 and zu==18)or(zlc==12 and zu~=18) then
    print(
      moji(zb) .. '&\\tt ' .. za .. '&\\tt ' .. zb
	 .. cx(zu).. cx(zx).. cy(zlc, zlj)
	 .. (zc=='F' and '&Fullwidth' or (zc=='W' and '&Windows' or ''))
     .. '\\\\')
--    end
end
for k=0,3 do z[k]=out[k]:close() end

print('\\end{supertabular}')
print('\\end{document}')
