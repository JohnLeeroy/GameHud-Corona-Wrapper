-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------


local ghAnalytics = require("GHAnalytics")

local function main()
  
  ghAnalytics.Init("insert api key", playerID");
  ghAnalytics.StartSession();
  
  --Sends off queued events every 5 seconds
  ghAnalytics.SetSendQueueTimer(5000)
  
  --Sends off event immediately
  local params = {StringProperty="ThisIsAString", NumberProperty=1234}
  ghAnalytics.SendEvent("EventName", params)
  
  --This will be sent off in ~5 seconds
  local params = {StringProperty="ThisIsAString", NumberProperty=1234}
  ghAnalytics.QueueEvent("QueueEventName", params)
  
  --Sends off player data immediately.
  --Add any properties you want
  local playerData = {}
  playerData.age = 21;
  playerData.name = "John Li";
  playerData.location = "Orlando, FL"
  ghAnalytics.SendPlayer(playerData)
  
  --Sends off device data immediately.
  --Add any properties you want
  local deviceData = {}
  deviceData.platform = "PC"
  deviceData.OS = "Windows 7"
  deviceData.graphicsVendor = "Nvidia"
  ghAnalytics.SendDevice(deviceData)

end

main();