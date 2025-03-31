local bumpThing = false;
luaDebugMode = true;

function onCreate()
	triggerEvent("Set GF Speed", 2, nil)

	if shadersEnabled then
	initLuaShader('perspective');

	makeLuaSprite('perspectiveShader');
	makeGraphic("perspectiveShader", screenWidth, screenHeight)
	setSpriteShader('perspectiveShader', 'perspective');

	addHaxeLibrary("ShaderFilter", "openfl.filters");
	runHaxeCode([[
		var filter:ShaderFilter = new ShaderFilter(game.getLuaObject('perspectiveShader').shader);
		function setPerspectiveShader()
		{
			game.camGame.setFilters([filter]);
		}
	]]);
	end
end

function onStepHit()
	if curStep == 65 then
		setProperty('defaultCamZoom', getProperty('defaultCamZoom') + 0.1);
	elseif curStep == 96 then
		setProperty('defaultCamZoom', getProperty('defaultCamZoom') + 0.1);
		setProperty('boyfriendCameraOffset[1]', getProperty('boyfriendCameraOffset[1]') + 100);
	elseif curStep == 128 then
		setProperty('defaultCamZoom', getProperty('defaultCamZoom') - 0.2);
		setProperty('boyfriendCameraOffset[1]', getProperty('boyfriendCameraOffset[1]') - 100)
	elseif curStep == 639 then
		setProperty('defaultCamZoom', getProperty('defaultCamZoom') + 0.1);
		bumpThing = true;
		if shadersEnabled then runHaxeFunction('setPerspectiveShader', {}); end
	elseif curStep == 760 then
		triggerEvent('Camera Modulo Change', '999', '');
		bumpThing = false;
		setProperty('camGame.angle', 0);
		setProperty('camHUD.angle', 0);
		setProperty('defaultCamZoom', getProperty('defaultCamZoom') - 0.1);
	elseif curStep == 768 then
		bumpThing = true;
		setProperty('defaultCamZoom', getProperty('defaultCamZoom') + 0.1);
	elseif curStep == 896 then
		setProperty('defaultCamZoom', getProperty('defaultCamZoom') - 0.1);
		bumpThing = false;
		setProperty('camGame.angle', 0);
		setProperty('camHUD.angle', 0);
	elseif curStep == 1152 then
		setProperty('defaultCamZoom', getProperty('defaultCamZoom') - 0.05);
	elseif curStep == 1184 then
		setProperty('defaultCamZoom', getProperty('defaultCamZoom') + 0.15);
	elseif curStep == 1440 then
		setProperty('defaultCamZoom', getProperty('defaultCamZoom') - 0.1);
	end
end

local newBeatToday = false;
function onBeatHit()
	if bumpThing then
		newBeatToday = true;
		setProperty('camGame.angle', (curBeat % 2 == 0) and 1 or -1);
		setProperty('camHUD.angle', (curBeat % 2 == 0) and -2 or 2);
		flick();
	end
end

local thing = 2;
function onUpdatePost(elapsed)
	if bumpThing then
		if newBeatToday then
			thing = 2;
			newBeatToday = false;
		end

		thing = lerp(thing, 0, 0.06);
		if shadersEnabled then
			setShaderFloat('perspectiveShader', 'depth', thing);
		end
		setProperty('camGame.angle', lerp(getProperty('camGame.angle'), 0, 0.15));
		setProperty('camHUD.angle', lerp(getProperty('camHUD.angle'), 0, 0.04));
	end
end

function flick()
	for i=0,getProperty('opponentStrums.length')-1 do
		setPropertyFromGroup('opponentStrums', i, 'y', 80)
		runTimer('opponentStrumTimer'..i, 0.03 * i);
		--debugPrint(i);
	end
	for i=0,getProperty('playerStrums.length')-1 do
		setPropertyFromGroup('playerStrums', i, 'y', 80)
		runTimer('playerStrumTimer'..i, 0.03 * (3 - i));
		--debugPrint(i);
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if stringStartsWith(tag, 'opponentStrumTimer') then
		local i = tonumber(string.sub(tag, string.len('opponentStrumTimer')+1, string.len(tag)));
		noteTweenY('opponentStrumTween'..tostring(i), i, 50, 0.23, 'backOut');
	elseif stringStartsWith(tag, 'playerStrumTimer') then
		local i = tonumber(string.sub(tag, string.len('playerStrumTimer')+1, string.len(tag)));
		noteTweenY('playerStrumTween'..tostring(i), 4+i, 50, 0.23, 'backOut');
	end
end

function lerp(a, b, ratio)
	return a + ratio * (b - a);
end