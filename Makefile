#----------------------------------------------------------------
# OBSIDIAN
#----------------------------------------------------------------
#
# GNU Makefile for Unix/Linux with system-wide install
#
# Using this makefile (make, make install) will place the
# executable, script and data files in standard Unixy places.
#
# NOTE: a system-wide FLTK library is assumed
#

PROGRAM=Obsidian

# prefix choices: /usr  /usr/local  /opt
PREFIX=/usr

SCRIPT_DIR=$(PREFIX)/share/obsidian

CXX=g++

OBJ_DIR=obj_linux

OPTIMISE=-O2

# operating system choices: UNIX WIN32
OS=UNIX


#--- Internal stuff from here -----------------------------------

# assumes system-wide FLTK installation
FLTK_CONFIG=fltk-config
FLTK_FLAGS=$(shell $(FLTK_CONFIG) --cflags)
FLTK_LIBS=$(shell $(FLTK_CONFIG) --use-images --ldflags)

CXXFLAGS=$(OPTIMISE) -Wall -D$(OS) -Isource_files/lua_src -Isource_files/zdbsp_src -Isource_files/ajpoly_src -Isource_files/acc_src -Isource_files/physfs_src $(FLTK_FLAGS)
LDFLAGS=-L/usr/X11R6/lib
LIBS=-lm -lz $(FLTK_LIBS)


#----- OBSIDIAN Objects ----------------------------------------------

OBJS=	$(OBJ_DIR)/main.o      \
	$(OBJ_DIR)/m_about.o  \
	$(OBJ_DIR)/m_addons.o  \
	$(OBJ_DIR)/m_cookie.o  \
	$(OBJ_DIR)/m_dialog.o  \
	$(OBJ_DIR)/m_lua.o     \
	$(OBJ_DIR)/m_manage.o  \
	$(OBJ_DIR)/m_options.o  \
	$(OBJ_DIR)/m_trans.o  \
	$(OBJ_DIR)/lib_argv.o  \
	$(OBJ_DIR)/lib_file.o  \
	$(OBJ_DIR)/lib_signal.o \
	$(OBJ_DIR)/lib_util.o  \
	$(OBJ_DIR)/lib_grp.o   \
	$(OBJ_DIR)/lib_pak.o   \
	$(OBJ_DIR)/lib_tga.o   \
	$(OBJ_DIR)/lib_wad.o   \
	$(OBJ_DIR)/lib_zip.o   \
	$(OBJ_DIR)/sys_assert.o \
	$(OBJ_DIR)/sys_debug.o \
	$(OBJ_DIR)/img_bolt.o  \
	$(OBJ_DIR)/img_pill.o  \
	$(OBJ_DIR)/img_carve.o \
	$(OBJ_DIR)/img_relief.o \
	$(OBJ_DIR)/img_font1.o  \
	\
	$(OBJ_DIR)/csg_bsp.o  \
	$(OBJ_DIR)/csg_clip.o  \
	$(OBJ_DIR)/csg_main.o  \
	$(OBJ_DIR)/csg_doom.o  \
	$(OBJ_DIR)/csg_nukem.o \
	$(OBJ_DIR)/csg_quake.o \
	$(OBJ_DIR)/csg_shade.o \
	$(OBJ_DIR)/csg_spots.o \
	$(OBJ_DIR)/dm_extra.o  \
	$(OBJ_DIR)/dm_prefab.o \
	$(OBJ_DIR)/g_doom.o    \
	$(OBJ_DIR)/g_nukem.o   \
	$(OBJ_DIR)/g_quake.o   \
	$(OBJ_DIR)/g_quake2.o  \
	$(OBJ_DIR)/g_quake3.o  \
	$(OBJ_DIR)/g_wolf.o    \
	$(OBJ_DIR)/q_common.o  \
	$(OBJ_DIR)/q_light.o   \
	$(OBJ_DIR)/q_tjuncs.o  \
	$(OBJ_DIR)/q_vis.o     \
	$(OBJ_DIR)/vis_buffer.o \
	$(OBJ_DIR)/vis_occlude.o \
	\
	$(OBJ_DIR)/tx_forge.o  \
	$(OBJ_DIR)/tx_skies.o  \
	$(OBJ_DIR)/ui_build.o  \
	$(OBJ_DIR)/ui_game.o   \
	$(OBJ_DIR)/ui_hyper.o  \
	$(OBJ_DIR)/ui_map.o    \
	$(OBJ_DIR)/ui_module.o \
	$(OBJ_DIR)/ui_rchoice.o \
	$(OBJ_DIR)/ui_window.o \
	\
	$(OBJ_DIR)/zf_menu.o \
	$(OBJ_DIR)/twister.o

