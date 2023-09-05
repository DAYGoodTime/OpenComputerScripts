Component = require("component")
Event = require("event")

Gt = Component.gt_machine
Redstone = Component.redstone
Runing = false;
CdTime = 20
CapacityHigh = 95
CapacityLow = 30
AcceptSide = 3;
OutputSide = 5;
NoticeSide = 1;
ShouldRunNuclear = false

local timer = Event.timer(CdTime, function()
    if Redstone.getInput(AcceptSide) == 15 then
        Runing = true;
    else
        Runing = false;
    end
    os.execute("cls")
    if Runing then
       local percent_float = (Gt.getEUStored() / Gt.getEUMaxStored())
       local percent = 0
       if percent_float >=0.999 then
        percent = 100
        percent_float = 1;
        else
            percent = math.floor(percent_float*100)
        end
       local progressBar = {}
       table.insert(progressBar,"[")
       if percent==0 then
        table.insert(progressBar,"0%")
       end
       for i=1,9 do
            if i == 5 then
                table.insert(progressBar,string.format("%.2f",percent_float*100) .. "%")
            else
                table.insert(progressBar,"=")
            end
       end
       if percent >= CapacityHigh then
            Redstone.setOutput(OutputSide,0)
            Redstone.setOutput(NoticeSide,0)
            ShouldRunNuclear =false
       end
       if percent <= CapacityLow then
            Redstone.setOutput(OutputSide,15)
            Redstone.setOutput(NoticeSide,15)
            ShouldRunNuclear = true
       end
       table.insert(progressBar,"]")
       print("当前电池容量:".. table.concat(progressBar))
       if shouldRunNuclear then
        print("反应堆状态: 启动！中")
       else
        print("反应堆状态: 未启动")
       end
    else
        print("控制信号为空,不启动")
        Redstone.setOutput(OutputSide,0)
        Redstone.setOutput(NoticeSide,0)
    end
end, math.huge)

while true do
    local _, _, _, _, _, eventID = Event.pull()

    if eventID == "interrupted" then
      Event.cancel(timer)
      break
    end
end