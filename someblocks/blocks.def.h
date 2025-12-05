//Modify this file to change what commands output to your statusbar, and recompile using the make command.
static const Block blocks[] = {
	/*Icon*/	/*Command*/		/*Update Interval*/	/*Update Signal*/
	/*{"", "slstatus -s",				5,		0},*/
	{"", "sb-internet",				60,		12},
	{"^fg(#b4befe)󰻠 ^fg()", "top -bn 2 -d 0.01 | grep '^%Cpu' | tail -n 1 | gawk '{print $2+$4+$6\"%\"}'", 30, 0},
	/*{" Mem ", "free -h | awk '/^Mem/ { print $3\"/\"$2 }' | sed s/i//g",	30,		0},*/
	{"", "memory-perc-sb",	30,		0},
	{" ", "sb-battery",		60,		0},
	{"", "sb-brightness",				0,		10},
	{"", "sb-volume",				0,		11},
	{"", "calendar-sb",					1,		0},
	
	/* Updates whenever "pkill -SIGRTMIN+10 someblocks" is ran */
	/* {"", "date '+%a, %d %b %H:%M'",					0,		10}, */
};

	/* function format          argument
	{ wifi_perc,     "   %s%% ",   "wlo1" },
	{ ram_used,      "|  %s/",     NULL },
	{ cpu_perc,      "| 󰻠 %s%% ",   NULL },
	{ ram_total,     "%s ",         NULL },
	{ battery_perc,  "|  %s%%",    "BAT0" },
	{ battery_state, "(%s) ",       "BAT0" },
	{ datetime, "%s",           "%a %F %T" },*/


//sets delimeter between status commands. NULL character ('\0') means no delimeter.
static char delim[] = " | ";
static unsigned int delimLen = 5;
