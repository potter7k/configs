-- prepare("dk_groups/get_groups","SELECT * FROM vrp_user_data WHERE (dkey = 'vRP:datatable' AND dvalue LIKE @group)") -- VRP
-- prepare("dk_groups/get_groups","SELECT * FROM vrp_permissions WHERE permiss = @permiss") -- CREATIVE V3
prepare("dk_groups/get_groups","SELECT * FROM summerz_playerdata WHERE (dkey = 'Datatable' AND dvalue LIKE @group)") -- CREATIVE V4 OU V5
