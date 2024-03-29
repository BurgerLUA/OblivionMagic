SWEP.PrintName 			= "GMod Magic"
SWEP.Author 			= "Burger" 
SWEP.Contact 			= "" 
SWEP.Category 			= "Burger's Weapons"
SWEP.Instructions 		= ""
SWEP.Purpose 			= ""

SWEP.Base 				= "weapon_base"	
SWEP.ViewModel 			= "models/weapons/c_arms_citizen.mdl" 
SWEP.WorldModel 		= ""
SWEP.HoldType 			= "normal" 
SWEP.ViewModelFlip 		= true
SWEP.UseHands			= false	


SWEP.Spawnable 			= true 
SWEP.AdminSpawnable 	= true

SWEP.AutoSwitchTo 		= true
SWEP.AutoSwitchFrom 	= false                        			-- Does the weapon get changed by other sweps if you pick them up.


SWEP.DrawCrosshair 		= false                           		-- Do you want it to have a crosshair.
SWEP.DrawAmmo 			= true                                -- Does the ammo show up when you are using it.


SWEP.Weight 			= 0                                   	-- Chose the weight of the Swep.
SWEP.SlotPos 			= 0                                    	-- Deside wich slot you want your swep do be in.
SWEP.Slot 				= 1                                     -- Deside wich slot you want your swep do be in.

SWEP.Primary.Ammo         		= "none"
SWEP.Primary.ClipSize			= 100
SWEP.Primary.DefaultClip		= 100
SWEP.Primary.Automatic   		= true					

SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo				= "none"

--function SWEP:SetupDataTables()

	--self:NetworkVar( "String", 1, "NHelpText" )

--end

if CLIENT then

	killicon.Add("ent_bur_magic_base", "vgui/hand", Color(255,255,255,255) )

	surface.CreateFont( "Oblivion", {
	font = "oblivion-font",
	size = 32,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
	} )
	
end

function SWEP:Initialize()  

	if CLIENT then
		self.Method = "target"
		self.Cost = 25
		--print(self.Method)
	end


	self:SetNWInt("sv_weaponslot",1)
	self.CanSwitch = true
	self.WeaponSlot = 1
	self.DamageType = "fire"
	self.Damage = 0
	self.Duration = 0
	self.Radius = 0
	self.VelMul = 0
	UpdateSpell(self)
	SetUpSpells(self)
	self.Text = "yeah"
	self.RegenTime = CurTime()+2
	self.Cost = 25
	self.Method = "target"
end 

function SWEP:Deploy()
	self:SetNWInt("sv_weaponslot",1)
	--self.Owner:Armor(100)
	self.CanSwitch = true
	self.WeaponSlot = 1
	self.DamageType = "fire"
	self.Damage = 0
	self.Duration = 3
	self.Radius = 0
	self.VelMul = 0
	UpdateSpell(self)
	SetUpSpells(self)
	self.Text = "yeah"
	self.RegenTime = CurTime()+2
	self.Cost = 25
	self.Method = "target"
	return true
end

function SWEP:Holster()
	return true
end

function SWEP:PrimaryAttack()


	self:SetNextPrimaryFire( CurTime() + 2 )
	--self:SetNextSecondaryFire( CurTime() + 2 )



	EmitEffects(self)
	
	if self.Cost <= self:Clip1() then
		self.RegenTime = CurTime()+2.25
		timer.Simple(1, function()
			UpdateSpell(self)
			--print(self.Damage)
			if SERVER then
				self.Weapon:TakePrimaryAmmo(self.Cost)
				self.CastWhen = CurTime()
				if self.Method == "target" then
					SpellTarget(self)
				elseif self.Method == "touch" then
					SpellTouch(self)
				elseif self.Method == "self" then
					SpellSelf(self)
				end
			end	
		end)
	end
end

function SWEP:SecondaryAttack()
	--print("NW: " .. self:GetNWInt("sv_weaponslot",99))
	--print("WeaponSlot: " .. self.WeaponSlot)
end

function SWEP:Reload()
	--print(self:Clip1())
end





