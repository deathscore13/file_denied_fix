#include <sourcemod>
#include <dhooks>

public Plugin myinfo =
{
    name = "FileDenied Fix",
    description = "CGameClient::FileDenied flood fix (only CS:S OLD or CS:S OB)",
    author = "DeathScore13",
    version = "1.0.0",
    url = "https://github.com/deathscore13/file_denied_fix"
};

public void OnPluginStart()
{
    GameData gd;
    EngineVersion engine = GetEngineVersion();
    if (engine == Engine_SourceSDK2006)
        gd = LoadGameConfigFile("file_denied_fix_v34");
    else if (engine == Engine_CSS)
        gd = LoadGameConfigFile("file_denied_fix");
    else 
        SetFailState("Support games: CS:S OLD or CS:S OB");

    if (!gd)
        SetFailState("LoadGameConfigFile failed");

    Handle dhook = DHookCreateDetour(Address_Null, CallConv_CDECL, ReturnType_Void, ThisPointer_Ignore);
    if (!DHookSetFromConf(dhook, gd, SDKConf_Signature, "FileDenied"))
        SetFailState("DHookSetFromConf failed");

    if (!DHookEnableDetour(dhook, false, Detour_OnFileDenied))
        SetFailState("DHookEnableDetour failed");

    gd.Close();
}

public MRESReturn Detour_OnFileDenied()
{
    return MRES_Supercede;
}
