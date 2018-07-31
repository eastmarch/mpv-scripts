-- Shows file details OSD. Runs automatically on playback start. 
-- Default keybinding: "="

local osdDuration

function showInfo()
	idleactive = mp.get_property_native("idle-active")
	demuxer = mp.get_property_native("current-demuxer")
	
	if idleactive or demuxer==nil then
		return
	end
	
	-- colecting data
	ttle = mp.get_property_osd("media-title")
	vfor = mp.get_property_osd("video-format")
	vrex = mp.get_property_osd("width")
	vrey = mp.get_property_osd("height")
	vbit = mp.get_property_osd("video-bitrate")
	vasp = mp.get_property_native("video-params/aspect")
	vfps = mp.get_property_native("estimated-vf-fps")
	acod = mp.get_property_osd("audio-codec-name")	
	achn = mp.get_property_osd("audio-params/channels")
	abit = mp.get_property_osd("audio-bitrate")
	hwdc = mp.get_property_osd("hwdec-current")

	-- preparing osd message
	info = {}
	dlmt = " • "
	assText = mp.get_property_osd("osd-ass-cc/0")
	yellowText = "{\\1c&HBFFFOO&}"
	greenText = "{\\1c&HCCFF99&}"
	blueText = "{\\1c&H99FF00&}"
	
	-- fisrt line (title)
	ttle = (#ttle <= 70 and ttle) or (string.sub(ttle,1,68).."[...]")
	info[#info+1] = assText..greenText..ttle

	-- second line (video)
	if vfor and vasp and vrex and vrey and vfps then
		vfor = string.upper(vfor)
		vres = vrex.."x"..vrey
		vasp = matchAspect(vasp)
		vfps = roundFPS(vfps)
		vbit = (vbit == "" and vbit) or (dlmt..vbit:gsub(" ",""))
		info[#info+1] = greenText.."Video:\t"..yellowText..vfor..dlmt..vres..dlmt..vasp..dlmt..vfps..vbit
	end

	-- third line (audio)
	if acod and achn then
		acod = string.upper(acod)
		achn = string.upper(achn)
		abit = (abit == "" and abit) or (dlmt..abit:gsub(" ",""))
		info[#info+1] = greenText.."Audio:\t"..yellowText..acod..dlmt..achn..abit
	end
	
	-- fourth line (hardware decoding)
	hwdc = (hwdc == "no" and "OFF") or "ON"
	info[#info+1] = greenText.."HwDc:\t"..yellowText..hwdc
	
	mp.osd_message(table.concat(info,"\n"), osdDuration)
end

function roundFPS(fps)
	fpsint, fpsdec = math.modf(fps)
	if fpsdec >= 0.5 then
		fpsint = fpsint+1
	end
	return fpsint.."fps"
end

function matchAspect(asp)
	asp = asp * 100
	asp = math.floor(asp) / 100
	aspects = {
		[1.33] = "4:3",
		[1.77] = "16:9",
		[2.00] = "18:9",
	}
	if asp >= 2.33 and asp <= 2.4 then
		res = "21:9"
	else
		res = asp..":1"
	end
	return aspects[asp] or res
end

function onLoad()
	osdDuration = 3
	mp.add_timeout(1, showInfo)
end

function onKeyPress()
	osdDuration = 6
	showInfo()
end

mp.register_event("file-loaded", onLoad)
mp.add_key_binding("=", onKeyPress)
