-- Search, download and load subtitles for TV shows and movies
-- Keybinding: english(N)
-- Keybinding: portuguese(B)

local utils = require "mp.utils"

function load_sub(lang)
    bin = "gosub" -- program used to find subtitles
	mp.msg.info("Searching subtitle...")
    mp.osd_message("Searching subtitle...")
    commands = {}
    commands.args = {bin, "-p", "opensub", "-l", lang, mp.get_property("path")}
    res = utils.subprocess(commands)
    if res.status == 0 then
        mp.commandv("rescan_external_files", "reselect") 
        mp.msg.info("Subtitle download succeeded")
        mp.osd_message("Subtitle download succeeded")
    else
        mp.msg.warn("Subtitle download failed")
        mp.osd_message("Subtitle download failed")
    end
end

function load_sub_en()
	load_sub("en")
end

function load_sub_pt()
	load_sub("pt")
end

mp.add_key_binding("n", "autosub_en", load_sub_en)
mp.add_key_binding("b", "autosub_pt", load_sub_pt)