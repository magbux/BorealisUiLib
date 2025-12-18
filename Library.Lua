local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function GetSafeGuiParent()
	local success, result = pcall(function() return CoreGui end)
	if success then
		return result
	else
		return LocalPlayer:WaitForChild("PlayerGui")
	end
end

local GuiParent = GetSafeGuiParent()

local Borealis = {}
local UIConfig = { Keybind = Enum.KeyCode.RightControl }

local TweenInfo_Hover = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TweenInfo_Click = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TweenInfo_Tab = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local TweenInfo_Line = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TweenInfo_Collapse = TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)

local Theme = {
	Background = Color3.fromRGB(24, 24, 24),
	Glow = Color3.fromRGB(0, 0, 0),
	Accent = Color3.fromRGB(60, 180, 255),
	LightContrast = Color3.fromRGB(30, 30, 30),
	DarkContrast = Color3.fromRGB(20, 20, 20),
	TextColor = Color3.fromRGB(255, 255, 255)
}

if GuiParent:FindFirstChild("BorealisUI") then
	GuiParent.BorealisUI:Destroy()
end

local function Create(class, properties)
	local instance = Instance.new(class)
	for k, v in pairs(properties) do
		instance[k] = v
	end
	return instance
end

local function AddRipple(Button)
	Button.ClipsDescendants = true
	Button.MouseButton1Down:Connect(function(Input)
		task.spawn(function()
			local Ripple = Instance.new("ImageLabel")
			Ripple.Name = "Ripple"
			Ripple.Parent = Button
			Ripple.BackgroundTransparency = 1
			Ripple.BorderSizePixel = 0
			Ripple.Image = "rbxassetid://2708891598"
			Ripple.ImageColor3 = Color3.fromRGB(255, 255, 255)
			Ripple.ImageTransparency = 0.8
			Ripple.ZIndex = 9

			local X = Input.Position.X - Button.AbsolutePosition.X
			local Y = Input.Position.Y - Button.AbsolutePosition.Y
			Ripple.Position = UDim2.new(0, X, 0, Y)
			Ripple.Size = UDim2.new(0, 0, 0, 0)

			local SizeAnim = TweenService:Create(Ripple, TweenInfo.new(0.4), {Size = UDim2.new(0, 500, 0, 500), Position = UDim2.new(0, X - 250, 0, Y - 250)})
			local FadeAnim = TweenService:Create(Ripple, TweenInfo.new(0.4), {ImageTransparency = 1})

			SizeAnim:Play()
			FadeAnim:Play()

			task.wait(0.4)
			Ripple:Destroy()
		end)
	end)
end

local function MakeDraggable(topbar, object)
	local dragging, dragInput, dragStart, startPos
	topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true; dragStart = input.Position; startPos = object.Position
		end
	end)
	topbar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
end

