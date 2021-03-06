local assets =
{
    Asset("ANIM", "anim/light_ferns.zip"),
}

local prefabs =
{
    "foliage",
}

local NUM_VARIATIONS = 4

local function KillPlant(inst)
    inst._killtask = nil
    --inst.components.pickable.caninteractwith = false
    inst:ListenForEvent("animover", inst.Remove)
    inst.AnimState:PlayAnimation("wilt"..inst.variation)
	inst.Light:Enable(false)
end

local function OnBloomed(inst)
    inst:RemoveEventCallback("animover", OnBloomed)
    inst.AnimState:PlayAnimation("idle"..inst.variation, true)
    --inst.components.pickable.caninteractwith = true
    inst.Light:Enable(true)
    inst._killtask = inst:DoTaskInTime(5 + math.random(), KillPlant)
end

local function OnPicked(inst)--, picker, loot)
    if inst._killtask ~= nil then
        inst._killtask:Cancel()
        inst._killtask = nil
    end
    inst:RemoveEventCallback("animover", OnBloomed)
    inst:ListenForEvent("animover", inst.Remove)
    inst.AnimState:PlayAnimation("picked"..inst.variation)
end

local function fn()
   local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddLight()
	inst.Light:SetRadius(1.5)
    inst.Light:SetFalloff(.8)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(237 / 255, 237 / 255, 209 / 255)

	
    inst.AnimState:SetBank("forest_fern")
    inst.AnimState:SetBuild("light_ferns")
    inst.AnimState:PlayAnimation("bloom")

    inst:AddTag("stalkerbloom")
	inst:AddTag("NOCLICK")
    if math.random() < 0.2 then
inst.Transform:SetScale(0.65, 0.65, 0.65)
elseif math.random() < 0.2 then
inst.Transform:SetScale(0.5, 0.5, 0.5)
elseif math.random() < 0.2 then
inst.Transform:SetScale(0.3, 0.3, 0.3)
elseif math.random() < 0.2 then
inst.Transform:SetScale(0.7, 0.7, 0.7)
elseif math.random() < 0.2 then
inst.Transform:SetScale(0.55, 0.55, 0.55)
else
inst.Transform:SetScale(0.4, 0.4, 0.4)
end

    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

    --inst.SoundEmitter:PlaySound("dontstarve/creatures/together/stalker/flowergrow")

    inst.variation = math.random(NUM_VARIATIONS)
    if inst.variation > 1 then
        inst.variation = tostring(inst.variation)
        inst.AnimState:PlayAnimation("bloom"..inst.variation)
    else
        inst.variation = ""
    end

    --[[inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable.onpickedfn = OnPicked
    inst.components.pickable.quickpick = true
    inst.components.pickable.caninteractwith = false
    inst.components.pickable:SetUp("foliage", 1000000, inst.variation == "2" and 1 or 2)
    inst.components.pickable:Pause()
	]]
    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:ListenForEvent("animover", OnBloomed)

    ---------------------
    --MakeSmallBurnable(inst)
    --MakeSmallPropagator(inst)
    --Clear default handlers so we don't stomp our .persists flag
    --inst.components.burnable:SetOnIgniteFn(nil)
    --inst.components.burnable:SetOnExtinguishFn(nil)
    ---------------------

    

    inst.persists = false

    return inst
end

return Prefab("musha_fern2", fn, assets, prefabs)
