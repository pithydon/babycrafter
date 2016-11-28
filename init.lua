local treasurer_path = minetest.get_modpath("treasurer")

for _,v in ipairs({{"a",{1,0,0,0,0,0},58},{"b",{1,0,1,0,0,0},50},
		{"c",{1,1,0,0,0,0},54},{"d",{1,1,0,1,0,0},55},{"e",{1,0,0,1,0,0},59},{"f",{1,1,1,0,0,0},52},{"g",{1,1,1,1,0,0},51},
		{"h",{1,0,1,1,0,0},56},{"i",{0,1,1,0,0,0},57},{"j",{0,1,1,1,0,0},48},{"k",{1,0,0,0,1,0},49},{"l",{1,0,1,0,1,0},54},
		{"m",{1,1,0,0,1,0},53},{"n",{1,1,0,1,1,0},57},{"o",{1,0,0,1,1,0},58},{"p",{1,1,1,0,1,0},50},{"q",{1,1,1,1,1,0},47},
		{"r",{1,0,1,1,1,0},55},{"s",{0,1,1,0,1,0},56},{"t",{0,1,1,1,1,0},59},{"u",{1,0,0,0,1,1},53},{"v",{1,0,1,0,1,1},49},
		{"w",{0,1,1,1,0,1},52},{"x",{1,1,0,0,1,1},48},{"y",{1,1,0,1,1,1},51},{"z",{1,0,0,1,1,1},47}}) do
	minetest.register_node("babycrafter:alphabet_block_"..v[1], {
		description = "Letter "..string.upper(v[1]).." Alphabet Block",
		drawtype = "normal",
		paramtype2 = "facedir",
		is_ground_content = false,
		tiles = {"babycrafter_"..v[1]..".png"},
		groups = {oddly_breakable_by_hand = 3, cracky = 3, flammable = 1, falling_node = 1},
		sounds = default.node_sound_defaults(),
		on_rotate = screwdriver.rotate_simple
	})

	local braille = {}

	for i,v in ipairs(v[2]) do
		if v == 1 then
			braille[i] = "default:paper"
		else
			braille[i] = "default:clay_lump"
		end
	end

	minetest.register_craft({
		output = "babycrafter:alphabet_block_"..v[1],
		recipe = {
			{braille[1], braille[2]},
			{braille[3], braille[4]},
			{braille[5], braille[6]}
		}
	})

	if treasurer_path then
		treasurer.register_treasure("babycrafter:alphabet_block_"..v[1],v[3]/10000,5,{1,4},nil,"deco")
	end
end

