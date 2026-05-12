CreateThread(function()
    -- Wait until the player has fully loaded
    while not NetworkIsSessionStarted() do
        Wait(0)
    end

    -- Close the loading screen
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
end)
