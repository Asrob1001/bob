AddCSLuaFile()
ENT.PrintName = "Bob"
ENT.Author = "Bubbie"
ENT.Category = "Bubbie's Bob"
ENT.Base = "base_nextbot"
ENT.Spawnable = true
ENT.Spawnable = true
ENT.AdminOnly = true

function BobChat( pname, msg, action )
	net.Start( "bobchat" )
	net.WriteString( pname )
	net.WriteString( msg )
	net.WriteBool( action )
	net.Broadcast()
end
net.Receive( "bobchat", function( ply )
pname = net.ReadString()
msg = net.ReadString()
action = net.ReadBool()
if action == true then
	chat.AddText( Color(0, 255, 255, 255), pname, " ", msg )
else
	chat.AddText( Color(0, 255, 255, 255), pname, Color(255, 255, 255, 255), ": " , msg )
end
end )

function FixedPrefix( prefix )
	if string.sub( prefix, 1, 4 ) == "npc_" then
		return "THAT " .. string.sub( prefix, 5 )
	elseif prefix == "bobe" then
		return "bob"
	else
		return prefix:GetName() -- Only now realised that this exists. :(
	end
end

function ENT:OnRemove()
	BobStop()
end

function ENT:Initialize()
	bobhideradius = 3000
	if SERVER then
		HappyBob( self )
		util.AddNetworkString( "bobchat" )
		BobChat( "Bob", "HELLO :D", false )
		self:SetModel( "models/kleiner.mdl" )
		BobSetNextUse( self, 0 )
		timer.Create( "Bob:D", 10, 0, function()
			BobChat( "Bob", table.Random( bob ), false )
		end )
		timer.Create( "MakeSureBobIsNotDrowning:D", 0, 0, function()
			if self:WaterLevel() > 0 then
				BobChat( "Bob", "OH MY GOD I'M DROWNING", false )
				BobChat( "Bob", "drowns :(", true )
				self:BecomeRagdoll( DamageInfo() )
				BobStop()
			end
		end )
	end
end
function ENT:OnKilled( dmginfo )
	if SERVER then
		hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
		BobChat( "Bob", "OH MY GOD YOU JUST SHOT ME", false )
		self:BecomeRagdoll( dmginfo )
		BobChat( "Bob", "dies :(", true )
		BobStop()
	end
end
function ENT:OnOtherKilled( victim, dmginfo )
	if SERVER then
		if victim:GetClass() == "player" then return end
		if string.find( victim:GetClass(), "zombi", 1 ) or string.find( victim:GetClass(), "antlion", 1 ) or string.find( victim:GetClass(), "headcrab", 1 ) or string.find( victim:GetClass(), "combine", 1 ) or string.find( victim:GetClass(), "barnacle", 1 )  then
			BobChat( "Bob", "Nice shot! :D" )
		return end
		if victim:GetClass() == "npc_crow" or victim:GetClass() == "npc_seagull" or victim:GetClass() == "npc_pigeon" then
			BobChat( "Bob", "Please don't harm our wildlife! D:" )
			dmginfo:GetAttacker():SetNWInt( "BobsBirdiesKilled", dmginfo:GetAttacker():GetNWInt( "BobsBirdiesKilled", 0 ) + 1 )
			if dmginfo:GetAttacker():GetNWInt( "BobsBirdiesKilled", 0 ) > 5 then
				AngryBob( self, dmginfo:GetAttacker() )
			end
		return end
		BobChat( "Bob", "OH MY GOD YOU JUST SHOT " .. string.upper( FixedPrefix( victim:GetClass() ) ) , false )
		if victim:GetClass() == "bobe" then
			BobChat( "Bob", "has a heart attack and dies :(", true )
			self:BecomeRagdoll( DamageInfo() )
			BobStop()
		return end
		if math.random( 1, 100 ) < 50 then
			bobhideradius = 8000
		else
			BobChat( "Bob", "has a heart attack and dies :(", true )
			self:BecomeRagdoll( DamageInfo() )
			BobStop()
		end
	end
end

function ENT:RunBehaviour()
	self:StartActivity( ACT_RUN )
	self:MoveToPos( self:FindSpot( "random", { type = 'hiding', radius = bobhideradius } ) )
	timer.Create( "MakeSureBobIsNotDisabled:D", 0.2, 0, self:RunBehaviour())
end

function BobSetNextUse( self, seconds )
	self:SetNWBool( "CanUse", false )
	timer.Create( "BobNextUse", seconds, 1, function()
		self:SetNWBool( "CanUse", true )
		timer.Destroy( "BobNextUse" )
	end )
end
function BobCanUse( self )
	if self:GetNWBool( "CanUse", true ) == false then
		return false
	else
		return true
	end
end

function ENT:Use( activator, caller, use, value )
	if BobCanUse( self ) then
		BobSetNextUse( self, 1 )
		self:SetUseType( SIMPLE_USE )
		local bobchat = { "hello " .. string.lower(caller:Nick()) .. "! :D", "this is fun", "how are you today? :D", "im just feeling amazing, " .. string.lower(caller:Nick()) .. "! :D", "what are you up to today? :D", "hi, my name is Bob! :D", "I feel like a rainbow!", "I feel like dancing! :D", "hello, friend! :D" }
		BobChat( "Bob", table.Random( bobchat ), false )
	end
end

function ENT:OnStuck()
	print( "Bob is stuck, so he has to die. :(" )
	BobChat( "Bob", "dies from claustrophobia :(", true ) -- Defined as fear of being stuck or having no escape, so why not? http://puu.sh/p9hqe/c8d8dbb8a8.png
	self:BecomeRagdoll( DamageInfo() )
end

function HappyBob( self )
	bob = { "I love running!", "I love everybody!", "Hello everybody!", "Who wants to play tag with me? :D", "RUNNING :D", "I love the wildlife!", "Bet you can't find me!", "Hey, play tag with me!", "Hey, let's play hide and seek!", "Everybody is beautiful! :D", "I love this! :D" }
end

function AngryBob( self, provoker )
	bob = { "You're a cruel evil monster, " .. provoker:Nick() .. "!", "Why would you shoot all those birds? >:(", "You're not my friend!", "I'm angry with you, " .. provoker:Nick() .. "!", "I hate you, " .. provoker:Nick() .. "!", "All those poor birdies are dead. ;-;" }
end

function DarkBob( self ) -- honestly need to get other shit done like Bob breaking at certain points on gm_construct before I get this done
	bob = { "Hey, what would your cold, lifeless and dead body look like? :D" }
end

function BobStop()
	timer.Destroy( "MakeSureBobIsNotDisabled:D" )
	timer.Destroy( "MakeSureBobIsNotDrowning:D" )
	timer.Destroy( "Bob:D" )
	timer.Destroy( "MakeSureBobIsNotDrowning2:D" )
end
