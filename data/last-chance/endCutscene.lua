local hasSeenCutscene = false;
function onEndSong()
	if not hasSeenCutscene and isStoryMode then
		startVideo('tabi has a crashout');
		hasSeenCutscene = true;
		return Function_Stop;
	end
end