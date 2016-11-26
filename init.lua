for _,v in ipairs({"a,1 0 0 0 0 0", "b,1 0 1 0 0 0", "c,1 1 0 0 0 0", "d,1 1 0 1 0 0", "e,1 0 0 1 0 0", "f,1 1 1 0 0 0",
		"g,1 1 1 1 0 0", "h,1 0 1 1 0 0", "i,0 1 1 0 0 0", "j,0 1 1 1 0 0", "k,1 0 0 0 1 0", "l,1 0 1 0 1 0",
		"m,1 1 0 0 1 0", "n,1 1 0 1 1 0", "o,1 0 0 1 1 0", "p,1 1 1 0 1 0", "q,1 1 1 1 1 0", "r,1 0 1 1 1 0",
		"s,0 1 1 0 1 0", "t,0 1 1 1 1 0", "u,1 0 0 0 1 1", "v,1 0 1 0 1 1", "w,0 1 1 1 0 1", "x,1 1 0 0 1 1",
		"y,1 1 0 1 1 1", "z,1 0 0 1 1 1"}) do
	local vt = v:split(",")

	minetest.register_node("babycrafter:alphabet_block_"..vt[1], {
		description = "Letter "..string.upper(vt[1]).." Alphabet Block",
		drawtype = "normal",
		paramtype2 = "facedir",
		tiles = {"babycrafter_"..vt[1]..".png"},
		groups = {oddly_breakable_by_hand = 3, cracky = 3, flammable = 1, falling_node = 1},
		sounds = default.node_sound_defaults(),
		on_rotate = screwdriver.rotate_simple
	})

	local braille = {}

	for i,v in ipairs(vt[2]:split(" ")) do
		if v == "1" then
			braille[i] = "default:paper"
		else
			braille[i] = "default:clay_lump"
		end
	end

	minetest.register_craft({
		output = "babycrafter:alphabet_block_"..vt[1],
		recipe = {
			{braille[1], braille[2]},
			{braille[3], braille[4]},
			{braille[5], braille[6]}
		}
	})
end

minetest.register_node("babycrafter:wood_block", {
	description = "Wood Block",
	drawtype = "normal",
	tiles = {"babycrafter_wood_block.png"},
	groups = {oddly_breakable_by_hand = 3, choppy = 2, flammable = 3, wood = 1, falling_node = 1},
	sounds = default.node_sound_wood_defaults()
})

minetest.register_node("babycrafter:shape_sorter", {
	description = "Shape Sorter",
	drawtype = "normal",
	paramtype2 = "facedir",
	tiles = {"babycrafter_shape_sorter.png", "babycrafter_wood_block.png"},
	groups = {oddly_breakable_by_hand = 3, choppy = 2, flammable = 3, falling_node = 1},
	sounds = default.node_sound_wood_defaults()
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
