--[[
	Made by Monnapse
--]]

local Character = {}

--// SETTINGS
Character.V1_SETTINGS = {
	LimitsEnabled = true,
	MaxFrictionTorque = 0,
	Restitution = 0,
	TwistLimitsEnabled = true,
	UpperAngle = 45,
	TwistLowerAngle = 135,
	TwistUpperAngle = -135
}

Character.RAGDOLL_V1_SETTINGS = {
	Length = 0.25
}

local function ApplyProperties(Part:Part, Properties: {any})
	for Property, Value in pairs(Properties) do
		Part[Property] = Value
	end
end

function Character.EnableRagdollV1(Rig: Model, Humanoid: Humanoid)
	if Rig:GetAttribute("Ragdoll") == false or Rig:GetAttribute("Ragdoll") == nil then
		--// Humanoid Settings
		Humanoid.WalkSpeed = 0
		--Humanoid.EvaluateStateMachine = false
		Humanoid.AutoRotate = false
		Humanoid.RequiresNeck = false

		--// Collecting Directories
		local Torso: Part = Rig:FindFirstChild("Torso")
		if not Torso then Torso = Rig:WaitForChild("Torso") end
		local RightLeg: Part = Rig:FindFirstChild("Right Leg")
		if not RightLeg then RightLeg = Rig:WaitForChild("Right Leg") end
		local LeftLeg: Part = Rig:FindFirstChild("Left Leg")
		if not LeftLeg then LeftLeg = Rig:WaitForChild("Left Leg") end
		local Head: Part = Rig:FindFirstChild("Head")
		if not Head then Head = Rig:WaitForChild("Head") end

		--// Constraints
		local RightRope: BallSocketConstraint = Instance.new("RopeConstraint", Torso)
		RightRope.Name = "RightConstraint"
		local LeftRope: BallSocketConstraint = Instance.new("RopeConstraint", Torso)
		LeftRope.Name = "LeftLegConstraint"
		local HeadRope: BallSocketConstraint = Instance.new("RopeConstraint", Torso)
		HeadRope.Name = "HeadConstraint"

		ApplyProperties(RightRope, Character.RAGDOLL_V1_SETTINGS)
		ApplyProperties(LeftRope, Character.RAGDOLL_V1_SETTINGS)
		ApplyProperties(HeadRope, Character.RAGDOLL_V1_SETTINGS)

		--// Attachemnts & Applying Constraints
		local RightConstraintAttachment: Attachment = RightLeg:FindFirstChild("RightFootAttachment"):Clone()
		RightConstraintAttachment.Parent = RightLeg
		RightConstraintAttachment.Name = "TopConstraintAttachment"
		RightConstraintAttachment.CFrame = CFrame.new(0,0.95,0)

		local RightTorsoConstraintAttachment: Attachment = Torso:FindFirstChild("WaistCenterAttachment"):Clone()
		RightTorsoConstraintAttachment.Parent = Torso
		RightTorsoConstraintAttachment.Name = "RightLegConstraintAttachment"
		RightTorsoConstraintAttachment.CFrame = CFrame.new(0.5,-1,0)

		RightRope.Attachment0 = RightTorsoConstraintAttachment
		RightRope.Attachment1 = RightConstraintAttachment

		local LeftConstraintAttachment: Attachment = LeftLeg:FindFirstChild("LeftFootAttachment"):Clone()
		LeftConstraintAttachment.Parent = LeftLeg
		LeftConstraintAttachment.Name = "TopConstraintAttachment"
		LeftConstraintAttachment.CFrame = CFrame.new(0,0.95,0)

		local LeftTorsoConstraintAttachment: Attachment = Torso:FindFirstChild("WaistCenterAttachment"):Clone()
		LeftTorsoConstraintAttachment.Parent = Torso
		LeftTorsoConstraintAttachment.Name = "LeftLegConstraintAttachment"
		LeftTorsoConstraintAttachment.CFrame = CFrame.new(-0.5,-1,0)

		LeftRope.Attachment0 = LeftTorsoConstraintAttachment
		LeftRope.Attachment1 = LeftConstraintAttachment

		local HeadConstraintAttachment: Attachment = Head:FindFirstChild("FaceCenterAttachment"):Clone()
		HeadConstraintAttachment.Parent = Head
		HeadConstraintAttachment.Name = "BottomConstraintAttachment"
		HeadConstraintAttachment.CFrame = CFrame.new(0,-0.5,0)

		HeadRope.Attachment0 = Torso:FindFirstChild("NeckAttachment")
		HeadRope.Attachment1 = HeadConstraintAttachment

		--// Collisions
		local RightLegCollision: Part = RightLeg:Clone()
		RightLegCollision.Parent = Rig
		RightLegCollision.Name = "Right Leg Collision"
		RightLegCollision.Transparency = 1
		RightLegCollision.CanCollide = true

		local RLCollision:Weld = Instance.new("Weld", RightLegCollision)
		RLCollision.Part0 = RightLegCollision
		RLCollision.Part1 = RightLeg

		local LeftLegCollision: Part = LeftLeg:Clone()
		LeftLegCollision.Parent = Rig
		LeftLegCollision.Name = "Left Leg Collision"
		LeftLegCollision.Transparency = 1
		LeftLegCollision.CanCollide = true

		local LLCollision:Weld = Instance.new("Weld", LeftLegCollision)
		LLCollision.Part0 = LeftLegCollision
		LLCollision.Part1 = LeftLeg

		local HeadCollision: Part = Head:Clone()
		HeadCollision.Parent = Rig
		HeadCollision.Name = "Head Collision"
		HeadCollision.Transparency = 1
		HeadCollision.CanCollide = true

		local HCollision:Weld = Instance.new("Weld", Head)
		HCollision.Part0 = HeadCollision
		HCollision.Part1 = Head

		--// Disable Welds
		Torso:FindFirstChild("Right Hip").Enabled = false
		Torso:FindFirstChild("Left Hip").Enabled = false
		Torso:FindFirstChild("Neck").Enabled = false

		Rig:SetAttribute("Ragdoll", true)
	else
		--// Humanoid Settings
		Humanoid.RequiresNeck = false
		Humanoid.WalkSpeed = 0
		--Humanoid.EvaluateStateMachine = false
		Humanoid.AutoRotate = false

		--// Collecting Directories
		local Torso: Part = Rig:FindFirstChild("Torso")
		if not Torso then Torso = Rig:WaitForChild("Torso") end

		--// Enable Welds
		Torso:FindFirstChild("Right Hip").Enabled = false
		Torso:FindFirstChild("Left Hip").Enabled = false
		Torso:FindFirstChild("Neck").Enabled = false
	end
