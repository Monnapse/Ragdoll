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

        --// Disable animations
        local Animator: Animator = Humanoid:WaitForChild("Animator")
        for i, track: AnimationTrack in pairs(Animator:GetPlayingAnimationTracks()) do
            track:Stop()
        end

		--// Collecting Directories
		local Torso: Part = Rig:FindFirstChild("Torso")
		if not Torso then Torso = Rig:WaitForChild("Torso") end
		local RightLeg: Part = Rig:FindFirstChild("Right Leg")
		if not RightLeg then RightLeg = Rig:WaitForChild("Right Leg") end
		local LeftLeg: Part = Rig:FindFirstChild("Left Leg")
		if not LeftLeg then LeftLeg = Rig:WaitForChild("Left Leg") end
		local Head: Part = Rig:FindFirstChild("Head")
		if not Head then Head = Rig:WaitForChild("Head") end
        local LeftArm: Part = Rig:FindFirstChild("Left Arm")
	    if not LeftArm then LeftArm = Rig:WaitForChild("Left Arm") end
	    local RightArm: Part = Rig:FindFirstChild("Right Arm")
	    if not RightArm then RightArm = Rig:WaitForChild("Right Arm") end

		--// Constraints
		local RightRope: BallSocketConstraint = Instance.new("RopeConstraint", Torso)
		RightRope.Name = "RightConstraint"
		local LeftRope: BallSocketConstraint = Instance.new("RopeConstraint", Torso)
		LeftRope.Name = "LeftLegConstraint"
		local HeadRope: BallSocketConstraint = Instance.new("RopeConstraint", Torso)
		HeadRope.Name = "HeadConstraint"
        local RightBallSocket: BallSocketConstraint = Instance.new("BallSocketConstraint", Torso)
	    RightBallSocket.Name = "RightArmConstraint"
	    local LeftBallSocket: BallSocketConstraint = Instance.new("BallSocketConstraint", Torso)
	    LeftBallSocket.Name = "LeftArmConstraint"

		ApplyProperties(RightRope, Character.RAGDOLL_V1_SETTINGS)
		ApplyProperties(LeftRope, Character.RAGDOLL_V1_SETTINGS)
		ApplyProperties(HeadRope, Character.RAGDOLL_V1_SETTINGS)
        ApplyProperties(RightBallSocket, Character.V1_SETTINGS)
	    ApplyProperties(LeftBallSocket, Character.V1_SETTINGS)

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

        local RightConstraintAttachment: Attachment = RightArm:FindFirstChild("RightShoulderAttachment"):Clone()
	    RightConstraintAttachment.Parent = RightArm
	    RightConstraintAttachment.Name = "RightConstraintAttachment"
	    RightConstraintAttachment.CFrame = CFrame.new(-0.5,1,0)
	    RightBallSocket.Attachment0 = Torso:FindFirstChild("RightCollarAttachment")
	    RightBallSocket.Attachment1 = RightConstraintAttachment

	    local LeftConstraintAttachment: Attachment = LeftArm:FindFirstChild("LeftShoulderAttachment"):Clone()
	    LeftConstraintAttachment.Parent = LeftArm
	    LeftConstraintAttachment.Name = "LeftConstraintAttachment"
	    LeftConstraintAttachment.CFrame = CFrame.new(0.5,1,0)
	    LeftBallSocket.Attachment0 = Torso:FindFirstChild("LeftCollarAttachment")
	    LeftBallSocket.Attachment1 = LeftConstraintAttachment

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

        local RightArmCollision: Part = RightArm:Clone()
	    RightArmCollision.Parent = Rig
	    RightArmCollision.Name = "Right Arm Collision"
	    RightArmCollision.Transparency = 1
	    RightArmCollision.CanCollide = true

	    local RACollision:Weld = Instance.new("Weld", RightArmCollision)
	    RACollision.Part0 = RightArmCollision
	    RACollision.Part1 = RightArm

	    local LeftArmCollision: Part = LeftArm:Clone()
	    LeftArmCollision.Parent = Rig
	    LeftArmCollision.Name = "Left Arm Collision"
	    LeftArmCollision.Transparency = 1
	    LeftArmCollision.CanCollide = true

	    local LACollision:Weld = Instance.new("Weld", LeftArmCollision)
	    LACollision.Part0 = LeftArmCollision
	    LACollision.Part1 = LeftArm



		--// Disable Welds
		Torso:FindFirstChild("Right Hip").Enabled = false
		Torso:FindFirstChild("Left Hip").Enabled = false
		Torso:FindFirstChild("Neck").Enabled = false
        Torso:FindFirstChild("Right Shoulder").Enabled = false
	    Torso:FindFirstChild("Left Shoulder").Enabled = false

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
        Torso:FindFirstChild("Right Shoulder").Enabled = false
	    Torso:FindFirstChild("Left Shoulder").Enabled = false
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
        local LeftArm: Part = Rig:FindFirstChild("Left Arm")
        if not LeftArm then LeftArm = Rig:WaitForChild("Left Arm") end
        local RightArm: Part = Rig:FindFirstChild("Right Arm")
        if not RightArm then RightArm = Rig:WaitForChild("Right Arm") end

		--// Enable Welds
		Torso:FindFirstChild("Right Hip").Enabled = true
		Torso:FindFirstChild("Left Hip").Enabled = true
		Torso:FindFirstChild("Neck").Enabled = true
        Torso:FindFirstChild("Right Shoulder").Enabled = true
	    Torso:FindFirstChild("Left Shoulder").Enabled = true

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