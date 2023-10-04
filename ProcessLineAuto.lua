local component = require("component");
local JSON = (loadfile "JSON.lua")()
-- 上:1
-- 下:0
-- 北:2
-- x东:5
-- 西:4
-- z南:3

TransposerList = {};
RecipeReaderAddress = "36bc2573-487b-4b9b-b6b9-c6e156afc404" -- aka input
OutputTransposerAddress = "36bc2573-487b-4b9b-b6b9-c6e156afc404"
RecipeReaderSide = 3;
InputHactchSide = 5;


Repices = {}

function LoadTransposer()
    os.execute("cls")
    print("Loading Transposers")
    if RecipeReaderAddress or OutputTransposerAddress then
        for address,name in component.list("transposer",true) do
            if address~=RecipeReaderAddress then
                table.insert(TransposerList,component.proxy(address));
            end
        end
    else
        print("Please setup reader and output Address")
        os.exit(1);
    end
end

function CreateRecipes()
    os.execute("cls")
    print("start reading recpies")
    local repiceReader = component.proxy(RecipeReaderAddress)
    local itemStacks = repiceReader.getAllStacks(RecipeReaderSide).getAll()
    local repicesFile = io.open("repices.json","w")
    local count = 0;
    local repices = {}
    for index, patten in pairs(itemStacks) do
        if next(patten) ~= nil then
            count=count+1;
            local repice = {}
            repice.inputs= {}
            repice.outputs = {}
            repice.inputs.fluids = {}
            repice.inputs.items = {}
            repice.outputs.fluids = {}
            repice.outputs.items = {}
            for key, item in pairs(patten.inputs) do
                if next(item) ~= nil then
                    local obj = {}
                    obj.name = item.name
                    obj.count = item.count
                    if string.match(item.name,'液滴') then
                        table.insert(repice.inputs.fluids,obj) 
                    else
                        table.insert(repice.inputs.items,obj) 
                    end
                end
            end
            for key, item in pairs(patten.outputs) do
                if next(item) ~= nil then
                    local obj = {}
                    obj["name"] = item.name
                    obj["count"] = item.count
                    if string.match(item.name,'液滴') then
                        table.insert(repice.outputs.fluids,obj) 
                    else
                        table.insert(repice.outputs.items,obj) 
                    end
                end
            end
            table.insert(repices,repice)
        end
    end
    print("reading finished updated" ..  count .. "recpies")
    if repicesFile then
        repicesFile:write(JSON:encode_pretty(repices))
    end
end

function LoadRecipes()
    local repice_file = io.open("repices.json", "r");
    if repice_file then
        Repices = JSON:decode(repice_file:read("*a"))
        print("Loaded   " .. #Repices  " Repices")
        repice_file:close()
    else
        print("repices.json not found. you should create one")
    end
    
end

function CheckRepice()
    while true do
        os.execute("cls")
        print("checking availbel repice")
        local InputBoxTransposer = component.proxy(RecipeReaderAddress)
        local InputSacks = InputBoxTransposer.getAllStacks(RecipeReaderSide).getAll()
            if InputSacks or #InputSacks>1 then
                for Repiceindex,repices in pairs(Repices) do
                    local isRepices = true;
                    local MatchIndex = {}
                    for requireItemIndex, requireItem in pairs(repices.inputs) do
                        local NotFouned = true;
                        for ItemStackIndex, ItemStack in pairs(InputSacks) do
                            if ItemStack.label==requireItem.name then
                                table.insert(MatchIndex,ItemStackIndex)
                                NotFouned = false;
                            end
                        end
                        if NotFouned then
                            isRepices = false;
                        end
                    end
                    if isRepices then
                        
                    end
                end
            end
        os.sleep(10)
    end
end

function MoveItem(transposer,)
    
end


function Main()
    LoadTransposer();
    print("type 1 to repices creation else will skip it")
    local select = io.read()
    if select == "1" then
        CreateRecipes();
    end
    LoadRecipes()
end

Main()