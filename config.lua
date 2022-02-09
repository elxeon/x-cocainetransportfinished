notification = true
showAboveHead = true

showNpc = true
npcHeading = 205.9
npcCoords = vector3(264.19, -3244.43, 5.79)
showblip = false

rankPenalty = -120
xpGain = 100

startSize = 5

cooldown = 120

abilityToKeepVehicle = false

driveAround = false

choiceTimer = 20

pedModel = GetHashKey("g_m_y_lost_01")

copSpawn = false
chanceToSpawnCop = 5


levelXpGoal = {
    4000, -- Level 2
    8000, -- Level 3
    9000, -- Level 4
}


vehicles = {
    { -- Level 1
        {model="pounder", name="cocaine transporter"},
        {model="pounder", name="cocaine transporter"},
        {model="pounder", name="cocaine transporter"},
    },
    { -- Level 2
        {model="pounder", name="cocaine transporter"},
        {model="pounder", name="cocaine transporter"},
        {model="pounder", name="cocaine transporter"},
    },
    { -- Level 3
        {model="pounder", name="cocaine transporter"},
        {model="pounder", name="cocaine transporter"},
        {model="pounder", name="cocaine transporter"},
    },
    { -- Level 4
        {model="pounder", name="cocaine transporter"},
        {model="pounder", name="cocaine transporter"},
        {model="pounder", name="cocaine transporter"},
    },
}

parked_spawns = { 
    {name="Vliegveld", x=1402.25, y=2999.21, z=40.55, heading=264.75, copHeading=332.55, copx=741.46, copy=-1766.14, copz=28.29},
    {name="Sandy", x=2707.01, y=4148.92, z=43.75, heading=280, copx=656.72, copy=-2791.2, copz=5.87, copHeading=289.29},
    {name="Paleto", heading=180, x=203.68, y=6385.48, z=31.4, copHeading=332.55, copx=741.46, copy=-1766.14, copz=28.29},
}

drive_spawns = {
    {name="voorbeeld", heading=179, x=-789.6, y=-821.9, z=20.43},
}

destinations = { 
    {name="Politie HB", x=451.44, y=-903.54, z=28.45, from=1200, to=1400},
    {name="Hotel", x=292.6, y=-694.63, z=29.3, from=1500, to=1700},
    {name="Train spoort", x=490.19, y=-542.02, z=24.75, from=1800, to=2000},
    {name="Brandweer", x=180.87, y=-1671.47, z=29.57, from=2000, to=2200},
}
