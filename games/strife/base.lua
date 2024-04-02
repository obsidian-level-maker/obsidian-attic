------------------------------------------------------------------------
--  BASE FILE for STRIFE
------------------------------------------------------------------------
--
--  Oblige Level Maker
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
------------------------------------------------------------------------

STRIFE = { }


------------------------------------------------------------
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

------------------------------------------------------------

function STRIFE.all_done()
  local convo_file = "games/strife/data/CONVERSATIONS.wad"

  gui.wad_transfer_lump(convo_file, "SCRIPT00", "SCRIPT00")

  gui.wad_insert_file("data/endoom/ENDOOM.bin", "ENDSTRF")
end


OB_GAMES["strife"] =
{
  label = _("Strife"),
  priority = 89,

  engine = "idtech_1",
  format = "doom",
  --sub_format = "strife",

  game_dir = "strife",
  iwad_name = "strife1.wad",

  tables =
  {
    STRIFE
  },

  hooks =
  {
    factory_setup = STRIFE.factory_setup,
    slump_setup = STRIFE.slump_setup,
    get_levels = STRIFE.get_levels,
    all_done   = STRIFE.all_done
  },
}

