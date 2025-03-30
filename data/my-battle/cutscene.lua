local startShit = false
local canDoShit = true
local canExit = true
local canPressShit = true

local textindex = 1
local currentText = ""

local dialogueLines = {}
local lineIndex = 1

local characterlinePath = "dialogue/characters/"
local panelPath = "dialogue/panels/"

function onStartCountdown()
    if not startShit then
        if isStoryMode then
            callMethod('closeSubState')
            openCustomSubstate("dialoguesa", true)
            startShit = true
        end
    end
end

function onUpdate(elapsed)
    if not startShit and isStoryMode then
        openCustomSubstate("dialoguesa", true)
        startShit = true
    end
end

function onCustomSubstateCreatePost(name)
    if name == 'dialoguesa' then
        setProperty("camHUD.alpha", 0)
        setProperty("camGame.alpha", 0)

        makeLuaSprite('dialogueFade', 'nil', 0, 0)
        setObjectOrder('dialogueFade', 20);
        makeGraphic('dialogueFade', screenWidth, screenHeight, '000000')
        addLuaSprite('dialogueFade', true)
        setProperty('dialogueFade.alpha', 0)
        setObjectCamera('dialogueFade', 'other')

        makeLuaSprite('dialogueFadeTalk', 'nil', 0, 0)
        setObjectOrder('dialogueFadeTalk', 3);
        makeGraphic('dialogueFadeTalk', screenWidth, screenHeight, '000000')
        addLuaSprite('dialogueFadeTalk', true)
        setProperty('dialogueFadeTalk.alpha', 0)
        setObjectCamera('dialogueFadeTalk', 'other')

        makeLuaSprite("dialogueBoxIG", "dialogue/box", 520, 400)
        setObjectCamera("dialogueBoxIG", "other")
        setObjectOrder("dialogueBoxIG", 5)
        addLuaSprite("dialogueBoxIG")

        makeLuaSprite("dialogueImage", "dialogue/panels/Phone_talk_1", 520, 400)
        setObjectCamera("dialogueImage", "other")
        setObjectOrder("dialogueImage", 3)
        addLuaSprite("dialogueImage")
        scaleObject("dialogueImage", 1.0, 1.07)
        setProperty("dialogueImage.alpha", 0)
        screenCenter("dialogueImage")

        makeLuaText("dialogueTextIG", "", 450, 670, 530)
        setObjectCamera("dialogueTextIG", "other")
        setObjectOrder("dialogueTextIG", 7)
        setTextFont("dialogueTextIG", "null")
        setTextSize("dialogueTextIG", 32)
        setTextAlignment("dialogueTextIG", 'left')
        setProperty("dialogueTextIG.angle", -2)
        addLuaText("dialogueTextIG")

        makeLuaText("dialogueChar", "", 450, 1070, 455)
        setObjectCamera("dialogueChar", "other")
        setObjectOrder("dialogueChar", 7)
        setTextFont("dialogueChar", "null")
        setTextSize("dialogueChar", 25)
        setTextAlignment("dialogueChar", 'left')
        setProperty("dialogueChar.angle", -2)
        addLuaText("dialogueChar")

        makeLuaSprite("BFTALK", "dialogue/characters/bf/idle", 570, -25)
        setObjectCamera("BFTALK", "other")
        scaleObject("BFTALK", 0.75, 0.75, true)
        setObjectOrder("BFTALK", 6)
        setProperty("BFTALK.alpha", 0)
        addLuaSprite("BFTALK")

        makeLuaSprite("GFTALK", "dialogue/characters/gf/huh", -100, 20)
        setObjectCamera("GFTALK", "other")
        scaleObject("GFTALK", 0.72, 0.72, true)
        setObjectOrder("GFTALK", 6)
        setProperty("GFTALK.alpha", 0)
        addLuaSprite("GFTALK")

        makeLuaSprite("TABITALK", "dialogue/characters/tabi/black", -100, 20)
        setObjectCamera("TABITALK", "other")
        scaleObject("TABITALK", 0.72, 0.72, true)
        setObjectOrder("TABITALK", 6)
        setProperty("TABITALK.alpha", 0)
        addLuaSprite("TABITALK")

        loadingdialogueshahaohhitil()
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
                if lineIndex == 2 then
                    playSound("phone-call", 1, "phone")
                elseif lineIndex == 12 then
                    stopSound("phone")
                    playSound("tabi-theme", 0.6, "tabi")
                    setProperty("camHUD.alpha", 1)
                    setProperty("camGame.alpha", 1)
                    setProperty("dialogueFadeTalk.alpha", 0.7)
                    setProperty("dialogueImage.visible", false)
                end
                if lineIndex == 25 then
                    soundFadeOut("tabi", 0.4, 0)
                    doTweenAlpha("dialogueFadeTalkA", "dialogueFadeTalk", 0, 1.4, "linear")
                    doTweenAlpha("BFTALK", "BFTALK", 0, 1.2, "linear")
                    doTweenAlpha("GFTALK", "GFTALK", 0, 1.2, "linear")
                    doTweenAlpha("TABITALK", "TABITALK", 0, 1.2, "linear")

                    doTweenAlpha("dialogueChar", "dialogueChar", 0, 1.2, "linear")
                    doTweenAlpha("dialogueTextIG", "dialogueTextIG", 0, 1.2, "linear")
                    doTweenAlpha("dialogueImage", "dialogueImage", 0, 1.2, "linear")

                    doTweenAlpha("dialogueBoxIG", "dialogueBoxIG", 0, 1.2, "linear")

                    canPressShit = false
                end
                if lineIndex == 9 then
                    playSound("dialogue/dialogue fucking clicking sound", 1, "idk")
                    doTweenAlpha("dialogueFadeA", "dialogueFade", 1, 1.2, "linear")
                    canPressShit = false
                else
                    if lineIndex <= #dialogueLines then
                        playSound("dialogue/dialogue fucking clicking sound", 1, "idk")
                        stopSound("yea")
                        medialogingsobad(dialogueLines[lineIndex])
                    else
                    end
                end
            end
        end
    end