$(OBJ_DIR)/%.o: source_files/gui/%.cc
	$(CXX) $(CXXFLAGS) -o $@ -c $<


#----- LUA Objects --------------------------------------------------

LUA_OBJS=\
	$(OBJ_DIR)/lua/lapi.o   \
	$(OBJ_DIR)/lua/lauxlib.o   \
	$(OBJ_DIR)/lua/lbaselib.o   \
	$(OBJ_DIR)/lua/lcode.o   \
	$(OBJ_DIR)/lua/lcorolib.o   \
	$(OBJ_DIR)/lua/lctype.o   \
	$(OBJ_DIR)/lua/ldblib.o   \
	$(OBJ_DIR)/lua/ldebug.o   \
	$(OBJ_DIR)/lua/ldo.o   \
	$(OBJ_DIR)/lua/ldump.o   \
	$(OBJ_DIR)/lua/lfunc.o   \
	$(OBJ_DIR)/lua/lgc.o   \
	$(OBJ_DIR)/lua/linit.o   \
	$(OBJ_DIR)/lua/liolib.o   \
	$(OBJ_DIR)/lua/llex.o   \
	$(OBJ_DIR)/lua/lmathlib.o   \
	$(OBJ_DIR)/lua/lmem.o   \
	$(OBJ_DIR)/lua/loadlib.o   \
	$(OBJ_DIR)/lua/lobject.o   \
	$(OBJ_DIR)/lua/lopcodes.o   \
	$(OBJ_DIR)/lua/loslib.o   \
	$(OBJ_DIR)/lua/lparser.o   \
	$(OBJ_DIR)/lua/lstate.o   \
	$(OBJ_DIR)/lua/lstring.o   \
	$(OBJ_DIR)/lua/lstrlib.o   \
	$(OBJ_DIR)/lua/ltable.o   \
	$(OBJ_DIR)/lua/ltablib.o   \
	$(OBJ_DIR)/lua/ltm.o   \
	$(OBJ_DIR)/lua/lundump.o   \
	$(OBJ_DIR)/lua/lutf8lib.o   \
	$(OBJ_DIR)/lua/lvm.o   \
	$(OBJ_DIR)/lua/lzio.o   

LUA_CXXFLAGS=$(OPTIMISE) -Wall -DLUA_ANSI -DLUA_USE_MKSTEMP

$(OBJ_DIR)/lua/%.o: source_files/lua_src/%.c
	$(CXX) $(LUA_CXXFLAGS) -o $@ -c $<


#----- AJ-Polygonator Objects --------------------------------------

AJPOLY_OBJS= \
	$(OBJ_DIR)/ajpoly/pl_map.o   \
	$(OBJ_DIR)/ajpoly/pl_poly.o  \
	$(OBJ_DIR)/ajpoly/pl_util.o  \
	$(OBJ_DIR)/ajpoly/pl_wad.o

AJPOLY_CXXFLAGS=$(OPTIMISE) -Wall -Isource_files/physfs_src

$(OBJ_DIR)/ajpoly/%.o: source_files/ajpoly_src/%.cc
	$(CXX) $(AJPOLY_CXXFLAGS) -o $@ -c $<

#----- ACC Objects --------------------------------------------------

ACC_OBJS= \
	$(OBJ_DIR)/acc/acc.o  \
	$(OBJ_DIR)/acc/error.o \
	$(OBJ_DIR)/acc/misc.o     \
	$(OBJ_DIR)/acc/parse.o     \
	$(OBJ_DIR)/acc/pcode.o  \
	$(OBJ_DIR)/acc/strlist.o \
	$(OBJ_DIR)/acc/symbol.o     \
	$(OBJ_DIR)/acc/token.o  

