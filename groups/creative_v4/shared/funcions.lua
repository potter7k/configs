groupsService = function(permission)
    local members = {}
    for _,v in pairs((vRP.numPermission(permission) or vRP.getUsersByPermission(permission))) do
        table.insert(members,v)
    end
    return members
end