local hasSeenCutscene = false;
local whatevermodfreeplay = getModSetting("freeplaydialogues")
function onEndSong()
	if not hasSeenCutscene and (isStoryMode or whatevermodfreeplay) then
		startVideo('tabi has a crashout');
		hasSeenCutscene = true;
		return Function_Stop;
	end
end