local function checkKillerHasLOS(attacker, victim, killerClientId)
    attempt = 0
    for i=0,3,1 do
        if not HasEntityClearLosToEntityInFront(attacker, victim) and not HasEntityClearLosToEntity(attacker, victim, 17) and HasEntityClearLosToEntity_2(attacker, victim, 17) == 0 then
            attempt = attempt + 1
        end
        Wait(1500)
    end

    if (attempt >= 3) then
        TriggerServerEvent("admin:magicbullet", killerClientId)
    end
end

AddEventHandler('gameEventTriggered', function(event, data)
	if event ~= 'CEventNetworkEntityDamage' then return end
	local victim, victimDied = data[1], data[4]
	if not IsPedAPlayer(victim) then return end
	local player = PlayerId()
	local playerPed = PlayerPedId()
	if victimDied and NetworkGetPlayerIndexFromPed(victim) == player and (IsPedDeadOrDying(victim, true) or IsPedFatallyInjured(victim))  then
		local killerEntity, deathCause = GetPedSourceOfDeath(playerPed), GetPedCauseOfDeath(playerPed)

        for _, player in pairs(GetActivePlayers()) do
            if(killerEntity == GetPlayerPed(player)) then
                if killerEntity ~= playerPed then
                    attacker = GetPlayerPed(player)
                    checkKillerHasLOS(attacker, victim, GetPlayerServerId(player))
                end
            end
        end
	end
end)
