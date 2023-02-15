local scrw,scrh = ScrW(), ScrH()

local function ClientInit()
    LocalPlayer().parts = {
        [1] = math.Clamp(100,0,100),
        [2] = math.Clamp(100,0,100),
        [3] = math.Clamp(100,0,100),
        [4] = math.Clamp(100,0,100),
        [5] = math.Clamp(100,0,100),
        [6] = math.Clamp(100,0,100),
        [7] = math.Clamp(100,0,100)
       }
       LocalPlayer().partsName = {
           [1] = "Head",
           [2] = "Chest",
           [3] = "Stomach",
           [4] = "Left Arm",
           [5] = "Right Arm",
           [6] = "Left Leg",
           [7] = "Right Leg"
       }
end

net.Receive("HealthReset",function()
    ClientInit()
    print("Init completed")
end)

net.Receive("PartHurt",function(ply,len)
    local dmg = net.ReadFloat()
    local damagedPart = net.ReadInt(6)
    LocalPlayer().parts[damagedPart] = LocalPlayer().parts[damagedPart] - (dmg * 2)
end)

net.Receive("FatalPartHurt",function(len,ply)
    local FataledPart = net.ReadInt(6)
    LocalPlayer().parts[FataledPart] = 0
end)

hook.Add("HUDPaint","ReduxHealthHUD",function()
    if not LocalPlayer().parts and not LocalPlayer().partsName then ClientInit() return end
    for k,v in pairs(LocalPlayer().parts) do
        draw.RoundedBox(10,scrw * 0.004,(k + 12.5) * 45,100 * 1.5,25,Color(0,0,0,50))
    end

    for k,v in pairs(LocalPlayer().parts) do
        draw.RoundedBox(10,scrw * 0.004,(k + 12.5) * 45,v * 1.5,25,Color(255,255,255))
    end

    for k,v in pairs(LocalPlayer().partsName) do
        draw.SimpleText(v,"Trebuchet24",scrw * 0.085,(k + 12.5) * 45,Color(255,255,255))
    end
    --[[for i = 2, table.Count(LocalPlayer().parts) do
        draw.RoundedBox(5,500,i * 50,LocalPlayer().parts[i],25,Color(255,255,255))
    end
    --]]
end)