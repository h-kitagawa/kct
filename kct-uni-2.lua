#!/usr/bin/env texlua
local out = {}
out[0] = io.open(arg[1],'r')
out[1] = io.open(arg[2],'r')
out[2] = io.open(arg[3],'r')
out[3] = io.open(arg[4],'r')

print('\\documentclass[uplatex]{jsarticle}')
print('\\usepackage[dvipdfmx]{graphicx,xcolor}')
print('\\definecolor{green}{rgb}{0,0.5,0}')
print('\\usepackage[lines=40]{geometry}')
print('\\usepackage{longtable,booktabs,metalogo}')
print('\\begin{document}\\fboxsep0pt')
print('\\begin{longtable}{cccccc}')

print('\\toprule')
print('文字&JIS&Unicode&u\\pTeX&\\XeTeX&Lua\\TeX-ja\\\\')
print('\\midrule')
print('\\endhead')

local cx = function(n)
  return '&\\textcolor{' .. 
         (((n==16 or n==17 or n==11) and  'green')
           or ((n==15) and 'blue' or 'red'))
     .. '}{' .. tostring(n) .. '}'
end

local moji = function(c)
  return '\\fcolorbox{cyan}{white}{\\Large\\kchar"'.. c .. '}'
end

local z = {}
for il in out[0]:lines() do
    for k=1,3 do 
      z[k]=tonumber(out[k]:read('*l'))
    end
    z[0], z[10] = il:match('(%w*) (%w*)')
    print(
      moji(z[10]) .. '&\\tt ' .. z[0] .. '&\\tt ' .. z[10] 
     .. cx(z[1]).. cx(z[2]).. cx(z[3])
     .. '\\\\')
end
for k=0,3 do z[k]=out[k]:close() end

print('\\end{longtable}')
print('\\end{document}')
