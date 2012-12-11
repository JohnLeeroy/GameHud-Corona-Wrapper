-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------


local ghAnalytics = require("GHAnalytics")

local function main()
  
  --Insert the API Key that can be found in the GAMEhud website and a unique player ID.
  --Call this function first.
  ghAnalytics.Init("insert_api_key", playerID);
  
  --Starts the player session.
  ghAnalytics.StartSession();
  
  --This sets the interval for sending queued events to every 5 seconds.
  ghAnalytics.SetSendQueueTimer(5000)
  
  --This sends off event immediately.
  local params = {StringProperty="ThisIsAString", NumberProperty=1234}
  ghAnalytics.SendEvent("EventName", params)
  
  --This adds an event to the queue. It will be sent in about 5 seconds.
  local params = {StringProperty="ThisIsAString", NumberProperty=1234}
  ghAnalytics.QueueEvent("QueueEventName", params)
  
  --This sends off player data immediately.
  --You can add any properties you want.
  local playerData = {}
  playerData.age = 21;
  playerData.name = "John Li";
  playerData.location = "Orlando, FL"
  ghAnalytics.SendPlayer(playerData)
  
  --This sends off device data immediately.
  --You can add any properties you want.
  local deviceData = {}
  deviceData.platform = "PC"
  deviceData.OS = "Windows 7"
  deviceData.graphicsVendor = "Nvidia"
  ghAnalytics.SendDevice(deviceData)

end

main();