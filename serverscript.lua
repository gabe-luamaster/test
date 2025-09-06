-- ServerScriptService/JCI_SurfaceSubmitServer.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextService = game:GetService("TextService")
local root = workspace:WaitForChild("JOY ELETRICK Proprosenter v4")

-- create RemoteEvent if missing (so product is plug-and-play)
local submitEvent = ReplicatedStorage:FindFirstChild("SubmitText") or ReplicatedStorage:FindFirstChild("TextSubmitted")
if not submitEvent then
	submitEvent = Instance.new("RemoteEvent")
	submitEvent.Name = "SubmitText"
	submitEvent.Parent = ReplicatedStorage
end

-- filter (required if showing to others)
local function filterText(player, raw)
	raw = tostring(raw or ""):sub(1, 500)
	local ok, result = pcall(function()
		local filtered = TextService:FilterStringAsync(raw, player.UserId)
		return filtered:GetNonChatStringForBroadcastAsync()
	end)
	if ok then return result else return "[message failed to filter]" end
end

-- update all screens: looks for SurfaceGui -> HomeScreen -> TextLabel named "main" (fallback to first TextLabel)
local function updateAllScreens(text)
	for _, screensFolder in ipairs(root:GetChildren()) do
		if screensFolder:IsA("Folder") and screensFolder.Name == "Screens" then
			for _, part in ipairs(screensFolder:GetChildren()) do
				if part:IsA("BasePart") then
					for _, child in ipairs(part:GetChildren()) do
						if child:IsA("SurfaceGui") then
							local home = child:FindFirstChild("HomeScreen") or child
							local label = home:FindFirstChild("main")
							if not label then
								for _, c in ipairs(home:GetChildren()) do
									if c:IsA("TextLabel") then
										label = c
										break
									end
								end
							end
							if label and label:IsA("TextLabel") then
								label.RichText = false
								label.Text = text
							end
						end
					end
				end
			end
		end
	end
end

submitEvent.OnServerEvent:Connect(function(player, rawText)
	local safe = filterText(player, rawText)
	updateAllScreens(safe)
end)
