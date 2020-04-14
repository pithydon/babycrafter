local creative = minetest.setting_getbool("creative_mode")
local ring_stacker_enabled = minetest.setting_getbool("babycrafter_enable_ring_stacker")

local stairs_path = minetest.get_modpath("stairs")
local mcstair_path = minetest.get_modpath("mcstair")
local treasurer_path = minetest.get_modpath("treasurer")

for _,v in ipairs({{"a",{1,0,0,0,0,0},58},{"b",{1,0,1,0,0,0},41},
		{"c",{1,1,0,0,0,0},49},{"d",{1,1,0,1,0,0},51},{"e",{1,0,0,1,0,0},60},{"f",{1,1,1,0,0,0},45},{"g",{1,1,1,1,0,0},44},
		{"h",{1,0,1,1,0,0},53},{"i",{0,1,1,0,0,0},56},{"j",{0,1,1,1,0,0},38},{"k",{1,0,0,0,1,0},39},{"l",{1,0,1,0,1,0},50},
		{"m",{1,1,0,0,1,0},47},{"n",{1,1,0,1,1,0},55},{"o",{1,0,0,1,1,0},57},{"p",{1,1,1,0,1,0},42},{"q",{1,1,1,1,1,0},36},
		{"r",{1,0,1,1,1,0},52},{"s",{0,1,1,0,1,0},54},{"t",{0,1,1,1,1,0},59},{"u",{1,0,0,0,1,1},48},{"v",{1,0,1,0,1,1},40},
		{"w",{0,1,1,1,0,1},46},{"x",{1,1,0,0,1,1},37},{"y",{1,1,0,1,1,1},43},{"z",{1,0,0,1,1,1},35}}) do
	minetest.register_node("babycrafter:alphabet_block_"..v[1], {
		description = "Letter "..string.upper(v[1]).." Alphabet Block",
		drawtype = "normal",
		paramtype2 = "facedir",
		is_ground_content = false,
		tiles = {"babycrafter_"..v[1]..".png"},
		groups = {oddly_breakable_by_hand = 3, cracky = 3, falling_node = 1},
		sounds = {
			footstep = {name = "", gain = 1},
			dig = {name = "babycrafter_dig", gain = 1},
			dug = {name = "babycrafter_dug", gain = 1},
			place = {name = "babycrafter_place", gain = 1}
		},
		on_rotate = function(pos, node, user, mode, new_param2)
			if mode ~= 1 then
				return false
			end
		end
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

local invimgs = ""
for i=0,7 do
	invimgs = invimgs.."image["..i..",2.85;1,1;babycrafter_formspec_hb_inv.png]"
end
for iy=4,6 do
	for ix=0,7 do
		invimgs = invimgs.."image["..ix..","..iy..".08;1,1;babycrafter_formspec_inv.png]"
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
	local itexture = {0, 0}
	if idrop - 8 >= 0 then
		idrop = idrop - 8
		drops[2] = {items = {"babycrafter:red_square"}, rarity = 1}
		consinv[1] = {1, ItemStack("babycrafter:red_square")}
		itexture[2] = 2
	end
	if idrop - 4 >= 0 then
		idrop = idrop - 4
		drops[#drops+1] = {items = {"babycrafter:blue_circle"}, rarity = 1}
		consinv[#consinv+1] = {2, ItemStack("babycrafter:blue_circle")}
		itexture[2] = itexture[2] + 1
	end
	if idrop - 2 >= 0 then
		idrop = idrop - 2
		drops[#drops+1] = {items = {"babycrafter:green_triangle"}, rarity = 1}
		consinv[#consinv+1] = {3, ItemStack("babycrafter:green_triangle")}
		itexture[1] = 2
	end
	if idrop - 1 >= 0 then
		drops[#drops+1] = {items = {"babycrafter:yellow_star"}, rarity = 1}
		consinv[#consinv+1] = {4, ItemStack("babycrafter:yellow_star")}
		itexture[1] = itexture[1] + 1
	end
	local texture
	if itexture[1] == itexture[2] then
		texture = "babycrafter_shape_sorter_"..itexture[1]..".png"
	else
		texture = "babycrafter_shape_sorter_"..itexture[2]..".png^[lowpart:50:babycrafter_shape_sorter_"..itexture[1]..".png"
	end

	minetest.register_node(node_name, {
		description = "Shape Sorter",
		drawtype = "normal",
		paramtype2 = "facedir",
		is_ground_content = false,
		tiles = {texture, "babycrafter_wood_block.png"},
		groups = {oddly_breakable_by_hand = 3, choppy = 2, flammable = 3, falling_node = 1, not_in_creative_inventory = cn},
		sounds = {
			footstep = {name = "", gain = 1},
			dig = {name = "babycrafter_dig", gain = 1},
			dug = {name = "babycrafter_dug", gain = 1},
			place = {name = "babycrafter_place", gain = 1}
		},
		drop = {
			max_items = 5,
			items = drops
		},
		on_construct = function(pos)
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", "size[8,7;]background[0,0;8,7;babycrafter_shape_sorter_formspec.png;true]"
					.."bgcolor[#bbbb;true]listcolors[#0000;#594d38aa;#0000;#787e50;#fff]"
					.."list[context;shapes;3,0.3;2,2;]list[current_player;main;0,2.85;8,1;]list[current_player;main;0,4.08;8,3;8]"
					.."listring[context;shapes]listring[current_player;main]"..invimgs)
			local inv = meta:get_inventory()
			inv:set_size("shapes", 4)
			for _,v in ipairs(consinv) do
				inv:set_stack("shapes", v[1], v[2])
			end
		end,
		allow_metadata_inventory_put = function(pos, listname, index, stack)
			local name = stack:get_name()
			if minetest.get_meta(pos):get_inventory():get_stack(listname, index):is_empty() and
					((name == "babycrafter:red_square" and index == 1) or (name == "babycrafter:blue_circle" and index == 2) or
					(name == "babycrafter:green_triangle" and index == 3) or (name == "babycrafter:yellow_star" and index == 4)) then
				return 1
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
			if name == "babycrafter:red_square" and index == 1 then
				desc = "red square"
				ni = i + 8
			elseif name == "babycrafter:blue_circle" and index == 2 then
				desc = "blue circle"
				ni = i + 4
			elseif name == "babycrafter:green_triangle" and index == 3 then
				desc = "green triangle"
				ni = i + 2
			elseif name == "babycrafter:yellow_star" and index == 4 then
				desc = "yellow star"
				ni = i + 1
			else
				minetest.log("error", player:get_player_name().." placed a misshaped \""..name
				.."\" in a \""..node_name.."\" at "..minetest.pos_to_string(pos))
				return
			end
			local node = minetest.get_node(pos)
			local player_name = player:get_player_name()
			minetest.swap_node(pos, {name = "babycrafter:shape_sorter_"..ni, param2 = node.param2})
			minetest.sound_play({name = "babycrafter_slide_in", gain = 0.1}, {to_player = player_name})
			minetest.log("action", player_name.." places a "..desc.." in a shape sorter at "..minetest.pos_to_string(pos))
		end,
		on_metadata_inventory_take = function(pos, listname, index, stack, player)
			local name = stack:get_name()
			local desc
			local ni
			if name == "babycrafter:red_square" and index == 1 then
				desc = "a red square"
				ni = i - 8
			elseif name == "babycrafter:blue_circle" and index == 2 then
				desc = "a blue circle"
				ni = i - 4
			elseif name == "babycrafter:green_triangle" and index == 3 then
				desc = "a green triangle"
				ni = i - 2
			elseif name == "babycrafter:yellow_star" and index == 4 then
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
			local player_name = player:get_player_name()
			minetest.swap_node(pos, {name = new_name, param2 = node.param2})
			minetest.sound_play({name = "babycrafter_slide_out", gain = 0.1}, {to_player = player_name})
			minetest.log("action", player_name.." takes "..desc.." from a shape sorter at "..minetest.pos_to_string(pos))
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
				if name == "babycrafter:red_square" and index == 1 then
					desc = "red square"
					ni = v + 8
				elseif name == "babycrafter:blue_circle" and index == 2 then
					desc = "blue circle"
					ni = v + 4
				elseif name == "babycrafter:green_triangle" and index == 3 then
					desc = "green triangle"
					ni = v + 2
				elseif name == "babycrafter:yellow_star" and index == 4 then
					desc = "yellow star"
					ni = v + 1
				else
					minetest.log("error", player:get_player_name().." placed a misshaped \""..name
					.."\" in a \"babycrafter:shape_sorter_"..v.."\" at "..minetest.pos_to_string(pos))
					return
				end
				local node = minetest.get_node(pos)
				local player_name = player:get_player_name()
				minetest.swap_node(pos, {name = "babycrafter:shape_sorter_"..ni, param2 = node.param2})
				minetest.sound_play({name = "babycrafter_slide_in", gain = 0.1}, {to_player = player_name})
				mesecon.receptor_on(pos, mesecon.rules.alldirs)
				minetest.log("action", player_name.." places a "..desc.." in a shape sorter at "..minetest.pos_to_string(pos))
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
			if name == "babycrafter:red_square" and index == 1 then
				desc = "a red square"
				ni = ni - 8
			elseif name == "babycrafter:blue_circle" and index == 2 then
				desc = "a blue circle"
				ni = ni - 4
			elseif name == "babycrafter:green_triangle" and index == 3 then
				desc = "a green triangle"
				ni = ni - 2
			elseif name == "babycrafter:yellow_star" and index == 4 then
				desc = "a yellow star"
				ni = ni - 1
			else
				minetest.log("error", player:get_player_name().." takes a misshaped \""..name
				.."\" from a \"babycrafter:shape_sorter_15\" at "..minetest.pos_to_string(pos))
				return
			end
			local node = minetest.get_node(pos)
			local player_name = player:get_player_name()
			minetest.swap_node(pos, {name = "babycrafter:shape_sorter_"..ni, param2 = node.param2})
			minetest.sound_play({name = "babycrafter_slide_out", gain = 0.1}, {to_player = player_name})
			mesecon.receptor_off(pos, mesecon.rules.alldirs)
			minetest.log("action", player_name.." takes "..desc.." from a shape sorter at "..minetest.pos_to_string(pos))
		end
	})
end

minetest.register_node("babycrafter:wood_block", {
	description = "Wood Block",
	drawtype = "normal",
	is_ground_content = false,
	tiles = {"babycrafter_wood_block.png"},
	groups = {oddly_breakable_by_hand = 3, choppy = 2, flammable = 3, wood = 1, falling_node = 1},
	sounds = {
		footstep = {name = "", gain = 1},
		dig = {name = "babycrafter_dig", gain = 1},
		dug = {name = "babycrafter_dug", gain = 1},
		place = {name = "babycrafter_place", gain = 1}
	}
})

if stairs_path then
	stairs.register_stair_and_slab("wood_block", "babycrafter:wood_block",
			{oddly_breakable_by_hand = 3, choppy = 2, flammable = 3, falling_node = 1}, {"babycrafter_wood_block.png"}, "Wood Block Stair", "Wood Block Slab",
			{footstep = {name = "", gain = 1}, dig = {name = "babycrafter_dig", gain = 1}, dug = {name = "babycrafter_dug", gain = 1},
			place = {name = "babycrafter_place", gain = 1}})
	if mcstair_path then
		mcstair.register("wood_block")
	end
end

local color_index = {
	{"white"},
	{"grey", "#aaa"},
	{"dark_grey", "#555"},
	{"black", "#1a1a1a"},
	{"violet", "#50a"},
	{"blue", "#22f"},
	{"cyan"},
	{"dark_green", "green"},
	{"green", "#0f0"},
	{"yellow"},
	{"brown", "#530"},
	{"orange"},
	{"red"},
	{"magenta"},
	{"pink"}
}

minetest.register_node("babycrafter:ring_stacker", {
	description = "Ring Stacker",
	drawtype = "nodebox",
	paramtype = "light",
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
			{-0.1875, -0.25, -0.1875, 0.1875, 0.5, 0.1875}
		}
	},
	tiles = {"babycrafter_wood_block.png"},
	groups = {oddly_breakable_by_hand = 3, choppy = 2, flammable = 3, wood = 1, falling_node = 1},
	sounds = {
		footstep = {name = "", gain = 1},
		dig = {name = "", gain = 1},
		dug = {name = "babycrafter_dug", gain = 1},
		place = {name = "babycrafter_place", gain = 1}
	},
	on_rightclick = function(pos, node, clicker, itemstack)
		local player_name = clicker:get_player_name()
		local item = itemstack:get_name()
		for i,v in ipairs(color_index) do
			if item == "babycrafter:ring_"..v[1] then
				minetest.log("action", player_name.." places babycrafter:ring_"..v[1].." on a ring stacker at "..minetest.pos_to_string(pos))
				minetest.swap_node(pos, {name = "babycrafter:ring_stacker_color", param2 = i - 1})
				minetest.sound_play({name = "babycrafter_place_ring", gain = 1}, {to_player = player_name})
				if not creative then
					itemstack:take_item()
					return itemstack
				end
				break
			end
		end
	end
})

minetest.register_node("babycrafter:ring_stacker_color", {
	description = "Ring Stacker",
	drawtype = "nodebox",
	paramtype = "light",
	paramtype2 = "color",
	is_ground_content = false,
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
			{-0.1875, 0, -0.1875, 0.1875, 0.5, 0.1875}
		}
	},
	tiles = {{name = "babycrafter_wood_block.png", color = "white"}},
	overlay_tiles = {"babycrafter_ring.png", "", "babycrafter_ring_side_1.png"},
	palette = "babycrafter_palette.png",
	groups = {oddly_breakable_by_hand = 3, choppy = 2, flammable = 3, wood = 1, falling_node = 1, not_in_creative_inventory = 1},
	sounds = {
		footstep = {name = "", gain = 1},
		dig = {name = "", gain = 1},
		dug = {name = "babycrafter_dug", gain = 1},
		place = {name = "babycrafter_place", gain = 1}
	},
	on_punch = function(pos, node, puncher)
		if node.param2 > 14 then
			return
		end
		local player_name = puncher:get_player_name()
		local color = color_index[node.param2 + 1]
		minetest.log("action", player_name.." takes babycrafter:ring_"..color[1].." from a ring stacker at "..minetest.pos_to_string(pos))
		minetest.swap_node(pos, {name = "babycrafter:ring_stacker"})
		minetest.sound_play({name = "babycrafter_place_ring", gain = 0.6}, {to_player = player_name})
		minetest.sound_play({name = "babycrafter_slide_out", gain = 0.1}, {to_player = player_name})
		local inv = puncher:get_inventory()
		if creative then
			if not inv:contains_item("main", "babycrafter:ring_"..color[1]) then
				inv:add_item("main", "babycrafter:ring_"..color[1])
			end
		else
			inv:add_item("main", "babycrafter:ring_"..color[1])
		end
	end,
	on_rightclick = function(pos, node, clicker, itemstack)
		local player_name = clicker:get_player_name()
		local item = itemstack:get_name()
		for _,v in ipairs(color_index) do
			if item == "babycrafter:ring_"..v[1] then
				minetest.log("action", player_name.." places babycrafter:ring_"..v[1].." on a ring stacker at "..minetest.pos_to_string(pos))
				minetest.swap_node(pos, {name = "babycrafter:ring_stacker_color_"..v[1], param2 = node.param2})
				minetest.sound_play({name = "babycrafter_place_ring", gain = 1}, {to_player = player_name})
				if not creative then
					itemstack:take_item()
					return itemstack
				end
				break
			end
		end
	end
})

minetest.register_craft({
	output = "babycrafter:ring_stacker",
	recipe = {
		{"group:stick"},
		{"babycrafter:wood_block"}
	}
})

for _,v in ipairs(color_index) do
	local upv
	for i,v in ipairs(v[1]:split("_")) do
		if i == 1 then
			upv = v:gsub("^%l", string.upper)
		else
			upv = upv.." "..v:gsub("^%l", string.upper)
		end
	end

	minetest.register_node("babycrafter:wood_block_"..v[1], {
		description = upv.." Wood Block",
		drawtype = "normal",
		is_ground_content = false,
		tiles = {"babycrafter_wood_block_colored.png^[multiply:"..v[#v]},
		groups = {oddly_breakable_by_hand = 3, choppy = 2, flammable = 3, wood = 1, falling_node = 1},
		sounds = {
			footstep = {name = "", gain = 1},
			dig = {name = "babycrafter_dig", gain = 1},
			dug = {name = "babycrafter_dug", gain = 1},
			place = {name = "babycrafter_place", gain = 1}
		}
	})

	if stairs_path then
		stairs.register_stair_and_slab("wood_block_"..v[1], "babycrafter:wood_block_"..v[1],
				{oddly_breakable_by_hand = 3, choppy = 2, flammable = 3, falling_node = 1}, {"babycrafter_wood_block_colored.png^[multiply:"..v[#v]},
				upv.." Wood Block Stair", upv.." Wood Block Slab", {footstep = {name = "", gain = 1}, dig = {name = "babycrafter_dig", gain = 1},
				dug = {name = "babycrafter_dug", gain = 1}, place = {name = "babycrafter_place", gain = 1}})
		if mcstair_path then
			mcstair.register("wood_block_"..v[1])
		end
	end

	minetest.register_node("babycrafter:ring_"..v[1], {
		description = upv.." Ring",
		drawtype = "nodebox",
		paramtype = "light",
		is_ground_content = false,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.1875, -0.5, 0.1875, 0.5, -0.25, 0.5},
				{-0.5, -0.5, -0.1875, -0.1875, -0.25, 0.5},
				{-0.5, -0.5, -0.5, 0.1875, -0.25, -0.1875},
				{0.1875, -0.5, -0.5, 0.5, -0.25, 0.1875}
			}
		},
		selection_box = {
			type = "fixed",
			fixed = {{-0.5, -0.5, -0.5, 0.5, -0.25, 0.5}}
		},
		tiles = {"babycrafter_ring.png", "babycrafter_ring.png", "babycrafter_ring_side.png"},
		inventory_image = "babycrafter_ring.png",
		color = v[#v],
		groups = {dig_immediate = 3, falling_node = 1},
		sounds = {
			footstep = {name = "", gain = 1},
			dig = {name = "", gain = 1},
			dug = {name = "babycrafter_place_ring", gain = 0.2},
			place = {name = "babycrafter_place_ring", gain = 0.8}
		}
	})

	minetest.register_node("babycrafter:ring_stacker_color_"..v[1], {
		description = "Ring Stacker",
		drawtype = "nodebox",
		paramtype = "light",
		paramtype2 = "color",
		is_ground_content = false,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0.25, 0.5},
				{-0.1875, 0.25, -0.1875, 0.1875, 0.5, 0.1875}
			}
		},
		tiles = {
			{name = "babycrafter_wood_block.png^(babycrafter_ring.png^[multiply:"..v[#v]..")", color = "white"},
			{name = "babycrafter_wood_block.png", color = "white"},
			{name = "babycrafter_wood_block.png^[lowpart:75:babycrafter_ring_side.png\\^[multiply\\:"..v[#v].."^[lowpart:25:babycrafter_wood_block.png",
					color = "white"}
		},
		overlay_tiles = {"", "", "babycrafter_ring_side_1.png"},
		palette = "babycrafter_palette.png",
		groups = {oddly_breakable_by_hand = 3, choppy = 2, flammable = 3, wood = 1, falling_node = 1, not_in_creative_inventory = 1},
		sounds = {
			footstep = {name = "", gain = 1},
			dig = {name = "", gain = 1},
			dug = {name = "babycrafter_dug", gain = 1},
			place = {name = "babycrafter_place", gain = 1}
		},
		on_punch = function(pos, node, puncher)
			local player_name = puncher:get_player_name()
			minetest.log("action", player_name.." takes babycrafter:ring_"..v[1].." from a ring stacker at "..minetest.pos_to_string(pos))
			minetest.swap_node(pos, {name = "babycrafter:ring_stacker_color", param2 = node.param2})
			minetest.sound_play({name = "babycrafter_place_ring", gain = 0.6}, {to_player = player_name})
			minetest.sound_play({name = "babycrafter_slide_out", gain = 0.1}, {to_player = player_name})
			local inv = puncher:get_inventory()
			if creative then
				if not inv:contains_item("main", "babycrafter:ring_"..v[1]) then
					inv:add_item("main", "babycrafter:ring_"..v[1])
				end
			else
				inv:add_item("main", "babycrafter:ring_"..v[1])
			end
		end,
		on_rightclick = function(pos, node, clicker, itemstack)
			local player_name = clicker:get_player_name()
			local item = itemstack:get_name()
			for _,v2 in ipairs(color_index) do
				if item == "babycrafter:ring_"..v2[1] then
					minetest.log("action", player_name.." places babycrafter:ring_"..v2[1].." on a ring stacker at "..minetest.pos_to_string(pos))
					minetest.swap_node(pos, {name = "babycrafter:ring_stacker_color_"..v[1].."_"..v2[1], param2 = node.param2})
					minetest.sound_play({name = "babycrafter_place_ring", gain = 1}, {to_player = player_name})
					if not creative then
						itemstack:take_item()
						return itemstack
					end
					break
				end
			end
		end
	})
	for _,v2 in ipairs(color_index) do
		minetest.register_node("babycrafter:ring_stacker_color_"..v[1].."_"..v2[1], {
			description = "Ring Stacker",
			drawtype = "normal",
			paramtype = "light",
			paramtype2 = "color",
			is_ground_content = false,
			tiles = {
				{name = "babycrafter_wood_block.png^(babycrafter_ring.png^[multiply:"..v2[#v2]..")", color = "white"},
				{name = "babycrafter_wood_block.png", color = "white"},
				{name = "babycrafter_ring_side.png^[multiply:"..v2[#v2]..
						"^[lowpart:75:babycrafter_ring_side.png\\^[multiply\\:"..v[#v].."^[lowpart:25:babycrafter_wood_block.png", color = "white"}
			},
			overlay_tiles = {"", "", "babycrafter_ring_side_1.png"},
			palette = "babycrafter_palette.png",
			groups = {oddly_breakable_by_hand = 3, choppy = 2, flammable = 3, wood = 1, falling_node = 1, not_in_creative_inventory = 1},
			sounds = {
				footstep = {name = "", gain = 1},
				dig = {name = "", gain = 1},
				dug = {name = "babycrafter_dug", gain = 1},
				place = {name = "babycrafter_place", gain = 1}
			},
			on_punch = function(pos, node, puncher)
				local player_name = puncher:get_player_name()
				minetest.log("action", player_name.." takes babycrafter:ring_"..v2[1].." from a ring stacker at "..minetest.pos_to_string(pos))
				minetest.swap_node(pos, {name = "babycrafter:ring_stacker_color_"..v[1], param2 = node.param2})
				minetest.sound_play({name = "babycrafter_place_ring", gain = 0.8}, {to_player = player_name})
				minetest.sound_play({name = "babycrafter_slide_out", gain = 0.1}, {to_player = player_name})
				local inv = puncher:get_inventory()
				if creative then
					if not inv:contains_item("main", "babycrafter:ring_"..v2[1]) then
						inv:add_item("main", "babycrafter:ring_"..v2[1])
					end
				else
					inv:add_item("main", "babycrafter:ring_"..v2[1])
				end
			end
		})
	end

	minetest.register_craft({
		output = "babycrafter:ring_"..v[1],
		recipe = {
			{"default:clay_lump", "default:clay_lump", "default:clay_lump"},
			{"default:clay_lump", "dye:"..v[1], "default:clay_lump"},
			{"default:clay_lump", "default:clay_lump", "default:clay_lump"}
		}
	})

	minetest.register_craft({
		type = "shapeless",
		output = "babycrafter:wood_block_"..v[1],
		recipe = {"babycrafter:wood_block", "dye:"..v[1]}
	})

	if treasurer_path then
		treasurer.register_treasure("babycrafter:wood_block_"..v[1],0.001,2,{1,20},nil,"building_block")
		treasurer.register_treasure("babycrafter:ring_"..v[1],0.0002,2,1,nil,"deco")
	end
end

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
		{"group:wood", "group:wood"},
		{"group:wood", "group:wood"}
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
	treasurer.register_treasure("babycrafter:shape_sorter",0.002,4,1,nil,"deco")
	treasurer.register_treasure("babycrafter:red_square",0.002,2,1)
	treasurer.register_treasure("babycrafter:blue_circle",0.002,2,1)
	treasurer.register_treasure("babycrafter:green_triangle",0.002,2,1)
	treasurer.register_treasure("babycrafter:yellow_star",0.002,2,1)
	if ring_stacker_enabled == true then
		treasurer.register_treasure("babycrafter:ring_stacker",0.002,4,1,nil,"deco")
	end
end
