
--Private Properties
local json = require("json")
local guid = require("GUID")

local apiKey = "5eaf423f19978cb3a26b9b2d484ecbcc878fd2cf"
local playerIdentifier;
local deviceIdentifier;

local identifierString = ""

local sessionID = "-1"
local eventQueue;
local eventFilePath = system.pathForFile( "GHAnalytics.json", system.DocumentsDirectory )

local sentQueueSize = 0;
local sendEventSucessCount = 0;


local function StartSession()
	sessionID = guid.Generate();
end

local function EndSession()
	sessionID = "-1";
end

--Private Methods
local function SendEventCallback(event)

	if(event.isError) then
		print(" Send Event Callback Error: " ..event.isError);
	else
		print("Send Event Callback: " .. event.response);
	end

	if(event.status == 200)then
		--Success!
		sendEventSucessCount = sendEventSucessCount + 1;
		print("Send Event Success Count " .. sendEventSucessCount);
	end
end

local function SendEvent(eventName, params)
	local p1 = "gh_api_key=" .. apiKey .. "&";
	local p2 = "gh_name=" .. eventName .. "&";
	local p3 = "gh_session_identifier=" .. sessionID .. "&";

	local paramString = "";
	for i,v in pairs(params) do
		paramString = paramString .. "&" .. i .. "=" .. v;
	end

	network.request("http://www.mygamehud.com/api/v2/events".."?".. p1 .. p2 .. p3 .. identifierString .. paramString, "POST", SendEventCallback);
end

local function addEventToQueue(eventName, params)
	local event;
	event = {name=eventName, params=params};
	table.insert(eventQueue, #eventQueue + 1, event);
end

local function SendEventQueue()
	local eventCount = #eventQueue;
	for i = 1, eventCount do
		SendEvent(eventQueue[i].name, eventQueue[i].params);
	end

	sendEventSucessCount = 0;
	sentQueueSize = eventCount;
	if(sentQueueSize > 0) then
		print(sentQueueSize .. " Events sent");
	end
	eventQueue = {};
end

--Removes GHAnalytics.json
local function RemoveEventFile()
	os.remove(eventFilePath);
end

--Reads from cache and fills in eventqueue with unsent events
local function ReadEventCache()
	print("Reading event cache");
	local file = io.open( eventFilePath, "r+" );
	if file then
		-- read all contents of file into a string
		local contents = file:read( "*a" );
		io.close( file );
		
		if(string.len(contents) == 0) then
			print("Event Cache is empty. ");
			return nil;
		else
			print(contents);
			eventsTable = json.decode(contents);
			RemoveEventFile();
			return eventsTable;
		end
	end
	return nil;
end

--Caches unsent events
local function WriteEventCache()
	
	local eventCache = '[';
	local eventCount = #eventQueue;
	local event;

	for i = 1, eventCount do
		if i == 1 then
			eventCache = '[' .. json.encode(eventQueue[i]);
		else
			eventCache =  eventCache .. ',' .. json.encode(eventQueue[i]);
		end
	end
	eventCache = eventCache .. ']';	

	file = io.open( eventFilePath, "w" );
	file:write(eventCache );
	io.close( file );
end

--When app closes, save out queued events
local function onAppClose(event)
	if(event.type == 'applicationExit') then
		WriteEventCache();
		EndSession();
	elseif(event.type == 'applicationSuspend') then
		WriteEventCache();
		EndSession();
	elseif(event.type == 'applicationResume') then
		EndSession();
		StartSession();
	end
end

--Public Methods
local ghAnalytics = {}

ghAnalytics.Init = function(playerID, deviceID)
	playerIdentifier = playerID or "";
	deviceIdentifier = deviceID or "";

	if(playerIdentifier:len() > 0) then
		identifierString = "gh_player_identifier=" .. playerIdentifier .. "&";
	end

	if(deviceIdentifier:len() > 0) then
		identifierString = identifierString .."gh_device_identifier=" .. deviceIdentifier .. "&";
	end

	eventQueue = ReadEventCache() or { };

	Runtime:addEventListener("system", onAppClose);
end

ghAnalytics.StartSession = function()
	StartSession();
end

ghAnalytics.EndSession = function()
	EndSession();
end

ghAnalytics.SendEvent = function(eventName, params)
	if(sessionID =="-1") then
		print("Session has ended.  Restart Session.");
	end
	addEventToQueue(eventName,params);
	--SendEvent(eventName, params)
end

ghAnalytics.SendPlayer = function(params)
	local p1 = "gh_api_key=" .. apiKey .. "&";
	local p2 = "gh_player_identifier=" .. playerIdentifier;
	local p3 = "gh_session_identifier=" .. sessionID .. "&";

	local paramString = ""
	for i,v in pairs(params) do
		paramString = paramString .. "&" .. i .. "=" .. v;
	end

	network.request("http://www.mygamehud.com/api/v2/players".."?".. p1 .. p2  .. p3 .. paramString, "POST", SendEventCallback);
end

ghAnalytics.SendDevice = function(params)
	local p1 = "gh_api_key=" .. apiKey .. "&";
	local p2 = "gh_device_identifier=" .. deviceIdentifier;
	local p3 = "gh_session_identifier=" .. sessionID .. "&";

	local paramString = ""
	for i,v in pairs(params) do
		paramString = paramString .. "&" .. i .. "=" .. v;
	end

	network.request("http://www.mygamehud.com/api/v2/devices".."?".. p1 .. p2 .. p3 .. paramString, "POST", SendEventCallback);
end

ghAnalytics.SendEventQueue = function()
	SendEventQueue();
end

ghAnalytics.SaveEventQueue = function()
	WriteEventCache();
end

ghAnalytics.LoadEventQueue = function()
	ReadEventCache();
end

--Send Event Queue in timed intervals
-- interval : time inproperties milliseconds
ghAnalytics.SetSendQueueTimer = function(seconds)
	timer.performWithDelay(seconds, ghAnalytics.SendEventQueue, 0);
end

return ghAnalytics;