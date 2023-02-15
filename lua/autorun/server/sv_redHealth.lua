local plym = FindMetaTable("Player")
util.AddNetworkString("HealthReset")
util.AddNetworkString("PartHurt")
util.AddNetworkString("FatalPart")

function plym:ResetParts()
    self.parts = {
     [1] = math.Clamp(100,0,100),
     [2] = math.Clamp(100,0,100),
     [3] = math.Clamp(100,0,100),
     [4] = math.Clamp(100,0,100),
     [5] = math.Clamp(100,0,100),
     [6] = math.Clamp(100,0,100),
     [7] = math.Clamp(100,0,100)
    }
 end 

hook.Add("PlayerSpawn","Parts",function(ply)
    ply:ResetParts()
    net.Start("HealthReset")
    net.Send(ply)
    PrintTable(ply.parts)
end)

hook.Add("EntityTakeDamage","PartsDamage",function(target,dmg)
    print(dmg:GetDamage())
    if target:IsPlayer() and IsValid(target) then
        if dmg:IsBulletDamage() and target:LastHitGroup() != 0 and target.parts[target:LastHitGroup()] > (dmg:GetDamage() * 2) then
            target.parts[target:LastHitGroup()] = target.parts[target:LastHitGroup()] - (dmg:GetDamage() * 2)
            PrintTable(target.parts)
            net.Start("PartHurt")
            net.WriteFloat(dmg:GetDamage())
            net.WriteInt(target:LastHitGroup(),6)
            net.Send(target)
        elseif dmg:IsBulletDamage() and target:LastHitGroup() != 1 and target.parts[target:LastHitGroup()] < (dmg:GetDamage() * 2) then 
            target.parts[target:LastHitGroup()] = 0
            dmg:ScaleDamage(2)
            target:EmitSound("npc/combine_soldier/die3.wav")
            net.Start("FatalPart")
            net.WriteInt(target:LastHitGroup(),6)
            net.Send(target)
        end
    end
end)

