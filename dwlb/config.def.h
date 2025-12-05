#define HEX_COLOR(hex)				\
	{ .red   = ((hex >> 24) & 0xff) * 257,	\
	  .green = ((hex >> 16) & 0xff) * 257,	\
	  .blue  = ((hex >> 8) & 0xff) * 257,	\
	  .alpha = (hex & 0xff) * 257 }

// use ipc functionality
static bool ipc = false;
// initially hide all bars
static bool hidden = false;
// initially draw all bars at the bottom
static bool bottom = false;
// hide vacant tags
static bool hide_vacant = true;
// vertical pixel padding above and below text
static uint32_t vertical_padding = 2;
// allow in-line color commands in status text
static bool status_commands = true;
// center title text
static bool center_title = false;
// use title space as status text element
static bool custom_title = false;
// title color use active colors
static bool active_color_title = false;
// scale
static uint32_t buffer_scale = 1;
// font
static char *fontstr = "JetBrainsMono Nerd Font Mono=18";
// tag names
static char *tags_names[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

// set 16-bit colors for bar
// use either pixman_color_t struct or HEX_COLOR macro for 8-bit colors
/* CATPPUCCIN MOCHA SCHEME for DWLB */

// Active Tag: Dark Text (#1e1e2e) on Lavender Background (#b4befe)
static pixman_color_t active_fg_color = HEX_COLOR(0x1e1e2eff);
static pixman_color_t active_bg_color = HEX_COLOR(0xb4befeff);

// Occupied Tag (Visible windows): Standard Text (#cdd6f4) on Surface0 (#313244)
// Note: I made the background slightly lighter than the base so you can see which tags have windows.
//static pixman_color_t occupied_fg_color = HEX_COLOR(0xcdd6f4ff);
//static pixman_color_t occupied_bg_color = HEX_COLOR(0x313244ff);
static pixman_color_t occupied_fg_color = HEX_COLOR(0x6c7086ff);
static pixman_color_t occupied_bg_color = HEX_COLOR(0x1e1e2eff);

// Inactive Tag (Empty): Dim Text (#6c7086) on Base Background (#1e1e2e)
static pixman_color_t inactive_fg_color = HEX_COLOR(0x6c7086ff);
static pixman_color_t inactive_bg_color = HEX_COLOR(0x1e1e2eff);

// Urgent: Dark Text (#1e1e2e) on Red (#f38ba8)
static pixman_color_t urgent_fg_color = HEX_COLOR(0x1e1e2eff);
static pixman_color_t urgent_bg_color = HEX_COLOR(0xf38ba8ff);

// Middle (The Status Text Area)
// Standard Background
static pixman_color_t middle_bg_color = HEX_COLOR(0x1e1e2eff);
static pixman_color_t middle_bg_color_selected = HEX_COLOR(0x1e1e2eff);
