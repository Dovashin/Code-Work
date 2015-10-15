#include <sourcemod>

static String:kvfile[PLATFORM_MAX_PATH];
static String:Items[200][2][200];

/*
	Items:
	- Items[0][0] = name
	- Items[0][1] = price
	-----------
	- Items[1][0]
	- Items[1][1]
	-----------
	- Items[2][0]
	- Items[2][1]
	------------>
	- Items[199][0]
	- Items[199][1]
*/




public Plugin:myinfo = {
name = "Store Plugin",
author = "Dovashin",
description = "This is a store plugin",
url = "thecubeserver.org"
};

public OnPluginStart()
{
	CreateDirectory("/addons/sourcemod/data/StorePlugin");
	BuildPath(Path_SM, kvfile, sizeof(kvfile), "data/StorePlugin/Items.txt");

	
	loadItems();
}

public loadItems()
{
	new Handle:db = CreateKeyValues("ItemList");
	FileToKeyValues(db, kvfile);

	if(KvJumpToKey(db, "Items", false))
	{
		new String:index[6], String:buffer[200];
		for(new i = 0;i < 200;i++)
		{
			Format(index, sizeof(index), %d, i);
			
			KvGetString(db, index, buffer, sizeof(buffer), "NULLSTRING");
			
			if(StrEqual (buffer, "NULLSTRING"))
			{
				decl String:tempstring[2][200]
				
				ExplodeString(buffer, "$", (tempstring, 2, 200);
				
				Items[i][0] = tempstring[0]
				Items[i][1] = tempstring[1];
				
				
			}
			
			
		
		}
	}
	


}
/*
"ItemList"
{
	"Items"
	{
		"0" "name$price"
		"1" "name$price"
		"2" "name$price"
		
	}
	
}
*/