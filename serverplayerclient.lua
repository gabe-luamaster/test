-- StarterPlayerScripts/JCI_SurfaceSubmitClient.lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local root = workspace:WaitForChild("JOY ELETRICK Proprosenter v4")

-- try common remote names (your project used SubmitText / TextSubmitted earlier)
local remote = ReplicatedStorage:FindFirstChild("SubmitText") or ReplicatedStorage:FindFirstChild("TextSubmitted")
if not remote then
	warn("[JCI] RemoteEvent 'SubmitText' or 'TextSubmitted' not found in ReplicatedStorage. Client will not fire submissions.")
	return
end

-- find a TextBox sibling of the Submit button
local function findSiblingTextBox(btn)
	local p = btn.Parent
	for _, child in ipairs(p:GetChildren()) do
		if child:IsA("TextBox") then
			return child
		end
	end
	return nil
end

local function wireButton(btn)
	if not btn or not btn:IsA("TextButton") then return end
	if btn:GetAttribute("JCI_Wired") then return end

	-- only wire buttons that are on SurfaceGui (prevents wiring other UI)
	local surface = btn:FindFirstAncestorOfClass("SurfaceGui")
	if not surface then return end

	local textBox = findSiblingTextBox(btn)
	if not textBox then
		warn("[JCI] Submit found but no sibling TextBox at:", btn:GetFullName())
		return
	end

	btn:SetAttribute("JCI_Wired", true)

	btn.MouseButton1Click:Connect(function()
		local txt = tostring(textBox.Text or "")
		if txt ~= "" then
			remote:FireServer(txt)
			textBox.Text = "" -- optional: clear after send
		end
	end)

	-- press Enter to submit too
	textBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			local txt = tostring(textBox.Text or "")
			if txt ~= "" then
				remote:FireServer(txt)
				textBox.Text = ""
			end
		end
	end)

	print("[JCI] Wired Submit button:", btn:GetFullName())
end

-- initial pass: wire existing Submit buttons under your root
for _, obj in ipairs(root:GetDescendants()) do
	if obj:IsA("TextButton") and obj.Name == "Submit" then
		wireButton(obj)
	end
end

-- keep wiring buttons that are added later
root.DescendantAdded:Connect(function(desc)
	if desc:IsA("TextButton") and desc.Name == "Submit" then
		wireButton(desc)
	end
end)
