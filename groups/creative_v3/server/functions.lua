userSource = function(user_id) -- Função que pega a source do player.
    return vRP.getUserSource(user_id) or vRP.userSource(user_id) or vRP.Source(user_id)
end

userId = function(source)
    return vRP.getUserId(source) or vRP.Passport(source)
end
userIdentity = function(user_id)
    return vRP.getUserIdentity(user_id) or vRP.userIdentity(user_id) or vRP.Identity(user_id) or {name = " ", name2 = " ", phone = " "}
end

prepare = vRP.prepare
query = function(name,table)
    local resp = vRP.query(name,table)
    if resp and type(resp) == "table" then
        return resp
    else
        return nil
    end
end
execute = vRP.execute

groupsPermission = function(source)
    return true
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
    Wait(600) -- IMPORTANTE PARA EVITAR SOBRECARGA! Caso queira reduzir/aumentar o tempo para testes, sinta-se livre.
    if group then
        local groups = query("dk_groups/get_groups", {permiss = group})
        if groups and type(groups) == "table" and groups[1] then
            for k,v in pairs(groups) do
                
                if not members[tonumber(v.user_id)] then
                    members[tonumber(v.user_id)] = {id = v.user_id, leader = leader}
                end
            end
            Wait(500)
        end
        return members
    end
end

checkInGroup = function(user_id,group)
    if user_id and group then
        Wait(200)
        local consult = query("vRP/get_group",{ user_id = user_id, permiss = tostring(group) })
        if consult and type(consult) == "table" and consult[1] then
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
        if not vRP.hasPermission(target_id,tostring(group)) then
            vRP.insertPermission(target_id,tostring(group))
            vRP.execute("vRP/add_group",{ user_id = target_id, permiss = tostring(group) })
            groupsLog("**ID:** "..userId(source).." \n **MEMBRO:** "..target_id.." \n **GRUPO:** "..group,"ADICIONOU MEMBRO")
            return true
        end
    end
    return false
end

removeGroupMember = function(source,target_id,group,groupName)
    if target_id then
        if vRP.hasPermission(target_id,group) then
            local psource = userSource(target_id)
            if psource then
                vRP.removePermission(psource,group)
            end
            vRP.execute("vRP/del_group",{ user_id = target_id, permiss = group })
        end
    end
    groupsLog("**ID:** "..userId(source).." \n **MEMBRO:** "..target_id.." \n **GRUPO:** "..group,"REMOVEU MEMBRO")
end

groupsPayment = function(user_id,amount,group)
    local canPay = vRP.paymentBank(user_id,amount)
    if canPay then
        groupsLog("**ID:** "..user_id.." \n **QUANTIDADE:** "..amount.." \n **GRUPO:** "..group,"ADICIONOU CAIXA")
    end
    return canPay
end

groupsReceive = function(user_id,amount,group)
    vRP.addBank(user_id,amount)
    groupsLog("**ID:** "..user_id.." \n **QUANTIDADE:** "..amount.." \n **GRUPO:** "..group,"RETIROU CAIXA")
end

AddEventHandler("vRP:playerSpawn",function(user_id,source,first_spawn)
    TriggerEvent("dk_groups/sendAction","update",user_id,{online = true})
end)
AddEventHandler("vRP:playerLeave",function(user_id,source,first_spawn)
    TriggerEvent("dk_groups/sendAction","update",user_id,{online = false,lastLogin = os.time()})
end)

-- -- ADICIONAR EM GROUP
-- TriggerEvent("dk_groups/sendAction","add",parseInt(args[1]),args[2])
-- -- ADICIONAR EM UNGROUP
-- TriggerEvent("dk_groups/sendAction","remove",parseInt(args[1]),args[2])