print([[
 ____                       _ _       _     _ _                          
| __ )  ___  _ __ ___  __ _| (_)___  | |   (_) |__  _ __ __ _ _ __ _   _ 
|  _ \ / _ \| '__/ _ \/ _` | | / __| | |   | | '_ \| '__/ _` | '__| | | |
| |_) | (_) | | |  __/ (_| | | \__ \ | |___| | |_) | | | (_| | |  | |_| |
|____/ \___/|_|  \___|\__,_|_|_|___/ |_____|_|_.__/|_|  \__,_|_|   \__, |
                                                                   |___/ 
]])
print("Loading Borealis Library...")

-- 1. Load Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/magbux/RyusaiSH/refs/heads/main/BorealisOfficialSH"))()

-- 2. Create Window
local Window = Library.new("Tutorial Script")

-- 3. Services & Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 4. Configuration Table
local Config = {
    SpeedEnabled = false,
    Speed = 16,
    FlyEnabled = false
}

-- 5. Helper Functions
local function GetChar()
    return LocalPlayer.Character
end

local function GetHumanoid()
    local char = GetChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- 6. Main Tab
local MainTab = Window:MakeTab("Main")
local MainSection = MainTab:AddSection()

-- Button
MainSection:AddButton({
    Name = "Print Message",
    Callback = function()
        print("Button clicked!")
        print("You just pressed a button")
    end
})

-- Toggle
MainSection:AddToggle({
    Name = "Speed Boost",
    Default = false,
    Callback = function(Value)
        Config.SpeedEnabled = Value
        print("Speed toggle:", Value)
        
        -- Reset speed if disabled
        if not Value then
            local hum = GetHumanoid()
            if hum then hum.WalkSpeed = 16 end
        end
    end
})

-- Slider
MainSection:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 16,
    Callback = function(Value)
        Config.Speed = Value
        print("Speed set to:", Value)
    end
})

-- Dropdown
MainSection:AddDropdown({
    Name = "Select Option",
    Default = "Option 1",
    Items = {"Option 1", "Option 2", "Option 3"},
    Callback = function(Value)
        print("Selected:", Value)
    end
})

-- Keybind
MainSection:AddKeybind("Toggle UI", Enum.KeyCode.Insert, function()
    print("Insert pressed!")
    Window:toggle()
end)

-- 7. Tutorial Tab
local TutorialTab = Window:MakeTab("Tutorial")
local TutorialSection = TutorialTab:AddSection()

TutorialSection:AddButton({
    Name = "How Toggles Work",
    Callback = function()
        print("=== TOGGLE TUTORIAL ===")
        print("Toggles turn features ON/OFF")
        print("Value = true when ON, false when OFF")
    end
})

TutorialSection:AddButton({
    Name = "How Loops Work",
    Callback = function()
        print("=== LOOP TUTORIAL ===")
        print("Use task.spawn for background loops")
        print("while task.wait() do ... end runs forever")
    end
})

TutorialSection:AddButton({
    Name = "TEST NO. 1",
    Callback = function()
        print("=== DONT MIND ===")
        print("S")
        print("U")
        print("M")
    end
})

-- 8. Main Logic Loop
task.spawn(function()
    while task.wait() do
        local humanoid = GetHumanoid()
        if humanoid and Config.SpeedEnabled then
            -- Only apply speed if the humanoid exists and toggle is ON
            humanoid.WalkSpeed = Config.Speed
        end
    end
end)

print("Script Loaded Successfully")
