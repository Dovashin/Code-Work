#pragma semicolon 1
#include <sourcemod>

public Plugin:myinfo = 
{
  name = "SteamIDGrabber",
  author = "Dovashin",
  description = "This obtains steam ID's of players you wish to execute commands on while online",
  url = "thetechgame.com"
};

public OnPluginStart()
{
  	LoadTranslations("common.phrases");
 	RegConsoleCmd("sm_getid", Command_GetID, "Collects user(s) steam ID.");
}

public Action:Command_GetID(client, args)
{
	new String:SteamID[32], String:name[32], String:arg1[32];
   
    if(args < 1)
    {
      ReplyToCommand(client, "[SM] Usage: !getid <name>");
      return Plugin_Handled;
    }
  
  GetCmdArg(1, arg1, sizeof(arg1));
  new target = FindTarget(client, arg1);
  
  if(target == -1)
  {
    return Plugin_Handled;
  }
  
  GetClientName(target, name, sizeof(name));
  GetClientAuthId(target, AuthId_Steam3, SteamID, sizeof(SteamID));
  PrintToChat(client, "%s's Steam ID is %s", name, SteamID);
  return Plugin_Handled;
}
