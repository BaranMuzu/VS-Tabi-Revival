local time = 0;

function onCreate()
	setProperty('skipCountdown', true);
	setVar('sorry', false);

	if shadersEnabled then
		initLuaShader('wavy');

		makeLuaSprite('shaderHeat');
		setSpriteShader('shaderHeat', 'wavy');
		setShaderFloat('shaderHeat', 'iTime', 0);
		setShaderFloat('shaderHeat', 'intensity', 4);

		addHaxeLibrary("ShaderFilter", "openfl.filters")
		runHaxeCode([[
			game.camGame.setFilters([new ShaderFilter(game.getLuaObject("shaderHeat").shader)]);
		]])
	end

	makeLuaSprite('fireSprite');
	makeGraphic('fireSprite', screenWidth * 2, screenHeight * 2, '000000');
	setScrollFactor('fireSprite', 0, 0);
	setProperty('fireSprite.alpha', 0);
	addLuaSprite('fireSprite', true);
end

local extraZoom = 0;
function onEvent(event, value1, value2)
	-- too lazy to change the name
	if event == 'HScript Call' then
		if value1 == 'perc' then
			setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.015);
			setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.03);
			setProperty('cam_dad.zoom', getProperty('cam_dad.zoom') + 0.05);
			setProperty('cam_boyfriend.zoom', getProperty('cam_boyfriend.zoom') + 0.05);
		elseif value1 == 'zoom' then
			local it = stringSplit(value2, ' ');
			if it[1] == "set" then extraZoom = tonumber(it[2]); end
			if it[1] == "add" then extraZoom = extraZoom + tonumber(it[2]); end
		end
	end
end

function onUpdatePost(elapsed)
	time = time + elapsed;
	if shadersEnabled then
		setShaderFloat('shaderHeat', 'iTime', time);
	end

	local target = getProperty('defaultCamZoom') + extraZoom;
	if getProperty('gfSection') then
		target = target - 0.1;
	end

	if getVar('sorry') then
		setProperty('camGame.zoom', lerp(getProperty('camGame.zoom'), target, 0.06));
	end
end

function onBeatHit()
	if curBeat == 64 then
		setVar('sorry', true);
	end
end

function opponentNoteHit()
	cameraShake('camGame', 0.0025, 0.1);
	cameraShake('camHUD', 0.0025, 0.1);
	setProperty('camGame.zoom', getProperty('camGame.zoom') + 0.0025);
	setProperty('camHUD.zoom', getProperty('camHUD.zoom') + 0.005);
	setProperty('vignette', 0.425);
end

-- god i FUCKING love and hate this function
function lerp(a, b, ratio)
	return a + ratio * (b - a);
end