function SWEP:Think()
	
	if SERVER then
		if self.RegenTime == nil then return end
		if self.RegenTime > CurTime() then return end
		
		if self.Weapon:Clip1() < 100 then
			self.RegenTime = CurTime() + 0.12
			self.Weapon:SetClip1(self.Weapon:Clip1()+1)
		end
	end

	if SERVER then
		if self.Owner:KeyDown( IN_ATTACK2 ) then
			if self.Owner:KeyDown( IN_FORWARD ) and self.Owner:KeyDown( IN_MOVELEFT ) then
				self.WeaponSlot = 8
				self:SetNWInt("sv_Weaponslot",8)
			elseif self.Owner:KeyDown( IN_FORWARD ) and self.Owner:KeyDown( IN_MOVERIGHT ) then
				self.WeaponSlot = 2
				self:SetNWInt("sv_Weaponslot",2)

			elseif self.Owner:KeyDown( IN_BACK ) and self.Owner:KeyDown( IN_MOVELEFT ) then
				self.WeaponSlot = 6
				self:SetNWInt("sv_Weaponslot",6)

			elseif self.Owner:KeyDown( IN_BACK ) and self.Owner:KeyDown( IN_MOVERIGHT ) then
				self.WeaponSlot = 4
				self:SetNWInt("sv_Weaponslot",4)

			elseif self.Owner:KeyDown( IN_FORWARD ) then
				self.WeaponSlot = 1
				self:SetNWInt("sv_Weaponslot",1)

			elseif self.Owner:KeyDown( IN_MOVELEFT ) then
				self.WeaponSlot = 7
				self:SetNWInt("sv_Weaponslot",7)

			elseif self.Owner:KeyDown( IN_MOVERIGHT ) then
				self.WeaponSlot = 3
				self:SetNWInt("sv_Weaponslot",3)

			elseif self.Owner:KeyDown( IN_BACK ) then
				self.WeaponSlot = 5
				self:SetNWInt("sv_Weaponslot",5)
			end
		end
	end
	
	
	--[[
	if self.WeaponSlot == self:GetNWInt("sv_weaponslot",99) then
		UpdateSpell(self)
		SetUpSpells(self)
	end
	]]--
	
	if CLIENT then
		self.WeaponSlot = self:GetNWInt("sv_weaponslot",99)
		UpdateSpell(self)
	end
	
	
	
		
	
		UpdateSpell(self)
		SetUpSpells(self)
	
	


	
	
end


function SWEP:DrawHUD()
	local BaseX = ScrW()*0.25
	local BaseY = ScrH()*0.90
	local BaseTrig = 1
	local ConVert = math.pi/180
	local Size = 64
	--local Icon = self:GetNWString("damagetype","nil")
	local Icon = self.DamageType
	local HelpText = self.Text or "ass"
	local HelpText2 = self.Text2 or "titties"
	--local HelpText = self:GetNWString("helptext","gg noob")
	
	if CanSwitch == true then
		helper = 255
	else
		helper = 0
	end
	
	
	if Icon == nil then return end
	if HelpText == nil then return end
	if HelpText2 == nil then return end
	
	surface.SetMaterial( Material("vgui/crosshairs/crosshair3") )
	surface.SetDrawColor(255,200,helper,1)
	surface.DrawTexturedRectRotated(ScrW()/2,ScrH()/2,64,64,0)
	
	surface.SetMaterial( Material("vgui/crosshairs/crosshair6") )
	surface.SetDrawColor(255,200,helper,1)
	surface.DrawTexturedRectRotated(ScrW()/2,ScrH()/2,64,64,0)
	

	

	
	surface.SetMaterial( Material("ob_icons/"..Icon..".png") )
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRectRotated(BaseX,BaseY,Size,Size,0)
	
	surface.SetFont( "Oblivion" )
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos( BaseX + Size/2 + 5 , BaseY - Size/2 ) 
	surface.DrawText( HelpText )
	
	surface.SetFont( "Oblivion" )
	surface.SetTextColor( 255, 255, 255, 255 )
	surface.SetTextPos( BaseX + Size/2 + 5, BaseY ) 
	surface.DrawText( HelpText2 )
	
end

