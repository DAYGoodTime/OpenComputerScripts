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

-- checking 

function Main()
    jsonFile = GetItemConfig()
    -- checking cooling
    print(#jsonFile[1].slot)
    coolerPoint = 1;
    fuelPoint = 1;

    Chamber = transposer.getAllStacks(targetSide)
    ChamberStacks = Chamber.getAll()
    for index,item in pairs(ChamberStacks) do
        if item.name==CoolerName then
            if jsonFile[1].slot[coolerPoint] ~= index then
                jsonFile[1].slot[coolerPoint] = index
                coolerPoint = coolerPoint+1
            end
            table.insert(coolerList,index .. " ")
        elseif item.name==FuelName  then
            if jsonFile[2].slot[fuelPoint] ~= index then
                jsonFile[2].slot[fuelPoint] = index
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
        if (ItemConfig_table[targetProject]) then
            itemConfig:close()
            return ItemConfig_table[targetProject]
        else
            print("The project name you entered could not be found.")
            itemConfig:close()
            os.exit(0)
        end
    else
        print("config.json not found.")
        os.exit(0)
    end
end

Main()