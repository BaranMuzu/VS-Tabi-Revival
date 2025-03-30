function onUpdatePost(elapsed)
	if getPropertyFromClass('states.PlayState', 'chartingMode') then
		if keyboardJustPressed('ONE') then
			endSong();
		end

		if keyboardJustPressed('TWO') then
			callMethod('setSongTime', {getSongPosition() + 10000});
			callMethod('clearNotesBefore', {getSongPosition()});
		end
	end
end