function UpdateSpell(self)
	--if SERVER then return end
	
	--print("what")

	--print("Updating Spell...")

	if CLIENT then
	self.Text = self.DamageType .. " " .. self.Damage .. "pts "
			
		if self.Radius >= 2 then
			self.Text = self.Text .. "in " .. self.Radius .. "ft "
		end
			
		if self.Duration >= 2 then
			self.Text = self.Text .. "for " .. self.Duration .. "sec "
		end
			
	self.Text = self.Text .. "on " .. self.Method
	self.Text2 = self.Cost .. " mana"
	end
	
end





function SpellTarget(self)
	
	if CLIENT then
		--print("Casting on Target...")
	end

	if SERVER then
		local ent = ents.Create ("ent_bur_magic_base");	
			ent:SetPos(self.Owner:GetShootPos() - Vector(0,0,5))
			ent:SetAngles(self.Owner:EyeAngles())
			ent:SetOwner(self.Owner)	
			ent.Cost = self.Cost
			ent.Method = self.Method
			ent.DamageType = self.DamageType
			ent.Damage = self.Damage
			ent.Duration = self.Duration
			ent.Radius = self.Radius
			ent.CollisionRadius = self.CollisionRadius
			ent.VelMul = self.VelMul
			ent.LoopSound = self.LoopSound
			ent.RColor= self.RColor
			ent.GColor = self.GColor
			ent.BColor = self.BColor
			ent.AColor = self.AColor
			ent.TrailLength = self.TrailLength
			ent.TrailWidthStart = self.TrailWidthStart
			ent.TrailWidthEnd = self.TrailWidthEnd
			ent.TrailTexture = self.TrailTexture
			ent.Effect = self.Effect
			ent.TravelDamage = self.TravelDamage
			ent.FranticEffect = self.FranticEffect
			ent.ExplosionEffect = self.ExplosionEffect						
		ent:Spawn();	

		local phys = ent:GetPhysicsObject();
		if IsValid(phys) then
			phys:SetVelocity((self.Owner:EyeAngles():Forward() * 800 * self.VelMul))
			phys:AddAngleVelocity(Vector(20000,20000,20000))
		end
	end
	
	
	--print(self.Damage)
	
	
	
end


function SpellSelf(self)




	if self.DamageType == "heal" then
		SpellHeal(self)
	elseif self.DamageType == "armor" then
		SpellShield(self)
	elseif self.DamageType == "conjure" then
		SpellConjure(self)
	end
end






function SpellHeal(self)
	self.HealValue = self.Damage
	if self.Duration > 1 then 		
		timer.Create(self.Owner:EntIndex() .. self.CastWhen .. "healtick",1, self.Duration,function()
			if self.Owner:Alive() == false then 
				timer.Destroy(self.Owner:EntIndex() .. self.CastWhen .. "healtick")
			return end	
				
			if self.Owner:Health() + self.HealValue > 100 then 
				self.Owner:SetHealth(100) 
			else
				self.Owner:SetHealth(self.Owner:Health() + self.HealValue)
			end
		end)
	else
		if self.Owner:Health() + self.HealValue > 100 then 
			self.Owner:SetHealth(100)
		else
			self.Owner:SetHealth(self.Owner:Health() + self.HealValue) 
		end
	end
end


function SpellConjure(self)

	self.MinionHealth = self.Damage
	for k,v in pairs(ents.FindByClass("npc_fastzombie")) do
		if v:GetOwner() == self.Owner then v:Remove() end
	end
				
	local minion = ents.Create("npc_fastzombie")
		minion:SetPos(self.Owner:GetPos() + self.Owner:GetForward()*50)
		minion:SetAngles(self.Owner:GetAngles())
		minion:SetOwner(self.Owner)
		minion:AddEntityRelationship(self.Owner, D_LI, 99 )
		--minion:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_PERFECT )
		--minion:SetKeyValue("spawnflags","256")
		minion:Spawn()
		minion:SetHealth(self.MinionHealth)
		minion:SetLastPosition( self.Owner:GetEyeTrace().HitPos + Vector(0,0,25) )
		minion:SetSchedule( SCHED_FORCED_GO_RUN )
	timer.Simple(self.Duration, function() if minion:IsValid() then minion:Remove() end end)
