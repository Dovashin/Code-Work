#include <sourcemod>

static save[32];

public Plugin:myinfo = {
		name = "The Cube TF2 Hud",
		author = "Dovashin",
		description = "This is the custom hud used for The Cube TF2 Server",
		url = "Thecubeserver.org"
};

public OnPluginStart()

	RegConsoleCmd("sm_set", Commandassign, "");

	
public OnClientPutInServer(client)
{
	CreateTimer(0.5, HUD, client, TIMER_REPEAT);
}

public Action:Commandassign(client, args)
{
	new string:arg1[5];
	GetCmdArg(1, arg1, 5);
	
	new arg1int = StringToInt(arg1);
	
	save[client] = arg1int
	return Plugin_Handled;
}

public Action:HUD(Handle:timer, any:client)
{
	if(isclientconnected(client) && IsClientInGame(client))
	{
		SetHudTextParams(0.043, -1.0, 0.5, 255, 255, 255, 255, 0, 60.0, 0.1, 0.2)
		SetHudText(client, -1, "Your saved num = %d", save [client];)
	}
}