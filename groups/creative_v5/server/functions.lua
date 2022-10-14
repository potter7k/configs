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
query = vRP.query
execute = vRP.execute

groupsPermission = function(source)
    return true
end

groupMembers = function(members,group,leader)
    if group then
        local groups = query("dk_groups/get_groups", {group = '%"'..group..'"%'})
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
        local data
        if userSource(user_id) then
            data = vRP.getDatatable(user_id)
        else
            data = vRP.userData(user_id,"Datatable")
        end
        return data["groups"][group]
    end
end

memberInformation = function(user_id)
    local identity = userIdentity(user_id)
    local on = "#ce3737"
    local nsource = userSource(user_id)
    if nsource then
        on = "#4ba84b"
    end
    return {name = (identity.name or " ").." "..(identity.name2 or identity.firstname or " "), phone = identity.phone or " ", online = on, id = user_id}
end

addGroupMember = function(source,target_id,group,groupName)
    if target_id then
        local nplayer = userSource(target_id)
        if vRP.hasPermission(parseInt(target_id),group) then
            return "#<b>"..target_id.."</b> já possuí a permissão de <b>"..group.."</b>."
        end
        vRP.setPermission(target_id,group)
        sendLog("**ID:** "..userId(source).." \n **MEMBRO:** "..target_id.." \n **GRUPO:** "..group,"ADICIONOU MEMBRO")
        return true
    end
    return false
end

removeGroupMember = function(source,target_id,group,groupName)
    vRP.remPermission(parseInt(target_id),group)
    sendLog("**ID:** "..userId(source).." \n **MEMBRO:** "..target_id.." \n **GRUPO:** "..group,"REMOVEU MEMBRO")
    return true
end

groupsPayment = function(user_id,amount,group)
    local canPay = vRP.paymentBank(user_id,amount)
    if canPay then
        sendLog("**ID:** "..user_id.." \n **QUANTIDADE:** "..amount.." \n **GRUPO:** "..group,"ADICIONOU CAIXA")
    end
    return canPay
end

groupsReceive = function(user_id,amount,group)
    vRP.addBank(user_id,amount)
    sendLog("**ID:** "..user_id.." \n **QUANTIDADE:** "..amount.." \n **GRUPO:** "..group,"RETIROU CAIXA")
end

AddEventHandler("playerConnect",function(user_id,source,first_spawn)
    TriggerEvent("dk_groups/sendAction","update",user_id,{online = "#4ba84b"})
end)
AddEventHandler("playerDisconnect",function(user_id,source,first_spawn)
    TriggerEvent("dk_groups/sendAction","update",user_id,{online = "#ce3737"})
end)

function sendLog(message,title)
    local webhook = ""
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