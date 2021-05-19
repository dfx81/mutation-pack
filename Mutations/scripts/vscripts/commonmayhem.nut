Msg("Activating Common Mayhem by dfx\n");

MutationOptions <-
{
  cm_CommonLimit = 50
  PreferredMobDirection = SPAWN_ANYWHERE
  PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
  ProhibitBosses = true
  MegaMobSize = 30
  cm_WanderingZombieDensityModifier = 0.01
  MaxSpecials = 4
  BileMobSize = 15
  TankLimit = 0
  WitchLimit = 0
  BoomerLimit = 4
  ChargerLimit = 0
  HunterLimit = 0
  JockeyLimit = 0
  SpitterLimit = 0
  SmokerLimit = 0
  RelaxMinInterval = 5
  RelaxMaxInterval = 10
  MobSpawnMinTime = 10
  MobSpawnMaxTime = 15
}

function SetupModeHUD()
{
  ModeHUD <- {}
  Ticker_AddToHud(ModeHUD, "Common Mayhem")
  HUDSetLayout(ModeHUD)
}