#include <sourcemod>

#define VERSION "1.0"
#define TAG "[DS]"

public Plugin myinfo = 
{
	name = "Dynamic Slots",
	description = "A simple dynamic slots plugin that should work with any game supporting sv_visiblemaxplayers.",
	author = "Christian Deacon",
	version = VERSION,
	url = "deaconn.net & lbgaming.co"
};

ConVar g_cvMinSlots = null;
ConVar g_cvMaxSlots = null;
ConVar g_cvIncreaseSlots = null;
ConVar g_cvBotsInclude = null;
ConVar g_cvDebug = null;

ConVar g_cvVisibleMaxplayers = null;

public void OnPluginStart() 
{
	g_cvMinSlots = CreateConVar("ds_min", "24", "The minimum amount of players required for the plugin to do anything.");
	g_cvMaxSlots = CreateConVar("ds_max", "0", "The maximum player count before the plugin stops doing anything. 0 = maxplayers.");
	g_cvIncreaseSlots = CreateConVar("ds_increase", "2", "How many slots to increase by after 'ds_min' is reached until 'ds_max'.");
	g_cvBotsInclude = CreateConVar("ds_bots_include", "0", "Whether to include bots in player count calculations.");
	g_cvDebug = CreateConVar("ds_debug", "0", "Enables debugging (for developer mode only). Will log a SourceMod message.");

	g_cvVisibleMaxplayers = FindConVar("sv_visiblemaxplayers");

	// If 'sv_visiblemaxplayers' isn't available, the plugin will not work.
	if (g_cvVisibleMaxplayers == INVALID_HANDLE)
	{
		SetFailState("%s Failed to find sv_visiblemaxplayers.", TAG);
	}
	
	AutoExecConfig(true, "plugin.dynamicslots");
}

public void OnClientPutInServer(int client) 
{
	int diff = PlayerDiff();

	if (diff != 0)
	{
		if (g_cvDebug.BoolValue)
		{
			LogMessage("%s Different value => %d.", TAG, diff);
		}

		g_cvVisibleMaxplayers.SetInt(g_cvVisibleMaxplayers.IntValue + diff);
	}
}

public void OnClientDisconnect(int client) 
{
	int diff = PlayerDiff();

	if (diff != 0)
	{
		if (g_cvDebug.BoolValue)
		{
			LogMessage("%s Different value => %d.", TAG, diff);
		}

		g_cvVisibleMaxplayers.SetInt(g_cvVisibleMaxplayers.IntValue + diff);
	}
}

stock int PlayerDiff()
{
	int cl_cnt = GetClientCountCustom();

	int min = g_cvMinSlots.IntValue;
	int max = (g_cvMaxSlots.IntValue > 0) ? g_cvMaxSlots.IntValue : MaxClients;
	int slot_cnt = g_cvVisibleMaxplayers.IntValue;

	// First, check special case where player count is below minimum, but we have a different visible max.
	if (cl_cnt < min && slot_cnt > min)
	{
		return -(slot_cnt - min);
	}

	// If not within range, return 0 (do nothing).
	if (cl_cnt < min || cl_cnt >= max)
	{
		return 0;
	}
	int remainder = cl_cnt - min;

	int multiplier = (remainder / g_cvIncreaseSlots.IntValue) + 1;
	
	// Return the difference between the current slot count and correct slot count.
	return (min + (multiplier * g_cvIncreaseSlots.IntValue)) - slot_cnt;
}

stock int GetClientCountCustom()
{
	int ret = 0, i;
	
	for (i = 1; i <= MaxClients; i++) 
	{
		if (!IsClientInGame(i))
		{
			continue;
		}

		if (!g_cvBotsInclude.BoolValue && IsFakeClient(i))
		{
			continue;
		}

		ret++;
	}
	
	return ret;
}