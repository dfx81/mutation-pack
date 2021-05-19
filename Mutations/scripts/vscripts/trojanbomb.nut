Msg("Activating Trojan Bomb by dfx\n");

MutationOptions <-
{
  cm_CommonLimit = 0
  PreferredMobDirection = SPAWN_ANYWHERE
  PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
  ProhibitBosses = true
  MegaMobSize = 0
  cm_WanderingZombieDensityModifier = 0
  cm_MaxSpecials = 4
  // cm_AggressiveSpecials = 1
  BileMobSize = 30
  TankLimit = 0
  WitchLimit = 0
  BoomerLimit = 4
  ChargerLimit = 0
  HunterLimit = 0
  JockeyLimit = 0
  SpitterLimit = 0
  SmokerLimit = 0
  cm_SpecialRespawnInterval = 10
  SpecialInitialSpawnDelayMin = 5
  SpecialInitialSpawnDelayMax = 10
  RelaxMinInterval = 5
  RelaxMaxInterval = 10
}

function SetupModeHUD()
{
  ModeHUD <- {}
  Ticker_AddToHud(ModeHUD, "Trojan Bomb")
  HUDSetLayout(ModeHUD)
}

function OnGameEvent_round_start_post_nav(params)
{
  local spawner = null

  while (spawner = Entities.FindByClassname(spawner, "info_zombie_spawn"))
  {
    if (spawner.IsValid())
    {
      local pop = NetProps.GetPropString(spawner, "m_szPopulation");

      if (pop == "boomer" || pop == "church") continue
      else spawner.Kill()
    }
  }
}

function OnGameEvent_player_now_it(params)
{
  SessionOptions.cm_CommonLimit = 30
  local name = GetPlayerFromUserID(params["userid"]).GetPlayerName()
  Ticker_NewStr(name + " got vomitted on!", -1)
}

function OnGameEvent_player_no_longer_it(params)
{
  SessionOptions.cm_CommonLimit = 0
}