end

function Character.DisableRagdollV1(Rig: Model, Humanoid: Humanoid, WalkSpeed: number)
	if Rig:GetAttribute("Ragdoll") == true then
		--// Collecting Directories
		local Torso: Part = Rig:FindFirstChild("Torso")
		if not Torso then Torso = Rig:WaitForChild("Torso") end
		local RightLeg: Part = Rig:FindFirstChild("Right Leg")
		if not RightLeg then RightLeg = Rig:WaitForChild("Right Leg") end
		local LeftLeg: Part = Rig:FindFirstChild("Left Leg")
		if not LeftLeg then LeftLeg = Rig:WaitForChild("Left Leg") end
		local Head: Part = Rig:FindFirstChild("Head")
		if not Head then Head = Rig:WaitForChild("Head") end

		--// Enable Welds
		Torso:FindFirstChild("Right Hip").Enabled = true
		Torso:FindFirstChild("Left Hip").Enabled = true
		Torso:FindFirstChild("Neck").Enabled = true

		--// Humanoid Settings
		Humanoid.WalkSpeed = WalkSpeed
		--Humanoid.EvaluateStateMachine = true
		Humanoid.AutoRotate = true
		-- Disable the "Ragdoll" state
		--Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		-- Re-enable EvaluateStateMachine
		--Humanoid:SetStateEnabled(Enum.HumanoidStateType.Physics, false) -- Disable the Physics state
		--Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) -- Disable the Ragdoll state
		--Humanoid:SetStateEnabled(Enum.HumanoidStateType.None, true) -- Enable the "Idle" state or any other desired state

		Rig:SetAttribute("Ragdoll", false)
	end
end

return Character