local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local EyeUI = {}
EyeUI.__index = EyeUI

local function CreateTween(object, properties, duration, easingStyle, easingDirection)
    duration = duration or 0.3
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tweenInfo = TweenInfo.new(duration, easingStyle, easingDirection)
    return TweenService:Create(object, tweenInfo, properties)
end

local function CreateElement(className, properties, parent)
    local element = Instance.new(className)
    for property, value in pairs(properties or {}) do
        element[property] = value
    end
    if parent then
        element.Parent = parent
    end
    return element
end

local function AnimateIn(element, delay)
    delay = delay or 0
    element.Transparency = 1
    element.Size = UDim2.new(0, 0, 0, 0)
    
    wait(delay)
    
    local sizeTween = CreateTween(element, {
        Size = element.Size,
        Transparency = 0
    }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    sizeTween:Play()
end

local function CreateKeySystem(config, onSuccess)
    local KeySystemGui = CreateElement("ScreenGui", {
        Name = "EyeUI_KeySystem",
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true
    }, PlayerGui)
    
    local Background = CreateElement("Frame", {
        Name = "Background",
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0
    }, KeySystemGui)
    
    local MainFrame = CreateElement("Frame", {
        Name = "MainFrame",
        Size = UDim2.new(0, 450, 0, 300),
        Position = UDim2.new(0.5, -225, 0.5, -150),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0
    }, Background)
    
    local MainCorner = CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 12)
    }, MainFrame)
    
    local TitleLabel = CreateElement("TextLabel", {
        Name = "Title",
        Size = UDim2.new(1, -40, 0, 50),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundTransparency = 1,
        Text = config.Title or "Key System",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 24,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, MainFrame)
    
    local SubtitleLabel = CreateElement("TextLabel", {
        Name = "Subtitle",
        Size = UDim2.new(1, -40, 0, 30),
        Position = UDim2.new(0, 20, 0, 60),
        BackgroundTransparency = 1,
        Text = "Enter your key to continue",
        TextColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    }, MainFrame)
    
    local KeyInput = CreateElement("TextBox", {
        Name = "KeyInput",
        Size = UDim2.new(1, -40, 0, 40),
        Position = UDim2.new(0, 20, 0, 120),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        Text = "",
        PlaceholderText = "Enter your key...",
        PlaceholderColor3 = Color3.fromRGB(100, 100, 100),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    }, MainFrame)
    
    local InputCorner = CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, KeyInput)
    
    local InputPadding = CreateElement("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12)
    }, KeyInput)
    
    local SubmitButton = CreateElement("TextButton", {
        Name = "Submit",
        Size = UDim2.new(0.48, -10, 0, 40),
        Position = UDim2.new(0, 20, 0, 180),
        BackgroundColor3 = Color3.fromRGB(70, 130, 255),
        BorderSizePixel = 0,
        Text = "Submit",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold
    }, MainFrame)
    
    local SubmitCorner = CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, SubmitButton)
    
    local GetKeyButton = CreateElement("TextButton", {
        Name = "GetKey",
        Size = UDim2.new(0.48, -10, 0, 40),
        Position = UDim2.new(0.52, 10, 0, 180),
        BackgroundColor3 = Color3.fromRGB(45, 45, 45),
        BorderSizePixel = 0,
        Text = "Get Key",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 14,
        Font = Enum.Font.GothamBold
    }, MainFrame)
    
    local GetKeyCorner = CreateElement("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, GetKeyButton)
    
    local StatusLabel = CreateElement("TextLabel", {
        Name = "Status",
        Size = UDim2.new(1, -40, 0, 30),
        Position = UDim2.new(0, 20, 0, 240),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = Color3.fromRGB(255, 100, 100),
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    }, MainFrame)
    
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local openTween = CreateTween(MainFrame, {
        Size = UDim2.new(0, 450, 0, 300),
        Position = UDim2.new(0.5, -225, 0.5, -150)
    }, 0.5, Enum.EasingStyle.Back)
    
    openTween:Play()
    
    local function ShowStatus(text, color)
        StatusLabel.Text = text
        StatusLabel.TextColor3 = color
        StatusLabel.TextTransparency = 0
        
        local fadeOut = CreateTween(StatusLabel, {TextTransparency = 1}, 3)
        wait(2)
        fadeOut:Play()
    end
    
    local function CheckKey(key)
        for _, validKey in pairs(config.Key) do
            if key == validKey then
                return true
            end
        end
        return false
    end
    
    SubmitButton.MouseButton1Click:Connect(function()
        local key = KeyInput.Text
        
        if key == "" then
            ShowStatus("Please enter a key!", Color3.fromRGB(255, 100, 100))
            return
        end
        
        if CheckKey(key) then
            ShowStatus("Key accepted! Loading...", Color3.fromRGB(100, 255, 100))
            
            if config.SaveKey then
                
            end
            
            local closeTween = CreateTween(MainFrame, {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }, 0.3)
            
            closeTween:Play()
            closeTween.Completed:Connect(function()
                KeySystemGui:Destroy()
                onSuccess()
            end)
        else
            ShowStatus("Invalid key! Please try again.", Color3.fromRGB(255, 100, 100))
            
            local shakeTween = CreateTween(MainFrame, {
                Position = UDim2.new(0.5, -235, 0.5, -150)
            }, 0.1)
            shakeTween:Play()
            shakeTween.Completed:Connect(function()
                local returnTween = CreateTween(MainFrame, {
                    Position = UDim2.new(0.5, -225, 0.5, -150)
                }, 0.1)
                returnTween:Play()
            end)
        end
    end)
    
    GetKeyButton.MouseButton1Click:Connect(function()
        if config.URL then
            
            ShowStatus("Check your browser for the key link!", Color3.fromRGB(100, 150, 255))
        end
    end)
    
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            SubmitButton.MouseButton1Click:Fire()
        end
    end)
    
    local function AddHoverEffect(button, hoverColor, normalColor)
        button.MouseEnter:Connect(function()
            CreateTween(button, {BackgroundColor3 = hoverColor}, 0.2):Play()
        end)
        
        button.MouseLeave:Connect(function()
            CreateTween(button, {BackgroundColor3 = normalColor}, 0.2):Play()
        end)
    end
    
    AddHoverEffect(SubmitButton, Color3.fromRGB(80, 140, 255), Color3.fromRGB(70, 130, 255))
    AddHoverEffect(GetKeyButton, Color3.fromRGB(55, 55, 55), Color3.fromRGB(45, 45, 45))
