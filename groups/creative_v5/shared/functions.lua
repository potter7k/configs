groupsService = function(permission)
    local inService = (vRP.numPermission(permission))
    if not inService then
        return {}
    end
    local members = {}
    for _,v in pairs(inService) do
        table.insert(members,v)
    end
    return members
end