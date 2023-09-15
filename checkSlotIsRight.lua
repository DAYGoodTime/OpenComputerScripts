local cp = require("component")
local JSON = (loadfile "JSON.lua")()
local itemConfig = io.open("config.json", "r")
local transposer = cp.transposer

local targetSide = 3

local CoolerName = "gregtech:gt.360k_Space_Coolantcell"
local FuelName = "gregtech:gt.reactorMOXQuad"
local targetProject = "day"

local coolerList = {}
local fuelList = {}
function Main()
    jsonFile = GetItemConfig()
    coolerPoint = 1;
    fuelPoint = 1;

    Chamber = transposer.getAllStacks(targetSide)
    ChamberStacks = Chamber.getAll()
    for index,item in pairs(ChamberStacks) do
        if item.name==CoolerName then
            if jsonFile[targetProject][1].slot[coolerPoint] ~= index then
                jsonFile[targetProject][1].slot[coolerPoint] = index
                coolerPoint = coolerPoint+1
            end
            table.insert(coolerList,index .. " ")
        elseif item.name==FuelName  then
            if jsonFile[targetProject][2].slot[fuelPoint] ~= index then
                jsonFile[targetProject][2].slot[fuelPoint] = index
                fuelPoint = fuelPoint+1
            end
            table.insert(fuelList,index .. " ")
        else
            print("inviadl item:slot" .. index)
        end
    end
    print("CoolerList:",table.concat(coolerList))
    print("FuelList:",table.concat(fuelList))
    WriteAbleConfig = io.open("config.json", "w")
    if WriteAbleConfig then 
        WriteAbleConfig:write(JSON:encode_pretty(jsonFile))
        io.close(WriteAbleConfig)
        print("更新新的slot配置到config.json")
    else
        print("config file not found")
    end 
end

function GetItemConfig()
    if itemConfig then
        local ItemConfig_table = JSON:decode(itemConfig:read("*a"))
        return ItemConfig_table
    else
        print("config.json not found.")
        os.exit(0)
    end
end

Main()