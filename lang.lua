-- For other languages, translate these strings
blipName = "Truck Delivery"
NoSpawnLocationInConfigFile = "No spawn locations in config file, quitting the job"
KeepTheCar_JobIsCancelled = "Keep the truck, job is canceled"
VehicleHasBeenDestroyed_JobIsCancelled = "The truck was destroyed! Job has been canceled."
JobQuit = "Truck delivery job has been quit"
JobStarted = "Truck delivery job started"
StartJob = "Press E to start a job"
QuitJob = "Press E to quit the job"
CarModelLoadingTimeout = "Truck model loading has timed out, check if model names of your cars are correct"
text_adminXPEditDescription = "(Admin) Edit truck delivery rank"
text_adminXPEditCommand = "cardeliveryxp"
text_option = "Option"
text_optionHelp = "Option type (add, reduce, set)"
text_add = "add"
text_reduce = "reduce"
text_set = "set"
text_number = "Number"
text_level = "Level"
text_levelUp = "Level up"
text_levelLost = "Level lost"
text_numberHelp = "Number of change"
text_noSuchParameter = "No such parameter"
text_notEveryArgumentWasEntered = "Not every argument was entered"
text_getXpCommand = "deliveryxp"
text_getXpDescription = "Shows your truck delivery xp"
text_added = "Added"
text_xpToCarDeliveryRank = "xp to truck delivery rank"
text_cooldown = "Cooldown"
text_secondsLeft = "seconds left"


KeepTheCar = "In the next " .. choiceTimer .. " seconds, press U to keep the truck and leave the job"
SubtractedXP = tostring(rankPenalty) .. " XP subtracted from truck delivery rank"

function text_GoFindCar(spawns, level, vehicleChoice, spawnLocation)
    return "Go find the ~g~" .. vehicles[level][vehicleChoice].name .. "~w~ somewhere around ~g~" .. spawns[spawnLocation].name .. "~w~!"
end

function text_GoFindParkedCar(spawns, level, vehicleChoice, spawnLocation)
    return "Go find the parked ~g~" .. vehicles[level][vehicleChoice].name .. "~w~ at ~g~" .. spawns[spawnLocation].name .. "~w~!"
end