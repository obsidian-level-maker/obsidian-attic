--------------------------------------------------------------------
--  STRIFE LEVELS
--------------------------------------------------------------------
--
--  Copyright (C) 2006-2016 Andrew Apted
--  Copyright (C)      2011 Reisal
--  Copyright (C) 2019 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--------------------------------------------------------------------

STRIFE.SECRET_EXITS =
{

}


STRIFE.EPISODES =
{
  episode1 =
  {
    ep_index = 1,

    theme = "town",
    sky_patch = "P_BLUE1",
    dark_prob = 0,
    sky_light = 0.75,
  },

  episode2 =
  {
    ep_index = 2,

    theme = "town",
    sky_patch = "P_BLUE1",
    dark_prob = 0,
    sky_light = 0.75,
  },

  episode3 =
  {
    ep_index = 3,

    theme = "town",
    sky_patch = "P_BLUE1",
    dark_prob = 0,
    sky_light = 0.75,
  },
}


STRIFE.PREBUILT_LEVELS =
{

}


--------------------------------------------------------------------


function STRIFE.get_levels()
  local MAP_LEN_TAB = { few=4, episode=11, game=30 }

  local MAP_NUM = MAP_LEN_TAB[OB_CONFIG.length] or 1

  local EP_NUM = 1
  if MAP_NUM > 11 then EP_NUM = 2 end
  if MAP_NUM > 30 then EP_NUM = 3 end

  -- create episode info...

  for ep_index = 1,3 do
    local ep_info = GAME.EPISODES["episode" .. ep_index]
    assert(ep_info)

    local EPI = table.copy(ep_info)

    EPI.levels = { }

    table.insert(GAME.episodes, EPI)
  end

  -- create level info...

  for map = 1,MAP_NUM do
    -- determine episode from map number
    local ep_index
    local ep_along

    local game_along = map / MAP_NUM

    if map > 30 then
      ep_index = 3 ; ep_along = 0.5 ; game_along = 0.5
    elseif map > 20 then
      ep_index = 3 ; ep_along = (map - 20) / 10
    elseif map > 11 then
      ep_index = 2 ; ep_along = (map - 11) / 9
    else
      ep_index = 1 ; ep_along = map / 11
    end

    if OB_CONFIG.length == "single" then
      game_along = 0.57
      ep_along   = 0.75

    elseif OB_CONFIG.length == "few" then
      ep_along = game_along
    end

    assert(ep_along <= 1.0)
    assert(game_along <= 1.0)

    local EPI = GAME.episodes[ep_index]
    assert(EPI)

    local LEV =
    {
      episode = EPI,

      ep_along = ep_along,
      game_along = game_along
    }

    if map == 1 then
      LEV.name = "MAP02"
    elseif map == 2 then
      LEV.name = "MAP01"
    else
      LEV.name  = string.format("MAP%02d", map)
    end

    table.insert( EPI.levels, LEV)
    table.insert(GAME.levels, LEV)

    -- the 'dist_to_end' value is used for Boss monster decisions
    if map >= 29 and map <= 32 then
      LEV.dist_to_end = 33 - map
    elseif map == 11 or map == 21 then
      LEV.dist_to_end = 1
    elseif map == 16 or map == 23 then
      LEV.dist_to_end = 2
    end

    -- prebuilt levels
    local pb_name = LEV.name

      if PARAM.bool_prebuilt_levels == 1 then
        LEV.prebuilt = GAME.PREBUILT_LEVELS[LEV.name]
      end

    if LEV.prebuilt then
      LEV.name_class = LEV.prebuilt.name_class or "BOSS"
    end

    -- procedural gotcha management code

    -- Prebuilts are to exist over procedural gotchas
    -- this means procedural gotchas will not override
    -- Icon of Sin for example if prebuilts are still on
    if not LEV.prebuilt then

      --handling for the Final Only option
      if PARAM.gotcha_frequency == "final" then
        if OB_CONFIG.length == "single" then
          if map == 1 then LEV.is_procedural_gotcha = true end
        elseif OB_CONFIG.length == "few" then
          if map == 4 then LEV.is_procedural_gotcha = true end
        elseif OB_CONFIG.length == "episode" then
          if map == 11 then LEV.is_procedural_gotcha = true end
        elseif OB_CONFIG.length == "game" then
          if map == 30 then LEV.is_procedural_gotcha = true end
        end
      end

      --every 10 maps
      if PARAM.gotcha_frequency == "epi" then
        if map == 11 or map == 20 or map == 30 then
          LEV.is_procedural_gotcha = true
        end
      end
      if PARAM.gotcha_frequency == "2epi" then
        if map == 5 or map == 11 or map == 16 or map == 20 or map == 25 or map == 30 then
          LEV.is_procedural_gotcha = true
        end
      end
      if PARAM.gotcha_frequency == "3epi" then
        if map == 3 or map == 7 or map == 11 or map == 14 or map == 17 or map == 20 or map == 23 or map == 27 or map == 30 then
          LEV.is_procedural_gotcha = true
        end
      end
      if PARAM.gotcha_frequency == "4epi" then
        if map == 3 or map == 6 or map == 9 or map == 11 or map == 14 or map == 16 or map == 18 or map == 20 or map == 23 or map == 26 or map == 28 or map == 30 then
          LEV.is_procedural_gotcha = true
        end
      end

      --5% of maps after map 4,
      if PARAM.gotcha_frequency == "5p" then
        if map > 4 and map ~= 15 and map ~= 31 then
          if rand.odds(5) then LEV.is_procedural_gotcha = true end
        end
      end

      -- 10% of maps after map 4,
      if PARAM.gotcha_frequency == "10p" then
        if map > 4 and map ~= 15 and map ~= 31 then
          if rand.odds(10) then LEV.is_procedural_gotcha = true end
        end
      end

      -- for masochists... or debug testing
      if PARAM.gotcha_frequency == "all" then
        LEV.is_procedural_gotcha = true
      end
    end

    local special_mode = {}

    if PARAM.float_streets_mode and rand.odds(PARAM.float_streets_mode) then
      table.add_unique(special_mode, "streets")
    end
 
    if PARAM.float_linear_mode and rand.odds(PARAM.float_linear_mode) then
      table.add_unique(special_mode, "linear")
    end

    if PARAM.float_nature_mode and rand.odds(PARAM.float_nature_mode) then
      table.add_unique(special_mode, "nature")
    end

    if not table.empty(special_mode) and not LEV.prebuilt then
      local selected_mode = rand.pick(special_mode)
      if selected_mode == "streets" then
        LEV.has_streets = true
        LEV.is_linear = false
        LEV.is_nature = false
      elseif selected_mode == "linear" then
        LEV.has_streets = false
        LEV.is_linear = true
        LEV.is_nature = false
      else
        LEV.has_streets = false
        LEV.is_linear = false
        LEV.is_nature = true
      end
    else
      LEV.has_streets = false
      LEV.is_linear = false
      LEV.is_nature = false
    end
    
  end

  -- handle "dist_to_end" for FEW and EPISODE lengths
  if OB_CONFIG.length ~= "single" and OB_CONFIG.length ~= "game" then
    GAME.levels[#GAME.levels].dist_to_end = 1

    if OB_CONFIG.length == "episode" then
      GAME.levels[#GAME.levels - 1].dist_to_end = 2
      GAME.levels[#GAME.levels - 2].dist_to_end = 3
    end
  end
end