ACC_CXXFLAGS=$(OPTIMISE) -Wall -DINLINE_G=inline

$(OBJ_DIR)/acc/%.o: source_files/acc_src/%.c
	$(CXX) $(ACC_CXXFLAGS) -o $@ -c $<


#----- ZDBSP Objects ------------------------------------------------

ZDBSP_OBJS= \
	$(OBJ_DIR)/zdbsp/zdmain.o  \
	$(OBJ_DIR)/zdbsp/blockmapbuilder.o \
	$(OBJ_DIR)/zdbsp/processor.o     \
	$(OBJ_DIR)/zdbsp/processor_udmf.o     \
	$(OBJ_DIR)/zdbsp/sc_man.o  \
	$(OBJ_DIR)/zdbsp/zdwad.o \
	$(OBJ_DIR)/zdbsp/nodebuild.o     \
	$(OBJ_DIR)/zdbsp/rejectbuilder.o  \
	$(OBJ_DIR)/zdbsp/rejectbuilder_nogl.o  \
	$(OBJ_DIR)/zdbsp/vis.o  \
	$(OBJ_DIR)/zdbsp/visflow.o  \
	$(OBJ_DIR)/zdbsp/nodebuild_events.o  \
	$(OBJ_DIR)/zdbsp/nodebuild_extract.o   \
	$(OBJ_DIR)/zdbsp/nodebuild_gl.o      \
	$(OBJ_DIR)/zdbsp/nodebuild_utility.o   \
	$(OBJ_DIR)/zdbsp/nodebuild_classify_nosse2.o   

ZDBSP_CXXFLAGS=$(OPTIMISE) -Wall -DINLINE_G=inline

$(OBJ_DIR)/zdbsp/%.o: source_files/zdbsp_src/%.cc
	$(CXX) $(ZDBSP_CXXFLAGS) -o $@ -c $<
	
#----- PhysFS Objects ---------------------------------------------

PHYSFS_OBJS= \
	$(OBJ_DIR)/physfs/physfs_byteorder.o  \
	$(OBJ_DIR)/physfs/physfs.o  \
	$(OBJ_DIR)/physfs/physfs_unicode.o  \
	$(OBJ_DIR)/physfs/physfs_archiver_7z.o   \
	$(OBJ_DIR)/physfs/physfs_archiver_grp.o   \
	$(OBJ_DIR)/physfs/physfs_archiver_dir.o   \
	$(OBJ_DIR)/physfs/physfs_archiver_qpak.o   \
	$(OBJ_DIR)/physfs/physfs_archiver_hog.o   \
	$(OBJ_DIR)/physfs/physfs_archiver_mvl.o   \
	$(OBJ_DIR)/physfs/physfs_archiver_wad.o   \
	$(OBJ_DIR)/physfs/physfs_archiver_slb.o   \
	$(OBJ_DIR)/physfs/physfs_archiver_iso9660.o   \
	$(OBJ_DIR)/physfs/physfs_archiver_unpacked.o   \
	$(OBJ_DIR)/physfs/physfs_archiver_vdf.o   \
	$(OBJ_DIR)/physfs/physfs_archiver_zip.o   \
	$(OBJ_DIR)/physfs/physfs_platform_unix.o   \
	$(OBJ_DIR)/physfs/physfs_platform_posix.o 

PHYSFS_CXXFLAGS=$(OPTIMISE) -Wall

$(OBJ_DIR)/physfs/%.o: source_files/physfs_src/%.cc
	$(CXX) $(PHYSFS_CXXFLAGS) -o $@ -c $<


#----- Language Analysis ------------------------------------------

LANG_FILES= \
	source_files/gui/*.cc \
	source_files/gui/*.h  \
	scripts/*.lua \
	engines/*.lua \
	modules/*.lua \
	games/*/*.lua


#----- Targets ----------------------------------------------------

all: $(PROGRAM)

$(PROGRAM): $(OBJS) $(LUA_OBJS) $(ZDBSP_OBJS) $(AJPOLY_OBJS) $(PHYSFS_OBJS) $(ACC_OBJS)
	$(CXX) -Wl,--warn-common $^ -o $@ $(LDFLAGS) $(LIBS)

