-- Automatically sets panscan to avoid horizontal black bars on 16:9 monitors
-- Keeps vertical black bars on 4:3 content

function panscan()
	idleactive = mp.get_property_native("idle-active")
	demuxer = mp.get_property_native("current-demuxer")
	
	if idleactive or demuxer==nil then
		return
	end
	
	vasp = mp.get_property_number("video-aspect")
	
	if aboveMonitor(vasp) then
		mp.set_property_number("options/panscan",1.0)
	end
end

function aboveMonitor(asp)
	asp = asp * 100
	asp = math.floor(asp) / 100
	if asp > 1.77 then
		return true
	else
		return false
	end
end

mp.register_event("file-loaded", panscan)