function handler(str,code_simbol,param) -- обработчик ввода символов
--[[
param == 1 - ¬се буквы и цифры
param == 2 - “олько целые числа
param == 3 - ќтрицательные и положительные целые числа
param == 4 - “олько положительные дробные числа
param == 5 - ќтрицательные и положительные дробные числа
--]]
	local permission = false
	if param == 1 then
		if (code_simbol > 60 and code_simbol < 91) or (code_simbol > 96 and code_simbol < 123) or (code_simbol >= 44 and code_simbol <= 58) or code_simbol == 8 or code_simbol == 32 or code_simbol == 95 then
			permission = true
		end
	elseif param == 2 then
		if (code_simbol > 47 and code_simbol < 58) or code_simbol == 8 then
			permission = true
		end
	elseif param == 3 then
		if (code_simbol > 47 and code_simbol < 58) or code_simbol == 8 or code_simbol == 45 then
			permission = true
		end
	elseif param == 4 then
		if (code_simbol > 47 and code_simbol < 58) or code_simbol == 8 or code_simbol == 46 or code_simbol == 44 then
			permission = true
		end
	elseif param == 5 then
		if (code_simbol >= 44 and code_simbol < 58) or code_simbol == 8  then --or code_simbol == 46 or code_simbol == 45
			permission = true
		end
	elseif param == 6 then
		if (code_simbol > 64 and code_simbol < 91) or (code_simbol > 96 and code_simbol < 123) or (code_simbol >= 44 and code_simbol <= 58) or code_simbol == 8 or code_simbol == 32 or code_simbol == 95 or (code_simbol >= 192 and code_simbol <= 255) or code_simbol == 168 then
			permission = true
		end
	end
	if permission then
		if code_simbol ~= 8 and code_simbol ~= 32 then
			str = str..tostring(string.char(code_simbol))
		elseif code_simbol == 8 then
			str = string.sub(str, 1, -2)
		end
	end
	if param ~= 1 then
		str = tostring(str)
		if #str == 2 then
			if string.sub(str,1,1) == "0" then
				str = string.sub(str,2,2)
			end
		end
		if str == "" then
			str = "0"
		elseif str == "." then
			str = "0."
		end
	end
	return str
end

function calculateTR(n) -- вычисл€ет диапазон одного бара (TR)
	local High = Price[n].high
	local Low = Price[n].low
	return High - Low
end

function findMatch(val, t) -- определ€ет, входит ли значение val в таблицу t
	for i = 1, #t do
		if t[i] == val then
			return true
		end
	end
	return false
end

function tabConcat(t1, t2) -- объедин€ет 2 таблицы не измен€€ их
	local new_t1 = {}
	local new_t2 = {}
	for i = 1, #t1 do
		table.insert(new_t1, t1[i])
	end
	for i = 1, #t2 do
		table.insert(new_t2, t2[i])
	end
	for i = 1, #t2 do
		table.insert(new_t1, new_t2[i])
	end
	return new_t1
end

function tabRewrite(t1, t2) -- переписывает значени€ из таблицы t1 в таблицу t2
	for i = 1, #t1 do
		table.insert(t2, t1[i])
	end

	return t2
end

function Sort(t) -- выстраивает числа в таблице по убыванию
	table.sort (t, function (a, b) return (a > b) end)
	return t
end