function Borealis.new(title)
	local Library = {}
	local ThemeObjects = {}

	function Library:UpdateTheme(NewColor)
		Theme.Accent = NewColor
		for _, UpdateFunc in pairs(ThemeObjects) do
			UpdateFunc(NewColor)
		end
	end

	local ScreenGui = Create("ScreenGui", {
		Name = "BorealisUI",
		Parent = GuiParent,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	})

	local Main = Create("Frame", {
		Name = "Main",
		Parent = ScreenGui,
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, -275, 0.5, -175),
		Size = UDim2.new(0, 550, 0, 350),
		ClipsDescendants = true
	})
	
	Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 6)})

	local TopBar = Create("Frame", {
		Name = "TopBar",
		Parent = Main,
		BackgroundColor3 = Theme.LightContrast,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 40)
	})
	
	Create("UICorner", {Parent = TopBar, CornerRadius = UDim.new(0, 6)})
	
	local TopBarCover = Create("Frame", {
		Parent = TopBar,
		BackgroundColor3 = Theme.LightContrast,
		BorderSizePixel = 0,
		Position = UDim2.new(0,0,1,-5),
		Size = UDim2.new(1,0,0,5)
	})

	local TitleLabel = Create("TextLabel", {
		Parent = TopBar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 15, 0, 0),
		Size = UDim2.new(0, 200, 1, 0),
		Font = Enum.Font.GothamBold,
		Text = title,
		TextColor3 = Theme.TextColor,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 2
	})

	local SearchBtn = Create("ImageButton", {
		Parent = TopBar,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -62, 0, 10), 
		Size = UDim2.new(0, 20, 0, 20),      
		Image = "rbxassetid://6031154871",   
		ImageColor3 = Color3.fromRGB(150, 150, 150),
		ZIndex = 2
	})

	local SearchBar = Create("TextBox", {
		Parent = TopBar,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 15, 0, 0),
		Size = UDim2.new(1, -100, 1, 0),
		Font = Enum.Font.GothamBold,
		Text = "",
		TextColor3 = Theme.TextColor,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Left,
		PlaceholderText = "Search...",
		PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
		Visible = false,
		ZIndex = 2,
		ClearTextOnFocus = false
	})

	local CloseBtn = Create("TextButton", {
		Parent = TopBar,
		BackgroundTransparency = 1,
		Position = UDim2.new(1, -35, 0, 5),
		Size = UDim2.new(0, 30, 0, 30),
		Font = Enum.Font.GothamBold,
		Text = "X",
		TextColor3 = Color3.fromRGB(150, 150, 150),
		TextSize = 16,
		ZIndex = 2
	})

	function Library:Unload()
		local closeTween = TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1
		})
		closeTween:Play()

		for _, v in pairs(Main:GetDescendants()) do
			if v:IsA("GuiObject") then
				TweenService:Create(v, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
			end
			if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
				TweenService:Create(v, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
			end
		end

		closeTween.Completed:Wait()
		ScreenGui:Destroy()
	end

	function Library:toggle()
		if Main.Visible then
			local tween = TweenService:Create(Main, TweenInfo.new(0.2), {Size = UDim2.new(0, 550, 0, 0)})
			tween:Play()
			tween.Completed:Wait()
			Main.Visible = false
			Main.ClipsDescendants = true
		else
			Main.Visible = true
			TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 550, 0, 350)}):Play()
		end
	end

	CloseBtn.MouseButton1Click:Connect(function()
		Library:Unload()
	end)

	local Dragging, DragInput, DragStart, StartPos
	TopBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Dragging = true
			DragStart = input.Position
			StartPos = Main.Position
		end
	end)
	TopBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then DragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			local delta = input.Position - DragStart
			TweenService:Create(Main, TweenInfo.new(0.05), {
				Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
			}):Play()
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
	end)

	local Sidebar = Create("Frame", {
		Name = "Sidebar",
		Parent = Main,
		BackgroundColor3 = Theme.LightContrast,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 40),
		Size = UDim2.new(0, 130, 1, -40)
	})
	
	Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 6)})
	local SidebarCover = Create("Frame", {
		Parent = Sidebar,
		BackgroundColor3 = Theme.LightContrast,
		BorderSizePixel = 0,
		Position = UDim2.new(0,0,0,0),
		Size = UDim2.new(1,0,0,10)
	})

	local TabContainer = Create("ScrollingFrame", {
		Parent = Sidebar,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, -10),
		Position = UDim2.new(0, 0, 0, 10),
		ScrollBarThickness = 0,
		ScrollingEnabled = false
	})

	local TabLayout = Create("UIListLayout", {
		Parent = TabContainer,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5)
	})

	local Pages = Create("Frame", {
		Name = "Pages",
		Parent = Main,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 140, 0, 50),
		Size = UDim2.new(1, -150, 1, -60),
		ClipsDescendants = true 
	})

	UserInputService.InputBegan:Connect(function(input, gp)
		if not gp and input.KeyCode == UIConfig.Keybind then
			Library:toggle()
		end
	end)

	local Tabs = {}
	local First = true
	local CurrentTab = nil

	function Library:MakeTab(name, icon)
		local TabBtn = Create("TextButton", {
			Parent = TabContainer,
			BackgroundColor3 = Theme.LightContrast,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 30),
			Font = Enum.Font.GothamMedium,
			Text = "           " .. name, 
			TextColor3 = Color3.fromRGB(150, 150, 150),
			TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutoButtonColor = false
		})

		if icon then
			local IconImg = Create("ImageLabel", {
				Parent = TabBtn,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0.5, -8),
				Size = UDim2.new(0, 16, 0, 16),
				Image = icon,
				ImageColor3 = Color3.fromRGB(150, 150, 150)
			})
			
			TabBtn.MouseEnter:Connect(function()
				if CurrentTab and CurrentTab.Name ~= name .. "Page" then
					TweenService:Create(IconImg, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(200,200,200)}):Play()
				end
			end)
			
			TabBtn.MouseLeave:Connect(function()
				if CurrentTab and CurrentTab.Name ~= name .. "Page" then
					TweenService:Create(IconImg, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150,150,150)}):Play()
				end
			end)
			
			table.insert(ThemeObjects, function(c)
				if CurrentTab and CurrentTab.Name == name .. "Page" then
					IconImg.ImageColor3 = c
				end
			end)
		else
			TabBtn.Text = "   " .. name
		end

		local Indicator = Create("Frame", {
			Parent = TabBtn,
			BackgroundColor3 = Theme.Accent,
			BorderSizePixel = 0,
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(0, 3, 0, 0),
			Visible = true
		})
		table.insert(ThemeObjects, function(c) Indicator.BackgroundColor3 = c end)

		local Page = Create("ScrollingFrame", {
			Name = name .. "Page",
			Parent = Pages,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ScrollBarThickness = 0,
			ScrollBarImageColor3 = Theme.Accent,
			Visible = false,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ClipsDescendants = false
		})

		Create("UIPadding", {
			Parent = Page,
			PaddingTop = UDim.new(0, 0),
			PaddingLeft = UDim.new(0, 0),
			PaddingRight = UDim.new(0, 10),
			PaddingBottom = UDim.new(0, 10)
		})

		local PageLayout = Create("UIListLayout", {
			Parent = Page,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 8)
		})

		PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Page.CanvasSize = UDim2.new(0, 0, 0, PageLayout.AbsoluteContentSize.Y + 24)
		end)

		TabBtn.MouseButton1Click:Connect(function()
			if CurrentTab == Page then return end
			
			if SearchBar.Visible then
				SearchBar.Text = ""
			end

			for _, t in pairs(Tabs) do
				if t.Page.Visible then
					TweenService:Create(t.Btn, TweenInfo_Hover, {TextColor3 = Color3.fromRGB(150, 150, 150)}):Play()
					if t.Btn:FindFirstChild("ImageLabel") then
						TweenService:Create(t.Btn.ImageLabel, TweenInfo_Hover, {ImageColor3 = Color3.fromRGB(150,150,150)}):Play()
					end
					TweenService:Create(t.Ind, TweenInfo_Line, {Size = UDim2.new(0, 3, 0, 0)}):Play()
					t.Page.Visible = false
				end
			end

			CurrentTab = Page
			Page.Visible = true

			TweenService:Create(Indicator, TweenInfo_Line, {Size = UDim2.new(0, 3, 1, 0)}):Play()

			Page.Position = UDim2.new(0, 0, 0, 15)
			for _, child in pairs(Page:GetChildren()) do
				if child:IsA("GuiObject") then child.BackgroundTransparency = 1 end
				if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then child.TextTransparency = 1 end
			end

			TweenService:Create(Page, TweenInfo_Tab, {Position = UDim2.new(0,0,0,0)}):Play()
			TweenService:Create(TabBtn, TweenInfo_Hover, {TextColor3 = Theme.TextColor}):Play()
			if TabBtn:FindFirstChild("ImageLabel") then
				TweenService:Create(TabBtn.ImageLabel, TweenInfo_Hover, {ImageColor3 = Theme.Accent}):Play()
			end

			for _, child in pairs(Page:GetDescendants()) do
				if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
					TweenService:Create(child, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
				elseif child:IsA("Frame") and child.Name ~= "Shadow" then
					local targetTransparency = 0
					if child.Name == "Ripple" then targetTransparency = 1 end
					if child.BackgroundColor3 == Theme.LightContrast or child.BackgroundColor3 == Theme.DarkContrast or child.BackgroundColor3 == Theme.Accent then
						TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = targetTransparency}):Play()
					end
					child.Visible = true
				end
				if child:IsA("GuiObject") and child:FindFirstChild("UICorner") then
					TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
				end
			end
		end)

		if First then
			First = false
			CurrentTab = Page
			Page.Visible = true
			TabBtn.TextColor3 = Theme.TextColor
			if TabBtn:FindFirstChild("ImageLabel") then
				TabBtn.ImageLabel.ImageColor3 = Theme.Accent
			end
			Indicator.Size = UDim2.new(0, 3, 1, 0)
		end

		table.insert(Tabs, {Btn = TabBtn, Page = Page, Ind = Indicator})

		local TabFunctions = {}

		function TabFunctions:AddSection(sectionName)
			local SectionFrame = Create("Frame", {
				Parent = Page,
				BackgroundColor3 = Color3.fromRGB(24,24,24),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 0),
				ClipsDescendants = true
			})
			
			local Header = Create("Frame", {
				Parent = SectionFrame,
				BackgroundColor3 = Theme.LightContrast,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 30)
			})
			Create("UICorner", {Parent = Header, CornerRadius = UDim.new(0, 4)})
			
			local HeaderText = Create("TextLabel", {
				Parent = Header,
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 10, 0, 0),
				Size = UDim2.new(1, -40, 1, 0),
				Font = Enum.Font.GothamBold,
				Text = sectionName,
				TextColor3 = Theme.TextColor,
				TextSize = 13,
				TextXAlignment = Enum.TextXAlignment.Left
			})
			
			local CollapseBtn = Create("ImageButton", {
				Parent = Header,
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -25, 0, 5),
				Size = UDim2.new(0, 20, 0, 20),
				Image = "rbxassetid://6031091004",
				ImageColor3 = Color3.fromRGB(150, 150, 150),
				Rotation = 180
			})
			
			local Container = Create("Frame", {
				Parent = SectionFrame,
				BackgroundColor3 = Color3.fromRGB(0,0,0),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 0, 30), -- FIXED: Changed from 35 to 30 to remove the line
				Size = UDim2.new(1, 0, 0, 0),
				ClipsDescendants = false 
			})
			
			local ContainerLayout = Create("UIListLayout", {
				Parent = Container,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 8)
			})
			
			local Collapsed = false
			local function UpdateSize()
				if Collapsed then
					TweenService:Create(SectionFrame, TweenInfo_Collapse, {Size = UDim2.new(1, 0, 0, 30)}):Play()
					TweenService:Create(CollapseBtn, TweenInfo_Collapse, {Rotation = 0}):Play()
				else
					local contentHeight = ContainerLayout.AbsoluteContentSize.Y
					TweenService:Create(SectionFrame, TweenInfo_Collapse, {Size = UDim2.new(1, 0, 0, contentHeight + 40)}):Play()
					TweenService:Create(CollapseBtn, TweenInfo_Collapse, {Rotation = 180}):Play()
				end
			end
			
			ContainerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if not Collapsed then
					SectionFrame.Size = UDim2.new(1, 0, 0, ContainerLayout.AbsoluteContentSize.Y + 40)
				end
			end)
			
			CollapseBtn.MouseButton1Click:Connect(function()
				Collapsed = not Collapsed
				UpdateSize()
			end)
			
			Header.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					Collapsed = not Collapsed
					UpdateSize()
				end
			end)

			local Section = {}

			function Section:AddLabel(text)
				local LabelBox = Create("Frame", {
					Parent = Container,
					BackgroundColor3 = Theme.LightContrast,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 30)
				})
				Create("UICorner", {Parent = LabelBox, CornerRadius = UDim.new(0, 4)})
	
				Create("TextLabel", {
					Parent = LabelBox,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 10, 0, 0),
					Size = UDim2.new(1, -20, 1, 0),
					Font = Enum.Font.GothamBold,
					Text = text,
					TextColor3 = Theme.TextColor,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left
				})
			end

			function Section:AddTextbox(props)
				local TextboxFrame = Create("Frame", {
					Parent = Container,
					BackgroundColor3 = Theme.LightContrast,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 36)
				})
				Create("UICorner", {Parent = TextboxFrame, CornerRadius = UDim.new(0, 4)})
		
				Create("TextLabel", {
					Parent = TextboxFrame,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 10, 0, 0),
					Size = UDim2.new(1, -160, 1, 0),
					Font = Enum.Font.Gotham,
					Text = props.Name,
					TextColor3 = Theme.TextColor,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left
				})
		
				local InputBox = Create("TextBox", {
					Parent = TextboxFrame,
					BackgroundColor3 = Theme.DarkContrast,
					BorderSizePixel = 0,
					Position = UDim2.new(1, -150, 0.5, -12),
					Size = UDim2.new(0, 140, 0, 24),
					Font = Enum.Font.Gotham,
					Text = props.Default or "",
					TextColor3 = Color3.fromRGB(200, 200, 200),
					TextSize = 12,
					PlaceholderText = props.Placeholder or "Type here...",
					ClearTextOnFocus = false
				})
				Create("UICorner", {Parent = InputBox, CornerRadius = UDim.new(0, 4)})
		
				InputBox.Focused:Connect(function()
					TweenService:Create(InputBox, TweenInfo.new(0.2), {TextColor3 = Theme.Accent}):Play()
				end)
		
				InputBox.FocusLost:Connect(function(enterPressed)
					TweenService:Create(InputBox, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
					if props.Callback then
						props.Callback(InputBox.Text)
					end
					if props.ClearOnFocusLost then
						InputBox.Text = ""
					end
				end)
				table.insert(ThemeObjects, function(c) if InputBox:IsFocused() then InputBox.TextColor3 = c end end)
			end

			function Section:AddToggle(props)
				local ToggleBox = Create("Frame", {
					Parent = Container,
					BackgroundColor3 = Theme.LightContrast,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 36)
				})
				Create("UICorner", {Parent = ToggleBox, CornerRadius = UDim.new(0, 4)})

				Create("TextLabel", {
					Parent = ToggleBox,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 10, 0, 0),
					Size = UDim2.new(1, -50, 1, 0),
					Font = Enum.Font.Gotham,
					Text = props.Name,
					TextColor3 = Theme.TextColor,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left
				})

				local Checkbox = Create("TextButton", {
					Parent = ToggleBox,
					BackgroundColor3 = Theme.DarkContrast,
					BorderSizePixel = 0,
					Position = UDim2.new(1, -30, 0.5, -10),
					Size = UDim2.new(0, 20, 0, 20),
					Text = "",
					AutoButtonColor = false
				})
				Create("UICorner", {Parent = Checkbox, CornerRadius = UDim.new(0, 4)})

				AddRipple(Checkbox)

				local State = props.Default or false
				local function Update()
					TweenService:Create(Checkbox, TweenInfo_Hover, {BackgroundColor3 = State and Theme.Accent or Theme.DarkContrast}):Play()
				end
				Update()
				table.insert(ThemeObjects, function(c)
					if State then
						Checkbox.BackgroundColor3 = c
					end
				end)

				Checkbox.MouseButton1Click:Connect(function()
					State = not State
					Update()
					if props.Callback then props.Callback(State) end
				end)
			end

			function Section:AddButton(props)
				local Button = Create("TextButton", {
					Parent = Container,
					BackgroundColor3 = Theme.LightContrast,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 36),
					Font = Enum.Font.Gotham,
					Text = props.Name,
					TextColor3 = Theme.TextColor,
					TextSize = 13,
					AutoButtonColor = false,
					TextXAlignment = (props.Icon and Enum.TextXAlignment.Left or Enum.TextXAlignment.Center)
				})
				Create("UICorner", {Parent = Button, CornerRadius = UDim.new(0, 4)})
				
				if props.Icon then
					Button.Text = "       " .. props.Name
					local BIcon = Create("ImageLabel", {
						Parent = Button,
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 10, 0.5, -8),
						Size = UDim2.new(0, 16, 0, 16),
						Image = props.Icon,
						ImageColor3 = Theme.TextColor
					})
				end

				AddRipple(Button)

				Button.MouseEnter:Connect(function()
					TweenService:Create(Button, TweenInfo_Hover, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
				end)
				Button.MouseLeave:Connect(function()
					TweenService:Create(Button, TweenInfo_Hover, {BackgroundColor3 = Theme.LightContrast}):Play()
				end)

				Button.MouseButton1Click:Connect(function()
					if props.Callback then props.Callback() end
				end)
			end

			function Section:AddSlider(props)
				local SliderBox = Create("Frame", {
					Parent = Container,
					BackgroundColor3 = Theme.LightContrast,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 50)
				})
				Create("UICorner", {Parent = SliderBox, CornerRadius = UDim.new(0, 4)})

				Create("TextLabel", {
					Parent = SliderBox,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 10, 0, 5),
					Size = UDim2.new(1, -20, 0, 20),
					Font = Enum.Font.Gotham,
					Text = props.Name,
					TextColor3 = Theme.TextColor,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left
				})

				local ValueText = Create("TextLabel", {
					Parent = SliderBox,
					BackgroundTransparency = 1,
					Position = UDim2.new(1, -60, 0, 5),
					Size = UDim2.new(0, 50, 0, 20),
					Font = Enum.Font.GothamBold,
					Text = tostring(props.Default or props.Min),
					TextColor3 = Theme.TextColor,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Right
				})

				local SlideTrack = Create("TextButton", {
					Parent = SliderBox,
					BackgroundColor3 = Theme.DarkContrast,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 10, 0, 32),
					Size = UDim2.new(1, -20, 0, 4),
					Text = "",
					AutoButtonColor = false
				})
				Create("UICorner", {Parent = SlideTrack, CornerRadius = UDim.new(0, 2)})

				local Fill = Create("Frame", {
					Parent = SlideTrack,
					BackgroundColor3 = Theme.Accent,
					BorderSizePixel = 0,
					Size = UDim2.new(0, 0, 1, 0)
				})
				Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(0, 2)})
				table.insert(ThemeObjects, function(c) Fill.BackgroundColor3 = c end)

				local min, max, def = props.Min or 0, props.Max or 100, props.Default or 0
				Fill.Size = UDim2.new((def - min)/(max - min), 0, 1, 0)

				local Dragging = false

				local function Update(input)
					local pos = math.clamp((input.Position.X - SlideTrack.AbsolutePosition.X) / SlideTrack.AbsoluteSize.X, 0, 1)
					local val = math.floor(min + (max - min) * pos)

					TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(pos, 0, 1, 0)}):Play()
					ValueText.Text = tostring(val)
					if props.Callback then props.Callback(val) end
				end

				SlideTrack.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Dragging = true
						Update(input)
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						Update(input)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
				end)
			end

			function Section:AddDropdown(props)
				local Dropdown = Create("Frame", {
					Parent = Container,
					BackgroundColor3 = Theme.LightContrast,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 36),
					ClipsDescendants = true
				})
				Create("UICorner", {Parent = Dropdown, CornerRadius = UDim.new(0, 4)})

				local Text = Create("TextLabel", {
					Parent = Dropdown,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 10, 0, 0),
					Size = UDim2.new(1, -40, 0, 36),
					Font = Enum.Font.Gotham,
					Text = props.Name .. ": " .. (props.Default or "None"),
					TextColor3 = Theme.TextColor,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left
				})

				local OpenBtn = Create("TextButton", {
					Parent = Dropdown,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 36),
					Text = "",
					ZIndex = 2
				})
				AddRipple(OpenBtn)

				local Arrow = Create("TextLabel", {
					Parent = Dropdown,
					BackgroundTransparency = 1,
					Position = UDim2.new(1, -30, 0, 0),
					Size = UDim2.new(0, 30, 0, 36),
					Font = Enum.Font.GothamBold,
					Text = "V",
					TextColor3 = Color3.fromRGB(150, 150, 150),
					TextSize = 12
				})

				local ItemHolder = Create("ScrollingFrame", {
					Parent = Dropdown,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0, 36),
					Size = UDim2.new(1, 0, 0, 100),
					CanvasSize = UDim2.new(0,0,0,0),
					ScrollBarThickness = 0,
					ScrollBarImageColor3 = Theme.Accent
				})
				table.insert(ThemeObjects, function(c) ItemHolder.ScrollBarImageColor3 = c end)

				local ItemLayout = Create("UIListLayout", {
					Parent = ItemHolder,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 4) 
				})

				ItemLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					ItemHolder.CanvasSize = UDim2.new(0,0,0, ItemLayout.AbsoluteContentSize.Y)
				end)

				local Open = false

				OpenBtn.MouseButton1Click:Connect(function()
					Open = not Open
					if Open then
						TweenService:Create(Dropdown, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 136)}):Play()
						TweenService:Create(Arrow, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Rotation = 180}):Play()
					else
						TweenService:Create(Dropdown, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 36)}):Play()
						TweenService:Create(Arrow, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Rotation = 0}):Play()
					end
				end)

				for _, item in pairs(props.Items or {}) do
					local ItemBtn = Create("TextButton", {
						Parent = ItemHolder,
						BackgroundColor3 = Theme.DarkContrast,
						BorderSizePixel = 0,
						Size = UDim2.new(1, -4, 0, 24),
						Font = Enum.Font.Gotham,
						Text = item,
						TextColor3 = Color3.fromRGB(200, 200, 200),
						TextSize = 12,
						AutoButtonColor = false
					})
					Create("UICorner", {Parent = ItemBtn, CornerRadius = UDim.new(0, 4)})

					ItemBtn.MouseEnter:Connect(function()
						TweenService:Create(ItemBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent, TextColor3 = Color3.new(1,1,1)}):Play()
					end)
					ItemBtn.MouseLeave:Connect(function()
						TweenService:Create(ItemBtn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.DarkContrast, TextColor3 = Color3.fromRGB(200,200,200)}):Play()
					end)

					ItemBtn.MouseButton1Click:Connect(function()
						Open = false
						Text.Text = props.Name .. ": " .. item
						TweenService:Create(Dropdown, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(1, 0, 0, 36)}):Play()
						TweenService:Create(Arrow, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Rotation = 0}):Play()
						if props.Callback then props.Callback(item) end
					end)
				end
			end

			function Section:AddColorPicker(props)
				local Box = Create("Frame", {
					Parent = Container,
					BackgroundColor3 = Theme.LightContrast,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 36)
				})
				Create("UICorner", {Parent = Box, CornerRadius = UDim.new(0, 4)})

				local Text = Create("TextLabel", {
					Parent = Box,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 10, 0, 0),
					Size = UDim2.new(1, -60, 0, 36),
					Font = Enum.Font.Gotham,
					Text = props.Name,
					TextColor3 = Theme.TextColor,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left
				})

				local CurrentColorFrame = Create("Frame", {
					Parent = Box,
					BackgroundColor3 = props.Default or Theme.Accent,
					BorderSizePixel = 0,
					Position = UDim2.new(1, -45, 0, 8),
					Size = UDim2.new(0, 35, 0, 20)
				})
				Create("UICorner", {Parent = CurrentColorFrame, CornerRadius = UDim.new(0, 4)})
				
				local TriggerBtn = Create("TextButton", {
					Parent = Box,
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 0, 36),
					Text = ""
				})
				AddRipple(TriggerBtn)

				local ColorH, ColorS, ColorV = 1, 1, 1
				if props.Default then
					ColorH, ColorS, ColorV = Color3.toHSV(props.Default)
				end

				TriggerBtn.MouseButton1Click:Connect(function()
					if ScreenGui:FindFirstChild("ColorPickerWindow") then
						ScreenGui.ColorPickerWindow:Destroy()
						return
					end

					local PickerWindow = Create("Frame", {
						Name = "ColorPickerWindow",
						Parent = ScreenGui,
						BackgroundColor3 = Theme.LightContrast,
						BorderSizePixel = 0,
						Size = UDim2.new(0, 200, 0, 230),
						Position = UDim2.new(0, Mouse.X + 10, 0, Mouse.Y),
						ZIndex = 10
					})
					Create("UICorner", {Parent = PickerWindow, CornerRadius = UDim.new(0, 6)})
					MakeDraggable(PickerWindow, PickerWindow)

					local PickerHeader = Create("Frame", {
						Parent = PickerWindow,
						BackgroundColor3 = Theme.DarkContrast,
						Size = UDim2.new(1,0,0,25)
					})
					Create("UICorner", {Parent = PickerHeader, CornerRadius = UDim.new(0,6)})
					
					Create("TextLabel", {
						Parent = PickerHeader,
						BackgroundTransparency = 1,
						Size = UDim2.new(1,0,1,0),
						Text = props.Name,
						Font = Enum.Font.GothamBold,
						TextColor3 = Theme.TextColor,
						TextSize = 12
					})

					local SaturationMap = Create("ImageLabel", {
						Parent = PickerWindow,
						BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 10, 0, 35),
						Size = UDim2.new(0, 150, 0, 150),
						Image = "rbxassetid://4155801252"
					})
					
					local SatCursor = Create("ImageLabel", {
						Parent = SaturationMap,
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 10, 0, 10),
						Image = "rbxassetid://4805639000",
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(ColorS, 0, 1-ColorV, 0)
					})

					local HueMap = Create("ImageLabel", {
						Parent = PickerWindow,
						BackgroundColor3 = Color3.new(1,1,1),
						BorderSizePixel = 0,
						Position = UDim2.new(0, 170, 0, 35),
						Size = UDim2.new(0, 20, 0, 150),
						Image = "rbxassetid://3570695787"
					})
					
					local HueCursor = Create("Frame", {
						Parent = HueMap,
						BackgroundColor3 = Color3.new(1,1,1),
						BorderColor3 = Color3.new(0,0,0),
						Size = UDim2.new(1, 0, 0, 2),
						AnchorPoint = Vector2.new(0, 0.5),
						Position = UDim2.new(0, 0, 1-ColorH, 0)
					})

					local function UpdateColor()
						local newColor = Color3.fromHSV(ColorH, ColorS, ColorV)
						CurrentColorFrame.BackgroundColor3 = newColor
						SaturationMap.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
						if props.Callback then props.Callback(newColor) end
						Library:UpdateTheme(newColor)
					end

					local draggingSat, draggingHue = false, false

					SaturationMap.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingSat = true end
					end)
					
					HueMap.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then draggingHue = true end
					end)

					UserInputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then 
							draggingSat = false
							draggingHue = false
						end
					end)

					RunService.RenderStepped:Connect(function()
						if not PickerWindow.Parent then return end
						
						if draggingSat then
							local mouseX = math.clamp(Mouse.X - SaturationMap.AbsolutePosition.X, 0, 150)
							local mouseY = math.clamp(Mouse.Y - SaturationMap.AbsolutePosition.Y, 0, 150)
							SatCursor.Position = UDim2.new(0, mouseX, 0, mouseY)
							ColorS = mouseX / 150
							ColorV = 1 - (mouseY / 150)
							UpdateColor()
						end
						
						if draggingHue then
							local mouseY = math.clamp(Mouse.Y - HueMap.AbsolutePosition.Y, 0, 150)
							HueCursor.Position = UDim2.new(0, 0, 0, mouseY)
							ColorH = 1 - (mouseY / 150)
							UpdateColor()
						end
					end)
					
					local ClosePick = Create("TextButton", {
						Parent = PickerWindow,
						BackgroundColor3 = Theme.DarkContrast,
						Position = UDim2.new(0, 10, 1, -30),
						Size = UDim2.new(1, -20, 0, 20),
						Font = Enum.Font.GothamBold,
						Text = "Close",
						TextColor3 = Theme.TextColor,
						TextSize = 12
					})
					Create("UICorner", {Parent = ClosePick, CornerRadius = UDim.new(0,4)})
					ClosePick.MouseButton1Click:Connect(function() PickerWindow:Destroy() end)
				end)
			end

			function Section:AddKeybind(name, defaultKey, onActivate)
				local BindFrame = Create("Frame", {
					Parent = Container,
					BackgroundColor3 = Theme.LightContrast,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, 36)
				})
				Create("UICorner", {Parent = BindFrame, CornerRadius = UDim.new(0, 4)})

				Create("TextLabel", {
					Parent = BindFrame,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 10, 0, 0),
					Size = UDim2.new(1, -80, 1, 0),
					Font = Enum.Font.Gotham,
					Text = name,
					TextColor3 = Theme.TextColor,
					TextSize = 13,
					TextXAlignment = Enum.TextXAlignment.Left
				})

				local BindBtn = Create("TextButton", {
					Parent = BindFrame,
					BackgroundColor3 = Theme.DarkContrast,
					BorderSizePixel = 0,
					Position = UDim2.new(1, -80, 0.5, -12),
					Size = UDim2.new(0, 70, 0, 24),
					Font = Enum.Font.GothamBold,
					Text = (defaultKey and defaultKey.Name) or "None",
					TextColor3 = Color3.fromRGB(200, 200, 200),
					TextSize = 12,
					AutoButtonColor = false
				})
				Create("UICorner", {Parent = BindBtn, CornerRadius = UDim.new(0, 4)})
				AddRipple(BindBtn)

				local currentKey = defaultKey
				local listening = false

				BindBtn.MouseButton1Click:Connect(function()
					if listening then return end
					listening = true
					BindBtn.Text = "..."
					TweenService:Create(BindBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Accent}):Play()

					local conn
					conn = UserInputService.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Keyboard then
							currentKey = input.KeyCode
							BindBtn.Text = currentKey.Name
							TweenService:Create(BindBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
							listening = false
							conn:Disconnect()
						end
					end)
				end)

				UserInputService.InputBegan:Connect(function(input, gp)
					if not gp and input.KeyCode == currentKey then
						if onActivate then onActivate() end
					end
				end)
			end
			
			return Section
		end
		
		return TabFunctions
	end

	local SearchOpen = false
	SearchBtn.MouseButton1Click:Connect(function()
		SearchOpen = not SearchOpen
		if SearchOpen then
			TitleLabel.Visible = false
			SearchBar.Visible = true
			SearchBar:CaptureFocus()
			TweenService:Create(SearchBtn, TweenInfo.new(0.2), {ImageColor3 = Theme.TextColor}):Play()
		else
			TitleLabel.Visible = true
			SearchBar.Visible = false
			SearchBar.Text = ""
			TweenService:Create(SearchBtn, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(150, 150, 150)}):Play()
			
			if CurrentTab then
				for _, v in pairs(CurrentTab:GetChildren()) do
					if v:IsA("Frame") then v.Visible = true end
				end
			end
		end
	end)

	SearchBar:GetPropertyChangedSignal("Text"):Connect(function()
		local input = SearchBar.Text:lower()
		if CurrentTab then
			for _, v in pairs(CurrentTab:GetDescendants()) do
				if v:IsA("TextLabel") and v.Parent.Parent.Name ~= "SectionHeader" then 
					if string.find(v.Text:lower(), input) then
						v.Parent.Visible = true
					else
						v.Parent.Visible = false
					end
				end
			end
		end
	end)

	return Library
end

return Borealis