for i=0,15 do
	local node_name = "babycrafter:shape_sorter_"..i
	local cn = 1
	if i == 0 then
		node_name = "babycrafter:shape_sorter"
		cn = 0
	end
	local drops = {{items = {"babycrafter:shape_sorter"}, rarity = 1}}
	local consinv = {}
	local idrop = i
	if idrop - 8 >= 0 then
		idrop = idrop - 8
		drops[#drops+1] = {items = {"babycrafter:red_square"}, rarity = 1}
		consinv[#consinv+1] = {1, ItemStack("babycrafter:red_square")}
	end
	if idrop - 4 >= 0 then
		idrop = idrop - 4
		drops[#drops+1] = {items = {"babycrafter:blue_circle"}, rarity = 1}
		consinv[#consinv+1] = {2, ItemStack("babycrafter:blue_circle")}
	end
	if idrop - 2 >= 0 then
		idrop = idrop - 2
		drops[#drops+1] = {items = {"babycrafter:green_triangle"}, rarity = 1}
		consinv[#consinv+1] = {3, ItemStack("babycrafter:green_triangle")}
	end
	if idrop - 1 >= 0 then
		drops[#drops+1] = {items = {"babycrafter:yellow_star"}, rarity = 1}
		consinv[#consinv+1] = {4, ItemStack("babycrafter:yellow_star")}
	end

	minetest.register_node(node_name, {
		description = "Shape Sorter",
		drawtype = "normal",
		paramtype2 = "facedir",
		is_ground_content = false,
		tiles = {"babycrafter_shape_sorter_"..i..".png", "babycrafter_wood_block.png"},
		groups = {oddly_breakable_by_hand = 3, choppy = 2, flammable = 3, falling_node = 1, not_in_creative_inventory = cn},
		sounds = default.node_sound_wood_defaults(),
		drop = {
			max_items = 5,
			items = drops
		},
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", "size[8,7;]background[0,0;8,7;babycrafter_shape_sorter_formspec.png;true]"
					.."listcolors[#00000023;#594d3869;#181413;#787e50;#fff]"
					.."list[context;shapes;3,0.3;2,2;]list[current_player;main;0,2.85;8,1;]list[current_player;main;0,4.08;8,3;8]"
					.."listring[context;shapes]listring[current_player;main]"..default.get_hotbar_bg(0,2.85))
			local inv = meta:get_inventory()
			inv:set_size("shapes", 4)
			for _,v in ipairs(consinv) do
				inv:set_stack("shapes", v[1], v[2])
			end
		end,
		allow_metadata_inventory_put = function(pos, listname, index, stack)
			local name = stack:get_name()
			if name == "babycrafter:red_square" and index == 1 then
				return stack:get_count()
			elseif name == "babycrafter:blue_circle" and index == 2 then
				return stack:get_count()
			elseif name == "babycrafter:green_triangle" and index == 3 then
				return stack:get_count()
			elseif name == "babycrafter:yellow_star" and index == 4 then
				return stack:get_count()
			end
			return 0
		end,
		allow_metadata_inventory_move = function()
			return 0
		end,
		on_metadata_inventory_put = function(pos, listname, index, stack, player)
			local name = stack:get_name()
			local desc
			local ni
			if name == "babycrafter:red_square" then
				desc = "red square"
				ni = i + 8
			elseif name == "babycrafter:blue_circle" then
				desc = "blue circle"
				ni = i + 4
			elseif name == "babycrafter:green_triangle" then
				desc = "green triangle"
				ni = i + 2
			elseif name == "babycrafter:yellow_star" then
				desc = "yellow star"
				ni = i + 1
			else
				minetest.log("error", player:get_player_name().." placed a misshaped \""..name
				.."\" in a \""..node_name.."\" at "..minetest.pos_to_string(pos))
				return
			end
			local node = minetest.get_node(pos)
			minetest.swap_node(pos, {name = "babycrafter:shape_sorter_"..ni, param2 = node.param2})
			minetest.log("action", player:get_player_name().." places a "..desc.." in a shape sorter at "..minetest.pos_to_string(pos))
		end,
		on_metadata_inventory_take = function(pos, listname, index, stack, player)
			local name = stack:get_name()
			local desc
			local ni
			if name == "babycrafter:red_square" then
				desc = "a red square"
				ni = i - 8
			elseif name == "babycrafter:blue_circle" then
				desc = "a blue circle"
				ni = i - 4
			elseif name == "babycrafter:green_triangle" then
				desc = "a green triangle"
				ni = i - 2
			elseif name == "babycrafter:yellow_star" then
				desc = "a yellow star"
				ni = i - 1
			else
				minetest.log("error", player:get_player_name().." takes a misshaped \""..name
				.."\" from a \""..node_name.."\" at "..minetest.pos_to_string(pos))
				return
			end
			local new_name = "babycrafter:shape_sorter_"..ni
			if ni == 0 then
				new_name = "babycrafter:shape_sorter"
			end
			local node = minetest.get_node(pos)
			minetest.swap_node(pos, {name = new_name, param2 = node.param2})
			minetest.log("action", player:get_player_name().." takes "..desc.." from a shape sorter at "..minetest.pos_to_string(pos))
		end
	})
end

minetest.override_item("babycrafter:shape_sorter_15", {
	groups = {oddly_breakable_by_hand = 3, choppy = 2, flammable = 3, falling_node = 1, not_in_creative_inventory = 1, wireworldhead = 1}
})

if minetest.get_modpath("mesecons") then
	minetest.override_item("babycrafter:shape_sorter", {
		mesecons = {receptor = {
			state = mesecon.state.off,
			rules = mesecon.rules.alldirs
		}}
	})
	for i=1,14 do
		minetest.override_item("babycrafter:shape_sorter_"..i, {
			mesecons = {receptor = {
				state = mesecon.state.off,
				rules = mesecon.rules.alldirs
			}}
		})
	end
	for _,v in ipairs({7,11,13,14}) do
		minetest.override_item("babycrafter:shape_sorter_"..v, {
			on_metadata_inventory_put = function(pos, listname, index, stack, player)
				local name = stack:get_name()
				local desc
				local ni
				if name == "babycrafter:red_square" then
					desc = "red square"
					ni = v + 8
				elseif name == "babycrafter:blue_circle" then
					desc = "blue circle"
					ni = v + 4
				elseif name == "babycrafter:green_triangle" then
					desc = "green triangle"
					ni = v + 2
				elseif name == "babycrafter:yellow_star" then
					desc = "yellow star"
					ni = v + 1
				else
					minetest.log("error", player:get_player_name().." placed a misshaped \""..name
					.."\" in a \"babycrafter:shape_sorter_"..v.."\" at "..minetest.pos_to_string(pos))
					return
				end
				local node = minetest.get_node(pos)
				minetest.swap_node(pos, {name = "babycrafter:shape_sorter_"..ni, param2 = node.param2})
				mesecon.receptor_on(pos, mesecon.rules.alldirs)
				minetest.log("action", player:get_player_name().." places a "..desc.." in a shape sorter at "..minetest.pos_to_string(pos))
			end
		})
	end
	minetest.override_item("babycrafter:shape_sorter_15", {
		mesecons = {receptor = {
			state = mesecon.state.on,
			rules = mesecon.rules.alldirs
		}},
		on_metadata_inventory_take = function(pos, listname, index, stack, player)
			local name = stack:get_name()
			local desc
			local ni = 15
			if name == "babycrafter:red_square" then
				desc = "a red square"
				ni = ni - 8
			elseif name == "babycrafter:blue_circle" then
				desc = "a blue circle"
				ni = ni - 4
			elseif name == "babycrafter:green_triangle" then
				desc = "a green triangle"
				ni = ni - 2
			elseif name == "babycrafter:yellow_star" then
				desc = "a yellow star"
				ni = ni - 1
			else
				minetest.log("error", player:get_player_name().." takes a misshaped \""..name
				.."\" from a \"babycrafter:shape_sorter_15\" at "..minetest.pos_to_string(pos))
				return
			end
			local node = minetest.get_node(pos)
			minetest.swap_node(pos, {name = "babycrafter:shape_sorter_"..ni, param2 = node.param2})
			mesecon.receptor_off(pos, mesecon.rules.alldirs)
			minetest.log("action", player:get_player_name().." takes "..desc.." from a shape sorter at "..minetest.pos_to_string(pos))
		end
	})
end

minetest.register_node("babycrafter:wood_block", {
	description = "Wood Block",
	drawtype = "normal",
	is_ground_content = false,
	tiles = {"babycrafter_wood_block.png"},
	groups = {oddly_breakable_by_hand = 3, choppy = 2, flammable = 3, wood = 1, falling_node = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_craftitem("babycrafter:red_square", {
	description = "Red Square",
	inventory_image = "babycrafter_red_square.png",
	stack_max = 1
})

minetest.register_craftitem("babycrafter:blue_circle", {
	description = "Blue Circle",
	inventory_image = "babycrafter_blue_circle.png",
	stack_max = 1
})

minetest.register_craftitem("babycrafter:green_triangle", {
	description = "Green Triangle",
	inventory_image = "babycrafter_green_triangle.png",
	stack_max = 1
})

minetest.register_craftitem("babycrafter:yellow_star", {
	description = "Yellow Star",
	inventory_image = "babycrafter_yellow_star.png",
	stack_max = 1
})

minetest.register_craft({
	output = "babycrafter:wood_block 4",
	recipe = {
		{"default:aspen_wood", "default:aspen_wood"},
		{"default:aspen_wood", "default:aspen_wood"}
	}
})

minetest.register_craft({
	type = "shapeless",
	output = "babycrafter:shape_sorter",
	recipe = {
		"babycrafter:wood_block",
		"dye:blue",
		"dye:green",
		"dye:yellow",
		"dye:red"
	}
})

minetest.register_craft({
	output = "babycrafter:red_square",
	recipe = {
		{"dye:red", "", "dye:red"},
		{"", "default:clay_lump", ""},
		{"dye:red", "", "dye:red"}
	}
})

minetest.register_craft({
	output = "babycrafter:blue_circle",
	recipe = {
		{"dye:blue", "dye:blue", "dye:blue"},
		{"dye:blue", "default:clay_lump", "dye:blue"},
		{"dye:blue", "dye:blue", "dye:blue"}
	}
})

minetest.register_craft({
	output = "babycrafter:green_triangle",
	recipe = {
		{"", "dye:green", ""},
		{"", "default:clay_lump", ""},
		{"dye:green", "", "dye:green"}
	}
})

minetest.register_craft({
	output = "babycrafter:yellow_star",
	recipe = {
		{"", "dye:yellow", ""},
		{"dye:yellow", "default:clay_lump", "dye:yellow"},
		{"dye:yellow", "", "dye:yellow"}
	}
})

if treasurer_path then
	treasurer.register_treasure("babycrafter:wood_block",0.006,2,{1,20},nil,"building_block")
	treasurer.register_treasure("babycrafter:shape_sorter",0.002,5,1,nil,"deco")
	treasurer.register_treasure("babycrafter:red_square",0.002,2,1)
	treasurer.register_treasure("babycrafter:blue_circle",0.002,2,1)
	treasurer.register_treasure("babycrafter:green_triangle",0.002,2,1)
	treasurer.register_treasure("babycrafter:yellow_star",0.002,2,1)
end
