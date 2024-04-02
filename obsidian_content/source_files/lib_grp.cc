//------------------------------------------------------------------------
//  ARCHIVE Handling - GRP files
//------------------------------------------------------------------------
//
//  OBSIDIAN Level Maker
//
//  Copyright (C) 2021-2022 The OBSIDIAN Team
//  Copyright (C) 2006-2017 Andrew Apted
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//------------------------------------------------------------------------

#include <algorithm>
#include <list>

#include "headers.h"
#include "main.h"

#ifdef HAVE_PHYSFS
#include "physfs.h"
#endif

#include "lib_grp.h"
#include "lib_util.h"

// #define LogPrintf  printf

//------------------------------------------------------------------------
//  GRP READING
//------------------------------------------------------------------------

#ifdef HAVE_PHYSFS
static PHYSFS_File *grp_R_fp;
#else
static FILE *grp_R_fp;
#endif

static raw_grp_header_t grp_R_header;
static raw_grp_lump_t *grp_R_dir;
static uint32_t *grp_R_starts;

static const uint8_t grp_magic_data[GRP_MAGIC_LEN] = {
    0xb4, 0x9a, 0x91, 0xac, 0x96, 0x93, 0x89, 0x9a, 0x8d, 0x92, 0x9e, 0x91};

bool GRP_OpenRead(const char *filename) {
#ifdef HAVE_PHYSFS
    grp_R_fp = PHYSFS_openRead(filename);
#else
    grp_R_fp = fopen(filename, "rb");
#endif

    if (!grp_R_fp) {
        LogPrintf("GRP_OpenRead: no such file: %s\n", filename);
        return false;
    }

    LogPrintf("Opened GRP file: %s\n", filename);

#ifdef HAVE_PHYSFS
    if ((PHYSFS_readBytes(grp_R_fp, &grp_R_header, sizeof(grp_R_header)) /
         sizeof(grp_R_header)) != 1)
#else
    if (fread(&grp_R_header, sizeof(grp_R_header), 1, grp_R_fp) != 1)
#endif
    {
        LogPrintf("GRP_OpenRead: failed reading header\n");
#ifdef HAVE_PHYSFS
        PHYSFS_close(grp_R_fp);
#else
        fclose(grp_R_fp);
#endif
        return false;
    }

    if (grp_R_header.magic[0] != 'K') {
        LogPrintf("GRP_OpenRead: not a GRP file!\n");
#ifdef HAVE_PHYSFS
        PHYSFS_close(grp_R_fp);
#else
        fclose(grp_R_fp);
#endif
        return false;
    }

    grp_R_header.num_lumps = LE_U32(grp_R_header.num_lumps);

    /* read directory */

    if (grp_R_header.num_lumps >= 5000)  // sanity check
    {
        LogPrintf("GRP_OpenRead: bad header (%u entries?)\n",
                  static_cast<unsigned int>(grp_R_header.num_lumps));
#ifdef HAVE_PHYSFS
        PHYSFS_close(grp_R_fp);
#else
        fclose(grp_R_fp);
#endif
        return false;
    }

    grp_R_dir = new raw_grp_lump_t[grp_R_header.num_lumps + 1];
    grp_R_starts = new uint32_t[grp_R_header.num_lumps + 1];

    uint32_t L_start = sizeof(raw_grp_header_t) +
                    sizeof(raw_grp_lump_t) * grp_R_header.num_lumps;

    for (int i = 0; i < (int)grp_R_header.num_lumps; i++) {
        raw_grp_lump_t *L = &grp_R_dir[i];

#ifdef HAVE_PHYSFS
        size_t res = (PHYSFS_readBytes(grp_R_fp, L, sizeof(raw_grp_lump_t)) /
                      sizeof(raw_grp_lump_t));
        if (res != 1)
#else
        int res = fread(L, sizeof(raw_grp_lump_t), 1, grp_R_fp);
        if (res == EOF || res != 1 || ferror(grp_R_fp))
#endif
        {
            if (i == 0) {
                LogPrintf("GRP_OpenRead: could not read any dir-entries!\n");
                GRP_CloseRead();
                return false;
            }

            LogPrintf("GRP_OpenRead: hit EOF reading dir-entry %d\n", i);

            // truncate directory
            grp_R_header.num_lumps = i;
            break;
        }

        L->length = LE_U32(L->length);

        grp_R_starts[i] = L_start;
        L_start += L->length;
    }

    return true;  // OK
}

void GRP_CloseRead(void) {
#ifdef HAVE_PHYSFS
    PHYSFS_close(grp_R_fp);
#else
    fclose(grp_R_fp);
#endif

    LogPrintf("Closed GRP file\n");

    delete[] grp_R_dir;
    delete[] grp_R_starts;

    grp_R_dir = NULL;
    grp_R_starts = NULL;
}

int GRP_NumEntries(void) { return (int)grp_R_header.num_lumps; }

int GRP_FindEntry(const char *name) {
    for (unsigned int i = 0; i < grp_R_header.num_lumps; i++) {
        char buffer[GRP_NAME_LEN + 4];

        strncpy(buffer, grp_R_dir[i].name.data(), GRP_NAME_LEN);
        buffer[GRP_NAME_LEN] = 0;

        if (StringCaseCmp(name, buffer) == 0) {
            return i;
        }
    }

    return -1;  // not found
}

int GRP_EntryLen(int entry) {
    SYS_ASSERT(entry >= 0 && entry < (int)grp_R_header.num_lumps);

    return grp_R_dir[entry].length;
}

