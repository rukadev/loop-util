-- Services
local RunService = game:GetService("RunService")


--[[

Visualized

loop = {
	loopers = {
		id = {},
		id = {}
	},

	classes = {
		classid = {id1, id2},
		classid2 = {id1, id2}
	}

	intervals = {
		1 = {id1, id2}
	}

	intervals = {1, 2, 3, 4} // the sorted

	idx = 0
	


	for _, id in pairs(intervals[idx]) do
		-- do thing here
	end
}

]]


local Loop = {}
Loop.__index = Loop

function Loop.new()
	local self = {}
	self.classes = {}
	self.loopers = {}
	self.intervalMap = {}
	self.intervalArray = {}
	self.idx = 0

	setmetatable(self, Loop)
	return self
end

-- Set code to run once
function Loop:schedule()
		
end

function Loop:begin()

	self.heartbeat = (function()
		
		-- Initialize timings
		for interval, info in pairs(self.intervals) do
			info.step = os.clock() + interval
		end
		
		-- Iterate intervals
		return RunService.Heartbeat:Connect(function(deltaTime)
			
			for interval, info in pairs(self.intervals) do
				if os.clock() >= info.step then
					for _, eventName in pairs(info.ids) do

					end
					info.step = os.clock() + interval
				end
			end
		end)
	end)()
		
		
	self.renderstep = (function()
		return RunService.RenderStepped:Connect(function(deltaTime)
		
		end)
	end)()

	self.stepped = (function()
		return RunService.Stepped:Connect(function(time, deltaTime)
		
		end)
	end)()
end

function Loop:FindBestSpot(CompletionTime)
	local LeftIdx = 1
	local RightIdx = #TimerArrays

	if RightIdx == 0 then
		return 1
	end
	while LeftIdx <= RightIdx do
		local CenterIdx = math.floor((LeftIdx + RightIdx) / 2)
		local CenterTimer = TimerArrays[CenterIdx]

		if CenterTimer == nil then
			return RightIdx
		end
		if CompletionTime > CenterTimer:GetRemaining() then
			RightIdx = CenterIdx - 1
		elseif CompletionTime < CenterTimer:GetRemaining() then
			LeftIdx = CenterIdx + 1
		else
			LeftIdx = CenterIdx
			break
		end
	end

	return LeftIdx
end

function Loop:addLooper(info)
	-- Add to interval or create new
	if self.intervalMap[info.interval] then
		table.insert(self.intervalMap[info.interval], info.id)
	else
		self:FindBestSpot(info.interval)
	end

	if info.className then
		table.insert(self.classes[info.className], info.id)
	end

	self.loopers[info.id] = {
		callbacks = info.callbacks,
		interval = info.interval
	}
end

function Loop:removeLooper(id)
	local looper = self.loopers[id]
	if looper.className then
		table.remove(self.classes[looper.className], id)
	end
	table.remove(self.intervalMap[looper.interval], looper.id)
	looper = nil
end

function Loop:addClass(className)
	self.classes[className] = {}
end

function Loop:removeClass(className)
	for _, eventName in pairs(self.classes[className]) do
		self.loopers[eventName] = nil
	end
	self.classes[className] = nil
end

return Loop