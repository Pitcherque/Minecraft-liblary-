-- Minecraft Liblary made by Healrous 
-- Complete Example: Loading MinecraftUILib from Raw Link with Guide how to use Minecraft Liblary 
-- This script can be executed directly in any Roblox executor so you can test it directly.

-- Load the MinecraftUILib from your raw link Lmao
local MinecraftUI = loadstring(game:HttpGet("https://pastefy.app/KpJchE8i/raw"))()

-- Create the main UI window
local UI = MinecraftUI:Create("Epic Gaming Hub")

-- Create tabs for different features
local playerTab = UI:CreateTab("Player")
local worldTab = UI:CreateTab("World")
local funTab = UI:CreateTab("Fun")
local settingsTab = UI:CreateTab("Settings")

-- Switch to first tab
UI:SwitchTab(playerTab)

-- PLAYER TAB - Character modifications
UI:CreateTextLabel("=== Player Controls ===", playerTab)

UI:CreateSlider("Walk Speed", 16, 500, 16, function(value)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = value
        print("Walk Speed:", value)
    end
end, playerTab)

UI:CreateSlider("Jump Power", 50, 500, 50, function(value)
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = value
        print("Jump Power:", value)
    end
end, playerTab)

UI:CreateToggle("Infinite Jump", function(enabled)
    local player = game.Players.LocalPlayer
    if enabled then
        _G.InfiniteJump = true
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.InfiniteJump and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
        print("Infinite Jump: ON")
    else
        _G.InfiniteJump = false
        print("Infinite Jump: OFF")
    end
end, playerTab)

UI:CreateToggle("No Clip", function(enabled)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    _G.NoClip = enabled
    game:GetService("RunService").Stepped:Connect(function()
        if _G.NoClip and character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)
    print("No Clip:", enabled and "ON" or "OFF")
end, playerTab)

UI:CreateButton("Reset Character", function()
    local player = game.Players.LocalPlayer
    if player and player.Character then
        player.Character:FindFirstChild("Humanoid").Health = 0
        print("Character reset!")
    end
end, playerTab)

-- WORLD TAB - Environment modifications
UI:CreateTextLabel("=== World Settings ===", worldTab)

UI:CreateToggle("Fullbright", function(enabled)
    local lighting = game:GetService("Lighting")
    if enabled then
        _G.OriginalBrightness = lighting.Brightness
        _G.OriginalClockTime = lighting.ClockTime
        _G.OriginalFogEnd = lighting.FogEnd
        
        lighting.Brightness = 2
        lighting.ClockTime = 14
        lighting.FogEnd = 100000
        lighting.GlobalShadows = false
        print("Fullbright: ON")
    else
        lighting.Brightness = _G.OriginalBrightness or 1
        lighting.ClockTime = _G.OriginalClockTime or 12
        lighting.FogEnd = _G.OriginalFogEnd or 10000
        lighting.GlobalShadows = true
        print("Fullbright: OFF")
    end
end, worldTab)

UI:CreateSlider("Time of Day", 0, 24, 12, function(value)
    game:GetService("Lighting").ClockTime = value
    print("Time set to:", string.format("%.1f", value) .. ":00")
end, worldTab)

UI:CreateSlider("Field of View", 50, 120, 70, function(value)
    local camera = workspace.CurrentCamera
    if camera then
        camera.FieldOfView = value
        print("FOV:", value)
    end
end, worldTab)

UI:CreateDropdown("Skybox", {"Default", "Night", "Sunset", "Space", "Cloudy"}, function(selected)
    local lighting = game:GetService("Lighting")
    print("Skybox changed to:", selected)
    
    -- Remove existing skybox
    for _, obj in pairs(lighting:GetChildren()) do
        if obj:IsA("Sky") then
            obj:Destroy()
        end
    end
    
    -- Add new skybox based on selection
    if selected ~= "Default" then
        local sky = Instance.new("Sky")
        sky.Parent = lighting
        
        if selected == "Night" then
            sky.SkyboxBk = "rbxasset://textures/sky/night_bk.png"
            sky.SkyboxDn = "rbxasset://textures/sky/night_dn.png"
            sky.SkyboxFt = "rbxasset://textures/sky/night_ft.png"
            sky.SkyboxLf = "rbxasset://textures/sky/night_lf.png"
            sky.SkyboxRt = "rbxasset://textures/sky/night_rt.png"
            sky.SkyboxUp = "rbxasset://textures/sky/night_up.png"
        end
    end
end, worldTab)

