HARMONY.PARAMETERS =
{
  teleporters = true,
  rails = true,
  switches = true,
  light_brushes = true,

  jump_height = 24,

  max_name_length = 28,

  skip_monsters = { 10,30 },

  time_factor   = 1.0,
  damage_factor = 1.0,
  ammo_factor   = 0.8,
  health_factor = 0.7,
  monster_factor = 0.75,

  titlepic_lump   = "TITLEPIC",
  titlepic_format = "patch",

  bex_map_prefix = "HUSTR_",
}

HARMONY.ACTIONS =
{
  --
  -- These keywords are used by prefabs that are remotely
  -- triggered (by a switch or walk-over line).
  --

  S1_OpenDoor = { id=103,  kind="open" },    -- opens and stays open
  W1_OpenDoor = { id=2,    kind="open" },    --
  GR_OpenDoor = { id=46,   kind="open" },    --

  W1_OpenDoorFast = { id=2, kind="open" },   -- [ Heretic lacks this ]

  S1_RaiseStair = { id=106,  kind="stair" },  -- 16 units
  W1_RaiseStair = { id=107,  kind="stair" },  --

  S1_FloorUp    = { id=18,  kind="floor_up" }, -- up to next highest floor

  S1_LowerFloor = { id=23, kind="lower" },  -- down to lowest nb floor
  W1_LowerFloor = { id=38, kind="lower" }  --
}
