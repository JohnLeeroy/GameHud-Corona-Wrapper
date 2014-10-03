#GameHud

Contains the Corona wrapper for GAMEhud

The code is free distributed under the terms of the MIT license in the LICENSE.txt file. 
The code may be used for any purpose including commercial purposes, at no cost.

Feel free to contact me at JohnLiGlobal@gmail.com

##How To
###Initialize
```lua
local ghAnalytics = require("GHAnalytics")
ghAnalytics.Init("insert_api_key", "optional_PlayerID");
ghAnalytics.StartSession();
```

###Basic events
```lua
local params = {StringProperty="ThisIsAString", NumberProperty=1234}
ghAnalytics.SendEvent("EventName", params)
```

  
```lua
local playerData = {}
playerData.name = "John Li";
playerData.location = "Orlando, FL"
ghAnalytics.SendPlayer(playerData)
```


```
local deviceData = {}
deviceData.platform = "PC"
deviceData.OS = "Windows 7"
deviceData.graphicsVendor = "Nvidia"
ghAnalytics.SendDevice(deviceData)
```

You can add optional parameters to most events.
###Queued Events
```
ghAnalytics.SetSendQueueTimer(5000)  //accepts milliseconds
  
local params = {StringProperty="ThisIsAString", NumberProperty=1234}
ghAnalytics.QueueEvent("QueueEventName", params)
```
The example sets the send interval to 5 seconds and sends a queued event.
