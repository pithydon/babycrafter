local creative = minetest.settings:get_bool("creative_mode")
local stairs_path = minetest.get_modpath("stairs")
local mcstair_path = minetest.get_modpath("mcstair")
local treasurer_path = minetest.get_modpath("treasurer")

minetest.register_tool("babycrafter:rattle_blue", {
	description = "Blue Baby Rattle",
	inventory_image = "babycrafter_rattle_blue.png",
	wield_image = "babycrafter_rattle_blue.png",
	on_use = function(itemstack, user)
		minetest.sound_play({name = "babycrafter_rattle", gain = 1}, {pos = user:get_pos()}, true)
	end
})

minetest.register_tool("babycrafter:rattle_pink", {
	description = "Pink Baby Rattle",
	inventory_image = "babycrafter_rattle_pink.png",
	wield_image = "babycrafter_rattle_pink.png",
	on_use = function(itemstack, user)
		minetest.sound_play({name = "babycrafter_rattle", gain = 1}, {pos = user:get_pos()}, true)
	end
})

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

local clicked_shape = function(under, above, face_pos, face, rotate)
	local quad
	if under.x ~= above.x then
		local y = face_pos.y % 1
		local z = face_pos.z % 1
		if y < 0.5 then
			if z > 0.5 then
				quad = 1
			else
				quad = 2
			end
		else
			if z > 0.5 then
				quad = 3
			else
				quad = 4
			end
		end
	elseif under.y ~= above.y then
		local x = face_pos.x % 1
		local z = face_pos.z % 1
		if z < 0.5 then
			if x > 0.5 then
				quad = 1
			else
				quad = 2
			end
		else
			if x > 0.5 then
				quad = 3
			else
				quad = 4
			end
		end
	elseif under.z ~= above.z then
		local y = face_pos.y % 1
		local x = face_pos.x % 1
		if y < 0.5 then
			if x > 0.5 then
				quad = 1
			else
				quad = 2
			end
		else
			if x > 0.5 then
				quad = 3
			else
				quad = 4
			end
		end
	else
		return
	end
	if face == 0 then
		if under.y < above.y then
			if rotate == 0 then
				if quad == 1 then
					return "babycrafter:red_square"
				elseif quad == 2 then
					return "babycrafter:blue_circle"
				elseif quad == 3 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			elseif rotate == 1 then
				if quad == 2 then
					return "babycrafter:red_square"
				elseif quad == 4 then
					return "babycrafter:blue_circle"
				elseif quad == 1 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			elseif rotate == 2 then
				if quad == 4 then
					return "babycrafter:red_square"
				elseif quad == 3 then
					return "babycrafter:blue_circle"
				elseif quad == 2 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			else
				if quad == 3 then
					return "babycrafter:red_square"
				elseif quad == 1 then
					return "babycrafter:blue_circle"
				elseif quad == 4 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			end
		end
	elseif face == 1 then
		if under.z < above.z then
			if rotate == 0 then
				if quad == 3 then
					return "babycrafter:red_square"
				elseif quad == 4 then
					return "babycrafter:blue_circle"
				elseif quad == 1 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			elseif rotate == 1 then
				if quad == 4 then
					return "babycrafter:red_square"
				elseif quad == 2 then
					return "babycrafter:blue_circle"
				elseif quad == 3 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			elseif rotate == 2 then
				if quad == 2 then
					return "babycrafter:red_square"
				elseif quad == 1 then
					return "babycrafter:blue_circle"
				elseif quad == 4 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			else
				if quad == 1 then
					return "babycrafter:red_square"
				elseif quad == 3 then
					return "babycrafter:blue_circle"
				elseif quad == 2 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			end
		end
	elseif face == 2 then
		if under.z > above.z then
			if rotate == 0 then
				if quad == 1 then
					return "babycrafter:red_square"
				elseif quad == 2 then
					return "babycrafter:blue_circle"
				elseif quad == 3 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			elseif rotate == 1 then
				if quad == 2 then
					return "babycrafter:red_square"
				elseif quad == 4 then
					return "babycrafter:blue_circle"
				elseif quad == 1 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			elseif rotate == 2 then
				if quad == 4 then
					return "babycrafter:red_square"
				elseif quad == 3 then
					return "babycrafter:blue_circle"
				elseif quad == 2 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			else
				if quad == 3 then
					return "babycrafter:red_square"
				elseif quad == 1 then
					return "babycrafter:blue_circle"
				elseif quad == 4 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			end
		end
	elseif face == 3 then
		if under.x < above.x then
			if rotate == 0 then
				if quad == 2 then
					return "babycrafter:red_square"
				elseif quad == 4 then
					return "babycrafter:blue_circle"
				elseif quad == 1 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			elseif rotate == 1 then
				if quad == 4 then
					return "babycrafter:red_square"
				elseif quad == 3 then
					return "babycrafter:blue_circle"
				elseif quad == 2 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			elseif rotate == 2 then
				if quad == 3 then
					return "babycrafter:red_square"
				elseif quad == 1 then
					return "babycrafter:blue_circle"
				elseif quad == 4 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			else
				if quad == 1 then
					return "babycrafter:red_square"
				elseif quad == 2 then
					return "babycrafter:blue_circle"
				elseif quad == 3 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			end
		end
	elseif face == 4 then
		if under.x > above.x then
			if rotate == 0 then
				if quad == 4 then
					return "babycrafter:red_square"
				elseif quad == 2 then
					return "babycrafter:blue_circle"
				elseif quad == 3 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			elseif rotate == 1 then
				if quad == 2 then
					return "babycrafter:red_square"
				elseif quad == 1 then
					return "babycrafter:blue_circle"
				elseif quad == 4 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			elseif rotate == 2 then
				if quad == 1 then
					return "babycrafter:red_square"
				elseif quad == 3 then
					return "babycrafter:blue_circle"
				elseif quad == 2 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			else
				if quad == 3 then
					return "babycrafter:red_square"
				elseif quad == 4 then
					return "babycrafter:blue_circle"
				elseif quad == 1 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			end
		end
	else
		if under.y > above.y then
			if rotate == 0 then
				if quad == 2 then
					return "babycrafter:red_square"
				elseif quad == 1 then
					return "babycrafter:blue_circle"
				elseif quad == 4 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			elseif rotate == 1 then
				if quad == 1 then
					return "babycrafter:red_square"
				elseif quad == 3 then
					return "babycrafter:blue_circle"
				elseif quad == 2 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			elseif rotate == 2 then
				if quad == 3 then
					return "babycrafter:red_square"
				elseif quad == 4 then
					return "babycrafter:blue_circle"
				elseif quad == 1 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			else
				if quad == 4 then
					return "babycrafter:red_square"
				elseif quad == 2 then
					return "babycrafter:blue_circle"
				elseif quad == 3 then
					return "babycrafter:green_triangle"
				else
					return "babycrafter:yellow_star"
				end
			end
		end
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
		on_place = function(itemstack, placer, pointed_thing)
			if pointed_thing.type ~= "node" then
				return itemstack
			end
			local under = pointed_thing.under
			local above = pointed_thing.above
			local param2
			local pos = placer:get_pos()
			local x = pos.x - under.x
			local z = pos.z - under.z
			if math.abs(x) > math.abs(z) then
				if pos.x > under.x then
					param2 = 3
				else
					param2 = 1
				end
			else
				if pos.z > under.z then
					param2 = 2
				else
					param2 = 0
				end
			end
			if under.y > above.y or (under.y == above.y and minetest.pointed_thing_to_face_pos(placer, pointed_thing).y % 1 < 0.5) then
				if param2 == 0 then
					param2 = 8
				elseif param2 == 1 then
					param2 = 17
				elseif param2 == 2 then
					param2 = 6
				else
					param2 = 15
				end
			end
			return minetest.item_place_node(itemstack, placer, pointed_thing, param2)
		end,
		on_punch = function(pos, node, puncher, pointed_thing)
			local itemstack = puncher:get_wielded_item()
			if itemstack:is_empty() then
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory()
				if inv:get_size("shapes") ~= 4 then
					inv:set_size("shapes", 4)
					for _,v in ipairs(consinv) do
						inv:set_stack("shapes", v[1], v[2])
					end
				end
				local face = math.floor(node.param2 / 4) % 6
				local rotate = node.param2 % 4
				local face_pos = minetest.pointed_thing_to_face_pos(puncher, pointed_thing)
				local under = pointed_thing.under
				local above = pointed_thing.above
				local shape = clicked_shape(under, above, face_pos, face, rotate)
				local desc
				local ni
				if shape == "babycrafter:red_square" and i >= 8 then
					local stack = inv:get_stack("shapes", 1)
					if stack:get_name() == "babycrafter:red_square" then
						desc = "a red square"
						ni = i - 8
						local item = stack:peek_item()
						puncher:set_wielded_item(item)
						inv:remove_item("shapes", item)
					else
						return
					end
				elseif shape == "babycrafter:blue_circle" and i >= 4 then
					local stack = inv:get_stack("shapes", 2)
					if stack:get_name() == "babycrafter:blue_circle" then
						desc = "a blue circle"
						ni = i - 4
						local item = stack:peek_item()
						puncher:set_wielded_item(item)
						inv:remove_item("shapes", item)
					else
						return
					end
				elseif shape == "babycrafter:green_triangle" and i >= 2 then
					local stack = inv:get_stack("shapes", 3)
					if stack:get_name() == "babycrafter:green_triangle" then
						desc = "a green triangle"
						ni = i - 2
						local item = stack:peek_item()
						puncher:set_wielded_item(item)
						inv:remove_item("shapes", item)
					else
						return
					end
				elseif shape == "babycrafter:yellow_star" and i >= 1 then
					local stack = inv:get_stack("shapes", 4)
					if stack:get_name() == "babycrafter:yellow_star" then
						desc = "a yellow star"
						ni = i - 1
						local item = stack:peek_item()
						puncher:set_wielded_item(item)
						inv:remove_item("shapes", item)
					else
						return
					end
				else
					return
				end
				local new_name = "babycrafter:shape_sorter_"..ni
				if ni == 0 then
					new_name = "babycrafter:shape_sorter"
				end
				local player_name = puncher:get_player_name()
				minetest.swap_node(pos, {name = new_name, param2 = node.param2})
				minetest.sound_play({name = "babycrafter_slide_out", gain = 0.2}, {to_player = player_name}, true)
				minetest.log("action", player_name.." takes "..desc.." from a shape sorter at "..minetest.pos_to_string(pos))
			end
		end,
		on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			if inv:get_size("shapes") ~= 4 then
				inv:set_size("shapes", 4)
				for _,v in ipairs(consinv) do
					inv:set_stack("shapes", v[1], v[2])
				end
			end
			local name = itemstack:get_name()
			local face = math.floor(node.param2 / 4) % 6
			local rotate = node.param2 % 4
			local face_pos = minetest.pointed_thing_to_face_pos(clicker, pointed_thing)
			local under = pointed_thing.under
			local above = pointed_thing.above
			local player_name = clicker:get_player_name()
			if name == clicked_shape(under, above, face_pos, face, rotate) then
				local desc
				local ni
				if name == "babycrafter:red_square" and inv:get_stack("shapes", 1):is_empty() and i < 8 then
					desc = "red square"
					ni = i + 8
					inv:set_stack("shapes", 1, ItemStack("babycrafter:red_square"))
				elseif name == "babycrafter:blue_circle" and inv:get_stack("shapes", 2):is_empty() and i < 12 then
					desc = "blue circle"
					ni = i + 4
					inv:set_stack("shapes", 2, ItemStack("babycrafter:blue_circle"))
				elseif name == "babycrafter:green_triangle" and inv:get_stack("shapes", 3):is_empty() and i < 14 then
					desc = "green triangle"
					ni = i + 2
					inv:set_stack("shapes", 3, ItemStack("babycrafter:green_triangle"))
				elseif name == "babycrafter:yellow_star" and inv:get_stack("shapes", 4):is_empty() and i < 15 then
					desc = "yellow star"
					ni = i + 1
					inv:set_stack("shapes", 4, ItemStack("babycrafter:yellow_star"))
				else
					minetest.show_formspec(player_name, "babycrafter:shape_sorter_formspec", "size[8,7;]background[0,0;8,7;babycrafter_shape_sorter_formspec.png;true]"..
							"bgcolor[#bbbb;true]listcolors[#0000;#594d38aa;#0000;#787e50;#fff]list[nodemeta:"..pos.x..","..pos.y..","..pos.z..
							";shapes;3,0.3;2,2;]list[current_player;main;0,2.85;8,1;]list[current_player;main;0,4.08;8,3;8]listring[nodemeta:"..
							pos.x..","..pos.y..","..pos.z..";shapes]listring[current_player;main]"..invimgs)
					return
				end
				minetest.swap_node(pos, {name = "babycrafter:shape_sorter_"..ni, param2 = node.param2})
				minetest.sound_play({name = "babycrafter_slide_in", gain = 0.2}, {to_player = player_name}, true)
				minetest.log("action", player_name.." places a "..desc.." in a shape sorter at "..minetest.pos_to_string(pos))
				itemstack:take_item()
				return itemstack
			else
				minetest.show_formspec(player_name, "babycrafter:shape_sorter_formspec", "size[8,7;]background[0,0;8,7;babycrafter_shape_sorter_formspec.png;true]"..
						"bgcolor[#bbbb;true]listcolors[#0000;#594d38aa;#0000;#787e50;#fff]list[nodemeta:"..pos.x..","..pos.y..","..pos.z..
						";shapes;3,0.3;2,2;]list[current_player;main;0,2.85;8,1;]list[current_player;main;0,4.08;8,3;8]listring[nodemeta:"..
						pos.x..","..pos.y..","..pos.z..";shapes]listring[current_player;main]"..invimgs)
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
			if name == "babycrafter:red_square" and index == 1 and i < 8 then
				desc = "red square"
				ni = i + 8
			elseif name == "babycrafter:blue_circle" and index == 2 and i < 12 then
				desc = "blue circle"
				ni = i + 4
			elseif name == "babycrafter:green_triangle" and index == 3 and i < 14 then
				desc = "green triangle"
				ni = i + 2
			elseif name == "babycrafter:yellow_star" and index == 4 and i < 15 then
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
			minetest.sound_play({name = "babycrafter_slide_in", gain = 0.2}, {to_player = player_name}, true)
			minetest.log("action", player_name.." places a "..desc.." in a shape sorter at "..minetest.pos_to_string(pos))
		end,
		on_metadata_inventory_take = function(pos, listname, index, stack, player)
			local name = stack:get_name()
			local desc
			local ni
			if name == "babycrafter:red_square" and index == 1 and i >= 8 then
				desc = "a red square"
				ni = i - 8
			elseif name == "babycrafter:blue_circle" and index == 2 and i >= 4 then
				desc = "a blue circle"
				ni = i - 4
			elseif name == "babycrafter:green_triangle" and index == 3 and i >= 2 then
				desc = "a green triangle"
				ni = i - 2
			elseif name == "babycrafter:yellow_star" and index == 4 and i >= 1 then
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
			minetest.sound_play({name = "babycrafter_slide_out", gain = 0.2}, {to_player = player_name}, true)
			minetest.log("action", player_name.." takes "..desc.." from a shape sorter at "..minetest.pos_to_string(pos))
		end
	})

	minetest.register_lbm({
		name = "babycrafter:update_shape_sorter",
		nodenames = {node_name},
		run_at_every_load = false,
		action = function(pos, node)
			local meta = minetest.get_meta(pos)
			meta:set_string("formspec", "")
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
			on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory()
				if inv:get_size("shapes") ~= 4 then
					inv:set_size("shapes", 4)
					for _,v in ipairs(consinv) do
						inv:set_stack("shapes", v[1], v[2])
					end
				end
				local name = itemstack:get_name()
				local face = math.floor(node.param2 / 4) % 6
				local rotate = node.param2 % 4
				local face_pos = minetest.pointed_thing_to_face_pos(clicker, pointed_thing)
				local under = pointed_thing.under
				local above = pointed_thing.above
				local player_name = clicker:get_player_name()
				if name == clicked_shape(under, above, face_pos, face, rotate) then
					local desc
					if name == "babycrafter:red_square" and inv:get_stack("shapes", 1):is_empty() and v == 7 then
						desc = "red square"
						inv:set_stack("shapes", 1, ItemStack("babycrafter:red_square"))
					elseif name == "babycrafter:blue_circle" and inv:get_stack("shapes", 2):is_empty() and v == 11 then
						desc = "blue circle"
						inv:set_stack("shapes", 2, ItemStack("babycrafter:blue_circle"))
					elseif name == "babycrafter:green_triangle" and inv:get_stack("shapes", 3):is_empty() and v == 13 then
						desc = "green triangle"
						inv:set_stack("shapes", 3, ItemStack("babycrafter:green_triangle"))
					elseif name == "babycrafter:yellow_star" and inv:get_stack("shapes", 4):is_empty() and v == 14 then
						desc = "yellow star"
						inv:set_stack("shapes", 4, ItemStack("babycrafter:yellow_star"))
					else
						minetest.show_formspec(player_name, "babycrafter:shape_sorter_formspec", "size[8,7;]background[0,0;8,7;babycrafter_shape_sorter_formspec.png;true]"..
								"bgcolor[#bbbb;true]listcolors[#0000;#594d38aa;#0000;#787e50;#fff]list[nodemeta:"..pos.x..","..pos.y..","..pos.z..
								";shapes;3,0.3;2,2;]list[current_player;main;0,2.85;8,1;]list[current_player;main;0,4.08;8,3;8]listring[nodemeta:"..
								pos.x..","..pos.y..","..pos.z..";shapes]listring[current_player;main]"..invimgs)
						return
					end
					minetest.swap_node(pos, {name = "babycrafter:shape_sorter_15", param2 = node.param2})
					minetest.sound_play({name = "babycrafter_slide_in", gain = 0.2}, {to_player = player_name}, true)
					mesecon.receptor_on(pos, mesecon.rules.alldirs)
					minetest.log("action", player_name.." places a "..desc.." in a shape sorter at "..minetest.pos_to_string(pos))
					itemstack:take_item()
					return itemstack
				else
					minetest.show_formspec(player_name, "babycrafter:shape_sorter_formspec", "size[8,7;]background[0,0;8,7;babycrafter_shape_sorter_formspec.png;true]"..
							"bgcolor[#bbbb;true]listcolors[#0000;#594d38aa;#0000;#787e50;#fff]list[nodemeta:"..pos.x..","..pos.y..","..pos.z..
							";shapes;3,0.3;2,2;]list[current_player;main;0,2.85;8,1;]list[current_player;main;0,4.08;8,3;8]listring[nodemeta:"..
							pos.x..","..pos.y..","..pos.z..";shapes]listring[current_player;main]"..invimgs)
				end
			end,
			on_metadata_inventory_put = function(pos, listname, index, stack, player)
				local name = stack:get_name()
				local desc
				if name == "babycrafter:red_square" and index == 1 and v == 7 then
					desc = "red square"
				elseif name == "babycrafter:blue_circle" and index == 2 and v == 11 then
					desc = "blue circle"
				elseif name == "babycrafter:green_triangle" and index == 3 and v == 13 then
					desc = "green triangle"
				elseif name == "babycrafter:yellow_star" and index == 4 and v == 14 then
					desc = "yellow star"
				else
					minetest.log("error", player:get_player_name().." placed a misshaped \""..name
					.."\" in a \"babycrafter:shape_sorter_"..v.."\" at "..minetest.pos_to_string(pos))
					return
				end
				local node = minetest.get_node(pos)
				local player_name = player:get_player_name()
				minetest.swap_node(pos, {name = "babycrafter:shape_sorter_15", param2 = node.param2})
				minetest.sound_play({name = "babycrafter_slide_in", gain = 0.2}, {to_player = player_name}, true)
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
		on_punch = function(pos, node, puncher, pointed_thing)
			local itemstack = puncher:get_wielded_item()
			if itemstack:is_empty() then
				local meta = minetest.get_meta(pos)
				local inv = meta:get_inventory()
				if inv:get_size("shapes") ~= 4 then
					inv:set_size("shapes", 4)
					for _,v in ipairs(consinv) do
						inv:set_stack("shapes", v[1], v[2])
					end
				end
				local face = math.floor(node.param2 / 4) % 6
				local rotate = node.param2 % 4
				local face_pos = minetest.pointed_thing_to_face_pos(puncher, pointed_thing)
				local under = pointed_thing.under
				local above = pointed_thing.above
				local shape = clicked_shape(under, above, face_pos, face, rotate)
				local desc
				local i
				if shape == "babycrafter:red_square" then
					local stack = inv:get_stack("shapes", 1)
					if stack:get_name() == "babycrafter:red_square" then
						desc = "a red square"
						i = 15 - 8
						local item = stack:peek_item()
						puncher:set_wielded_item(item)
						inv:remove_item("shapes", item)
					else
						return
					end
				elseif shape == "babycrafter:blue_circle" then
					local stack = inv:get_stack("shapes", 2)
					if stack:get_name() == "babycrafter:blue_circle" then
						desc = "a blue circle"
						i = 15 - 4
						local item = stack:peek_item()
						puncher:set_wielded_item(item)
						inv:remove_item("shapes", item)
					else
						return
					end
				elseif shape == "babycrafter:green_triangle" then
					local stack = inv:get_stack("shapes", 3)
					if stack:get_name() == "babycrafter:green_triangle" then
						desc = "a green triangle"
						i = 15 - 2
						local item = stack:peek_item()
						puncher:set_wielded_item(item)
						inv:remove_item("shapes", item)
					else
						return
					end
				elseif shape == "babycrafter:yellow_star" then
					local stack = inv:get_stack("shapes", 4)
					if stack:get_name() == "babycrafter:yellow_star" then
						desc = "a yellow star"
						i = 15 - 1
						local item = stack:peek_item()
						puncher:set_wielded_item(item)
						inv:remove_item("shapes", item)
					else
						return
					end
				else
					return
				end
				local new_name = "babycrafter:shape_sorter_"..i
				local player_name = puncher:get_player_name()
				minetest.swap_node(pos, {name = new_name, param2 = node.param2})
				minetest.sound_play({name = "babycrafter_slide_out", gain = 0.2}, {to_player = player_name}, true)
				mesecon.receptor_off(pos, mesecon.rules.alldirs)
				minetest.log("action", player_name.." takes "..desc.." from a shape sorter at "..minetest.pos_to_string(pos))
			end
		end,
		on_metadata_inventory_take = function(pos, listname, index, stack, player)
			local name = stack:get_name()
			local desc
			local i
			if name == "babycrafter:red_square" and index == 1 then
				desc = "a red square"
				i = 15 - 8
			elseif name == "babycrafter:blue_circle" and index == 2 then
				desc = "a blue circle"
				i = 15 - 4
			elseif name == "babycrafter:green_triangle" and index == 3 then
				desc = "a green triangle"
				i = 15 - 2
			elseif name == "babycrafter:yellow_star" and index == 4 then
				desc = "a yellow star"
				i = 15 - 1
			else
				minetest.log("error", player:get_player_name().." takes a misshaped \""..name
				.."\" from a \"babycrafter:shape_sorter_15\" at "..minetest.pos_to_string(pos))
				return
			end
			local node = minetest.get_node(pos)
			local player_name = player:get_player_name()
			minetest.swap_node(pos, {name = "babycrafter:shape_sorter_"..i, param2 = node.param2})
			minetest.sound_play({name = "babycrafter_slide_out", gain = 0.2}, {to_player = player_name}, true)
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
				minetest.sound_play({name = "babycrafter_place_ring", gain = 1}, {to_player = player_name}, true)
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
		minetest.sound_play({name = "babycrafter_place_ring", gain = 0.6}, {to_player = player_name}, true)
		minetest.sound_play({name = "babycrafter_slide_out", gain = 0.1}, {to_player = player_name}, true)
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
				minetest.sound_play({name = "babycrafter_place_ring", gain = 1}, {to_player = player_name}, true)
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
			minetest.sound_play({name = "babycrafter_place_ring", gain = 0.6}, {to_player = player_name}, true)
			minetest.sound_play({name = "babycrafter_slide_out", gain = 0.1}, {to_player = player_name}, true)
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
					minetest.sound_play({name = "babycrafter_place_ring", gain = 1}, {to_player = player_name}, true)
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
				minetest.sound_play({name = "babycrafter_place_ring", gain = 0.8}, {to_player = player_name}, true)
				minetest.sound_play({name = "babycrafter_slide_out", gain = 0.1}, {to_player = player_name}, true)
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
	output = "babycrafter:rattle_blue",
	recipe = {
		{"", "default:clay_lump", "dye:blue"},
		{"", "group:stick", "default:clay_lump"},
		{"group:stick", "", ""}
	}
})

