#pragma newdecls required
#pragma semicolon 1
#include <smrpg>
#include <sdkhooks>
#include <sdktools>

#define UPGRADE_SHORTNAME "antibingo"
#define PLUGIN_VERSION "1.0"

ConVar AntiBingoChance;

int g_hAntiBingoChance;

public Plugin myinfo = 
{
	name = "SM:RPG Upgrade > AntiBingo",
	author = "WanekWest",
	description = "Lower a chance for bingo.",
	version = PLUGIN_VERSION,
	url = "https://vk.com/wanek_west"
}

public void OnPluginStart()
{
	LoadTranslations("smrpg_stock_upgrades.phrases");
}

public void OnPluginEnd()
{
	if(SMRPG_UpgradeExists(UPGRADE_SHORTNAME))
		SMRPG_UnregisterUpgradeType(UPGRADE_SHORTNAME);
}

public void OnAllPluginsLoaded()
{
	OnLibraryAdded("smrpg");
}

public void OnLibraryAdded(const char[] name)
{
	if(StrEqual(name, "smrpg"))
	{
		SMRPG_RegisterUpgradeType("bingo", UPGRADE_SHORTNAME, "Give a small chance for kill player.", 10, true, 5, 15, 10);
		SMRPG_SetUpgradeTranslationCallback(UPGRADE_SHORTNAME, SMRPG_TranslateUpgrade);

		SMRPG_CreateUpgradeConVar(UPGRADE_SHORTNAME, "smrpg_antibingo_chance", "1", "Reduces bingo chance.(Level*Value)", _, true, 0.0);
		AntiBingoChance = SMRPG_CreateUpgradeConVar(UPGRADE_SHORTNAME, "smrpg_antibingo_chance", "1", "Reduces bingo chance.(Level*Value)", _, true, 0.0);
		AntiBingoChance.AddChangeHook(OnAntiBinChange);
		g_hAntiBingoChance = AntiBingoChance.IntValue;
	}
}

public void OnAntiBinChange(ConVar hCvar, const char[] szOldValue, const char[] szNewValue)
{
	g_hAntiBingoChance = hCvar.IntValue;
}

public void SMRPG_TranslateUpgrade(int client, const char[] shortname, TranslationType type, char[] translation, int maxlen)
{
	if(type == TranslationType_Name)
		Format(translation, maxlen, "%T", UPGRADE_SHORTNAME, client);
	else if(type == TranslationType_Description)
	{
		char sDescriptionKey[MAX_UPGRADE_SHORTNAME_LENGTH+12] = UPGRADE_SHORTNAME;
		StrCat(sDescriptionKey, sizeof(sDescriptionKey), " description");
		Format(translation, maxlen, "%T", sDescriptionKey, client);
	}
}

public APLRes AskPluginLoad2(Handle hPlugin, bool bLate, char[] sError, int iLenError)
{
    CreateNative("Get_bingo",Native_bingo);
}    
public int Native_bingo(Handle hPlugin, int iArgs)
{
    return g_hAntiBingoChance;
}