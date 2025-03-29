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


        makeLuaSprite("dialogueBoxIG", "dialogue/box", 520, 400)
        setObjectCamera("dialogueBoxIG", "other")
        setObjectOrder("dialogueBoxIG", 5)
        addLuaSprite("dialogueBoxIG")

        makeLuaText("dialogueTextIG", "", 450, 670, 530)
        setObjectCamera("dialogueTextIG", "other")
        setObjectOrder("dialogueTextIG", 7)
        setTextFont("dialogueTextIG", "null")
        setTextSize("dialogueTextIG", 32)
        setTextAlignment("dialogueTextIG", 'left')
        setProperty("dialogueTextIG.angle", -2)
        addLuaText("dialogueTextIG")

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
                end
                if lineIndex <= #dialogueLines then
                    playSound("dialogue/dialogue fucking clicking sound", 1, "idk")
                    stopSound("yea")
                    medialogingsobad(dialogueLines[lineIndex])
                else
                    closeCustomSubstate()
                    doTweenAlpha("camGAME", "camGame", 1, 1.0, "linear")
                    doTweenAlpha("camHUD", "camHUD", 1, 1.0, "linear")
                end
            end
        end
    end    
end

function medialogingsobad(line)
    local splitLine = stringSplit(line, ": ")
    local char = splitLine[1] or "empty"
    local text = splitLine[2] or ""
    local sound = splitLine[3] or ""
    
    if char == "BFPHONE" then
        setTextFont("dialogueTextIG", "Graffiti City.otf")
        setProperty("dialogueBoxIG.flipX", false)
        setProperty("dialogueBoxIG.x", 520)
        setProperty("dialogueTextIG.x", 670)
        setProperty("dialogueTextIG.angle", -2)
    elseif char == "GFPHONE" then
        setTextFont("dialogueTextIG", "Restaurant.otf")
        setProperty("dialogueBoxIG.flipX", true)
        setProperty("dialogueBoxIG.x", 20)
        setProperty("dialogueTextIG.x", 120)
        setProperty("dialogueTextIG.angle", 2)
    elseif char == "Tabi" then
        setTextFont("dialogueTextIG", "Russian Angel.ttf")
    elseif char == "empty" then
        setTextFont("dialogueTextIG", "null")
    end

    if sound ~= "" then
        playSound(sound, 1, "yea")
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
