// somebar - dwl bar
// See LICENSE file for copyright and license details.

#pragma once
#include "common.hpp"

constexpr bool topbar = true;

constexpr int paddingX = 10;
constexpr int paddingY = 3;

// See https://docs.gtk.org/Pango/type_func.FontDescription.from_string.html
constexpr const char* font = "JetBrainsMono Nerd Font Mono 12";
//#8839ef
//#7287fd
//#209fb5
//#eff1f5
//#cba6f7
//#b4befe
/*
constexpr ColorScheme colorInactive = {Color(0xef, 0xf1, 0xf5), Color(0x20, 0x9f, 0xb5)};
constexpr ColorScheme colorActive = {Color(0xef, 0xf1, 0xf5), Color(0x72, 0x87, 0xfd)};
*/

/* CATPPUCCIN MOCHA SCHEME */

// Inactive: Text (#cdd6f4) on Base Background (#1e1e2e)
constexpr ColorScheme colorInactive = {
    Color(0xcd, 0xd6, 0xf4),
    Color(0x1e, 0x1e, 0x2e)
};

// Active: Dark Base Text (#1e1e2e) on Mauve Background (#cba6f7)
// This creates a cool "highlight" effect for the active tag
constexpr ColorScheme colorActive = {
    Color(0x1e, 0x1e, 0x2e),
    Color(0xb4, 0xbe, 0xfe)
};

constexpr const char* termcmd[] = {"foot", nullptr};

static std::vector<std::string> tagNames = {
	"1", "2", "3",
	"4", "5", "6",
	"7", "8", "9",
};

constexpr Button buttons[] = {
	{ ClkStatusText,   BTN_RIGHT,  spawn,      {.v = termcmd} },
};
