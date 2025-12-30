local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Confirmed = false
WindUI:Popup({
    Title = '<font color="#00FFFF">✨ 欢迎使用</font><font color="#FF3366">Qing Feng</font><font color="#00FF99"> Hub ✨</font>',
    Icon = "sparkles",
    IconThemed = true,
    Content = '<font color="#FFD700">版本: 免费版 V1.0</font>\n<font color="#FF6B9D">制作人: 红蓝 eyes</font>\n<font color="#66FF99">本脚本使用了AI修改</font>',
    BackgroundBlur = 10,
    BackgroundTransparency = 0.3,
    Buttons = {
        {
            Title = "❌ 取消",
            Icon = "x",
            Callback = function() 
                WindUI:Notify({
                    Title = "再见",
                    Content = "期待下次再见！",
                    Icon = "heart",
                    Duration = 2
                })
            end,
            Variant = "Secondary",
        },
        {
            Title = "🚀 启动脚本",
            Icon = "rocket",
            Callback = function() 
                Confirmed = true 
            end,
            Variant = "Primary",
        }
    }
})

repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Title = '<font color="#FF6B6B">D</font><font color="#FFD166">O</font><font color="#06D6A0">O</font><font color="#118AB2">R</font><font color="#073B4C">S</font> <font color="#EF476F">V1</font>',
    Icon = "gamepad-2",
    IconThemed = true,
    Author = '<font color="#FF3366">Qing Feng</font> | <font color="#00CCFF">免费版 V1.0</font>',
    Folder = "AdvancedUI",
    Size = UDim2.fromOffset(600, 450),
    Transparent = true,
    BackgroundBlur = 15,
    Theme = "Dark",
    AccentColor = Color3.fromRGB(255, 102, 204), 
    User = {
        Enabled = true,
        Callback = function() 
            WindUI:Notify({
                Title = "👤 用户信息",
                Content = '<font color="#FF0000">欢</font><font color="#FF9900">迎</font><font color="#FFFF00">使</font><font color="#00FF00">用</font> <font color="#00FFFF">QING</font> <font color="#9900FF">Feng</font>\n<font color="#FFD700">🕐 时间: '.. os.date("%Y-%m-%d %H:%M:%S") ..'</font>',
                Duration = 5,
                Icon = "user-check"
            })
        end,
        Anonymous = false
    },
    SideBarWidth = 240,
    ScrollBarEnabled = true,
    RoundedCorners = true,
    DropShadow = true
})

local a = Window:Tab({
    Title = "主要功能",
    Icon = "home",
    Desc = "Doors"
})

local b = Window:Tab({
    Title = "物品透视",
    Icon = "package-search",
    Desc = "Doors"
})

local c = Window:Tab({
    Title = "怪物透视",
    Icon = "skull-crossbones",
    Desc = "Doors"
})

local d = Window:Tab({
    Title = "怪物提示",
    Icon = "radar",
    Desc = "Doors"
})

local e = Window:Tab({
    Title = "物品刷新提示",
    Icon = "home",
    Desc = "Doors"
})

local Lighting = game:GetService("Lighting")
local espTasks = {}
local monsterDetectionTasks = {}
local itemDetectionTasks = {}
local bj = {}

local function ts(itemName, displayName)
    return function(value)
        if value then
            if itemDetectionTasks[itemName] then
                itemDetectionTasks[itemName] = false
                itemDetectionTasks[itemName] = nil
            end
            
            local taskId = tick()
            local taskRunning = true
            itemDetectionTasks[itemName] = {id = taskId, running = taskRunning}
            
            task.spawn(function()
                while taskRunning and itemDetectionTasks[itemName] and itemDetectionTasks[itemName].id == taskId do
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj.Name == itemName and obj:IsA("Model") and not bj[obj] then
                            bj[obj] = true
                            WindUI:Notify({
                                Title = "物品检测",
                                Content = displayName .. " 刷新了",
                                Duration = 2
                            })
                            
                            local connection
                            connection = obj.AncestryChanged:Connect(function()
                                if not obj:IsDescendantOf(workspace) then
                                    bj[obj] = nil 
                                    if connection then
                                        connection:Disconnect()
                                    end
                                end
                            end)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            if itemDetectionTasks[itemName] then
                itemDetectionTasks[itemName].running = false
                itemDetectionTasks[itemName] = nil
            end
        end
    end
end

local function guanbi(itemName)
    for _, item in pairs(workspace:GetDescendants()) do
        if item.Name == itemName and item:IsA("Model") then
            local billboard = item:FindFirstChild("ItemMarker")
            local highlight = item:FindFirstChild("DoorHighlight")
            if billboard then 
                billboard:Destroy() 
            end
            if highlight then 
                highlight:Destroy() 
            end
        end
    end
end

local function hanshu(name, yanse, gaoliangyanse, zhongwm)
    for _, item in pairs(workspace:GetDescendants()) do
        if item.Name == name and item:IsA("Model") then
            if not item:FindFirstChild("ItemMarker") then
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ItemMarker"
                billboard.Size = UDim2.new(0, 200, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true
                billboard.Enabled = true

                local textLabel = Instance.new("TextLabel")
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = zhongwm
                textLabel.TextColor3 = yanse
                textLabel.TextScaled = true
                textLabel.Parent = billboard
                billboard.Parent = item
            end
            
            if not item:FindFirstChild("DoorHighlight") then
                local highlight = Instance.new("Highlight")
                highlight.Name = "DoorHighlight"
                highlight.Adornee = item
                highlight.FillColor = gaoliangyanse
                highlight.FillTransparency = 0.6
                highlight.OutlineColor = gaoliangyanse
                highlight.OutlineTransparency = 0
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                highlight.Parent = item
            end
        end
    end
end

local function createItemESP(itemName, color, highlightColor, displayName, toggleKey)
    return function(value)
        if value then
            guanbi(itemName)
            
            local taskRunning = true
            local taskId = tick()
            espTasks[toggleKey] = {id = taskId, running = taskRunning}
            
            task.spawn(function()
                while taskRunning and espTasks[toggleKey] and espTasks[toggleKey].id == taskId do
                    hanshu(itemName, color, highlightColor, displayName)
                    task.wait(0.5)
                end
            end)
        else
            if espTasks[toggleKey] then
                espTasks[toggleKey].running = false
                espTasks[toggleKey] = nil
            end
            
            guanbi(itemName)
        end
    end
end

local function createMonsterDetection(monsterName, displayName, warningMessage)
    return function(value)
        if value then
            if monsterDetectionTasks[monsterName] then
                monsterDetectionTasks[monsterName] = false
                monsterDetectionTasks[monsterName] = nil
            end
            
            local taskId = tick()
            local taskRunning = true
            monsterDetectionTasks[monsterName] = {id = taskId, running = taskRunning}
            
            task.spawn(function()
                while taskRunning and monsterDetectionTasks[monsterName] and monsterDetectionTasks[monsterName].id == taskId do
                    for _, monster in pairs(workspace:GetDescendants()) do
                        if monster.Name == monsterName and monster:IsA("Model") then
                            WindUI:Notify({
                                Title = "怪物检测",
                                Content = warningMessage,
                                Duration = 2
                            })
                            task.wait(2)
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            if monsterDetectionTasks[monsterName] then
                monsterDetectionTasks[monsterName].running = false
                monsterDetectionTasks[monsterName] = nil
            end
        end
    end
end

a:Toggle({
    Title = "跳跃",
    Desc = "获得跳跃能力",
    Callback = function(value)
        local LocalPlayer = game.Players.LocalPlayer
        if LocalPlayer.Character then
            LocalPlayer.Character:SetAttribute("CanJump", value)
        end
        
        LocalPlayer.CharacterAdded:Connect(function(newCharacter)
            task.wait(1.5)
            newCharacter:SetAttribute("CanJump", value)
        end)
    end
})

a:Button({
    Title = "删除Seek触手",
    Desc = "娱乐",
    Callback = function()
        for _, a in pairs(workspace:GetDescendants()) do
            if a.Name == "Seek_Arm" then
                a:Destroy()
            end
        end
    end
})

a:Button({
    Title = "删除Seek",
    Desc = "娱乐",
    Callback = function()
        for _, a in pairs(workspace:GetDescendants()) do
            if a.Name == "SeekMoving" then
                a:Destroy()
            end
        end
    end
})



b:Toggle({
    Title = "门",
    Desc = "透视门",
    Callback = createItemESP("Door", Color3.fromRGB(255, 165, 0), Color3.fromRGB(0, 255, 0), "门", "door")
})

b:Toggle({
    Title = "钥匙",
    Desc = "透视钥匙",
    Callback = createItemESP("KeyObtain", Color3.fromRGB(255, 165, 0), Color3.fromRGB(0, 255, 0), "钥匙", "key")
})

b:Toggle({
    Title = "十字架",
    Desc = "透视十字架",
    Callback = createItemESP("Crucifix", Color3.fromRGB(139, 69, 19), Color3.fromRGB(139, 69, 19), "十字架", "crucifix")
})

b:Toggle({
    Title = "手电筒",
    Desc = "透视手电筒",
    Callback = createItemESP("Flashlight", Color3.fromRGB(30, 144, 255), Color3.fromRGB(30, 144, 255), "手电筒", "flashlight")
})

b:Toggle({
    Title = "电池",
    Desc = "透视电池",
    Callback = createItemESP("Battery", Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 215, 0), "电池", "battery")
})

b:Toggle({
    Title = "蜡烛",
    Desc = "透视蜡烛",
    Callback = createItemESP("Candle", Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 165, 0), "蜡烛", "candle")
})

b:Toggle({
    Title = "打火机",
    Desc = "透视打火机",
    Callback = createItemESP("Lighter", Color3.fromRGB(255, 69, 0), Color3.fromRGB(255, 69, 0), "打火机", "lighter")
})

b:Toggle({
    Title = "绷带",
    Desc = "透视绷带",
    Callback = createItemESP("BandagePack", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), "绷带包", "bandage")
})

b:Toggle({
    Title = "金币",
    Desc = "透视金币",
    Callback = createItemESP("GoldPile", Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 215, 0), "金币", "gold")
})

b:Toggle({
    Title = "拉杆",
    Desc = "透视拉杆",
    Callback = createItemESP("LeverForGate", Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 215, 0), "拉杆", "leverforgate")
})

b:Toggle({
    Title = "酒",
    Desc = "透视酒",
    Callback = createItemESP("Smoothie", Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 215, 0), "酒", "smoothie")
})

b:Toggle({
    Title = "维他命",
    Desc = "透视维他命",
    Callback = createItemESP("Vitamins", Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 215, 0), "维他命", "Vitamins")
})

b:Toggle({
    Title = "剪刀",
    Desc = "透视剪刀",
    Callback = createItemESP("Shears", Color3.fromRGB(255, 215, 0), Color3.fromRGB(255, 215, 0), "剪刀", "Shears")
})

a:Button({
    Title = "清理所有透视",
    Desc = "清除所有透视效果",
    Callback = function()
        for taskKey, taskInfo in pairs(espTasks) do
            taskInfo.running = false
        end
        espTasks = {}
        
        local items = {"Door", "KeyObtain", "Crucifix", "Flashlight", "Battery", "Candle", "Lighter", "BandagePack", "GoldPile", "LeverForGate", "Smoothie", "Vitamins", "Shears"}
        for _, itemName in ipairs(items) do
            guanbi(itemName)
        end
    end
})

a:Button({
    Title = "夜视",
    Desc = "好清楚",
    Callback = function()
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        Lighting.GlobalShadows = false
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.FogStart = 0
        if Lighting:FindFirstChild("Atmosphere") then
            Lighting.Atmosphere:Destroy()
        end
    end
})

d:Toggle({
    Title = "rush",
    Desc = "rush检测",
    Callback = createMonsterDetection("RushMoving", "Rush", "Rush来了快躲避")
})

d:Toggle({
    Title = "Eyes",
    Desc = "Eyes检测",
    Callback = createMonsterDetection("Eyes", "Eyes", "Eyes来了别看他")
})

d:Toggle({
    Title = "Ambush",
    Desc = "Ambush检测",
    Callback = createMonsterDetection("AmbushMoving", "Ambush", "Ambush来了快躲避")
})

d:Toggle({
    Title = "A60",
    Desc = "A60检测",
    Callback = createMonsterDetection("A60", "A60", "A60来了快躲避")
})

d:Toggle({
    Title = "A120",
    Desc = "A120检测",
    Callback = createMonsterDetection("A120", "A120", "A120来了快躲避")
})

d:Toggle({
    Title = "Screech",
    Desc = "Screech检测",
    Callback = createMonsterDetection("Screech", "Screech", "Screech来了快看看他")
})

d:Toggle({
    Title = "Seek",
    Desc = "Seek检测",
    Callback = createMonsterDetection("SeekMoving", "Seek", "Seek来了快跑")
})

c:Toggle({
    Title = "rush",
    Desc = "透视rush",
    Callback = createItemESP("RushMoving", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), "rush", "rush")
})

c:Toggle({
    Title = "Ambush",
    Desc = "透视Ambush",
    Callback = createItemESP("AmbushMoving", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), "Ambush", "ambush")
})

c:Toggle({
    Title = "A60",
    Desc = "透视A60",
    Callback = createItemESP("A60", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), "A60", "a60")
})

c:Toggle({
    Title = "A120",
    Desc = "透视A120",
    Callback = createItemESP("A120", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), "A120", "a120")
})

c:Toggle({
    Title = "FigureRig",
    Desc = "透视FigureRig",
    Callback = createItemESP("FigureRig", Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 0, 0), "FigureRig", "figurerig")
})

e:Toggle({
    Title = "钥匙",
    Desc = "提示钥匙",
    Callback = ts("KeyObtain", "钥匙")
})

e:Toggle({
    Title = "十字架",
    Desc = "提示十字架",
    Callback = ts("Crucifix", "十字架")
})

e:Toggle({
    Title = "手电筒",
    Desc = "提示手电筒",
    Callback = ts("Flashlight", "手电筒")
})

e:Toggle({
    Title = "电池",
    Desc = "提示电池",
    Callback = ts("Battery", "电池")
})

e:Toggle({
    Title = "蜡烛",
    Desc = "提示蜡烛",
    Callback = ts("Candle", "蜡烛")
})

e:Toggle({
    Title = "打火机",
    Desc = "提示打火机",
    Callback = ts("Lighter", "打火机")
})

e:Toggle({
    Title = "绷带",
    Desc = "提示绷带",
    Callback = ts("BandagePack", "绷带")
})

e:Toggle({
    Title = "金币",
    Desc = "提示金币",
    Callback = ts("GoldPile", "金币")
})

e:Toggle({
    Title = "酒",
    Desc = "提示酒",
    Callback = ts("Smoothie", "酒")
})

e:Toggle({
    Title = "维他命",
    Desc = "提示维他命",
    Callback = ts("Vitamins", "维他命")
})