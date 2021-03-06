AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

local RD = CAF.GetAddon("Resource Distribution")
include('shared.lua')

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self:SetColor(Color( 0, 204, 0, 255 ))
	-- If wiremod is installed, create an output partaining to requirments!
	if not (WireAddon == nil) then self.Outputs = Wire_CreateOutputs(self, { "Petrol" }) end
	-- Are we valid?
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:SetMass(2000)
		phys:Wake()
	end
	
	-- Add resource
	RD.AddResource(self, "Petrol", self.MAXRESOURCE)
end

function ENT:Damage()
	if (self.damaged == 0) then self.damaged = 1 end
end

function ENT:Repoxygen()
	self:SetColor(Color( 255, 255, 255, 255 ))
	self.health = self.maxhealth
	self.damaged = 0
end

function ENT:Destruct()
	local Effect = EffectData()
		Effect:SetOrigin(self:GetPos())
		Effect:SetScale(1)
		Effect:SetMagnitude(25)
	util.Effect("Explosion", Effect, true, true)
	self:Remove()
end

function ENT:Think()
	self.BaseClass.Think(self)
	
	-- If wire is installed, Use it...
	if not (WireAddon == nil) then
		self.Petrol = RD.GetResourceAmount(self, "Petrol")
		Wire_TriggerOutput(self, "Petrol", self.Petrol)
	end
	
	self:NextThink(CurTime() + 1)
	return true
end