function calculateATR(period, n, up, down) -- ¬ычисл€ет ATR. ”читывает верх/ниж коэффициенты (up/down). ≈сли коэф-ты не заданы, то не учитывает.

	local atr = 0
	local sum = 0
	local sum_2 = 0
	local i = 0
	local t_UP = {}
	local t_DOWN = {}
	local t = {}
	local p = period

	while true do

		if #t == period then
			t_UP = {}
			t_DOWN = {}
			sum_2 = sum
			for j = 1, #t do
				local y = calculateTR(t[j])
				if up ~= nil and up > 0 and y > sum/#t*up then
					table.insert(t_UP, t[j])
					sum_2 = sum_2 - calculateTR(t[j])
				elseif down ~= nil and down > 0 and y < sum/#t*down then
					table.insert(t_DOWN, t[j])
					sum_2 = sum_2 - calculateTR(t[j])
				end
			end
			if p > #t - (#t_UP + #t_DOWN) then
				sum = 0
				i = 0
				t = {}
				period = period + 1
			else
				atr = sum_2/(#t - (#t_UP + #t_DOWN))
				return atr, t, t_UP, t_DOWN -- возвращает ATR; таблицу с индексами учтенных баров; 2 таблицы с индексами паронормальных баров выше и ниже ATR
			end
		end

		if #t < period then
			table.insert(t, n-i)
			sum = sum + calculateTR(n-i)
			i = i + 1
		end

		if n - i == 1 or i == 200 then
			atr = sum_2/(#t - (#t_UP + #t_DOWN))
			return atr, t, t_UP, t_DOWN
		end
	end
end

function calculateWATR(period, n, up, down) -- ¬ычисл€ет средневзвешенный ATR
	local sum = 0
	local sum2 = 0
	local atr, t_n, t_u, t_d = calculateATR(period, n, up, down)

	for i = 1, #t_n do
		if findMatch(t_n[i], t_u) == false and findMatch(t_n[i], t_d) == false then
			sum = sum + calculateTR(t_n[i])*(#t_n-i+1)
			sum2 = sum2 + (#t_n-i+1)
		end
	end

	local watr = sum/sum2
	return watr, t_n, t_u, t_d
end

function calculateTRF(n) -- ¬ычисл€ет TRF. ѕринимает индекс текущей свечи
	local trf
	local High = Price[n].high
	local Low = Price[n].low
	local Prev_High = Price[n-1].high
	local Prev_Low = Price[n-1].low

	if Prev_Low > High then
		trf =  Prev_Low - Low
	elseif Prev_High < Low then
		trf =  High - Prev_High
	else
		trf =  High - Low
	end

	return round(trf, accuracy)
end

function calculateTRC(n) -- ¬ычисл€ет TR—. ѕринимает индекс текущей свечи
	local trc
	local Close = Price[n].close
	local Prev_Close = Price[n-1].close
	if Close > Prev_Close then
		trc = Close - Prev_Close
	else
		trc = Prev_Close - Close
	end

	return round(trc, accuracy)
end

function calculatePercent(val1, val2) -- находит % val2 от val1
	return math.floor(100/(val1/val2)+0.5)
end

function createObj(path, reg, t) -- создает таблицу с данными из файла
	local file = io.open(path, reg)
	for line in file:lines() do
		local s = {}
		s = split(line, " ")
		for j = 1, #s do
			if s[1] == "ATR:" then
				if s[2] == nil then
					t:setATR("atr")
				else
					t:setATR(s[2])
				end
			elseif s[1] == "Graph:" then
				if s[2] == nil then
					t:setGraph_id("DESK.D")
				else
					t:setGraph_id(s[2])
				end
			elseif s[1] == "Graph2:" then
				if s[2] == nil then
					t:setGraph_5m("")
				else
					t:setGraph_5m(s[2])
				end
			elseif s[1] == "Graph3:" then
				if s[2] == nil then
					t:setGraph_1h("")
				else
					t:setGraph_1h(s[2])
				end
			elseif s[1] == "Period:" then
				if s[2] == nil then
					t:setPeriod(8)
				else
					t:setPeriod(tonumber(s[2]))
				end
			elseif s[1] == "k_UP:" then
				if s[2] == nil then
					t:setK_up(1.5)
				else
					t:setK_up(tonumber(s[2]))
				end
			elseif s[1] == "k_DOWN:" then
				if s[2] == nil then
					t:setK_down(0.5)
				else
					t:setK_down(tonumber(s[2]))
				end
			elseif s[1] == "Filter:" then
				if s[2] == nil then
					t:setParanormal_filter(1)
				else
					t:setParanormal_filter(tonumber(s[2]))
				end
			elseif s[1] == "Color_filter:" then
				if s[2] == nil then
					t:setColor_filter(1)
				else
					t:setColor_filter(tonumber(s[2]))
				end
			elseif s[1] == "Custom_Lines:" then
				if s[2] == nil then
					t:setCustomLines(1)
				else
					t:setCustomLines(tonumber(s[2]))
				end
			elseif s[1] == "Win_ATR:" then
				if s[2] == nil then
					t:setWindowATR_pos({"0","0","390","145"})
				else
					t:setWindowATR_pos(split(s[2], "_"))
				end
			elseif s[1] == "Win_Set:" then
				if s[2] == nil then
					t:setWindowSet_pos({"0","145","390","199"})
				else
					t:setWindowSet_pos(split(s[2], "_"))
				end
			end
		end
	end
	file:close()
	if t:getGraph_id() == nil then
		t:setATR("atr")
		t:setGraph_id("DESK.D")
		t:setGraph_5m("")
		t:setGraph_1h("")
		t:setPeriod(8)
		t:setK_up(1.5)
		t:setK_down(0.5)
		t:setParanormal_filter(1)
		t:setColor_filter(1)
		t:setCustomLines(1)
		t:setWindowATR_pos({"0","0","390","145"})
		t:setWindowSet_pos({"0","145","390","199"})
	end
end

function createColumns(path, reg, t) -- создает таблицу с ширинами колонок
	local file = io.open(path, reg)
	local i = 1
	for line in file:lines() do
		local s = {}
		s = split(line, " ")
		t[i] = tonumber(s[2])
		i = i + 1
	end
	file:close()
end

function split(str, sep) --разделение строки по символу.
	if sep == nil then
		sep = "%s"
	end
	local t={}
	local i=1
	for str in string.gmatch(str, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function calculateValues(t, n, up, down) -- ¬ычисл€ет ATR или WATR, c паранормальными барами или без. «ависит от того, какие выбраны настройки.
	local atr = t:getATR()
	local period = t:getPeriod()
	local up = t:getK_up()
	local down = t:getK_down()
	local filter = t:getParanormal_filter()
	local val, t_n, t_u, t_d
		if atr == "atr" then
			if filter == 1 then
				val, t_n, t_u, t_d = calculateATR(period, n, up, down)
			else
				val, t_n, t_u, t_d = calculateATR(period, n)
			end
		elseif atr == "watr" then
			if filter == 1 then
				val, t_n, t_u, t_d = calculateWATR(period, n, up, down)
			else
				val, t_n, t_u, t_d = calculateWATR(period, n)
			end
		end
	return round(val, accuracy), t_n, t_u, t_d
end

function saveData(t, path, reg) -- сохран€ет данные в файл
	local file = io.open(path, reg)

	local a = "ATR: "..t:getATR().."\n"
	local b = "Graph: "..t:getGraph_id().."\n"
	local b2 = "Graph2: "..t:getGraph_5m().."\n"
	local b3 = "Graph3: "..t:getGraph_1h().."\n"
	local c = "Period: "..t:getPeriod().."\n"
	local d = "k_UP: "..t:getK_up().."\n"
	local e = "k_DOWN: "..t:getK_down().."\n"
	local f = "Filter: "..t:getParanormal_filter().."\n"
	local g = "Color_filter: "..t:getColor_filter().."\n"
	local h = "Custom_Lines: "..t:getCustomLines().."\n"
	local i = "Win_ATR: "..atr2.."_"..atr1.."_"..(atr4-atr2).."_"..(atr3-atr1).."\n"
	local j = "Win_Set: "..set2.."_"..set1.."_"..(set4-set2).."_"..(set3-set1).."\n"

	file:write(a,b,b2,b3,c,d,e,f,g,h,i,j)
	file:close()
end

function windowPosition(t)
	local x = tonumber(t[1])
	local y = tonumber(t[2])
	local w = tonumber(t[3])
	local h = tonumber(t[4])
	return x,y,w,h
end

function calculateNumOfSymbols(n) -- считает количество знаков после зап€той у числа. n - индекс свечи.
	local l = 0
	local t = {}
	local len = 0
	local x = true
	local i = 0
	while x == true do
		local price = tostring(Price[n-i].close)
		local s = split(price, ".")
		if #s == 2 then
			if string.len(s[2]) > l then
				l = string.len(s[2])
			end
			if s[2] == "0" then
				t[i+1] = s[2]
			end
		elseif #s == 1 then
			t[i+1] = "0"
		end
		if i == 99 or n - i == 1 then
			x = false
		end
		i = i + 1
	end
	if #t == i then
		return 0
	else
		return l
	end
end

function round(num, n) -- ќкругление в соответствии с количеством знаков после зап€той. num - число дл€ округлени€, n - точность цены
	if n > 0 then
		return math.floor(num * 10^n + 0.5)/10^n
	end
	return math.floor(num + 0.5)
end

function removeSymbol(str, s) -- дл€ удалени€ повтор€ющейс€ точки в числе
	local count = 0
	for i = 1, string.len(str) do
		local b = string.sub(str,i,i)
		if b == s then
			count = count + 1
		end
		if count == 2 then
			return string.sub(str,1,i-1)
		end
	end
	return str
end

function strToTable(str) -- преобразует строку в массив символов
	local t = {}
	for i = 1, string.len(str) do
		t[i] = string.sub(str,i,i)
	end
	return t
end

function removeDot(str, s) -- дл€ удалени€ точки в числе
	local t = strToTable(str)
	local res = ""
	for i = 1, #t do
		if t[i] ~= s then
			res = res..t[i]
		end
	end
	return res
end

function mathFrexp(num) --преобразует экспоненциальное положительное число (меньше 1) в обычное
	num = tostring(num)
	if #split(num, "e-") > 1 then
		local s = split(num, "e-")
		local m = removeDot(s[1], ".")
		local n = tonumber(s[2])
		local z = "0."
		local res

		for i = 1, n-1 do
			z = z.."0"
		end

		if string.len(s[1]) + string.len(s[2]) < string.len(num) - 2 then
			res = "-"..z..m
		else
			res = z..m
		end

		return res
	end
	return num
end

function addZero(num, n) -- добавл€ет нули к числу (num - строковый тип) до соответстви€ количеству знаков (n)
	num = tostring(num)
	local t = split(num, ".")
	t[2] = t[2] or "0"
	if n > 0 then
		while #t[2]<n do
			t[2] = t[2].."0"
		end
		return t[1].."."..t[2]
	else
		return t[1]
	end
end

function calculateBasicValues() -- расчет основных значений
	ATR, t_n, t_u, t_d = calculateValues(valATR, N-2, valATR:getK_up(), valATR:getK_down())
	TRF = calculateTRF(N-1, ATR)
	TRC = calculateTRC(N-1, ATR)
	AC = mathFrexp(round((ATR - TRC), accuracy))
	AF = mathFrexp(round((ATR - TRF), accuracy))
	ATR_TRF_percent = tostring(calculatePercent(ATR, TRF)).."%"
	ATR_TRC_percent = tostring(calculatePercent(ATR, TRC)).."%"
	volatility = 100/(Price[N-2].close/ATR)
	volatility = tostring(round(volatility, 2))
	local t_vol = split(volatility, ".")
	if #t_vol == 1 then
		volatility = volatility..".00"
	elseif #t_vol == 2 and  #t_vol[2] == 1 then
		volatility = volatility.."0"
	elseif #t_vol == 2 and  #t_vol[2] == 0 then
		volatility = volatility.."00"
	end

	if tonumber(AC) <= 0 then
		AC = "0"
		ATR_TRC_remains = "0%"
	else
		ATR_TRC_remains = tostring(100 - calculatePercent(ATR, TRC)).."%"
	end
	if tonumber(AF) <= 0 then
		AF = "0"
		ATR_TRF_remains = "0%"
	else
		ATR_TRF_remains = tostring(100 - calculatePercent(ATR, TRF)).."%"
	end
	if valATR:getATR() == "atr" then
		ATR_type = ""
	else
		ATR_type = "W"
	end

	ATR = addZero(mathFrexp(ATR), accuracy)
	TRF = addZero(mathFrexp(TRF), accuracy)
	TRC = addZero(mathFrexp(TRC), accuracy)
	AC = addZero(AC, accuracy)
	AF = addZero(AF, accuracy)

	total_length = #t_n
	calc_length = #t_n - (#t_u + #t_d)
end

function drawLabel(color, yvalue, date, time) -- –исует линии
	local label_params = {
			IMAGE_PATH = getScriptPath() .. "\\data\\lines\\"..color..".bmp",
			ALIGNMENT = "RIGHT",
			YVALUE = yvalue,
			DATE = date,
			TIME = time,
	}
	return label_params
end

function calculateHighLow(n) -- находит High/Low дн€ дл€ отрисовки линий
	local HighLine
	local LowLine
	local High = Price[n].high
	local Low = Price[n].low
	local Prev_High = Price[n-1].high
	local Prev_Low = Price[n-1].low

	if Prev_Low > High then
		HighLine =  Prev_Low
	else
		HighLine =  High
	end

	if Prev_High < Low then
		LowLine =  Prev_High
	else
		LowLine =  Low
	end

	return HighLine, LowLine
end

function Date(n)
	local y = Price[n].datetime.year
	local m = Price[n].datetime.month
	local d = Price[n].datetime.day

	if m<10 then
		m = "0"..m
	end
	if d<10 then
		d = "0"..d
	end

	local date = tonumber(y..m..d)

	return date
end

