-- vRP.prepare("dk_groups/get_groups","SELECT * FROM vrp_user_data WHERE dvalue LIKE @group") -- VRP
-- vRP.prepare("dk_groups/get_groups","SELECT * FROM vrp_permissions WHERE permiss = @permiss") -- CREATIVE V3
vRP.prepare("dk_groups/get_groups","SELECT * FROM summerz_playerdata WHERE dvalue LIKE (dkey = 'Datatable' AND dvalue LIKE @group)") -- CREATIVE V4
