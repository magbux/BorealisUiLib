-- Load Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/magbux/RyusaiSH/refs/heads/main/BorealisOfficialSH"))()
local Window = Library.new("Tutorial Script")

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Config to store values
local Config = {
    SpeedEnabled = false,
    Speed = 16,
    FlyEnabled = false
}

-- Helper functions
local function GetChar()
    return LocalPlayer.Character
end

local function GetHumanoid()
    local char = GetChar()
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- Create Main Tab
local MainTab = Window:MakeTab("Main")
local MainSection = MainTab:AddSection()

-- Button Example
MainSection:AddButton({
    Name = "Print Message",
    Callback = function()
        print("Button clicked!")
        print("You just pressed a button")
    end
})

-- Toggle Example
MainSection:AddToggle({
    Name = "Speed Boost",
    Default = false,
    Callback = function(Value)
        Config.SpeedEnabled = Value
        print("Speed toggle:", Value)
    end
})

-- Slider Example
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

-- Dropdown Example
MainSection:AddDropdown({
    Name = "Select Option",
    Default = "Option 1",
    Items = {"Option 1", "Option 2", "Option 3"},
    Callback = function(Value)
        print("Selected:", Value)
    end
})

-- Keybind Example
MainSection:AddKeybind("Toggle UI", Enum.KeyCode.Insert, function()
    print("Insert pressed!")
    Window:toggle()
end)

-- Tutorial Tab
local TutorialTab = Window:MakeTab("Tutorial")
local TutorialSection = TutorialTab:AddSection()

TutorialSection:AddButton({
    Name = "How Toggles Work",
    Callback = function()
        print("=== TOGGLE TUTORIAL ===")
        print("Toggles turn features ON/OFF")
        print("Value = true when ON, false when OFF")
        print("Use: if Config.SpeedEnabled then ... end")
    end
})

TutorialSection:AddButton({
    Name = "How Loops Work",
    Callback = function()
        print("=== LOOP TUTORIAL ===")
        print("Use task.spawn for background loops")
        print("while task.wait() do ... end runs forever")
        print("Check Config values inside loops")
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

-- Main Loop (applies the configs)
task.spawn(function()
    while task.wait() do
        local humanoid = GetHumanoid()
        if humanoid and Config.SpeedEnabled then
            humanoid.WalkSpeed = Config.Speed
        end
    end
end)

print("SUM")
print("SUM")
