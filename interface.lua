Table = AllocTable()
SettingsTable = AllocTable()
function PrintTable(t, name, width)
	AddColumn(t, 1,"", true, QTABLE_STRING_TYPE, width*widthTable[1])
	AddColumn(t, 2,"", true, QTABLE_DOUBLE_TYPE, width*widthTable[2])
	AddColumn(t, 3,"", true, QTABLE_DOUBLE_TYPE, width*widthTable[3])
	AddColumn(t, 4,"", true, QTABLE_DOUBLE_TYPE, width*widthTable[4])
	AddColumn(t, 5,"", true, QTABLE_DOUBLE_TYPE, width*widthTable[5])

	local x,y,w,h = windowPosition(valATR:getWindowATR_pos())
	CreateWindow(t)
	SetWindowCaption(t, name)
	SetWindowPos(t, x,y,w,h)

	for i = 1, 4 do
		InsertRow(t, -1)
	end
end

function PrintSettingsTable(t, name, width)
	AddColumn(t, 1,"", true, QTABLE_STRING_TYPE, width*widthTable[6])
	AddColumn(t, 2,"", true, QTABLE_DOUBLE_TYPE, width*widthTable[7])

	local x,y,w,h = windowPosition(valATR:getWindowSet_pos())
	CreateWindow(t)
	SetWindowCaption(t, name)
	SetWindowPos(t, x,y,w,h)

	for i = 1, 11 do
		InsertRow(t, -1)
		InsertRow (Tabl,-1)
	end
end

function SetCells(t)
	SetCell(t, 1, 1, "ATR:")
	SetCell(t, 2, 1, "")
	SetCell(t, 3, 1, "TRF:")
	SetCell(t, 4, 1, "TRC:")
	SetCell(t, 1, 2, ATR)
	SetCell(t, 2, 2, "Пройдено:")
	SetCell(t, 3, 2, TRF)
	SetCell(t, 4, 2, TRC)
	SetCell(t, 1, 3, volatility.."%")
	SetCell(t, 2, 3, "%")
	SetCell(t, 3, 3, ATR_TRF_percent)
	SetCell(t, 4, 3, ATR_TRC_percent)
	SetCell(t, 1, 4, tostring(calc_length).."/"..tostring(total_length))
	SetCell(t, 2, 4, "Осталось:")
	SetCell(t, 3, 4, AF)
	SetCell(t, 4, 4, AC)
	SetCell(t, 1, 5, ATR_type)
	SetCell(t, 2, 5, "%")
	SetCell(t, 3, 5, ATR_TRF_remains)
	SetCell(t, 4, 5, ATR_TRC_remains)
end

function SetSettingsCells(t)
	SetCell(t, 1, 1, "Классический ATR")
	SetCell(t, 2, 1, "Средневзвешенный ATR")
	SetCell(t, 3, 1, "ID графика для расчета ATR")
	SetCell(t, 4, 1, "ID графика для отрисовки уровней на М5")
	SetCell(t, 5, 1, "ID графика для отрисовки уровней на Н1")
	SetCell(t, 6, 1, "Период расчета")
	SetCell(t, 7, 1, "Коэф. верхней границы ATR")
	SetCell(t, 8, 1, "Коэф. нижней границы ATR")
	SetCell(t, 9, 1, "Фильтр паранормальных баров")
	SetCell(t, 10, 1, "Подсветка значений")
	SetCell(t, 11, 1, "Отрисовка уровней ATR на графиках")
	
	SetCell(t, 1, 2, "")
	SetCell(t, 2, 2, "")
	SetCell(t, 3, 2, id)
	SetCell(t, 4, 2, id_2)
	SetCell(t, 5, 2, id_3)
	SetCell(t, 6, 2, tostring(per))
	SetCell(t, 7, 2, tostring(k_up))
	SetCell(t, 8, 2, tostring(k_dn))
	SetCell(t, 9, 2, "")
	SetCell(t, 10, 2, "")
	SetCell(t, 11, 2, "")
end

