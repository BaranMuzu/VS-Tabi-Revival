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

local startShit = false
local canDoShit = true
local canExit = true
local canPressShit = true
local whatevermodfreeplay = getFreeplayDialogueCheck()

local textindex = 1
local currentText = ""
local currentPortrait = ""
local currentBackground = ""

local dialogueLines = {}
local lineIndex = 1

local characterlinePath = "dialogue/characters/"
local panelPath = "dialogue/panels/"
local music = ""
local volume = 1
local canLoop = true

luaDebugMode = true;

local spriteNames = {'dialogueBackground', 'dialoguePortrait', 'dialogueBoxIG', 'dialogueTextIG', 'dialogueNameIG'};

local realTimer = 0;
function onUpdate(elapsed)
    if not startShit and (isStoryMode or whatevermodfreeplay) then
        if callMethodFromClass('backend.Paths', 'formatToSongPath', {songName}) == 'genocide' then
            setProperty('camOther.bgColor', getColorFromName('black'));
            cameraFlash('camOther', 'red', 4, false)
            playSound('crash', 1.5);
            realTimer = 5;
        else
            openCustomSubstate("dialoguesa", true)
        end
        setProperty('inCutscene', true);
        if getProperty('skipCountdown') then
            setProperty('startedCountdown', false);
            setPropertyFromClass('backend.Conductor', 'songPosition', -1);
        end
        startShit = true
    end

    if realTimer > 0 then
        realTimer = realTimer - elapsed;

        if realTimer <= 0 then
            realTimer = -1;
            callMethod('camOther.fade', {getColorFromName('black'), 2.3, true});
            setProperty('camOther.bgColor', 0);
            openCustomSubstate("dialoguesa", true)
        end
    end
end

function onCustomSubstateCreatePost(name)
    if name == 'dialoguesa' then
        setProperty('camHUD.alpha', 0);
        makeLuaSprite('dialogueBackground', nil, 0, 0);
        setObjectCamera("dialogueBackground", "other");
        setObjectOrder("dialogueBackground", 3)
        addLuaSprite("dialogueBackground")

        makeLuaSprite('dialoguePortrait', nil, 0, 0);
        setObjectCamera("dialoguePortrait", "other");
        setObjectOrder("dialoguePortrait", 4)
        addLuaSprite("dialoguePortrait")
        setProperty("dialoguePortrait.alpha", 0)

        makeLuaSprite("dialogueBoxIG", "dialogue/box", 520, 400)
        setObjectCamera("dialogueBoxIG", "other")
        setObjectOrder("dialogueBoxIG", 5)
        scaleObject('dialogueBoxIG', 1.1, 1.1, true);
        setProperty('dialogueBoxIG.x', screenWidth * 0.5 - getProperty('dialogueBoxIG.width') / 2);
        setProperty('dialogueBoxIG.y', screenHeight / 2);
        addLuaSprite("dialogueBoxIG")

        makeLuaText("dialogueTextIG", "", 510, 25, 200)
        setObjectCamera("dialogueTextIG", "other")
        setObjectOrder("dialogueTextIG", 7)
        setTextFont("dialogueTextIG", "null")
        setTextSize("dialogueTextIG", 36)
        setTextAlignment("dialogueTextIG", 'left')
        setProperty("dialogueTextIG.angle", -2.3)
        addLuaText("dialogueTextIG")

        makeLuaText("dialogueNameIG", "", 0, 50, 10)
        setObjectCamera("dialogueNameIG", "other")
        setObjectOrder("dialogueNameIG", 8)
        setTextFont("dialogueNameIG", nil)
        setTextSize("dialogueNameIG", 30)
        setTextAlignment("dialogueNameIG", 'left')
        addLuaText("dialogueNameIG")

        --loadingdialogueshahaohhitil()
        loadDialogueData();
        if #dialogueLines > 0 then
            medialogingsobad(dialogueLines[1])
        end
    end
end

function onCustomSubstateUpdatePost(name, elapsed)
    if name == 'dialoguesa' then
        if keyJustPressed("accept") then
            if canPressShit then
                lineIndex = lineIndex + 1
                playSound("dialogue/dialogue fucking clicking sound", 1, "idk")
                if songName == 'My Battle' then
                   if lineIndex == 3 then
                      canLoop = false
                   elseif lineIndex == 13 then
                      canLoop = true
                   elseif lineIndex == 14 then
                      canLoop = false
                   end
                elseif songName == 'Last Chance' then
                    canLoop = false
                elseif songName == 'Genocide' then
                    canLoop = false
                end
                if lineIndex <= #dialogueLines then
                    stopSound("yea")
                    medialogingsobad(dialogueLines[lineIndex])
                elseif canExit then
                    endDialogue();
                end
            end
        end
    end
end

function destroyDialogue()
    stopSound('realMusic');
    stopSound('yea');
    removeLuaSprite('dialogueBoxIG')
    removeLuaText('dialogueTextIG')
    removeLuaText('dialogueNameIG')
    removeLuaSprite('dialoguePortrait')
    removeLuaSprite('dialogueBackground')
    setProperty('inCutscene', false);
    if getProperty('skipCountdown') then
        setProperty('startedCountdown', true);
        setPropertyFromClass('backend.Conductor', 'songPosition', 0);
    end
end

function endDialogue()
    canExit = false;
    doTweenAlpha('helloUI', 'camHUD', 1, 1);
    doTweenAlpha('byeDialogue', 'camOther', 0, 1);
end

function onTweenCompleted(tag)
    if tag == 'byeDialogue' then
        setProperty('camOther.alpha', 1);
        closeCustomSubstate()
        close()
        destroyDialogue()
    end
end

