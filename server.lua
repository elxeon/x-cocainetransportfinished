ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(30)
  end
end)

local metaDataName = "cardeliveryxp"

RegisterNetEvent("xeon_cardelivery:start_cooldown")
AddEventHandler("xeon_cardelivery:start_cooldown", function()
	local src = source
	local Player = ESX.GetPlayerFromId(src)

	cdCooldown = true
	TriggerClientEvent("x-cocainetransport:update-cooldown", -1, cdCooldown)

	if Player.PlayerData.metadata[metaDataName] ~= nil then
		TriggerClientEvent("x-cocainetransport:client-receive-rank", src, Player.PlayerData.metadata[metaDataName])
	else
		TriggerClientEvent("x-cocainetransport:client-receive-rank", src, 0)
	end

	CreateThread(function()
		for cooldownTime = cooldown, 0, -1 do
			Citizen.Wait(1000)
			secondsLeft = cooldownTime
		end
		cdCooldown = false
		TriggerClientEvent("x-cocainetransport:update-cooldown", -1, cdCooldown)
	end)
end)

RegisterNetEvent("x-cocainetransport:cooldown-request")
AddEventHandler("x-cocainetransport:cooldown-request", function()
	local src = source
	TriggerClientEvent("x-cocainetransport:update-cooldown", src, cdCooldown)
end)

RegisterNetEvent("x-cocainetransport:request-cooldown-time")
AddEventHandler("x-cocainetransport:request-cooldown-time", function()
	TriggerClientEvent("xeon:Notify", source, (text_cooldown .. " - " .. secondsLeft .. " " .. text_secondsLeft), "primary", 3000)
end)


RegisterNetEvent('x-cocainetransport:server:receiveCB', function()
	local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem("bread", 1)
end)