function setCustomColors()

	local def = QTABLE_DEFAULT_COLOR
	local cells = {}

	local function setV(t, x)
		t.i = t.i + 1
		t.val[t.i] = x.val
		t.bcg[t.i] = x.background
		t.txt[t.i] = x.text
	end

	function Volatility(v)
		setV(cells[1], v)
	end

	function trfValue(v)
		setV(cells[2], v)
	end

	function trcValue(v)
		setV(cells[3], v)
	end

	function atrValue(v)
		setV(cells[4], v)
	end

	function trfRem(v)
		setV(cells[5], v)
	end

	function trcRem(v)
		setV(cells[6], v)
	end

	for i = 1, 6 do
		cells[i] = {}
	end

	cells[1].n = tonumber(string.sub(volatility, 1, -2))
	cells[2].n = tonumber(string.sub(ATR_TRF_percent, 1, -2))
	cells[3].n = tonumber(string.sub(ATR_TRC_percent, 1, -2))
	cells[4].n = ATR_type
	cells[5].n = tonumber(string.sub(ATR_TRF_remains, 1, -2))
	cells[6].n = tonumber(string.sub(ATR_TRC_remains, 1, -2))


	cells[1].l = 1
	cells[1].c = 3
	cells[2].l = 3
	cells[2].c = 3
	cells[3].l = 4
	cells[3].c = 3
	cells[4].l = 1
	cells[4].c = 5
	cells[5].l = 3
	cells[5].c = 5
	cells[6].l = 4
	cells[6].c = 5

	for i = 1, #cells do
		cells[i].val = {}
		cells[i].bcg = {}
		cells[i].txt = {}
		cells[i].i = 0
	end

	dofile (getScriptPath() .. "\\parameters\\CustomColors.txt")

	for i = 1, #cells do
		if cells[i].n ~= nil then
			if i == 4 then
				if cells[i].n == cells[i].val[1] then
					SetColor(Table, cells[i].l, cells[i].c, RGB(cells[i].bcg[1][1],cells[i].bcg[1][2],cells[i].bcg[1][3]), RGB(cells[i].txt[1][1],cells[i].txt[1][2],cells[i].txt[1][3]), def, def)
				elseif cells[i].n == cells[i].val[2] then
					SetColor(Table, cells[i].l, cells[i].c, RGB(cells[i].bcg[2][1],cells[i].bcg[2][2],cells[i].bcg[2][3]), RGB(cells[i].txt[2][1],cells[i].txt[2][2],cells[i].txt[2][3]), def, def)
				end
			else
				for j = 1, #cells[i].val do
					if cells[i].n>=cells[i].val[j] then
						SetColor(Table, cells[i].l, cells[i].c, RGB(cells[i].bcg[j][1],cells[i].bcg[j][2],cells[i].bcg[j][3]), RGB(cells[i].txt[j][1],cells[i].txt[j][2],cells[i].txt[j][3]), def, def)
					end
				end
			end
		end
	end
end

function setNormalColors()
	local def = QTABLE_DEFAULT_COLOR
	SetColor(Table, 1, 3, def, def, def, def)
	SetColor(Table, 3, 3, def, def, def, def)
	SetColor(Table, 4, 3, def, def, def, def)
	SetColor(Table, 1, 5, def, def, def, def)
	SetColor(Table, 3, 5, def, def, def, def)
	SetColor(Table, 4, 5, def, def, def, def)
end

function setCol(t)
	local def = QTABLE_DEFAULT_COLOR
	if t:getATR() == "atr" then
		SetColor(SettingsTable, 1, 2, RGB (93, 166, 107), def, def, def)
		SetColor(SettingsTable, 2, 2, def, def, def, def)
	elseif t:getATR() == "watr" then
		SetColor(SettingsTable, 2, 2, RGB (93, 166, 107), def, def, def)
		SetColor(SettingsTable, 1, 2, def, def, def, def)
	end
	if t:getParanormal_filter() == 1 then
		SetColor(SettingsTable, 9, 2, RGB (93, 166, 107), def, def, def)
	elseif t:getParanormal_filter() == 0 then
		SetColor(SettingsTable, 9, 2, def, def, def, def)
	end
	if t:getColor_filter() == 1 then
		SetColor(SettingsTable, 10, 2, RGB (93, 166, 107), def, def, def)
	elseif t:getColor_filter() == 0 then
		SetColor(SettingsTable, 10, 2, def, def, def, def)
	end
	if t:getCustomLines() == 1 then
		SetColor(SettingsTable, 11, 2, RGB (93, 166, 107), def, def, def)
	elseif t:getCustomLines() == 0 then
		SetColor(SettingsTable, 11, 2, def, def, def, def)
	end
end

