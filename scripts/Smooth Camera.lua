local camBetterFollowLerp = 0.1;

local camCharacter = 'dad';
local charCamPosition = {0, 0};
local overrideCamPos = false;

luaDebugMode = true;

function onCreatePost()
	createInstance('camBetterFollow', 'flixel.FlxObject', {getProperty('camFollow.x'), getProperty('camFollow.y'), 2, 2});
	runHaxeCode([[
		game.camGame.target = game.variables.get('camBetterFollow');
		game.camGame.followLerp = 0.04;
	]]);
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

function onMoveCamera(character)
	if not overrideCamPos then
		camCharacter = character;
		updateCameraChar();
	end
end

function updateCameraChar()
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
end

function onUpdatePost(elapsed)
	local realCameraPos = {charCamPosition[1], charCamPosition[2]};

	local displacement = getDisplacement(camCharacter);
	realCameraPos[1] = realCameraPos[1] + displacement[1];
	realCameraPos[2] = realCameraPos[2] + displacement[2];

	setProperty('camBetterFollow.x', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('camBetterFollow.x'), getProperty('camFollow.x'), camBetterFollowLerp}));
	setProperty('camBetterFollow.y', callMethodFromClass('flixel.math.FlxMath', 'lerp', {getProperty('camBetterFollow.y'), getProperty('camFollow.y'), camBetterFollowLerp}));

	setProperty('camFollow.x', realCameraPos[1]);
	setProperty('camFollow.y', realCameraPos[2]);
end