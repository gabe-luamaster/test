local Players = game:GetService("Players")

while true do
	for _, player in pairs(Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			
			-- Create the part
			local part = Instance.new("Part")
			part.Size = Vector3.new(5, 1, 5)
			part.Anchored = true
			part.Position = hrp.Position + Vector3.new(0, 10, 0) -- 10 studs above player
			part.Parent = workspace
		end
	end
	
	wait(5) -- wait before spawning the next batch
end
