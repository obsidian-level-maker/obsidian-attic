HARMONY = { }

----------------------------------------------------------------
gui.import("params")
gui.import("entities")
gui.import("factory") -- For earlier Oblige versions
gui.import("monsters")
gui.import("pickups")
gui.import("weapons")
gui.import("materials")
gui.import("themes")
gui.import("levels")
gui.import("resources")
gui.import("vanilla_mats")
gui.import("names")
----------------------------------------------------------------

function HARMONY.all_done()
	gui.wad_insert_file("data/endoom/ENDOOM.bin", "ENDOOM")
end

OB_GAMES["harmony"] =
{
	label = _("Harmony"),
	priority = 91,
	
	engine = "idtech_1",
	format = "doom",
	--sub_format = "harmony",
	
	game_dir = "harmony",
	iwad_name = "harm1.wad",

	tables =
	{
		HARMONY
	},
	
	hooks =
	{
		--setup = HARMONY.setup,
		slump_setup = HARMONY.slump_setup,
		get_levels = HARMONY.get_levels,
		all_done = HARMONY.all_done
	},
}