CreateThread(function()
    while true do
        local players = (#(GetActivePlayers()))
        SetDiscordAppId(1097975882452324382) -- id aplikacji / application's id

        --SetRichPresence("Gra razem z "..(players-1).." innymi osobami!") -- tekst wyświetlany w okienku aktywności / content of activity (text)
        SetRichPresence("Więcej informacji wkrótce...")

        local playerId = PlayerId()
        SetDiscordRichPresenceAsset("logo") -- nazwa obrazka wyświetlanego w okienku aktywności / image next to the text content
        SetDiscordRichPresenceAssetText(GetPlayerName(playerId)) -- tekst po najechaniu na obrazek / text displayed on image hover

        SetDiscordRichPresenceAssetSmall("id") -- nazwa mini obrazka wyświetlanego w okienku aktywności / small image next to the text content
        SetDiscordRichPresenceAssetSmallText("ID Gracza: "..GetPlayerServerId(playerId)) -- nazwa mini obrazka wyświetlanego w okienku aktywności / text displayed on small image hover

        --SetDiscordRichPresenceAction(0, "Dołącz na discord!", "https://discord.gg/wEamjX3D5T") -- przycisk akcji 0 / action button no. 1 (id, label, url)
	
	    Wait(20000)
    end
end)

-- "Pływa w kajaku razem z "..(players-1).." innymi osobami!"