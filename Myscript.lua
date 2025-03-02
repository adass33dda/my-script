-- Load a simple UI library (replace this with your preferred library if needed)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/library/main/UI_library.lua"))()

-- Create the main window
local Window = Library.CreateLib("My Custom Script", "DarkTheme")

-- Aimbot Category
local AimbotTab = Window:NewTab("Aimbot")
local AimbotSection = AimbotTab:NewSection("Camlock & Lock")

local camlockEnabled = false
local targetPlayer = nil

AimbotSection:NewToggle("Camlock", "Locks your camera onto a player", function(state)
    camlockEnabled = state
    if state then
        -- Enable Camlock Logic
        spawn(function()
            while camlockEnabled and task.wait() do
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local rootPart = targetPlayer.Character.HumanoidRootPart
                    if rootPart then
                        game.Workspace.CurrentCamera.CFrame = CFrame.new(game.Players.LocalPlayer.Character.Head.Position, rootPart.Position)
                    end
                end
            end
        end)
    end
end)

AimbotSection:NewButton("Select Target", "Choose a player to lock onto", function()
    targetPlayer = game.Players:PromptForPlayerAsync()
end)

-- Fly Category
local FlyTab = Window:NewTab("Fly")
local FlySection = FlyTab:NewSection("Fly Controls")

local flyEnabled = false
local flySpeed = 50

FlySection:NewToggle("Fly Toggle", "Enable/Disable flying", function(state)
    flyEnabled = state
    if state then
        -- Enable Fly Logic
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")

        local flyVelocity = Vector3.new(0, 0, 0)

        spawn(function()
            while flyEnabled and task.wait(0.1) do
                if humanoid.FloorMaterial == Enum.Material.Air then
                    rootPart.Velocity = flyVelocity * flySpeed
                end
            end
        end)

        -- Key Bindings for Movement
        local keys = {}
        local keybinds = {
            ["w"] = Vector3.new(0, 0, -1),
            ["s"] = Vector3.new(0, 0, 1),
            ["a"] = Vector3.new(-1, 0, 0),
            ["d"] = Vector3.new(1, 0, 0),
            ["e"] = Vector3.new(0, 1, 0),
            ["q"] = Vector3.new(0, -1, 0),
        }

        local userInputService = game:GetService("UserInputService")

        userInputService.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local key = input.KeyCode.Name:lower()
                if keybinds[key] then
                    keys[key] = true
                    flyVelocity = flyVelocity + keybinds[key]
                end
            end
        end)

        userInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local key = input.KeyCode.Name:lower()
                if keybinds[key] then
                    keys[key] = false
                    flyVelocity = flyVelocity - keybinds[key]
                end
            end
        end)
    end
end)

FlySection:NewSlider("Fly Speed", "Adjust your fly speed", 50, 100, flySpeed, function(value)
    flySpeed = value
end)

-- Fun Category
local FunTab = Window:NewTab("Fun")
local FunSection = FunTab:NewSection("Coming Soon")

FunSection:NewLabel("Stay tuned for fun features!")
FunSection:NewButton("Request Feature", "Let us know what you'd like to see!", function()
    print("Feature request button clicked!")
end)

-- Function to make the GUI smaller
local function resizeGUI(scaleFactor)
    for _, tab in ipairs(Window.Tabs) do
        for _, section in ipairs(tab.Sections) do
            section.Size = UDim2.new(section.Size.X.Scale * scaleFactor, section.Size.X.Offset, section.Size.Y.Scale * scaleFactor, section.Size.Y.Offset)
        end
    end
end

-- Example: Make the GUI smaller
resizeGUI(0.8) -- Adjust the scale factor as needed