end

function onSoundFinished(tag)
    if tag == 'phone' then
        playSound("phone-call", 1, "phone")
    end
    if tag == 'tabi' then
        playSound("tabi-theme", 1, "tabi")
    end
end

function onTweenCompleted(tag, vars)
    if tag == 'dialogueFadeA' then
        doTweenAlpha("dialogueFade", "dialogueFade", 0, 1.2, "linear")
        playSound("dialogue/dialogue fucking clicking sound", 1, "idk")
        stopSound("yea")
        medialogingsobad(dialogueLines[lineIndex])
        scaleObject("dialogueImage", 0.67, 0.67)
        screenCenter("dialogueImage")
        canPressShit = true
    end
    if tag == 'dialogueFadeTalkA' then
        closeCustomSubstate()
        stopSound("tabi")
    end
end

function medialogingsobad(line)
    local splitLine = stringSplit(line, ": ")
    local char = splitLine[1] or "empty"
    local text = splitLine[2] or ""
    local sound = splitLine[3] or ""
    local image = splitLine[4] or ""
    local charstyle = splitLine[5] or ""

    if char == "BFPHONE" then
        setTextString("dialogueChar", "BF")
        setTextFont("dialogueTextIG", "Graffiti City.otf")
        setTextFont("dialogueChar", "Graffiti City.otf")
        setProperty("dialogueBoxIG.flipX", false)
        setProperty("dialogueBoxIG.x", 520)
        setProperty("dialogueTextIG.x", 670)
        setProperty("dialogueTextIG.angle", -2)

        setProperty("dialogueChar.x", 1070)
        setProperty("dialogueChar.y", 460)
        setProperty("dialogueChar.angle", -2)
    elseif char == "GFPHONE" then
        setTextString("dialogueChar", "GF")
        setTextFont("dialogueTextIG", "Restaurant.otf")
        setTextFont("dialogueChar", "Restaurant.otf")
        setProperty("dialogueBoxIG.flipX", true)
        setProperty("dialogueBoxIG.x", 50)
        setProperty("dialogueTextIG.x", 150)
        setProperty("dialogueTextIG.angle", 2)

        setProperty("dialogueChar.x", 180)
        setProperty("dialogueChar.y", 475)
        setProperty("dialogueChar.angle", 2)
    elseif char == "GF" then
        setTextString("dialogueChar", "GF")
        setTextFont("dialogueTextIG", "Restaurant.otf")
        setTextFont("dialogueChar", "Restaurant.otf")
        setProperty("dialogueBoxIG.flipX", false)
        setProperty("dialogueBoxIG.x", 520)
        setProperty("dialogueTextIG.x", 670)
        setProperty("dialogueTextIG.angle", -2)

        setProperty("GFTALK.alpha", 1)
        setProperty("BFTALK.alpha", 0)
        setProperty("TABITALK.alpha", 0)

        setProperty("dialogueChar.x", 1070)
        setProperty("dialogueChar.y", 460)
        setProperty("dialogueChar.angle", -2)
    elseif char == "BF" then
        setTextString("dialogueChar", "BF")
        setTextFont("dialogueTextIG", "Graffiti City.otf")
        setTextFont("dialogueChar", "Graffiti City.otf")
        setProperty("dialogueBoxIG.flipX", true)
        setProperty("dialogueBoxIG.x", 50)
        setProperty("dialogueTextIG.x", 150)
        setProperty("dialogueTextIG.angle", 2)

        setProperty("GFTALK.alpha", 0)
        setProperty("BFTALK.alpha", 1)
        setProperty("TABITALK.alpha", 0)


        setProperty("dialogueChar.x", 180)
        setProperty("dialogueChar.y", 475)
        setProperty("dialogueChar.angle", 2)
    elseif char == "Tabi" then
        setProperty("GFTALK.alpha", 0)
        setProperty("BFTALK.alpha", 0)
        setProperty("TABITALK.alpha", 1)

        setProperty("dialogueBoxIG.flipX", false)
        setProperty("dialogueBoxIG.x", 520)
        setProperty("dialogueTextIG.x", 670)
        setProperty("dialogueTextIG.angle", -2)

        setTextString("dialogueChar", "Tabi")
        setTextFont("dialogueTextIG", "Russian Angel.ttf")
        setTextFont("dialogueChar", "Russian Angel.ttf")

        setProperty("dialogueChar.x", 1065)
        setProperty("dialogueChar.y", 455)
        setProperty("dialogueChar.angle", -2)
    elseif char == "empty" then
        setTextFont("dialogueTextIG", "null")
        setTextFont("dialogueChar", "null")
    end

    if sound ~= "" then
        playSound(sound, 1, "yea")
    end

    if charstyle ~= "" then
        loadGraphic("BFTALK", "dialogue/characters/bf/" .. charstyle)
        loadGraphic("GFTALK", "dialogue/characters/gf/" .. charstyle)
        loadGraphic("TABITALK", "dialogue/characters/tabi/" .. charstyle)
    end


    if image ~= "" then
        loadGraphic("dialogueImage", "dialogue/panels/" .. image)
        setProperty("dialogueImage.alpha", 1)
        if lineIndex == 6 then
            scaleObject("dialogueImage", 1.3, 1.45)
            screenCenter("dialogueImage")
        elseif lineIndex == 7 then
            scaleObject("dialogueImage", 0.92, 1)
            screenCenter("dialogueImage")
        elseif lineIndex == 8 then
            scaleObject("dialogueImage", 1.3, 1.45)
            screenCenter("dialogueImage")
        end
    end

    writeText(text)
end

function writeText(text)
    textindex = 1
    currentText = text
    setTextString('dialogueTextIG', string.sub(currentText, 1, textindex))
    runTimer('imtypingit', 0.05, string.len(text))
end

function onTimerCompleted(tag, loops, loopsLeft)
    if tag == 'imtypingit' then
        setTextString('dialogueTextIG', string.sub(currentText, 1, textindex))
        textindex = textindex + 1
    end
end

function loadingdialogueshahaohhitil()
    local songName = songName or "unknown"
    local linePath = "data/" .. songName .. "/cutsceneLines.txt"

    if checkFileExists(linePath) then
        local file = getTextFromFile(linePath)
        for line in string.gmatch(file, "[^\r\n]+") do
            table.insert(dialogueLines, line)
        end
    else
        debugPrint("bro cutscene txt not founded bro are u serious rn dude?")
    end
end
