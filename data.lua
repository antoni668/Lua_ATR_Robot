Data= {}
function Data:new()

    local obj= {}
        obj.atr = atr
		obj.graph_id = graph_id
		obj.graph_5m = graph_5m
		obj.graph_1h = graph_1h
		obj.period = period
		obj.k_up = k_up
		obj.k_down = k_down
		obj.paranormal_filter = paranormal_filter
		obj.color = color
		obj.customLines = customLines
		obj.windowATR_pos = windowATR_pos
		obj.windowSet_pos = windowSet_pos

    function obj:getATR()
        return self.atr
    end
	function obj:getGraph_id()
        return self.graph_id
    end
	function obj:getGraph_5m()
        return self.graph_5m
    end
	function obj:getGraph_1h()
        return self.graph_1h
    end
	function obj:getPeriod()
        return self.period
    end
	function obj:getK_up()
        return self.k_up
    end
	function obj:getK_down()
        return self.k_down
    end
	function obj:getParanormal_filter()
        return self.paranormal_filter
    end
	function obj:getColor_filter()
        return self.color_filter
    end
	function obj:getCustomLines()
        return self.customLines
    end
	function obj:getWindowATR_pos()
        return self.windowATR_pos
    end
	function obj:getWindowSet_pos()
        return self.windowSet_pos
    end


	function obj:setATR(ATR)
		self.atr = ATR
	end
	function obj:setGraph_id(ID)
		self.graph_id = ID
	end
	function obj:setGraph_5m(ID5m)
		self.graph_5m = ID5m
	end
	function obj:setGraph_1h(ID1h)
		self.graph_1h = ID1h
	end
	function obj:setPeriod(per)
		self.period = per
	end
	function obj:setK_up(up)
		self.k_up = up
	end
	function obj:setK_down(down)
		self.k_down = down
	end
	function obj:setParanormal_filter(p_filter)
		self.paranormal_filter = p_filter
	end
	function obj:setColor_filter(clr)
		self.color_filter = clr
	end
	function obj:setCustomLines(custl)
		self.customLines = custl
	end
	function obj:setWindowATR_pos(ATR_pos)
		self.windowATR_pos = ATR_pos
	end
	function obj:setWindowSet_pos(SetPos)
		self.windowSet_pos = SetPos
	end


    setmetatable(obj, self)
    self.__index = self; return obj
end
