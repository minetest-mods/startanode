singlenode = {
	min_pos = {x = -500, y = -30, z = -500 },
	max_pos = {x =  500, y =  30, z =  500 },
	node_name = "mapgen_stone" -- "default:stone"
}

-- support for undernull water
if minetest.get_modpath("water") then
	minetest.log("[singlenode] compatibility mode to undernull water")
	local water_level = minetest.setting_get("water_level") or 0
	singlenode.min_pos.y = water_level
	singlenode.max_pos.y = water_level
else
	minetest.register_on_mapgen_init(function(mgparams)
		minetest.set_mapgen_params({mgname="singlenode"})
	end)
end

minetest.register_on_newplayer(function(player)
	local playername = player:get_player_name()
	local pos = {
		x=math.random(singlenode.min_pos.x, singlenode.max_pos.x), 
		y=math.random(singlenode.min_pos.y, singlenode.max_pos.y),
		z=math.random(singlenode.min_pos.z, singlenode.max_pos.z)
	}

	minetest.log("Player "..playername.." Spawned on singlenode at "..minetest.pos_to_string(pos))
	minetest.get_voxel_manip(pos, pos)
	minetest.set_node(pos, {name=singlenode.node_name})
	player:setpos({x=pos.x,y=pos.y+2,z=pos.z})

	if minetest.global_exists("sethome") then
		sethome.set(playername, {x=pos.x,y=pos.y+2,z=pos.z})
	end
end)

