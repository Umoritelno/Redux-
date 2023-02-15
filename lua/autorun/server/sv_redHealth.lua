local plym = FindMetaTable("Player")
util.AddNetworkString("HealthReset")
util.AddNetworkString("PartHurt")
util.AddNetworkString("FatalPartHurt")

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
end)

hook.Add("EntityTakeDamage","PartsDamage",function(target,dmg)
    if target:IsPlayer() and IsValid(target) and target:LastHitGroup() != 0 then
        if dmg:IsBulletDamage() then
            if target.parts[target:LastHitGroup()] > (dmg:GetDamage() * 5) then 
            target.parts[target:LastHitGroup()] = target.parts[target:LastHitGroup()] - (dmg:GetDamage() * 2)
            net.Start("PartHurt")
            net.WriteFloat(dmg:GetDamage())
            net.WriteInt(target:LastHitGroup(),6)
            net.Send(target)
            elseif dmg:IsBulletDamage() and target.parts[target:LastHitGroup()] < (dmg:GetDamage() * 5) then 
            target.parts[target:LastHitGroup()] = 0
            target:EmitSound("npc/combine_soldier/die3.wav")
            net.Start("FatalPartHurt")
            net.WriteInt(target:LastHitGroup(),6)
            net.Send(target)
            elseif dmg:IsBulletDamage() and target.parts[target:LastHitGroup()] == 0 then 
            target:SetDamage(target:GetDamage() * 2)
            end 
        end 
    end 
    if target:IsPlayer() and IsValid(target) then 
        if dmg:IsExplosionDamage() then 
           for i = 2,3 do
            if target.parts[i] > dmg:GetDamage() then
                target.parts[i] = target.parts[i] - (dmg:GetDamage() * math.Rand(0.25,0.5))
                net.Start("PartHurt")
                net.WriteFloat(dmg:GetDamage() * math.Rand(0.25,0.5))
                net.WriteInt(i,6)
                net.Send(target)
            elseif target.parts[i] <= dmg:GetDamage() then 
                target.parts[i] = 0
                target:EmitSound("npc/combine_soldier/die3.wav")
                net.Start("FatalPartHurt")
                net.WriteInt(i,6)
                net.Send(target)
             end
           end
        end
    end 
    if target:IsPlayer() and IsValid(target) then 
        if dmg:IsFallDamage() then
            for i = 6,7 do
                if target.parts[i] > dmg:GetDamage() then
                    target.parts[i] = target.parts[i] - (dmg:GetDamage() * math.Rand(1,1.5))
                    net.Start("PartHurt")
                    net.WriteFloat(dmg:GetDamage() * math.Rand(1,1.5))
                    net.WriteInt(i,6)
                    net.Send(target)
                elseif target.parts[i] <= dmg:GetDamage() then 
                    target.parts[i] = 0
                    target:EmitSound("npc/combine_soldier/die3.wav")
                    net.Start("FatalPartHurt")
                    net.WriteInt(i,6)
                    net.Send(target)
                 end
            end
        end
    end 
end)

