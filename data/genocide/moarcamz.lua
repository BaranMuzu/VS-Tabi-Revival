local characterNames = {'dad', 'boyfriend'};
local preventCameraPlacementMath = true;

function onCreatePost()
	-- only reason they are with underscores is so i can match them with the main variable easily
	createInstance('cam_dad', 'flixel.FlxCamera', {});
	createInstance('cam_boyfriend', 'flixel.FlxCamera', {screenWidth / 2, 0});
	createInstance('camPoint_dad', 'flixel.FlxObject', {0, 0, 1, 1});
	createInstance('camPoint_boyfriend', 'flixel.FlxObject', {0, 0, 1, 1});

	addHaxeLibrary("ShaderFilter", "openfl.filters")

	for i=1,#characterNames do
		setProperty('cam_'..characterNames[i]..'.bgColor', FlxColor('000000'));
		callMethod('cam_'..characterNames[i]..'.setSize', {screenWidth / 2, screenHeight});
		runHaxeCode([[
			var cam = game.variables.get("cam_]]..characterNames[i]..[[");
			FlxG.cameras.add(cam);
			cam.setFilters([new ShaderFilter(game.getLuaObject("shaderHeat").shader)]);
		]]);
	end
	setProperty('cam_dad.x', (-screenWidth / 2) - 100);
	setProperty('cam_boyfriend.x', screenWidth + 100);

	for i=1,#characterNames do
		runHaxeCode([[
			var cam = game.variables.get("cam_]]..characterNames[i]..[[");
			var point = game.variables.get("camPoint_]]..characterNames[i]..[[");
			cam.follow(point, game.camGame.style, 0.1);
		]]);
	end

	runHaxeCode([[
		FlxG.cameras.remove(game.camHUD, false);
		FlxG.cameras.add(game.camHUD, false);

		FlxG.cameras.remove(game.camOther, false);
		FlxG.cameras.add(game.camOther, false);
	]]);

	makeLuaSprite('bTop');
	makeGraphic('bTop', screenWidth, screenHeight * 0.5, '000000');
	setObjectCamera('bTop', 'camOther');
	setProperty('bTop.alpha', 0);
	addLuaSprite('bTop');

	makeLuaSprite('bBot', nil, 0, screenHeight * 0.5);
	makeGraphic('bBot', screenWidth, screenHeight * 0.5, '000000');
	setObjectCamera('bBot', 'camOther');
	setProperty('bBot.alpha', 0);
	addLuaSprite('bBot');
end

function tweenBars(distance, time, ease)
	doTweenY('bTopTwn', 'bTop', -screenHeight * 0.5 + distance, time, ease);
	doTweenY('bBotTwn', 'bBot', screenHeight - distance, time, ease);
end

function onStepHit()
	if curStep == 256 then
		setProperty('bTop.alpha', 1);
		setProperty('bBot.alpha', 1);
		tweenBars(0, 3, 'quintOut');
	elseif curStep == 1816 or curStep == 2392 then
		doTweenX('welcomeDadCamera', 'cam_dad',
			0,
			getPropertyFromClass('backend.Conductor', 'stepCrochet') / 1000 * 8,
			'quintIn'
		);
		doTweenX('welcomeBoyfriendCamera', 'cam_boyfriend',
			screenWidth / 2,
			getPropertyFromClass('backend.Conductor', 'stepCrochet') / 1000 * 8,
			'quintIn'
		);
	elseif curStep == 1823 or curStep == 2399 then
		preventCameraPlacementMath = false;
	elseif curStep == 2080 then
		preventCameraPlacementMath = true;
		setProperty('camGame.visible', false);
		setProperty('cam_dad.x', (-screenWidth / 2) - 100);
		setProperty('cam_dad.width', screenWidth / 2);
		setProperty('cam_boyfriend.x', screenWidth + 100);
		setProperty('cam_boyfriend.width', screenWidth / 2);
	elseif curStep == 2084 then
		setProperty('camGame.visible', true);
		callMethod('camHUD.flash', {getColorFromName('RED'), 3});
	elseif curStep == 2464 then
		preventCameraPlacementMath = true;
		doTweenX('byeDadCamera', 'cam_dad',
			-screenWidth / 2,
			getPropertyFromClass('backend.Conductor', 'stepCrochet') / 1000 * 4,
			'quintOut'
		);
		doTweenX('byeBoyfriendCamera', 'cam_boyfriend',
			screenWidth,
			getPropertyFromClass('backend.Conductor', 'stepCrochet') / 1000 * 4,
			'quintOut'
		);

		doTweenAlpha('fadeToBlack', 'fireSprite', 1, getPropertyFromClass('backend.Conductor', 'stepCrochet') / 1000 * 32);
		screenCenter('fireSprite');
		setVar('sorry', true);
		doTweenZoom('zoomInalil', 'camGame', 1.5, 4, 'circOut');
		setProperty('opponentCameraOffset[0]', getProperty('opponentCameraOffset[0]') - 230);
		setProperty('opponentCameraOffset[1]', getProperty('opponentCameraOffset[1]') - 130);
	end