clean:
	rm -f $(PROGRAM) $(OBJ_DIR)/*.o ERRS
	rm -f $(OBJ_DIR)/lua/*.o
	rm -f $(OBJ_DIR)/acc/*.o
	rm -f $(OBJ_DIR)/ajpoly/*.o
	rm -f $(OBJ_DIR)/physfs/*.o
	rm -f $(OBJ_DIR)/zdbsp/*.o
	rm -f LANG_TEMPLATE.txt

halfclean:
	rm -f $(PROGRAM) $(OBJ_DIR)/*.o ERRS

svgclean:
	rm -f grow*.svg

stripped: $(PROGRAM)
	strip --strip-unneeded $(PROGRAM)

install: stripped
	install -o root -m 755 $(PROGRAM) $(PREFIX)/bin/obsidian
	#
	install -d $(SCRIPT_DIR)/scripts
	install -d $(SCRIPT_DIR)/engines
	install -d $(SCRIPT_DIR)/modules
	install -d $(SCRIPT_DIR)/modules/heretic
	install -d $(SCRIPT_DIR)/modules/hexen
	install -d $(SCRIPT_DIR)/modules/strife
	install -d $(SCRIPT_DIR)/modules/zdoom_internal_scripts	
	install -d $(SCRIPT_DIR)/addons
	install -d $(SCRIPT_DIR)/language
	#
	install -o root -m 644 scripts/*.lua $(SCRIPT_DIR)/scripts
	install -o root -m 644 engines/*.lua $(SCRIPT_DIR)/engines
	install -o root -m 644 modules/*.lua $(SCRIPT_DIR)/modules
	install -o root -m 644 modules/heretic/*.lua $(SCRIPT_DIR)/modules/heretic
	install -o root -m 644 modules/hexen/*.lua $(SCRIPT_DIR)/modules/hexen
	install -o root -m 644 modules/strife/*.lua $(SCRIPT_DIR)/modules/strife
	install -o root -m 644 modules/zdoom_internal_scripts/*.* $(SCRIPT_DIR)/modules/zdoom_internal_scripts
#	install -o root -m 644  addons/*.pk3 $(SCRIPT_DIR)/addons
	install -o root -m 644 language/*.*  $(SCRIPT_DIR)/language
	#
	install -d $(SCRIPT_DIR)/data
	install -d $(SCRIPT_DIR)/data/bg
	install -d $(SCRIPT_DIR)/data/masks
	install -d $(SCRIPT_DIR)/data/loading
	install -d $(SCRIPT_DIR)/data/music
	install -d $(SCRIPT_DIR)/data/sounds
	install -o root -m 644 data/*.* $(SCRIPT_DIR)/data
	install -o root -m 644 data/bg/*.* $(SCRIPT_DIR)/data/bg
	install -o root -m 644 data/masks/*.* $(SCRIPT_DIR)/data/masks
	install -o root -m 644 data/*.* $(SCRIPT_DIR)/data/loading
	install -o root -m 644 data/bg/*.* $(SCRIPT_DIR)/data/music
	install -o root -m 644 data/masks/*.* $(SCRIPT_DIR)/data/sounds
	#
	rm -Rf $(SCRIPT_DIR)/games
	cp -a games $(SCRIPT_DIR)/games
	chown -R root $(SCRIPT_DIR)/games
	chmod -R g-s  $(SCRIPT_DIR)/games
	#
	xdg-desktop-menu  install --novendor misc/obsidian.desktop
	xdg-icon-resource install --novendor --size 32 misc/obsidian.xpm

uninstall:
	rm -v $(PREFIX)/bin/obsidian
	rm -Rv $(SCRIPT_DIR)
	#
	xdg-desktop-menu  uninstall --novendor misc/obsidian.desktop
	xdg-icon-resource uninstall --novendor --size 32 obsidian

xgettext:
	xgettext -o LANG_TEMPLATE.txt -k_ -kN_ -F -i --foreign-user --package-name="Obsidian Level Maker" $(LANG_FILES)

.PHONY: all clean halfclean stripped install uninstall xgettext

#--- editor settings ------------
# vi:ts=8:sw=8:noexpandtab