UI:CreateButton("Delete All NPCs", function()
    local deleted = 0
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not game.Players:GetPlayerFromCharacter(obj) then
            obj:Destroy()
            deleted = deleted + 1
        end
    end
    print("Deleted", deleted, "NPCs")
end, worldTab)

-- FUN TAB - Entertainment features
UI:CreateTextLabel("=== Fun Features ===", funTab)

UI:CreateButton("Teleport to Random Player", function()
    local player = game.Players.LocalPlayer
    local players = {}
    
    for _, p in pairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(players, p)
        end
    end
    
    if #players > 0 then
        local randomPlayer = players[math.random(1, #players)]
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = randomPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(5, 0, 0)
            print("Teleported to:", randomPlayer.Name)
        end
    else
        print("No players found to teleport to!")
    end
end, funTab)

UI:CreateToggle("Spin Character", function(enabled)
    local player = game.Players.LocalPlayer
    if enabled then
        _G.Spinning = true
        spawn(function()
            while _G.Spinning do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(10), 0)
                end
                wait(0.1)
            end
        end)
        print("Character spinning: ON")
    else
        _G.Spinning = false
        print("Character spinning: OFF")
    end
end, funTab)

UI:CreateSlider("Character Size", 0.5, 5, 1, function(value)
    local player = game.Players.LocalPlayer
    if player and player.Character then
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Size = part.Size * value / (player.Character:GetAttribute("CurrentScale") or 1)
            end
        end
        player.Character:SetAttribute("CurrentScale", value)
        print("Character size:", value)
    end
end, funTab)

UI:CreateButton("Rainbow Trail", function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local trail = Instance.new("Trail")
        local attachment0 = Instance.new("Attachment")
        local attachment1 = Instance.new("Attachment")
        
        attachment0.Parent = player.Character.HumanoidRootPart
        attachment1.Parent = player.Character.HumanoidRootPart
        attachment1.Position = Vector3.new(0, -2, 0)
        
        trail.Attachment0 = attachment0
        trail.Attachment1 = attachment1
        trail.Parent = player.Character.HumanoidRootPart
        trail.Lifetime = 2
        trail.MinLength = 0
        trail.FaceCamera = true
        
        -- Rainbow effect
        spawn(function()
            while trail and trail.Parent do
                for i = 0, 1, 0.1 do
                    if trail and trail.Parent then
                        trail.Color = ColorSequence.new(Color3.fromHSV(i, 1, 1))
                        wait(0.1)
                    end
                end
            end
        end)
        
        print("Rainbow trail added!")
    end
end, funTab)

-- SETTINGS TAB - Configuration options
UI:CreateTextLabel("=== GUI Settings ===", settingsTab)

UI:CreateDropdown("UI Theme", {"Default", "Dark Mode", "Light Mode", "Rainbow"}, function(selected)
    print("UI Theme changed to:", selected)
    -- You could implement theme changes here by modifying the UI colors
end, settingsTab)

UI:CreateToggle("Show Notifications", function(enabled)
    _G.ShowNotifications = enabled
    print("Notifications:", enabled and "ON" or "OFF")
end, settingsTab)

UI:CreateButton("Reset All Settings", function()
    -- Reset all global variables
    _G.InfiniteJump = false
    _G.NoClip = false
    _G.Spinning = false
    _G.ShowNotifications = true
    
    -- Reset player stats
    local player = game.Players.LocalPlayer
    if player and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end
    
    -- Reset lighting
    local lighting = game:GetService("Lighting")
    lighting.Brightness = 1
    lighting.ClockTime = 12
    lighting.FogEnd = 10000
    lighting.GlobalShadows = true
    
    print("All settings reset to default!")
end, settingsTab)

UI:CreateButton("Destroy GUI", function()
    UI.Gui:Destroy()
    print("GUI destroyed!")
end, settingsTab)

UI:CreateTextLabel("Made with MinecraftUILib", settingsTab)

-- Print welcome message
print("🎮 Epic Gaming Hub Loaded! 🎮")
print("📁 Raw link: https://pastefy.app/KpJchE8i/raw")
print("✨ Features: Player mods, World settings, Fun tools")
print("⚙️ Use the tabs to navigate between different features!")
print("❌ Use Settings tab to reset or destroy the GUI")

