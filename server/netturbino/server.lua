ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent("Garbage:Reward")
AddEventHandler("Garbage:Reward", function(Amount, Boolean, data)
    if Boolean and data == 'mangiamerdadown' then
        local Player = ESX.GetPlayerFromId(source)

        Player.addAccountMoney(Shared.AccountReward, Amount)
    end
end)