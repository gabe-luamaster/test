local panel = script.Parent.Parent:WaitForChild("Panel")
local surfaceGui = panel:WaitForChild("SurfaceGui")

local originalFrame = surfaceGui:FindFirstChild("Frame")
local powerOn = surfaceGui:FindFirstChild("power on")

if powerOn and originalFrame then
    -- Clone 'power on' and rename
    local newFrame = powerOn:Clone()
    newFrame.Name = "ServiceNotice"
    newFrame.Parent = surfaceGui

    -- Clear contents of the clone
    for _, child in pairs(newFrame:GetChildren()) do
        child:Destroy()
    end

    -- Remove the original Frame
    originalFrame:Destroy()

    -- Remove the original 'power on'
    powerOn:Destroy()

    -- Create the TextLabel
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Position = UDim2.new(0, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(0, 0, 0) -- white text
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Text = "Our Service is currently out for updates..."
    label.Parent = newFrame
end