end

function SpellShield(self)
	
	self.ArmorKill = false
	self.ArmorValue = self.Damage
	timer.Simple(self.Duration, function() self.ArmorKill = true; self.Owner:SetArmor(0) end)
	
	timer.Create(self.Owner:EntIndex() .. self.CastWhen .. "armortick",0.1, self.Duration*10,function() 
		if self.Owner:Alive() and not self.ArmorKill then
			self.Owner:SetArmor(self.ArmorValue)
		else 
			timer.Destroy(self.Owner:EntIndex() .. self.CastWhen .. "healtick")
			self.Owner:SetArmor(0)
			end
	end)
	
end

function SetUpSpells(self)
	--if SERVER then return end
	--print("Setting Up Spells..")
	if self.WeaponSlot == 1 then -- W Top Offensive
		self.Cost = 14
		self.Method = "target"
		self.DamageType = "fire"
		self.Damage = 8
		self.Duration = 5
		self.Radius = 10
		self.CollisionRadius = 2
		self.VelMul = 0.9
		self.LoopSound = "fx/spl/spl_fireball_travel_lp.wav"
		self.RColor = 255
		self.GColor = 200
		self.BColor = 0
		self.AColor = 255
		self.TrailLength = 0.25
		self.TrailWidthStart = 50
		self.TrailWidthEnd = 1
		self.TrailTexture = "trails/laser.vmt"
		self.Effect = "sentry_rocket_fire"
		self.TravelDamage = false
		self.FranticEffect = false
		self.ExplosionEffect = true
	elseif self.WeaponSlot == 2 then -- WD Top Right Offensive
		self.Cost = 5
		self.Method = "target"
		self.DamageType = "frost"
		self.Damage = 5
		self.Duration = 5
		self.Radius = 25
		self.CollisionRadius = 5
		self.VelMul = 0.5
		self.LoopSound = "fx/spl/spl_frost_travel_lp.wav"
		self.RColor = 0
		self.GColor = 255
		self.BColor = 255
		self.AColor = 255
		self.TrailLength = 0.5
		self.TrailWidthStart = 100
		self.TrailWidthEnd = 0
		self.TrailTexture = "trails/laser.vmt"
		self.Effect = "critical_rocket_blue"
		self.TravelDamage = true
		self.FranticEffect = false
		self.ExplosionEffect = false
	elseif self.WeaponSlot == 3 then -- D Right Blink
		self.Cost = 60
		self.Method = "target"
		self.DamageType = "unlock"
		self.Damage = 100
		self.Duration = 1
		self.Radius = 0
		self.CollisionRadius = 1
		self.VelMul = 1
		self.LoopSound = "fx/spl/spl_alteration_travel_lp.wav"
		self.RColor = 255
		self.GColor = 255
		self.BColor = 0
		self.AColor = 255
		self.TrailLength = 0.1
		self.TrailWidthStart = 10
		self.TrailWidthEnd = 1
		self.TrailTexture = "trails/laser.vmt"
		self.Effect = "community_sparkle"
		self.TravelDamage = false
		self.FranticEffect = false
		self.ExplosionEffect = true
	elseif self.WeaponSlot == 4 then -- SD Bottom Right Defensive
		self.Cost = 17
		self.Method = "self"
		self.DamageType = "conjure"
		self.Damage = 100
		self.Duration = 30
		self.Radius = 0
		self.CollisionRadius = nil
		self.VelMul = nil
		self.LoopSound = nil
		self.RColor = nil
		self.GColor = nil
		self.BColor = nil
		self.AColor = nil
		self.TrailLength = nil
		self.TrailWidthStart = nil
		self.TrailWidthEnd = nil
		self.TrailTexture = nil
		self.Effect = nil
		self.TravelDamage = nil
		self.FranticEffect = nil
		self.ExplosionEffect = nil
	elseif self.WeaponSlot == 5 then -- S Bottom Heal
		self.Cost = 20
		self.Method = "self"
		self.DamageType = "heal"
		self.Damage = 2
		self.Duration = 5
		self.Radius = 0
		self.CollisionRadius = nil
		self.VelMul = nil
		self.LoopSound = nil
		self.RColor = nil
		self.GColor = nil
		self.BColor = nil
		self.AColor = nil
		self.TrailLength = nil
		self.TrailWidthStart = nil
		self.TrailWidthEnd = nil
		self.TrailTexture = nil
		self.Effect = nil
		self.TravelDamage = nil
		self.FranticEffect = nil
		self.ExplosionEffect = nil
	elseif self.WeaponSlot == 6 then -- SA Bottom Left Defensive
		self.Cost = 50
		self.Method = "self"
		self.DamageType = "armor"
		self.Damage = 100
		self.Duration = 15
		self.Radius = 0
		self.CollisionRadius = nil
		self.VelMul = nil
		self.LoopSound = nil
		self.RColor = nil
		self.GColor = nil
		self.BColor = nil
		self.AColor = nil
		self.TrailLength = nil
		self.TrailWidthStart = nil
		self.TrailWidthEnd = nil
		self.TrailTexture = nil
		self.Effect = nil
		self.TravelDamage = nil
		self.FranticEffect = nil
		self.ExplosionEffect = nil
	elseif self.WeaponSlot == 7 then -- A Left Dash
		self.Cost = 80
		self.Method = "target"
		self.DamageType = "pure"
		self.Damage = 100
		self.Duration = 1
		self.Radius = 1
		self.CollisionRadius = 5
		self.VelMul = 0.25
		self.LoopSound = "fx/spl/spl_destruction_travel_lp.wav"
		self.RColor = 255
		self.GColor = 255
		self.BColor = 255
		self.AColor = 255
		self.TrailLength = 0.5
		self.TrailWidthStart = 32
		self.TrailWidthEnd = 1
		self.TrailTexture = "trails/laser.vmt"
		self.Effect = "critical_rocket_red"
		self.TravelDamage = false
		self.FranticEffect = false
		self.ExplosionEffect = true
	elseif self.WeaponSlot == 8 then -- WA Top Left Offensive
		self.Cost = 15
		self.Method = "target"
		self.DamageType = "shock"
		self.Damage = 50
		self.Duration = 1
		self.Radius = 1
		self.CollisionRadius = 1
		self.VelMul = 2
		self.LoopSound = "fx/spl/spl_shock_travel_lp.wav"
		self.RColor = 255
		self.GColor = 255
		self.BColor = 255
		self.AColor = 255
		self.TrailLength = 1
		self.TrailWidthStart = 5
		self.TrailWidthEnd = 5
		self.TrailTexture = "trails/electric.vmt"
		self.Effect = "critical_rocket_blue"
		self.TravelDamage = false
		self.FranticEffect = true
		self.ExplosionEffect = true
	end
