local function addSuggestion(commandName, commandDescription, arguments)
  TriggerEvent('chat:addSuggestion', "/" .. tostring(commandName), commandDescription, arguments)
end

local suggestions = {
  {
      name = "car",
      desc = "spawn any model"
  },
  {
      name = "kill",
      desc = "Die"
  },
  {
    name = "settings",
    desc = "[open game settings]"
  },

    {
    name = "ars",
    desc = "[Displays AR Spawn Codes]"
  },

      {
    name = "smgs",
    desc = "[Displays SMG Spawn Codes]"
  },

        {
    name = "pistols",
    desc = "[Displays Pistol Spawn Codes]"
  },
  {
    name = "togglecrosshair",
    desc = "[Toggle the Ingame Crosshair]"
  },
  {
    name = "dva",
    desc = "[DV All Vehicles]"
  },
  {
    name = "seat",
    desc = "[Seat (-1 - 2)]"
  },
  {
    name = "stats",
    desc = "[Check your Current Stats]"
  },
  {
    name = "clothing",
    desc = "[Clothing Menu]"
  },
  {
    name = "barber",
    desc = "[Barber Menu]"
  },
  {
    name = "crosssize",
    desc = "[Set Crosshair Size (1-10)]"
  },
  {
    name = "crosshair",
    desc = "[Set Crosshair Color (#FFFFFF)]"
  },
  

}

for _, suggestion in pairs(suggestions) do
  addSuggestion(suggestion.name, suggestion.desc, suggestion.args)
end



