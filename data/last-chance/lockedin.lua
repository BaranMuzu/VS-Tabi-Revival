local lockedIn = false;
luaDebugMode = true;

function onCreate()
	setProperty('skipCountdown', true);
end

function onSongStart()
	if getProperty('inCutscene') then
		return;
	end

	setProperty('opponentCameraOffset[0]', getProperty('opponentCameraOffset[0]') - 200);
	callMethod('camGame.fade', {FlxColor('000000'), 10, true, nil, true});
	setProperty('camGame.scroll.x', -450);
	setProperty('camGame.zoom', getProperty('defaultCamZoom') + 0.2);
	doTweenZoom('zoomAlil', 'camGame', getProperty('camGame.zoom') + 0.1, 10, 'quartOut');
end

function onStepHit()
	if curStep == 128 then
		setProperty('opponentCameraOffset[0]', getProperty('opponentCameraOffset[0]') + 200);
	end
end

function onEvent(event, value1, value2, strumTime)
	-- im too lazy to change the name
	if event == 'HScript Call' then
		if value1 == 'locktoggle' then
			lockedIn = not lockedIn;

			if lockedIn then
				setProperty('boyfriendCameraOffset[1]', getProperty('boyfriendCameraOffset[1]') + 90);
			else
				setProperty('boyfriendCameraOffset[1]', getProperty('boyfriendCameraOffset[1]') - 90);
			end
		end
	end
end

function onUpdatePost(elapsed)
	if lockedIn and mustHitSection then
		setProperty('camGame.zoom', lerp(getProperty('camGame.zoom'), getProperty('defaultCamZoom') + 0.2, 0.04));
	end
end

function lerp(a, b, ratio)
	return a + ratio * (b - a);
end
