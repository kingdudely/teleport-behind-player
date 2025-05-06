pcall(function()
    getgenv().teleportBehind:Disconnect()
    getgenv().teleportBehind = nil
end)

local settings = {
    distance = 3,
    key = "e"
}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local LocalCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = LocalCharacter:FindFirstChildWhichIsA("Humanoid")
local LocalRootPart = Humanoid.RootPart

function getNearestCharacter()
    local closestCharacter = nil
    local shortestDistance = math.huge

    for _, Character in workspace:GetDescendants() do
        if Character ~= LocalCharacter then
            local RootPart = Character:FindFirstChild("HumanoidRootPart")

            if RootPart then
                local distance = (LocalRootPart.Position - RootPart.Position).Magnitude

                if distance < shortestDistance then
                    shortestDistance = distance
                    closestCharacter = Character
                end
            end
        end
    end

    return closestCharacter
end

getgenv().teleportBehind = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode:FromName(settings.key:upper()) then
        local Character = getNearestCharacter()
        
        -- I don't have to check for RootPart because getNearestCharacter does that for me!
        if Character then
            local Pivot = Character:GetPivot()

            local position = Pivot.Position - (Pivot.LookVector * settings.distance)
            LocalRootPart.CFrame = CFrame.new(position, Pivot.Position)
        end
    end
end)
