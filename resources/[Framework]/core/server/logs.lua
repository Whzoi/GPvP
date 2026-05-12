-- local txadmin_Logs = "https://discord.com/api/webhooks/1437133335880143040/n6QpfjcMXEYbg0UDTz9Lwx6lAhKjICXnF5oC_b32V-UhRePXbV4q8LTwhYc7q3hO8DnQ"

-- local function sendToDisc(title, message)
--     exports['admin']:sendToDiscord(txadmin_Logs, title, message)
-- end

-- AddEventHandler('txAdmin:events:playerKicked', function(eventData)

--     local target = eventData.target
--     local author = eventData.author
--     local reason = eventData.reason

--     sendToDisc('Player Kicked', "Name: **" .. GetPlayerName(target) .. "** \nAdmin: **" .. author .. "** \nReason: **" .. reason .. "**")
-- end)

-- AddEventHandler('txAdmin:events:playerWarned', function(eventData)

--     local target = eventData.target
--     local author = eventData.author
--     local reason = eventData.reason
--     local id = eventData.actionId

--     sendToDisc('Player Warned', "Name: **" .. GetPlayerName(target) .. "** \nAdmin: **" .. author .. "** \nReason: **" .. reason .. "**\nID: **" .. id .. "**")

-- end)

-- AddEventHandler('txAdmin:events:playerBanned', function(eventData)

--     local target = eventData.targetName
--     local author = eventData.author
--     local reason = eventData.reason
--     local id = eventData.actionId
--     local exp = eventData.expiration
--     local playername = ""

--     if not exp then
--         exp = 'Never'
--     else
--         exp = os.date('%c', exp)
--     end 

--     if (type(target) == "table") then 
--         playername = "`Offline Ban`"
--     else 
--         playername = target
--     end
    
--     sendToDisc('Player Banned', "Name: **" .. playername .. "** \nAdmin: **" .. author .. "** \nReason: **" .. reason .. "**\nID: **" .. id .. "**\nExpires: **" .. exp .. "**")

-- end)

-- AddEventHandler('txAdmin:events:announcement', function(eventData)

--     local author = eventData.author
--     local msg = eventData.message
    
--     sendToDisc('Announcement', "Admin: **" .. author .. "**\nMessage: **" .. msg .. "**")
-- end)

-- AddEventHandler('txAdmin:events:configChanged', function(eventData)
--     sendToDisc('Config Changed', "TxAdmin config changes made.")
-- end)

-- AddEventHandler('txAdmin:events:serverShuttingDown', function(eventData)

--     local delay = eventData.delay
--     local author = eventData.author
--     local msg = eventData.message
        
        
--     sendToDisc('Server Shutdown', "Author: **" .. author .. "**\nMessage: **" .. msg .. "**\nDelay: **" .. delay .. "ms**")
-- end)

-- AddEventHandler('txAdmin:events:actionRevoked', function(eventData)

--     local actionAuthor = eventData.actionAuthor
--     local author = eventData.revokedBy
--     local target = eventData.playerName
--     local reason = eventData.actionReason
--     local actionType = eventData.actionType
        
--     sendToDisc('Action Revoked', "By admin: **" .. author .. "**\nOriginal admin: **" .. actionAuthor .. "**\nPlayer: **" .. target .. "**\nType: **" .. actionType .. "**\nReason: **" .. reason .. "**")
-- end)

-- local function getPlayerName(src)
--     return GetPlayerName(src) or "unknown"
-- end

-- local actionMessages = {
--     playerModeChanged = {
--         godmode = "Enabled godmode",
--         noclip = "Enabled noclip",
--         superjump = "Enabled super jump",
--         none = "Disabled godmode/noclip/super jump",
--         default = "Changed player mode to unknown"
--     },
--     teleportWaypoint = "Teleported to a waypoint",
--     teleportCoords = function(data)
--         if type(data) ~= 'table' then return end
--         local x, y, z = data.x or 0.0, data.y or 0.0, data.z or 0.0
--         return ("teleported to coordinates (x=%.3f, y=%.3f, z=%.3f)"):format(x, y, z)
--     end,
--     spawnVehicle = function(data)
--         if type(data) ~= 'string' then return end
--         return "Spawned a vehicle (model: " .. data .. ")"
--     end,
--     deleteVehicle = "Deleted a vehicle",
--     vehicleRepair = "Repaired their vehicle",
--     vehicleBoost = "Boosted their vehicle",
--     healSelf = "Healed themself",
--     healAll = "Healed all players!",
--     clearArea = function(data)
--         if type(data) ~= 'number' then return end
--         return "Cleared an area with " .. data .. "m radius"
--     end,
--     spectatePlayer = function(data)
--         return 'Started spectating player ' .. getPlayerName(data)
--     end,
--     freezePlayer = function(data)
--         return 'Toggled freeze on player ' .. getPlayerName(data)
--     end,
--     teleportPlayer = function(data)
--         if type(data) ~= 'table' then return end
--         local playerName = getPlayerName(data.target)
--         local x = data.x or 0.0
--         local y = data.y or 0.0
--         local z = data.z or 0.0
--         return ("Teleported to player %s (x=%.3f, y=%.3f, z=%.3f)"):format(playerName, x, y, z)
--     end,
--     healPlayer = function(data)
--         return "Healed player " .. getPlayerName(data)
--     end,
--     summonPlayer = function(data)
--         return "Summoned player " .. getPlayerName(data)
--     end,
--     drunkEffect = function(data)
--         return "Triggered drunk effect on " .. getPlayerName(data)
--     end,
--     setOnFire = function(data)
--         return "Set ".. getPlayerName(data) .." on fire" 
--     end,
--     wildAttack = function(data)
--         return "Triggered wild attack on " .. getPlayerName(data)
--     end,
--     showPlayerIDs = function(data)
--         if type(data) ~= 'boolean' then return end
--         if data then
--             return "Turned admin nametags on"
--         else
--             return "Turned admin nametags off"
--         end
--     end
-- }

-- local function getMessage(action, data)
--     local message = "Unknown action"
--     local actionMessage = actionMessages[action]

--     if type(actionMessage) == 'function' then
--         message = actionMessage(data)
--     elseif type(actionMessage) == 'table' then
--         message = actionMessage[data] or actionMessage.default or "Unknown action"
--     elseif type(actionMessage) == 'string' then
--         message = actionMessage
--     end

--     return message
-- end

-- AddEventHandler('txsv:logger:menuEvent', function(source, action, allowed, data)
--     if not allowed then return end

--     local message = getMessage(action, data)
--     if message == "Unknown action" then
--         return
--     end

--     local author = GetPlayerName(source)
--     sendToDisc('Actions', "Admin: **" .. author .. "**\nAction: **" .. message .. "**")
-- end)
