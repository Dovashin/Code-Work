#pragma semicolon 1
#include <sourcemod>
#include <custom-chatcolors>

static String:KVPath[PLATFORM_MAX_PATH];

public Plugin:myinfo = 
{
	name = "SM Adduser",
	author = "Nanochip & Dovashin",
	description = "Add a user in-game",
	url = "http://thecubeserver.org/"
};

public OnPluginStart()
{
	LoadTranslations("common.phrases");
	RegAdminCmd("sm_adduser", Command_AddUser, ADMFLAG_GENERIC, "Adds a user to admins.cfg");
	RegAdminCmd("sm_adduserid", Command_AddUserId, ADMFLAG_GENERIC, "Adds a user ID to admins.cfg");
	RegAdminCmd("sm_removeuser", Command_RemoveUser, ADMFLAG_GENERIC, "Removes a user from admins.cfg");
	RegAdminCmd("sm_removeuserid", Command_RemoveUserId, ADMFLAG_GENERIC, "Removes a user ID from admins.cfg");
	RegAdminCmd("sm_remuser", Command_RemoveUser, ADMFLAG_GENERIC, "Removes a user from admins.cfg");
	RegAdminCmd("sm_remuserid", Command_RemoveUserId, ADMFLAG_GENERIC, "Removes a user ID from admins.cfg");
	
	BuildPath(Path_SM, KVPath, sizeof(KVPath), "configs/admins.cfg");
}

public Action:Command_AddUser(client, args)
{
	if(args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: !adduser <name> <group>");
		return Plugin_Handled;
	}
	
	new String:arg1[32], String:group[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, group, sizeof(group));
	
	new target = FindTarget(client, arg1);
	if (target == -1)
	{
		return Plugin_Handled;
	}
	
	new String:name[MAX_NAME_LENGTH], String:admin[MAX_NAME_LENGTH], String: authid[32];
	
	GetClientName(target, name, sizeof(name));
	GetClientAuthId(target, AuthId_Steam2, authid, sizeof(authid));
	GetClientName(client, admin, sizeof(admin));
	
	//Assign target to group
	new Handle:DB = CreateKeyValues("Admins");
	FileToKeyValues(DB, KVPath);
	
	if (KvJumpToKey(DB, authid, true))
	{
		KvSetString(DB, "name", name);
		KvSetString(DB, "auth", "steam");
		KvSetString(DB, "identity", authid);
		KvSetString(DB, "group", group);
		KvSetString(DB, "promoted by", admin);
	}
	
	KvRewind(DB);
	KeyValuesToFile(DB, KVPath);
	CloseHandle(DB);
	
	// Finisher
	CPrintToChatAll("{gmodclient}%s {gmodtext}added {gmodtarget2}%s(%s){gmodtext} to group {gmodgroup}%s{gmodtext}.", admin, name, authid, group);
	ServerCommand("sm_reloadadmins");
	ServerCommand("sm plugins reload custom-chatcolors");
	return Plugin_Handled;
}

public Action:Command_AddUserId(client, args)
{
	if(args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: !adduserid <steam2 id> <group> <name of user");
		return Plugin_Handled;
	}
	
	new String:authid[32], String:group[32], String:admin[32], String:name[32];
	GetCmdArg(1, authid, sizeof(authid));
	GetCmdArg(2, group, sizeof(group));
	GetCmdArg(3, name, sizeof(name));
	
	GetClientName(client, admin, sizeof(admin));
	
	//Assign target to group
	new Handle:DB = CreateKeyValues("Admins");
	FileToKeyValues(DB, KVPath);
	
	if (KvJumpToKey(DB, authid, true))
	{
		KvSetString(DB, "name", name);
		KvSetString(DB, "auth", "steam");
		KvSetString(DB, "identity", authid);
		KvSetString(DB, "group", group);
		KvSetString(DB, "promoted by", admin);
	}
	
	KvRewind(DB);
	KeyValuesToFile(DB, KVPath);
	CloseHandle(DB);
	
	CPrintToChatAll("{gmodclient}%s {gmodtext}added {gmodtarget2}%s(%s){gmodtext} to group {gmodgroup}%s{gmodtext}.", admin, name, authid, group);
	ServerCommand("sm_reloadadmins");
	ServerCommand("sm plugins reload custom-chatcolors");
	return Plugin_Handled;
}

public Action:Command_RemoveUser(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: !removeuser <name> <group>");
		return Plugin_Handled;
	}
	

	new String:arg1[32], String:admin[32], String:group[32], String:authid[32], String:name[32];
	GetCmdArg(1, arg1, sizeof(arg1));
	GetCmdArg(2, group, sizeof(group));
	new target = FindTarget(client, arg1);
	if (target == -1)
	{
		return Plugin_Handled;
	}
	
	GetClientName(target, name, sizeof(name));
	GetClientName(client, admin, sizeof(admin));
	GetClientAuthId(target, AuthId_Steam2, authid, sizeof(authid));
	
	//Assign target to group
	new Handle:DB = CreateKeyValues("Admins");
	FileToKeyValues(DB, KVPath);
	
	if (KvJumpToKey(DB, authid, false))
	{
		KvDeleteThis(DB);
		CPrintToChatAll("{gmodclient}%s {gmodtext}removed {gmodtarget2}%s(%s){gmodtext} from group {gmodgroup}%s{gmodtext}.", admin, name, authid, group);
		ServerCommand("sm_reloadadmins");
		ServerCommand("sm plugins reload custom-chatcolors");
		KvRewind(DB);
		KeyValuesToFile(DB, KVPath);
		CloseHandle(DB);
		return Plugin_Handled;
	}
	
	PrintToChat(client, "[SM] %s has not been added to a group.", name);
	KvRewind(DB);
	KeyValuesToFile(DB, KVPath);
	CloseHandle(DB);
	return Plugin_Handled;
}

public Action:Command_RemoveUserId(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[SM] Usage !removeuserid <steam2ID> <group>");
		return Plugin_Handled;
	}
	
	new String:admin[32], String:group[32], String:authid[32];
	GetCmdArg(1, authid, sizeof(authid));
	GetCmdArg(2, group, sizeof(group));
	
	GetClientName(client, admin, sizeof(admin));
	
	//Assign target to group
	new Handle:DB = CreateKeyValues("Admins");
	FileToKeyValues(DB, KVPath);
	
	if (KvJumpToKey(DB, authid, false))
	{
		KvDeleteThis(DB);
		CPrintToChatAll("{gmodclient}%s {gmodtext}removed {gmodtarget2}%s{gmodtext} from group {gmodgroup}%s{gmodtext}.", admin, authid, group);
		ServerCommand("sm_reloadadmins");
		ServerCommand("sm plugins reload custom-chatcolors");
		KvRewind(DB);
		KeyValuesToFile(DB, KVPath);
		CloseHandle(DB);
		return Plugin_Handled;
	}
	
	PrintToChat(client, "[SM] %s has not been added to a group.", authid);
	KvRewind(DB);
	KeyValuesToFile(DB, KVPath);
	CloseHandle(DB);
	return Plugin_Handled;
}