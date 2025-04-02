local letend = false
local whatevermodfreeplay = getModSetting("freeplaydialogues")

function onCreatePost()
	makeLuaSprite('lighting');
	makeGraphic('lighting', screenWidth * 2, screenHeight * 2, 'FF0000');
        screenCenter('lighting')
	setObjectCamera('lighting', 'camHUD');
	addLuaSprite('lighting');
	setProperty('lighting.blend', 0);
	setProperty('lighting.alpha', 0.3);

	makeLuaSprite('black');
	makeGraphic('black', screenWidth * 2, screenHeight * 2, '000000');
	addLuaSprite('black');
	setScrollFactor('black', 0, 0);
	setProperty('black.alpha', 0);
end

function onSongStart()
	if getProperty('inCutscene') then
		return;
	end

	setProperty('camGame.zoom', 1.5);
	setProperty('defaultCamZoom', 1.5);
	setProperty('black.alpha', 0);
	setObjectOrder('black', getObjectOrder('dadGroup')-1);
	callMethod('camHUD.fade', {FlxColor('000000'), 19, true});
	doTweenZoom('zoomOutAlil', 'camGame', 0.7, 19, 'cubeInOut');
	setProperty('camZooming', false);
end

local forceUpdateCenter = true;
function onBeatHit()
	if curBeat == 60 then
		setProperty('bTop.alpha', 1);
		setProperty('bBot.alpha', 1);
	elseif curBeat == 64 then
		callMethod('camOther.flash', {getColorFromName('RED'), 2});
	elseif curBeat == 192 then
		callMethod('camOther.flash', {getColorFromName('BLACK'), 2});
		setProperty('black.alpha', 0.8);
		screenCenter('black');
		setProperty('frontflameright.alpha', 0.1);
		setProperty('frontflameleft.alpha', 0.1);
	elseif curBeat == 224 then
		doTweenAlpha('byeBlack', 'black', 0, 9);
		screenCenter('black');
		doTweenAlpha('rightflamecomingback', 'frontflameright', 0.85, 9);
		doTweenAlpha('leftflamecomingback', 'frontflameleft', 0.85, 9);
	elseif curBeat == 256 then
		callMethod('camOther.flash', {getColorFromName('RED'), 2});
	elseif curBeat == 384 then
		callMethod('camOther.flash', {getColorFromName('BLACK'), 2});
		setProperty('black.alpha', 0.8);
		screenCenter('black');
		setProperty('frontflameright.alpha', 0.1);
		setProperty('frontflameleft.alpha', 0.1);
		setProperty('defaultCamZoom', getProperty('defaultCamZoom') + 0.3);
	elseif curBeat == 416 then
		local toGoTo = getProperty('defaultCamZoom') - 0.3;
		startTween('zoomOutAlilBit', 'this', {defaultCamZoom = toGoTo}, 9, {ease = 'cubeInOut'});
		doTweenAlpha('byeBlack', 'black', 0, 9);
		screenCenter('black');
		doTweenAlpha('rightflamecomingback', 'frontflameright', 0.85, 9);
		doTweenAlpha('leftflamecomingback', 'frontflameleft', 0.85, 9);
	elseif curBeat == 616 then
		doTweenX('finishHealthBar', 'healthBar', screenWidth + 100, getRandomFloat(4, 5), 'quartIn');
		forceUpdateCenter = true;
		startTween('finishScoreTxt', 'scoreTxt', {
			y = (not downscroll) and screenHeight + 200 or -200,
			angle = getRandomFloat(-6, 6)
		}, getRandomFloat(4, 6), {ease = 'quartIn'});

		local timeBarAngle = getRandomFloat(-6, 6);
		local timeBarTime = getRandomFloat(4, 6)
		startTween('finishTimeBar', 'timeBar', {
			y = (not downscroll) and screenHeight + 200 or -200,
			angle = timeBarAngle
		}, timeBarTime, {ease = 'quartIn'});

		startTween('finishTimeTxt', 'timeTxt', {
			y = (not downscroll) and screenHeight + 200 or -200,
			angle = timeBarAngle
		}, timeBarTime, {ease = 'quartIn'});

		for i=0,getProperty('opponentStrums.length')-1 do
			startTween('finishOppStrum'..i, 'opponentStrums.members['..i..']', {
				y = (not downscroll) and screenHeight + 200 or -200,
				angle = getRandomFloat(-6, 6)
			}, getRandomFloat(3, 4.5), {ease = 'quartIn'});
		end

		for i=0,getProperty('playerStrums.length')-1 do
			startTween('finishPlayerStrum'..i, 'playerStrums.members['..i..']', {
				y = (not downscroll) and screenHeight + 200 or -200,
				angle = getRandomFloat(-6, 6)
			}, getRandomFloat(3, 4.5), {ease = 'quartIn'});
		end
	end
end

function onTweenCompleted(tag)
	if tag == 'zoomOutAlil' then
		setProperty('defaultCamZoom', 0.7);
		setProperty('camZooming', true);
	end
end

function onUpdatePost(elapsed)
	if forceUpdateCenter then
		local oldPercent = getProperty('healthBar.percent');
		setProperty('healthBar.percent', 0.00001);
		setProperty('healthBar.percent', oldPercent);
	end
end

function opponentNoteHit(index, noteData, noteType, isSustainNote)
	if getHealth() >= 0.1 then
		addHealth(-((0.023 * (getHealth() + 0.2)) * (isSustainNote and 0.75 or 1)));
	end
end

function onEndSong()
    if not letend and (isStoryMode or whatevermodfreeplay)
        startVideo("credits")
        letend = true
        return Function_Stop
    else
        return Function_Continue
    end
end
