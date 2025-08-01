local spawnedNPC = nil

RegisterCommand("spawnnpc", function()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local forwardVector = GetEntityForwardVector(playerPed)
    local spawnPos = coords + forwardVector * 2.0 -- spawn 2 meters in front

    local model = `a_m_m_business_01`

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end

    spawnedNPC = CreatePed(4, model, spawnPos.x, spawnPos.y, spawnPos.z, 0.0, true, true)
    SetEntityAsMissionEntity(spawnedNPC, true, true)
    SetPedCanRagdoll(spawnedNPC, true)
    SetPedFleeAttributes(spawnedNPC, 0, 0)
    SetPedCombatAttributes(spawnedNPC, 46, true)
    SetPedMaxHealth(spawnedNPC, 300)
    SetEntityHealth(spawnedNPC, 300)

    TriggerEvent("chat:addMessage", {
        args = { "^2NPC spawned! Health: 300" }
    })
end, false)

RegisterCommand("checknpc", function()
    if spawnedNPC and DoesEntityExist(spawnedNPC) then
        local currentHealth = GetEntityHealth(spawnedNPC)
    TriggerEvent("chat:addMessage", {
        args = { "^2NPC! Health: " .. currentHealth}
    })
    else
        SetNotificationTextEntry("STRING")
        AddTextComponentString("No NPC exists.")
        DrawNotification(false, false)
    end
end, false)

-- Monitor damage from player and notify
CreateThread(function()
    while true do
        Wait(100)
        if spawnedNPC and DoesEntityExist(spawnedNPC) then
            if HasEntityBeenDamagedByEntity(spawnedNPC, PlayerPedId(), true) then
                ClearEntityLastDamageEntity(spawnedNPC)
                local currentHealth = GetEntityHealth(spawnedNPC)
                SetNotificationTextEntry("STRING")
                AddTextComponentString("NPC Health: " .. currentHealth)
                DrawNotification(false, false)
            end
        end
    end
end)
