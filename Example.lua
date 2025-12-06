local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/magbux/RyusaiSH/refs/heads/main/BorealisOfficialSH"))()

local Window = Library.new("This is a Window")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local Config = {
    Spamming = false,
    Message = "Borealis on top!",
    Delay = 1
}

local MainTab = Window:MakeTab("This is a Tab")
local MainSection = MainTab:AddSection()

MainSection:AddLabel("This is a Label")

MainSection:AddButton({
    Name = "This is a Button",
    Callback = function()
        print("Button Clicked")
    end
})

MainSection:AddToggle({
    Name = "This is a Toggle",
    Default = false,
    Callback = function(Value)
        Config.Spamming = Value
    end
})

MainSection:AddSlider({
    Name = "This is a Slider",
    Min = 0,
    Max = 10,
    Default = 1,
    Callback = function(Value)
        Config.Delay = Value
    end
})

MainSection:AddTextbox({
    Name = "This is a Textbox",
    Default = "Borealis on top!",
    Placeholder = "Type here...",
    ClearOnFocusLost = false,
    Callback = function(Text)
        Config.Message = Text
    end
})

MainSection:AddDropdown({
    Name = "This is a Dropdown",
    Default = "Option 1",
    Items = {"Option 1", "Option 2", "Option 3"},
    Callback = function(Value)
        print(Value)
    end
})

local ThemeTab = Window:MakeTab("UI Theme")
local ThemeSection = ThemeTab:AddSection()

ThemeSection:AddColorPicker({
    Name = "This is a Color Picker",
    Default = Color3.fromRGB(60, 180, 255),
    Callback = function(Value)
    end
})

ThemeSection:AddKeybind("This is a Keybind", Enum.KeyCode.RightControl, function()
    Window:toggle()
end)

task.spawn(function()
    while task.wait() do
        if Config.Spamming and Config.Message ~= "" then
            if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                local generalChannel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
                if generalChannel then
                    generalChannel:SendAsync(Config.Message)
                end
            else
                ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(Config.Message, "All")
            end
            task.wait(Config.Delay)
        end
    end
end)