minetest.register_craft({
	output = "babycrafter:rattle_pink",
	recipe = {
		{"", "default:clay_lump", "dye:pink"},
		{"", "group:stick", "default:clay_lump"},
		{"group:stick", "", ""}
	}
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
		{"", "dye:blue", ""},
		{"dye:blue", "default:clay_lump", "dye:blue"},
		{"", "dye:blue", ""}
	}
})

minetest.register_craft({
	output = "babycrafter:green_triangle",
	recipe = {
		{"", "dye:green", ""},
		{"", "default:clay_lump", ""},
		{"dye:green", "dye:green", "dye:green"}
	}
})

minetest.register_craft({
	output = "babycrafter:yellow_star",
	recipe = {
		{"default:clay_lump", "dye:yellow", "dye:yellow"},
		{"dye:yellow", "", ""},
		{"dye:yellow", "", ""}
	}
})

if minetest.get_modpath("dungeon_loot") then
	dungeon_loot.register({{name = "babycrafter:rattle_blue", chance = 0.5}, {name = "babycrafter:rattle_pink", chance = 0.5}})
end

if treasurer_path then
	treasurer.register_treasure("babycrafter:rattle_blue",0.02,2,1)
	treasurer.register_treasure("babycrafter:rattle_pink",0.02,2,1)
	treasurer.register_treasure("babycrafter:wood_block",0.006,2,{1,20},nil,"building_block")
	treasurer.register_treasure("babycrafter:shape_sorter",0.002,4,1,nil,"deco")
	treasurer.register_treasure("babycrafter:red_square",0.002,2,1)
	treasurer.register_treasure("babycrafter:blue_circle",0.002,2,1)
	treasurer.register_treasure("babycrafter:green_triangle",0.002,2,1)
	treasurer.register_treasure("babycrafter:yellow_star",0.002,2,1)
	treasurer.register_treasure("babycrafter:ring_stacker",0.002,4,1,nil,"deco")
end