end

function EyeUI:CreateWindow(config)
    local Window = {}
    Window.__index = Window
    
    local windowConfig = {
        Title = config.Title or "EyeUI",
        Transparent = config.Transparent or false,
        Theme = config.Theme or "Dark",
        KeySystem = config.KeySystem
    }
    
    local function CreateMainWindow()
        local MainGui = CreateElement("ScreenGui", {
            Name = "EyeUI_Main",
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            IgnoreGuiInset = true
        }, PlayerGui)
        
        local MainFrame = CreateElement("Frame", {
            Name = "MainFrame",
            Size = UDim2.new(0, 600, 0, 400),
            Position = UDim2.new(0.5, -300, 0.5, -200),
            BackgroundColor3 = windowConfig.Transparent and Color3.fromRGB(15, 15, 15) or Color3.fromRGB(25, 25, 25),
            BackgroundTransparency = windowConfig.Transparent and 0.1 or 0,
            BorderSizePixel = 0
        }, MainGui)
        
        local MainCorner = CreateElement("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }, MainFrame)
        
        if windowConfig.Transparent then
            local Blur = CreateElement("BlurEffect", {
                Size = 10
            }, game.Lighting)
        end
        
        local TitleBar = CreateElement("Frame", {
            Name = "TitleBar",
            Size = UDim2.new(1, 0, 0, 50),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = Color3.fromRGB(35, 35, 35),
            BackgroundTransparency = windowConfig.Transparent and 0.3 or 0,
            BorderSizePixel = 0
        }, MainFrame)
        
        local TitleCorner = CreateElement("UICorner", {
            CornerRadius = UDim.new(0, 12)
        }, TitleBar)
        
        local TitleLabel = CreateElement("TextLabel", {
            Name = "Title",
            Size = UDim2.new(1, -100, 1, 0),
            Position = UDim2.new(0, 20, 0, 0),
            BackgroundTransparency = 1,
            Text = windowConfig.Title,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 18,
            Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center
        }, TitleBar)
        
        local CloseButton = CreateElement("TextButton", {
            Name = "Close",
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -40, 0, 10),
            BackgroundColor3 = Color3.fromRGB(255, 75, 75),
            BorderSizePixel = 0,
            Text = "×",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 18,
            Font = Enum.Font.GothamBold
        }, TitleBar)
        
        local CloseCorner = CreateElement("UICorner", {
            CornerRadius = UDim.new(0, 15)
        }, CloseButton)
        
        local MinimizeButton = CreateElement("TextButton", {
            Name = "Minimize",
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -80, 0, 10),
            BackgroundColor3 = Color3.fromRGB(255, 200, 75),
            BorderSizePixel = 0,
            Text = "_",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 18,
            Font = Enum.Font.GothamBold
        }, TitleBar)
        
        local MinimizeCorner = CreateElement("UICorner", {
            CornerRadius = UDim.new(0, 15)
        }, MinimizeButton)
        
        local ContentFrame = CreateElement("Frame", {
            Name = "Content",
            Size = UDim2.new(1, -40, 1, -90),
            Position = UDim2.new(0, 20, 0, 70),
            BackgroundTransparency = 1,
            BorderSizePixel = 0
        }, MainFrame)
        
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local openTween = CreateTween(MainFrame, {
            Size = UDim2.new(0, 600, 0, 400),
            Position = UDim2.new(0.5, -300, 0.5, -200)
        }, 0.6, Enum.EasingStyle.Back)
        
        openTween:Play()
        
        local isMinimized = false
        local originalSize = UDim2.new(0, 600, 0, 400)
        local minimizedSize = UDim2.new(0, 600, 0, 50)
        
        MinimizeButton.MouseButton1Click:Connect(function()
            isMinimized = not isMinimized
            local targetSize = isMinimized and minimizedSize or originalSize
            
            CreateTween(MainFrame, {Size = targetSize}, 0.3):Play()
            MinimizeButton.Text = isMinimized and "□" or "_"
        end)
        
        CloseButton.MouseButton1Click:Connect(function()
            local closeTween = CreateTween(MainFrame, {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            }, 0.3)
            closeTween:Play()
            closeTween.Completed:Connect(function()
                MainGui:Destroy()
            end)
        end)
        
        local function AddButtonHover(button, hoverColor, normalColor)
            button.MouseEnter:Connect(function()
                CreateTween(button, {BackgroundColor3 = hoverColor}, 0.2):Play()
            end)
            
            button.MouseLeave:Connect(function()
                CreateTween(button, {BackgroundColor3 = normalColor}, 0.2):Play()
            end)
        end
        
        AddButtonHover(CloseButton, Color3.fromRGB(255, 100, 100), Color3.fromRGB(255, 75, 75))
        AddButtonHover(MinimizeButton, Color3.fromRGB(255, 220, 100), Color3.fromRGB(255, 200, 75))
        
        local dragStart = nil
        local startPos = nil
        
        local function UpdateInput(input)
            local delta = input.Position - dragStart
            local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            CreateTween(MainFrame, {Position = newPos}, 0.1):Play()
        end
        
        TitleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragStart = input.Position
                startPos = MainFrame.Position
                
                local connection
                connection = input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        connection:Disconnect()
                    end
                end)
            end
        end)
        
        TitleBar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
                UpdateInput(input)
            end
        end)
        
        Window.MainFrame = MainFrame
        Window.ContentFrame = ContentFrame
        
        return Window
    end
    
    if windowConfig.KeySystem then
        CreateKeySystem(windowConfig.KeySystem, function()
            return CreateMainWindow()
        end)
    else
        return CreateMainWindow()
    end
    
    return Window
end

return EyeUI
