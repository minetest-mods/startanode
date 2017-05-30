--[[
Configuration interface.
  The values can be changed from other mods at init time
  Just be sure this mod is in dependency of the other mod
]]

startanode = {
	min_pos = {x = -500, y = -30, z = -500 },
	max_pos = {x =  500, y =  30, z =  500 },
	node_name = "mapgen_stone", -- "default:stone"
	after_place_func = nil, -- function(player, pos) called after the node is placed
	singlenode_mode = true -- no effect from other mods. Changed too late
}

-- support for undernull water
minetest.register_on_mapgen_init(function(mgparams)
	if startanode.singlenode_mode then
		minetest.set_mapgen_params({mgname="singlenode"})
	end
end)



local function spawn_node(player, pos)

	-- select new pos if no given
	if not pos then
		pos = {
			x=math.random(startanode.min_pos.x, startanode.max_pos.x),
			y=math.random(startanode.min_pos.y, startanode.max_pos.y),
			z=math.random(startanode.min_pos.z, startanode.max_pos.z)
		}
	end

	-- Check if spawn place generated and loaded. Force it
	local node = minetest.get_node_or_nil(pos)
	if not node or node.name == "ignore" then
		-- Load the map at pos and try again
		minetest.emerge_area(pos, pos)
--		minetest.get_voxel_manip(pos, pos)
		minetest.after(0.5, spawn_node, player, pos)
		return
	end

	-- check if placing allowed at this position
	if node.is_ground_content == false then
		minetest.after(0, spawn_node, player, nil) --new position
	end

	local playername = player:get_player_name()
	minetest.log("Player "..playername.." Node and player spawned at "..minetest.pos_to_string(pos)..". replacing "..node.name)
	minetest.set_node(pos, {name=startanode.node_name})
	player:setpos({x=pos.x,y=pos.y+2,z=pos.z})

	if minetest.global_exists("sethome") then
		sethome.set(playername, {x=pos.x,y=pos.y+2,z=pos.z})
	end

	if startanode.after_place_func then
		startanode.after_place_func(player, pos)
	end

	-- trigger additional actions like filling chest
	minetest.forceload_free_block(pos)
end

minetest.register_on_newplayer(function(player)
	spawn_node(player, nil)
end)

-- Respawn allways at home if sethome mod enabled
if minetest.global_exists("sethome") then
	minetest.register_on_respawnplayer(function(player)
		minetest.after(0, sethome.go, player:get_player_name())
	end)
end