function medialogingsobad(line)
    local char = line.char or 'transition';
    local expression = line.expression or 'none';
    local text = line.text or '';
    local boxPos = line.boxPos;
    music = line.music or '';
    local sound = line.audio or '';
    volume = line.volume or 1;
    local background = line.bg or 1;

    if char == 'transition' then
        canPressShit = false;
        lineIndex = lineIndex + 1
        cameraFade('camOther', 'black', 1, true);
        runTimer('fadeBackIn');
        return;
    end

    local isLeft = string.lower(char) == 'bf';

    if boxPos ~= nil then
        isLeft = boxPos == 'left';
    end

    local amount = 40;
    local displayName = string.upper(char);
    local fontName = nil;
    if string.lower(char) == "bf" then
        fontName = "Graffiti City.otf";
    elseif string.lower(char) == "gf" then
        fontName = "Restaurant.otf";
        amount = 45;
    elseif string.lower(char) == "tabi" then
        fontName = "Russian Angel.ttf";
        amount = 55;
        displayName = 'Tabi';
    end
    setTextFont('dialogueTextIG', fontName);
    setTextFont('dialogueNameIG', fontName);
    setTextString('dialogueNameIG', displayName);

    setProperty('dialogueBoxIG.x', screenWidth * (isLeft and 0.35 or 0.65) - getProperty('dialogueBoxIG.width') / 2);
    setProperty('dialogueBoxIG.flipX', isLeft);

    setProperty('dialogueNameIG.x', getProperty('dialogueBoxIG.x') + getProperty('dialogueBoxIG.width') * (isLeft and 0.2 or 0.8) - getProperty('dialogueNameIG.width') / 2);
    setProperty('dialogueNameIG.y', screenHeight * 0.622 - getProperty('dialogueNameIG.height') / 2);
    setProperty('dialogueNameIG.angle', isLeft and 3.5 or -3.5);

    setProperty('dialogueTextIG.x', getProperty('dialogueBoxIG.x') + (getProperty('dialogueBoxIG.width') / 2) * (isLeft and 0.3 or 0.43));
    setProperty('dialogueTextIG.y', (screenHeight * 0.77) - amount);
    setProperty('dialogueTextIG.angle', isLeft and 2.3 or -2.3);

    if sound ~= "" and sound ~= nil then
        playSound('dialogue/'..sound, 1, "yea")
    end

    if music ~= "" and music ~= nil and canLoop then
        playSound(music, volume, 'realMusic')
    end

    if currentBackground ~= background and background ~= nil and background ~= '' and background ~= 1 then
        setProperty('dialogueBackground.alpha', 1);
        scaleObject('dialogueBackground', 1, 1, true);
        if background == 'blur' then
            makeGraphic('dialogueBackground', screenWidth, screenHeight, 'black');
            setProperty('dialogueBackground.alpha', 160 / 255);
        elseif background == 'black' then
            makeGraphic('dialogueBackground', screenWidth, screenHeight, 'black');
        else
            loadGraphic('dialogueBackground', panelPath..background)
            setGraphicSize('dialogueBackground', screenWidth, screenHeight, true);
            screenCenter('dialogueBackground');
        end
        currentBackground = background;
    end

    if currentPortrait ~= char and char ~= nil then
        if char == 'empty' or expression == 'none' then
            setProperty('dialoguePortrait.visible', false);
            setProperty("dialoguePortrait.alpha", 0)
        else
            setProperty('dialoguePortrait.visible', true);
            setProperty("dialoguePortrait.alpha", 1)
            loadGraphic('dialoguePortrait', characterlinePath..char..'/'..expression);
            scaleObject('dialoguePortrait', 0.7, 0.7, true);
            setProperty('dialoguePortrait.x', screenWidth * (isLeft and 0.8 or 0.2) - getProperty('dialoguePortrait.width') / 2);
            setProperty('dialoguePortrait.y', 400 - getProperty('dialoguePortrait.height') / 2);
        end
        currentBackground = background;
    end

    writeText(text)
end

function onSoundFinished(tag)
    if tag == 'realMusic' then
        playSound(music, 0.8, 'realMusic')
    end
end

function writeText(text)
    textindex = 1
    currentText = text
    setTextString('dialogueTextIG', string.sub(currentText, 1, textindex))
    runTimer('imtypingit', 0.05, string.len(currentText)+1)
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'imtypingit' then
        setTextString('dialogueTextIG', string.sub(currentText, 1, textindex))
        textindex = textindex + 1
    end
    if tag == 'fadeBackIn' then
        runHaxeCode('game.camOther.stopFX();');
        callMethod('camOther.fade', {getColorFromName('black'), 1, true});
        medialogingsobad(dialogueLines[lineIndex])
        canPressShit = true
    end
end

-- im sorry baran but this get no used anymore 😭
-- man im so useless porter for this.
function loadingdialogueshahaohhitil()
    local songName = songName or "unknown"
    local linePath = "data/" .. songName .. "/cutsceneLines.txt"

    if checkFileExists(linePath) then
        local file = getTextFromFile(linePath)
        for line in string.gmatch(file, "[^\r\n]+") do
            local splitStuff = stringSplit(line, ': ');
            local backwardsCompatability = {
                char = splitStuff[1];
                text = splitStuff[2];
            };
            table.insert(dialogueLines, backwardsCompatability)
        end
    else
        debugPrint("bro cutscene txt not founded bro are u serious rn dude?")
    end
end

function loadDialogueData()
    local path = 'data/'..callMethodFromClass('backend.Paths', 'formatToSongPath', {songName})..'/cutscene.json';
    if not checkFileExists(path) then
        closeCustomSubstate()
        close()
        destroyDialogue()
        return;
    end
    local content = getTextFromFile(path, false);
    local json = callMethodFromClass('tjson.TJSON', 'parse', {content});
    dialogueLines = json.lines;
end