function onUpdatePost(elapsed)
	-- uncomment the true if you want, i do NOT care in the slightest
	if getPropertyFromClass('states.PlayState', 'chartingMode') or true then
		if keyboardJustPressed('ONE') then
			endSong();
		end

		if keyboardJustPressed('TWO') then
			callMethod('setSongTime', {getSongPosition() + 10000});
			callMethod('clearNotesBefore', {getSongPosition()});
		end
	end
end