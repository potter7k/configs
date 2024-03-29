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

local splitString = function(str,symbol)
	local Number = 1
	local tableResult = {}

	if not symbol then
		symbol = "-"
	end

	for str in string.gmatch(str,"([^"..symbol.."]+)") do
		tableResult[Number] = str
		Number = Number + 1
	end

	return tableResult
end

local groupsLog = function(message,title)
    local webhook = "" -- Webhook logs aqui
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

groupMembers = function(members,group,leader)
    Wait(3000) -- IMPORTANTE PARA EVITAR SOBRECARGA! Caso queira reduzir/aumentar o tempo para testes, sinta-se livre.
    if group then
        local splited = splitString(group,"//")
        if splited and splited[1] and splited[2] then
            local gmembers = vRP.DataGroups(splited[1])
            if gmembers then
                for id,num in pairs(gmembers) do
                    if id and not members[tonumber(id)] and tostring(num) == splited[2] then
                        members[tonumber(id)] = {id = tonumber(id), leader = leader}
                    end
                end
            end
        end
        return members
    end 
end

checkInGroup = function(user_id,group)
    if user_id and group then
        Wait(200)
        local splited = splitString(group,"//")
        if splited and splited[1] and splited[2] then
            local gData = vRP.DataGroups(splited[1])
            if gData and gData[tostring(user_id)] and tostring(gData[tostring(user_id)]) == splited[2] then
                return true
            end
        end
    end
    return false
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
        local splited = splitString(group,"//")
        vRP.SetPermission(target_id,splited[1],splited[2])
        groupsLog("**ID:** "..userId(source).." \n **MEMBRO:** "..target_id.." \n **GRUPO:** "..group,"ADICIONOU MEMBRO")
        return true
    end
    return false
end

removeGroupMember = function(source,target_id,group,groupName)
    if target_id then
        local splited = splitString(group,"//")
        vRP.RemovePermission(target_id,splited[1])
    end
    groupsLog("**ID:** "..userId(source).." \n **MEMBRO:** "..target_id.." \n **GRUPO:** "..group,"REMOVEU MEMBRO")
end

groupsPayment = function(user_id,amount,group)
    local canPay = vRP.PaymentBank(user_id,amount)
    if canPay then
        groupsLog("**ID:** "..user_id.." \n **QUANTIDADE:** "..amount.." \n **GRUPO:** "..group,"ADICIONOU CAIXA")
    end
    return canPay
end

groupsReceive = function(user_id,amount,group)
    vRP.GiveBank(user_id,amount)
    groupsLog("**ID:** "..user_id.." \n **QUANTIDADE:** "..amount.." \n **GRUPO:** "..group,"RETIROU CAIXA")
end

AddEventHandler("Connect",function(user_id,source,first_spawn)
    TriggerEvent("dk_groups/sendAction","update",user_id,{online = true})
end)
AddEventHandler("Disconnect",function(user_id,source,first_spawn)
    TriggerEvent("dk_groups/sendAction","update",user_id,{online = false,lastLogin = os.time()})
end)


-- -- ADICIONAR EM GROUP
-- TriggerEvent("dk_groups/sendAction","add",parseInt(args[1]),args[2])
-- -- ADICIONAR EM UNGROUP
-- TriggerEvent("dk_groups/sendAction","remove",parseInt(args[1]),args[2])
