function getFreeplayDialogueCheck()
	local versionsSupportSettings = {'0.7.2', '0.7.3', '1.0'};
	local isSupported = false;
	for i=1,#versionsSupportSettings do
		if stringStartsWith(version, versionsSupportSettings[i]) then
			isSupported = true;
		end
	end

	if isSupported then
		return getModSetting("freeplaydialogues");
	else
		return false;
	end
end

local hasSeenCutscene = false;
local whatevermodfreeplay = getFreeplayDialogueCheck();
function onEndSong()
	if not hasSeenCutscene and (isStoryMode or whatevermodfreeplay) then
		startVideo('tabi has a crashout');
		hasSeenCutscene = true;
		return Function_Stop;
	end
end