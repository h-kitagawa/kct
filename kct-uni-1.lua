#!/usr/bin/env texlua
local tbl = io.open(arg[1], 'r')
local out = io.open(arg[2], 'w')

local jis, uni, buf
buf = {}
for line in tbl:lines() do
   if line:match ('0x2[0-9A-D]....*Fullwidth: U%+....') then
      jis, uni = line:match ('0x(2[0-9A-D]...).*Fullwidth: U%+(....)')
      buf[#buf+1] = {tonumber(uni,16), jis, uni, ' F' }
   elseif line:match('0x2[0-9A-D]...%s*U.....%s') then
      jis, uni = line:match ('0x(2[0-9A-D]...)%s*U%+(....)')
      buf[#buf+1] = {tonumber(uni,16), jis, uni, ' !' }
   end
   if line:match ('0x2[0-9A-D]....*Windows: U%+....') then
      jis, uni = line:match ('0x(2[0-9A-D]...).*Windows: U%+(....)')
      buf[#buf+1] = {tonumber(uni,16), jis, uni, ' W' }
   end
   if buf[#buf] and line:match('%[200.%]') then
      buf[#buf][5]=true
   end
end
tbl:close()

table.sort(buf, function (a,b) return (a[1]<b[1]) end)
for i=1,#buf do
   out:write(string.format('%X', tonumber(buf[i][2], 16)) .. ' ' 
                .. buf[i][3] ..  buf[i][4] 
                .. (buf[i][5] and 'N' or '!') .. '\n')
end
out:close()