f_cb = function(t, msg,  par1, par2)
	local def = QTABLE_DEFAULT_COLOR
	if msg==QTABLE_LBUTTONDOWN then
		activeLine = par1
		activeCol = par2
		if activeCol == 2 then
			if activeLine == 1 then
				valATR:setATR("atr")
				SetColor(SettingsTable, 1, 2, RGB (93, 166, 107), def, def, def)
				SetColor(SettingsTable, 2, 2, def, def, def, def)
			elseif activeLine == 2 then
				valATR:setATR("watr")
				SetColor(SettingsTable, 2, 2, RGB (93, 166, 107), def, def, def)
				SetColor(SettingsTable, 1, 2, def, def, def, def)
			elseif activeLine == 9 then
				if valATR:getParanormal_filter() == 1 then
					valATR:setParanormal_filter(0)
					SetColor(SettingsTable, activeLine, activeCol, def, def, def, def)
				elseif valATR:getParanormal_filter() == 0 then
					valATR:setParanormal_filter(1)
					SetColor(SettingsTable, activeLine, activeCol, RGB (93, 166, 107), def, def, def)
				end
			elseif activeLine == 10 then
				if valATR:getColor_filter() == 1 then
					valATR:setColor_filter(0)
					SetColor(SettingsTable, activeLine, activeCol, def, def, def, def)
				elseif valATR:getColor_filter() == 0 then
					valATR:setColor_filter(1)
					SetColor(SettingsTable, activeLine, activeCol, RGB (93, 166, 107), def, def, def)
				end				
			elseif activeLine == 11 then
				if valATR:getCustomLines() == 1 then
					valATR:setCustomLines(0)
					SetColor(SettingsTable, activeLine, activeCol, def, def, def, def)
					DelAllLabels(id_2)
					DelAllLabels(id_3)
					id1, id2, id3, id4, id5, id6, id7, id8 = 0,0,0,0,0,0,0,0
				elseif valATR:getCustomLines() == 0 then
					valATR:setCustomLines(1)
					SetColor(SettingsTable, activeLine, activeCol, RGB (93, 166, 107), def, def, def)
				end
			elseif activeLine >= 3 and activeLine <= 8 then
				SetColor(SettingsTable, activeLine, 2, RGB (181, 62, 26), RGB (32, 32, 32), def, def)
				edit = true
			end
		end
	end

	if msg == QTABLE_CHAR then
		if activeCol == 2 then
			if activeLine == 3 then
				id = handler(id,par2,1)
			elseif activeLine == 4 then
				id_2 = handler(id_2,par2,1)
			elseif activeLine == 5 then
				id_3 = handler(id_3,par2,1)
			elseif activeLine == 6 then
				per = handler(per,par2,2)
			elseif activeLine == 7 then
				k_up = handler(k_up,par2,4)
			elseif activeLine == 8 then
				k_dn = handler(k_dn,par2,4)
			end
		end
	end

	if msg == QTABLE_VKEY then -- по нажатию Enter новые параметры начинают действовать
		if par2 == 13 then
			if per == 0 then
				per = 1
			end
			if k_up == 0 then
				k_up = 1
			end
			if k_dn == 0 then
				k_dn = 1
			end
			
			if id ~= valATR:getGraph_id() then
				DelAllLabels(valATR:getGraph_5m())
				DelAllLabels(valATR:getGraph_1h())
				id1, id2, id3, id4, id5, id6, id7, id8 = 0,0,0,0,0,0,0,0
			end
			if id_2 ~= valATR:getGraph_5m() then
				DelAllLabels(valATR:getGraph_5m())
				id1, id2, id3, id4 = 0,0,0,0
			end
			if id_3 ~= valATR:getGraph_1h() then
				DelAllLabels(valATR:getGraph_1h())
				id5, id6, id7, id8 = 0,0,0,0
			end
			
			valATR:setGraph_id(id)
			valATR:setGraph_5m(id_2)
			valATR:setGraph_1h(id_3)
			valATR:setPeriod(tonumber(per))
			valATR:setK_up(tonumber(removeSymbol(tostring(k_up), "."))) -- проверка на две точки в числе
			valATR:setK_down(tonumber(removeSymbol(tostring(k_dn), ".")))

			for i = 3, 8 do
				SetColor(SettingsTable, i, 2, def, def, def, def)
			end
			edit = false
		end
	end
end