end

function onSectionHit()
	if not preventCameraPlacementMath then
		local amount = 700;
		startTween('camDadMvmntTwn', 'cam_dad',
			{width = not mustHitSection and amount or (screenWidth - amount)},
			getPropertyFromClass('backend.Conductor', 'stepCrochet') / 1000 * 8,
			{ease = 'quartOut'}
		);
		startTween('camBoyfriendMvmntTwn', 'cam_boyfriend',
			{
				x = not mustHitSection and amount or screenWidth - amount,
				width = mustHitSection and amount or screenWidth - amount
			},
			getPropertyFromClass('backend.Conductor', 'stepCrochet') / 1000 * 8,
			{ease = 'quartOut'}
		);
	end
end

function onUpdatePost(elapsed)
	for i=1,#characterNames do
		local realCameraPos = getCharPos(characterNames[i]);

		local displacement = getDisplacement(characterNames[i]);
		realCameraPos[1] = realCameraPos[1] + displacement[1];
		realCameraPos[2] = realCameraPos[2] + displacement[2];

		local camOffset = getCharCamOffset(characterNames[i]);
		realCameraPos[1] = realCameraPos[1] + camOffset[1];
		realCameraPos[2] = realCameraPos[2] + camOffset[2];

		setProperty('camPoint_'..characterNames[i]..'.x', realCameraPos[1]);
		setProperty('camPoint_'..characterNames[i]..'.y', realCameraPos[2]);
		runHaxeCode([[
			var cam = game.variables.get("cam_]]..characterNames[i]..[[");
			var point = game.variables.get("camPoint_]]..characterNames[i]..[[");
			cam.follow(point, game.camGame.style, 0.1);
		]]);
		setProperty('cam_'..characterNames[i]..'.zoom', lerp(getProperty('cam_'..characterNames[i]..'.zoom'), 1.1, 0.05));
	end

	if getPropertyFromClass('states.PlayState', 'chartingMode') then
		if keyboardJustPressed('ONE') then
			callMethod('KillNotes');
			callMethodFromClass('flixel.FlxG', 'sound.music.onComplete', {});
		end

		if keyboardJustPressed('TWO') then
			callMethod('setSongTime', {getSongPosition() + 10000});
			callMethod('clearNotesBefore', {getSongPosition()});
		end
	end
end

function getCharPos(camCharacter)
	local charCamPosition = {0, 0};
	if camCharacter == 'dad' then
		charCamPosition = {getMidpointX('dad') + 150, getMidpointY('dad') - 100};
		charCamPosition[1] = charCamPosition[1] + getProperty('dad.cameraPosition[0]') + getProperty('opponentCameraOffset[0]');
		charCamPosition[2] = charCamPosition[2] + getProperty('dad.cameraPosition[1]') + getProperty('opponentCameraOffset[1]');
	elseif camCharacter == 'boyfriend' then
		charCamPosition = {getMidpointX('boyfriend') - 100, getMidpointY('boyfriend') - 100};
		charCamPosition[1] = charCamPosition[1] - getProperty('boyfriend.cameraPosition[0]') - getProperty('boyfriendCameraOffset[0]');
		charCamPosition[2] = charCamPosition[2] + getProperty('boyfriend.cameraPosition[1]') + getProperty('boyfriendCameraOffset[1]');
	elseif camCharacter == 'gf' then
		charCamPosition = {getMidpointX('gf'), getMidpointY('gf')};
		charCamPosition[1] = charCamPosition[1] + getProperty('gf.cameraPosition[0]') + getProperty('girlfriendCameraOffset[0]');
		charCamPosition[2] = charCamPosition[2] + getProperty('gf.cameraPosition[1]') + getProperty('girlfriendCameraOffset[1]');
	end

	return charCamPosition;
end

local cameraDisplacement = 20;
function getDisplacement(charName)
	local animName = getProperty(charName..'.animation.curAnim.name');
	if animName == 'singLEFT' then
		return {cameraDisplacement * -1, 0};
	elseif animName == 'singDOWN' then
		return {0, cameraDisplacement};
	elseif animName == 'singUP' then
		return {0, cameraDisplacement * -1};
	elseif animName == 'singRIGHT' then
		return {cameraDisplacement, 0};
	else
		return {0, 0};
	end
end

function getCharCamOffset(character)
	if character == 'boyfriend' then
		return {200, 50};
	elseif character == 'dad' then
		return {-200, 0};
	else
		return {0, 0};
	end
end

function lerp(a, b, ratio)
	return a + ratio * (b - a);
end