# <b>Bubbie's Bob NPC</b>
Download from <a href="http://bubbie.ga/bob/">HERE</a> or <a href="http://steamcommunity.com/sharedfiles/filedetails/?id=705919581">HERE</a></b>
# Reporting issues:
If you're going to report an issue, please include any errors if there are any.
# Known bugs (don't report these!):
On certain points on gm_flatgrass, Bob's AI may stop working. Unknown if this happens on other maps.
Only report this if this occurs <b>everywhere on the map.</b> Error usually given:<br>
<sub>NextBot [173][bobe] Error: gamemodes/base/entities/entities/base_nextbot/sv_nextbot.lua:289: bad argument #2 to 'Compute' (Vector expected, got nil)</sub><br>
<b>* This has been fixed in the newest update. *</b>
<b>If Bob still doesn't move, use nav_generate</b>
# Things that need to be done:<br>
Only react to deaths of other NPCs if Bob was close to the NPC. That'll be easy.<br>
# For Developers:
######<b><u>Hooks:</u></b><br>
BobChat - Called when Bob says something<br>
BobRemoved - Called when Bob is removed<br>
BobSpawned - Called when Bob is spawned - Entity spawner<br>
BobDrowned - Called when Bob drowns<br>
BobKilled - Called when Bob is killed - dmginfo<br>
BobBirdieKilled - Called when a bird is killed - Entity killer<br>
BobAngered - Called when Bob is angered - Entity provoker<br>
BobDeath - Called when Bob dies<br>
BobScared - Called when Bob is scared - Entity scarer<br>
BobInteract - Called when a player interacts with Bob - Entity player<br>
BobStuck - Called when Bob is stuck<br>
BobStop - Called when Bob is stopped<br>
######<b>Hook Examples:</b><br>
<sub>
hook.Add( "BobKilled", "ExampleHook1", function( dmginfo )<br>
	dmginfo:GetAttacker():ChatPrint( "Woah! How dare you kill Bob!" )<br>
end )
<br><br>
hook.Add( "BobInteract", "ExampleHook2", function( ply )<br>
	ply:SetVelocity( Vector(0, 0, 800) )<br>
end )<br>
</sub>
