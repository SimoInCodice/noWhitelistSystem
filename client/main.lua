local isVisible = false
local info = {
            name = 'John Doe',
            email = 'john.doe@example.com',
            money = 0,
            profilePic = exports["MugShotBase64"]:GetMugShotBase64(PlayerPedId(), true)
        }
local function openUI()
    isVisible = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'setVisible',
        status = true
    })

    info.profilePic = exports["MugShotBase64"]:GetMugShotBase64(PlayerPedId(), true)

    SendNUIMessage({
        action = 'setUserInfo',
        info = info
    })
end

local function closeUI()
    isVisible = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        action = 'setVisible',
        status = false
    })
end


RegisterCommand('opentoggle', function()
    isVisible = not isVisible
    if isVisible then
        openUI()
    else
        closeUI()
    end
end, false)

RegisterKeyMapping('opentoggle', 'Apri UI Svelte', 'keyboard', 'F5')


RegisterNUICallback('actionButton', function(data, cb)
    print('Dato ricevuto da Svelte:', data.value)
    -- Qui puoi integrare altre risorse (es. esportazioni di ESX/QBCore o eventi server)
    cb('ok')
end)

RegisterNUICallback('closeUI', function(data, cb)
    closeUI()
    print('Chiusura UI richiesta da Svelte')
    -- Qui puoi integrare altre risorse (es. esportazioni di ESX/QBCore o eventi server)
    cb('ok')
end)

CreateThread(function ()
    while true do
        Wait(1000)
        info.money = info.money + 1
        SendNUIMessage({
            action = 'setUserInfo',
            info = info
        })
    end
end)