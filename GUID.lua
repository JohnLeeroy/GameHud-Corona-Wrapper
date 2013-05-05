local crypto = require("crypto");
local GUID = { }

 
--For Android, I will take the DeviceID, Android version, timestamp, and MD5 hash to create the session token.  
--For iOS, I would use the device name (name assigned to device by user from iTunes), device model, timestamp, and MD5 hash to create the session token.  

GUID.Generate = function()
	
	local platform = system.getInfo("platformName");
	local hash = 0;
	local time = os.time();
	print("Time ", time);
	
	if(platform == "Android") then
		local deviceID = system.getInfo("deviceID");
		local version = system.getInfo("platformVersion");
		hash = crypto.digest(crypto.md5, deviceID .. version .. time);
	elseif(platform == "iPhone OS") then
		local deviceName = system.getInfo("name");
		local deviceModel = system.getInfo("architectureInfo");
		hash = crypto.digest(crypto.md5, deviceName .. deviceModel.. time);
	else
		--Assuming it is simulator
		local deviceID = system.getInfo("deviceID");
		hash = crypto.digest(crypto.md5, deviceID .. time);
	end
	print("Sending Hash", hash)
	return hash;
end

return GUID;