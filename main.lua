-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
local ghAnalytics = require("GHAnalytics")



local function main()
ghAnalytics.Init("playerID", "deviceID");
ghAnalytics.StartSession();
--

--
local params = {StringProperty="ThisIsAString", NumberProperty=1337}
ghAnalytics.SendEvent("EventName", params)

ghAnalytics.SetSendQueueTimer(5000)

local playerData = {}
playerData.age = 21;
playerData.name = "John Li";
playerData.location = "Orlando, FL"
ghAnalytics.SendPlayer(playerData)

local deviceData = {}
deviceData.platform = "PC"
deviceData.OS = "Windows 7"
deviceData.graphicsVendor = "Nvidia"
ghAnalytics.SendDevice(deviceData)

end

main();