#!texlua
-- JIS2004 (or JIS2000/90JIS) の全文字を含む dvi を作成し，
-- dvipdfmx でどう処理されるかを見る．
-- 処理中，temp.{tex,dvi,log} を作成します．

kpse.set_program_name('eptex') -- dummy
-- jisx0213-2004-8bit-std.txt が必要
local usage = [[
usage: test-ip1-jis04.lua [-0|-9] [-e] [-h] [-n] [-f font_file_name]
-0: JIS2000         ( <-> default: JIS2004)
-9: 90JIS           ( <-> default: JIS2004)
-e: use IPAexMIncho ( <-> default: IPAMincho)
-p: produce temp.pdf
-h: this help]]
local cmap_name, tfm_name, font_name = 'UniJIS2004-UTF16-H', 'urml', 'ipam.ttf'
local j04_flag, j00_flag, non_pdf = true, true, true

do
   local narg = 1
   local j0_on, j9_on
   repeat
      this_arg = arg[narg]
      if this_arg == '-0' then
	 cmap_name = 'UniJIS-UTF16-H'
	 j04_flag, j00_flag = false, true
	 j0_on = true
      elseif this_arg == '-9' then
	 cmap_name = 'UniJIS-UTF16-H'
	 j04_flag, j00_flag = false, false
	 j9_on = true
      elseif this_arg == '-e' then
	 font_name = 'ipaexm.ttf'
      elseif this_arg == '-f' then
	 font_name = arg[narg+1]; narg = narg + 1
      elseif this_arg == '-p' then
	 non_pdf = false
      elseif this_arg == '-h' then
	 print(usage); os.exit(0)
      elseif this_arg then
	 print("Unrecognized option: '" .. this_arg .. "'\n")
	 print(usage); os.exit(0)
      end
      narg = narg+1
   until narg > #arg
   if j0_on and j9_on then
      print("Error: both '-0' and '-9' are specified.\n")
      print(usage); os.exit(0)
   end
end

local jis_table = {}
do
   local tbl = io.open('jisx0213-2004-8bit-std.txt', 'r')
   for line in tbl:lines() do
      if line:match('0x....%s*U......?%s') then
	 local jis, uni = line:match ('0x(....)%s*U%+(.....)')
	 jis, uni = tonumber(jis, 16), string.format('%04X', tonumber(uni,16))
	 if j04_flag or not line:match('%[2004%]') then
	    if j00_flag or j04_flag or not line:match('%[2000%]') then
	       local entry = {uni, 1+ (jis>=0xA0A0 and 1 or 0) }
	       jis_table[#jis_table+1] = entry
	       jis  = jis - 0x2020
	       entry[4] = jis % 0x80
	       entry[3] = ((jis-entry[4])/0x100) % 0x80
	    end
	 end
      end
   end
   tbl:close()
end

--local u2j_table = cmapdec.open_cmap_file(cmap_name)
--local u2j_uni = {}
--for i,_ in pairs(u2j_table) do
--   if i<=0x10ffff and i>=0x100 then u2j_uni[#u2j_uni+1] = i end
--end
--table.sort(u2j_uni)

local file_temp = io.open('temp.tex', 'w')
if not file_temp then
   os.exit(1)
end

file_temp:write('\\special{pdf:mapline ' .. tfm_name .. ' ' .. cmap_name .. ' ' .. font_name .. '}\n')
file_temp:write('\\jfont\\TF=' .. tfm_name .. ' \\TF\\raggedbottom\n')

for _,v in pairs(jis_table) do
   file_temp:write('\\kchar"' .. v[1] .. '\\relax% = JIS ' 
		      .. tostring(v[2]) .. '-' .. tostring(v[3]) .. '-' .. tostring(v[4]) .. '\n')
end

file_temp:write('\\end')
file_temp:close()

local exe_uptex = assert(io.popen('uptex -interaction=batchmode temp.tex')); 
if exe_uptex:close() then
   local exec_dpx = io.popen('dvipdfmx ' .. (non_pdf and '-o - ' or '') ..' temp.dvi')
   exec_dpx:close()
end

