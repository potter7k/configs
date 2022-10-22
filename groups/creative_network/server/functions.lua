userSource = function(user_id) -- Função que pega a source do player.
    return vRP.getUserSource(user_id) or vRP.userSource(user_id) or vRP.Source(user_id)
end

userId = function(source)
    return vRP.getUserId(source) or vRP.Passport(source)
end
userIdentity = function(user_id)
    return vRP.getUserIdentity(user_id) or vRP.userIdentity(user_id) or vRP.Identity(user_id) or {name = " ", name2 = " ", phone = " "}
end

prepare = vRP.Prepare
query = function(name,table)
    local resp = vRP.Query(name,table)
    if resp and type(resp) == "table" then
        return resp
    else
        return nil
    end
end
execute = vRP.Query

groupsPermission = function(source)
    return true
end

groupMembers = function(members,group,leader)
    Wait(3000) -- IMPORTANTE PARA EVITAR SOBRECARGA! Caso queira reduzir/aumentar o tempo para testes, sinta-se livre.
    if group then
        local gmembers = vRP.DataGroups(group)
        if gmembers then
            for id,_ in pairs(gmembers) do
                if not members[tonumber(id)] then
                    members[tonumber(id)] = {id = tonumber(id), leader = leader}
                end
            end
        end
        return members
    end 
end

checkInGroup = function(user_id,group)
    if user_id and group then
        Wait(200)
        local gData = vRP.DataGroups(group)
        if gData and gData[tostring(user_id)] then
            return true
        else
            return false
        end
    end
end

memberInformation = function(user_id)
    local identity = userIdentity(user_id)
    if identity and type(identity) == "table" then
        return {name = (identity.name or " ").." "..(identity.name2 or identity.firstname or " "), phone = identity.phone or " ", online = userSource(user_id), id = user_id}
    else
        return {name = " ", phone = " ", online = false, id = user_id}
    end
end

addGroupMember = function(source,target_id,group,groupName)
    if target_id then
        vRP.SetPermission(target_id,tostring(group))
        sendLog("**ID:** "..userId(source).." \n **MEMBRO:** "..target_id.." \n **GRUPO:** "..group,"ADICIONOU MEMBRO")
        return true
    end
    return false
end

removeGroupMember = function(source,target_id,group,groupName)
    if target_id then
        vRP.RemovePermission(target_id,tostring(group))
    end
    sendLog("**ID:** "..userId(source).." \n **MEMBRO:** "..target_id.." \n **GRUPO:** "..group,"REMOVEU MEMBRO")
end

groupsPayment = function(user_id,amount,group)
    local canPay = vRP.PaymentBank(user_id,amount)
    if canPay then
        sendLog("**ID:** "..user_id.." \n **QUANTIDADE:** "..amount.." \n **GRUPO:** "..group,"ADICIONOU CAIXA")
    end
    return canPay
end

groupsReceive = function(user_id,amount,group)
    vRP.GiveBank(user_id,amount)
    sendLog("**ID:** "..user_id.." \n **QUANTIDADE:** "..amount.." \n **GRUPO:** "..group,"RETIROU CAIXA")
end

AddEventHandler("Connect",function(user_id,source,first_spawn)
    TriggerEvent("dk_groups/sendAction","update",user_id,{online = "#4ba84b"})
end)
AddEventHandler("Disconnect",function(user_id,source,first_spawn)
    TriggerEvent("dk_groups/sendAction","update",user_id,{online = "#ce3737",lastLogin = os.time()})
end)

function sendLog(message,title)
    local webhook = "https://discord.com/api/webhooks/1029804915326996561/dGORgExq6OW31F0Y7xJGRzo7agQuPxoHFytibv9VqaLSPdEm2VSXIsW_nX9r8X_wJQEH"
	if webhook ~= "" then
		PerformHttpRequest(webhook,function(err,text,headers) end,"POST",json.encode({
			embeds = {
				{
					title = title,
					thumbnail = {
					url = serverImg
					}, 
					description = message,
					footer = { 
						text = "DK Logs - "..os.date("%d/%m/%Y - %H:%M:%S"), 
						icon_url = serverImg
					},
					color = 3092790 
				}
			}
		}),{ ['Content-Type'] = "application/json" })
	end
end