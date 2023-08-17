Component = require("component")
Event = require("event")

Gt = Component.gt_machine
Redstone = Component.redstone
Runing = false;
CdTime = 30
CapacityHigh = 95
CapacityLow = 30
AcceptSide = 4;
OutputSide = 5;

local timer = Event.timer(CdTime, function()
    if Redstone.getInput(AcceptSide) == 15 then
        Runing = true;
    else
        Runing = false;
    end
    if Runing then
       local percent = Gt.getEUStored() / Gt.getEUMaxStored()
       if percent >= CapacityHigh then
            Redstone.setOutput(OutputSide,0)
       end
       if percent <= CapacityLow then
            Redstone.setOutput(OutputSide,15)
       end
    end
end, math.huge)

while true do
    local _,_,_,_,_, eventID = Event.pull()
    if eventID == "interrupted" then
        Event.cancel(timer)
        break
    end
end