const char *GRP_EntryName(int entry) {
    static char name_buf[GRP_NAME_LEN + 4];

    SYS_ASSERT(entry >= 0 && entry < (int)grp_R_header.num_lumps);

    // entries are often not NUL terminated, hence return a static copy
    strncpy(name_buf, grp_R_dir[entry].name.data(), GRP_NAME_LEN);
    name_buf[GRP_NAME_LEN] = 0;

    return name_buf;
}

bool GRP_ReadData(int entry, int offset, int length, void *buffer) {
    SYS_ASSERT(entry >= 0 && entry < (int)grp_R_header.num_lumps);
    SYS_ASSERT(offset >= 0);
    SYS_ASSERT(length > 0);

    int L_start = grp_R_starts[entry];

    if ((uint32_t)offset + (uint32_t)length > grp_R_dir[entry].length) {  // EOF
        return false;
    }

#ifdef HAVE_PHYSFS
    if (!PHYSFS_seek(grp_R_fp, L_start + offset)) {
        return false;
    }

    size_t res = (PHYSFS_readBytes(grp_R_fp, buffer, length) / length);

#else
    if (fseek(grp_R_fp, L_start + offset, SEEK_SET) != 0) return false;

    int res = fread(buffer, length, 1, grp_R_fp);
#endif

    return (res == 1);
}

//------------------------------------------------------------------------
//  GRP WRITING
//------------------------------------------------------------------------

static std::fstream grp_W_fp;

static std::list<raw_grp_lump_t> grp_W_directory;

static raw_grp_lump_t grp_W_lump;

// hackish workaround for the GRP format which places the
// directory before all the data files.
#define GRP_MAX_LUMPS 200

bool GRP_OpenWrite(const std::filesystem::path &filename) {
    grp_W_fp.open(filename, std::ios::out | std::ios::binary);

    if (!grp_W_fp.is_open()) {
        LogPrintf("GRP_OpenWrite: cannot create file: %s\n", filename.u8string().c_str());
        return false;
    }

    LogPrintf("Created GRP file: %s\n", filename.u8string().c_str());

    // write out a dummy header
    raw_grp_header_t header;
    memset(&header, 0, sizeof(header));

    grp_W_fp.write(reinterpret_cast<const char *>(&header),
                   sizeof(raw_grp_header_t));
    grp_W_fp << std::flush;

    // write out a dummy directory
    for (int i = 0; i < GRP_MAX_LUMPS; i++) {
        raw_grp_lump_t entry;
        memset(&entry, 0, sizeof(entry));

        std::string name = StringFormat("__%03d.ZZZ", i + 1);
        std::copy(name.data(), name.data() + name.size(), entry.name.begin());

        entry.length = LE_U32(1);

        grp_W_fp.write(reinterpret_cast<const char *>(&entry), sizeof(entry));
    }

    grp_W_fp << std::flush;

    return true;
}

void GRP_CloseWrite(void) {
    // add dummy data for the dummy entries
    uint8_t zero_buf[GRP_MAX_LUMPS];
    memset(zero_buf, 0, sizeof(zero_buf));

    grp_W_fp.write(reinterpret_cast<const char *>(zero_buf), sizeof(zero_buf));

    grp_W_fp << std::flush;

    // write the _real_ GRP header

    grp_W_fp.seekg(0, std::ios::beg);

    raw_grp_header_t header;

    for (unsigned int i = 0; i < GRP_MAGIC_LEN; i++) {
        header.magic[i] = ~grp_magic_data[i];
    }

    header.num_lumps = LE_U32(GRP_MAX_LUMPS);

    grp_W_fp.write(reinterpret_cast<const char *>(&header), sizeof(header));
    grp_W_fp << std::flush;

    // write the _real_ directory

    LogPrintf("Writing GRP directory\n");

    std::list<raw_grp_lump_t>::iterator WDI;

    for (WDI = grp_W_directory.begin(); WDI != grp_W_directory.end(); ++WDI) {
        raw_grp_lump_t *L = &(*WDI);

        grp_W_fp.write(reinterpret_cast<const char *>(L),
                       sizeof(raw_grp_lump_t));
    }

    grp_W_fp << std::flush;
    grp_W_fp.close();

    LogPrintf("Closed GRP file\n");

    grp_W_directory.clear();
}

void GRP_NewLump(std::string name) {
    if (grp_W_directory.size() >= GRP_MAX_LUMPS) {
        Main::FatalError("GRP_NewLump: too many lumps (> %d)\n", GRP_MAX_LUMPS);
    }

    if (name.size() > GRP_NAME_LEN) {
        Main::FatalError("GRP_NewLump: name too long: '%s'\n", name.c_str());
    }

    memset(&grp_W_lump, 0, sizeof(grp_W_lump));

    std::copy(name.data(), name.data() + name.size(), grp_W_lump.name.begin());
}

bool GRP_AppendData(const void *data, int length) {
    if (length == 0) {
        return true;
    }

    SYS_ASSERT(length > 0);

    if (!grp_W_fp.write(static_cast<const char *>(data), length)) {
        return false;
    }

    grp_W_lump.length += (uint32_t)length;
    return true;  // OK
}

void GRP_FinishLump(void) {
    // fix endianness
    grp_W_lump.length = LE_U32(grp_W_lump.length);

    grp_W_directory.push_back(grp_W_lump);
}

//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab
