Config                            = {}
Config.Sprite  = 61
Config.Display = 4
Config.Scale   = 1.0
Config.Colour  = 4
Config.Locale = 'en'

Config.RespawnPlaceLS = vector3(299.632, -574.7994, 42.40)
Config.RespawnPlaceSANDY = vector3(1836.2681, 3671.073, 33.3267)
Config.RespawnPlacePALETO = vector3(-247.4772, 6330.8159, 31.4761)

-- How much time before auto respawn at hospital
Config.RespawnDelayAfterRPDeath   = 0.5 * 60 * 1000
Config.RespawnDelayAfterRPDeath2   = 30 * 60 * 1000

Config.RemoveWeaponsAfterRPDeath    = true
Config.RemoveCashAfterRPDeath       = true
Config.RemoveItemsAfterRPDeath      = true

-- Will display a timer that shows RespawnDelayAfterRPDeath as a countdown
Config.ShowDeathTimer               = true

-- Will allow respawn after half of RespawnDelayAfterRPDeath has elapsed.
Config.EarlyRespawn                 = false
-- The player will be fined for respawning early (on bank account)
Config.EarlyRespawnFine                  = false
Config.EarlyRespawnFineAmount            = 500

Config.RespawnPlace = vector3(299.632, -574.7994, 42.40)

Config.Blips = {
	{
		coords = vector3(304.90 , -586.41, 42.31)
	},
	{
		coords = vec3(-676.206604, 308.769226, 83.081298)
	}
}