end

function EmitEffects(self)

	--Serverside
	
	
	
	if self.Cost >= self.Weapon:Clip1() then
		self:EmitSound("fx/spl/fail/spl_destruction_fail.wav",500,100)
	return end
	
	if self.DamageType == "fire" then
		self.CastSound = "fx/spl/spl_fireball_cast.wav"
	elseif self.DamageType == "frost" then
		self.CastSound = "fx/spl/spl_frost_cast.wav"
	elseif self.DamageType == "shock" then
		self.CastSound = "fx/spl/spl_shock_cast.wav"
	elseif self.DamageType == "heal" then
		self.CastSound = "fx/spl/spl_restoration_cast.wav"
	elseif self.DamageType == "pure" then
		self.CastSound = "fx/spl/spl_destruction_cast.wav"
	elseif self.DamageType == "unlock" then
		self.CastSound = "fx/spl/spl_alteration_cast.wav"
	elseif self.DamageType == "conjure" then
		self.CastSound = "fx/spl/spl_conjuration_cast.wav"
	elseif self.DamageType == "armor" then
		self.CastSound = "fx/spl/spl_alteration_cast.wav"
	else end
	
	self.SoundRand = math.Rand(-5,5)
	self:EmitSound(self.CastSound, 500, 100 + self.SoundRand )
end





