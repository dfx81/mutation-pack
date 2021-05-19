Msg("Activating Witch Trial by dfx\n");
IncludeScript("vslib.nut")

MutationOptions <-
{
  cm_CommonLimit = 25
  NoMobSpawn = true
  PreferredMobDirection = SPAWN_ANYWHERE
  PreferredSpecialDirection = SPAWN_SPECIALS_ANYWHERE
  MegaMobSize = 0
  cm_WanderingZombieDensityModifier = 0.01
  cm_MaxSpecials = 1
  cm_AggressiveSpecials = 1
  ProhibitBosses = true
  TankLimit = 0
  WitchLimit = -1
  BoomerLimit = 0
  ChargerLimit = 0
  HunterLimit = 0
  JockeyLimit = 1
  SpitterLimit = 0
  SmokerLimit = 0
  cm_SpecialRespawnInterval = 10
  SpecialInitialSpawnDelayMin = 5
  SpecialInitialSpawnDelayMax = 10
  RelaxMinInterval = 5
  RelaxMaxInterval = 10

  weaponsToConvert =
  {
    weapon_pipe_bomb =  "weapon_molotov_spawn"
    weapon_vomitjar =   "weapon_molotov_spawn"
  }

  weaponsToRemove =
  {
    weapon_melee = 0
    weapon_chainsaw = 0
  }

  function ConvertWeaponSpawn(classname)
  {
    if (classname in weaponsToConvert)
    {
      return weaponsToConvert[classname];
    }
    return 0
  }

  function AllowWeaponSpawn(classname)
  {
    if (classname in weaponsToRemove)
    {
      return false
    }

    return true
  }

  function ShouldAvoidItem(classname)
  {
    if (classname in weaponsToRemove)
    {
      return true
    }

    return false
  }

  DefaultItems =
  [
    "weapon_pumpshotgun",
    "weapon_pistol"
  ]

  function GetDefaultItem( idx )
  {
    if ( idx < DefaultItems.len() )
    {
      return DefaultItems[idx];
    }
    return 0
  }
}

Witch <-
{
  type = 7
  pos = null
  ang = null
}

MutationState <-
{
  UnlockTrainDoor = false
  FinaleStart = false
}

function SetupModeHUD()
{
  ModeHUD <- {}
  Ticker_AddToHud(ModeHUD, "Witch Trial")
  HUDSetLayout(ModeHUD)
}

function Update()
{
  if (!SessionState.FinaleStart)
  {
    local common = null
    local witch = null

    while (common = Entities.FindByClassname(common, "infected"))
    {
      Witch.pos = common.GetOrigin()
      Witch.ang = common.GetAngles()
      common.Kill()

      if (SessionState.MapName == "c6m1_riverbank")
        Witch.type = Z_WITCH_BRIDE
      else
        Witch.type = Z_WITCH

      Utils.SpawnZombie(Witch.type, Witch.pos, Witch.ang)
    }
  }

  if (!SessionState.UnlockTrainDoor && Director.HasAnySurvivorLeftSafeArea())
  {
    EntFire("tankdoorout_button","unlock")
    EntFire("tank_sound_timer","kill")
    SessionState.UnlockTrainDoor = true
  }
}

function OnGameEvent_finale_start(params)
{
  SessionState.FinaleStart = true
  SessionOptions.cm_CommonLimit = 50
  SessionOptions.WitchLimit = 50
  SessionOptions.cm_SpecialRespawnInterval = 5
  SessionOptions.SpecialInitialSpawnDelayMin = 2.5
  SessionOptions.SpecialInitialSpawnDelayMax = 5

  for (local i = 0; i != SessionOptions.WitchLimit; i++)
    SpawnWitch()
}

function OnGameEvent_create_panic_event(params)
{
  SessionOptions.WitchLimit = 25

  for (local i = 0; i != SessionOptions.WitchLimit; i++)
    SpawnWitch()

  SessionOptions.WitchLimit = -1
}

function OnGameEvent_witch_killed(params)
{
  if (SessionState.FinaleStart)
    SpawnWitch()
}

function OnGameEvent_jockey_killed(params)
{
  if (SessionState.FinaleStart)
    SpawnWitch()
}

function SpawnWitch()
{
  if (SessionState.FinaleStart)
  {
    local player = Players.SurvivorWithHighestFlow()
    local MaxDist = RandomInt(1000, 1600)
    local MinDist = RandomInt(400, 1000)
    local type = null
  
    if (SessionState.MapName == "c6m1_riverbank")
      type = Z_WITCH_BRIDE
    else
      type = Z_WITCH

    Utils.SpawnZombieNearPlayer(player, type, MaxDist, MinDist, false)
  }
}