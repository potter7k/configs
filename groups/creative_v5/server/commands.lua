local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")


RegisterCommand("painel",function(source,args)
    TriggerClientEvent("dk_groups/toggleMenu",source)
end)