groupsList = {
    ["Owner"] = {
        name = "Staff", -- Nome do grupo.
        image = "", -- Imagem do grupo.
        once = true, -- Para poder ter apenas 1 permissão por player
        blockLeader = false, -- Para não permitir a remoção de líderes
        selfRemove = false, -- Para poder remover a si mesmo.
        -- moneyRanking = 1, -- Para ter um ranking com os grupos q possuem mais dinheiro em caixa, o número 1 indica a categoria 1, você pode separar por categorias.
        maxMembers = 20, -- Máximo de membros que podem ser contratados no grupo, caso não queira limite basta colocar maxMembers = nil,
        blackList = {id = 1, days = 5}, -- Sistema de blacklist, assim que o player é removido do grupo, ele só pode ser adicionado em outro grupo **DO MESMO ID** depois do tempo indicado em "days", no caso em coloquei 5 dias.

        leader = { -- Permissões dos líderes do grupo.
        {index = "Admin"},
        },
        addPermissions = { -- Permissões que os líderes terão acesso para adicionar aos membros.
        {index = "Admin", name = "Lider", customHook = {rolesWebhookIlegal}, customRoles = {"1008134296990650428","954241427745947680"}}, -- customHook é um webhook custom para ser enviado / customRoles é um cargo custom para ser adicionado no discord, no exemplo coloquei o cargo de membro e lider no discord
        {index = "Suporte", name = "Membro", customHook = {rolesWebhookIlegal}, customRoles = {"954241427745947680"}},
        },
        removePermissions = {  -- Permissões que serão retiradas ao remover o membro do grupo.
        {index = "Admin"},
        {index = "Suporte"},
        },
        extraAction = { -- Ações extras (opcionais)
            request = function(source,target_id,groupName) -- Enviar request perguntando se o membro deseja ser adicionado ao grupo.
                TriggerClientEvent("Notify",source,"importante","Solicitação enviada.")
                if vRP.request(userSource(target_id),"Você está sendo convidado(a) para o grupo: <b>"..groupName.."</b>. Aceitar?",10) then
                    TriggerClientEvent("Notify",userSource(target_id),"sucesso","Você entrou no grupo: <b>"..groupName.."</b>.")
                    return true
                else
                    return false
                end
            end,
            -- onAdd = function(source,target,group) -- Ação extra ao adicionar o membro no grupo
            
            -- end,
            -- onRemove = function(source,target,group) -- Ação extra ao removar o membro do grupo
                
            -- end,
        },
    },
    
    ["Police"] = {
        name = "Police", -- Nome do grupo.
        image = "",
        once = true, -- Para poder ter apenas 1 permissão por player
        blockLeader = false, -- Para não permitir a remoção de líderes
        selfRemove = false, -- Para poder remover a si mesmo.

        leader = { -- Permissões dos líderes do grupo.
            {index = "Chief"},
            {index = "waitChief"},
        },
        addPermissions = { -- Permissões que os líderes terão acesso para adicionar aos membros.            
            {index = "waitChief", name = "Chief", customRoles = {"938406834228822076"}},
            {index = "waitCadet", name = "Cadet"}, -- Esses são os grupos em "paisana", no caso da policia é necessário adicionar, para que o player entre em paisana, e a permissão seja removida também. 
        
            {index = "Chief", name = "Chief", hidden = true}, -- Com o hidden = true, a opção não aparecerá no painel
            {index = "Cadet", name = "Cadet", hidden = true},
        },
        removePermissions = {  -- Permissões que serão retiradas ao remover o membro do grupo.
            {index = "Chief"},
            {index = "Cadet"},
            
            {index = "waitChief"},
            {index = "waitCadet"},
        },
        inService = function() -- Mostrar os membros em serviço
            return groupsService("Police")
        end,
        discordRole = "910539664996302859", -- Cargo que será adicionado por padrão.
        extraAction = { -- Ações extras (opcionais)
            request = function(source,target_id,groupName) -- Enviar request perguntando se o membro deseja ser adicionado ao grupo.
                TriggerClientEvent("Notify",source,"importante","Solicitação enviada.")
                if vRP.request(userSource(target_id),"Você está sendo convidado(a) para o grupo: <b>"..groupName.."</b>. Aceitar?",10) then
                    TriggerClientEvent("Notify",userSource(target_id),"sucesso","Você entrou no grupo: <b>"..groupName.."</b>.")
                    return true
                else
                    return false
                end
            end,
            -- onAdd = function(source,target,group) -- Ação extra ao adicionar o membro no grupo
            
            -- end,
            onRemove = function(source,target_id,group) -- Ação extra ao removar o membro do grupo
                local target = userSource(target_id)
                if target then
                    vRPclient.replaceWeapons(target)
                    TriggerEvent("blipsystem:serviceExit",target)
                end
            end,
        },
    },
}