local pause = false
local curSelect = 1
local arts = {
    ["my-battle"] = "tabi",
    ["last-chance"] = "tabi",
    ["genocide"] = "tabi-fire"
}

local buttons = {"resume", "retry", "options", "exit"}
local songnames = {"my-battle", "last-chance", "genocide"} -- idk
local allobject = {"resume", "retry", "options", "exit", "songName", "pausebg", "bgOverlayingLay", "art", "fade"}

function onCreate()
    precacheImage("pause/bg")
    precacheImage("pause/bg-overlay")

    precacheImage("pause/resume")
    precacheImage("pause/retry")
    precacheImage("pause/options")
    precacheImage("pause/exit")

    precacheImage("pause/arts/tabi")
    precacheImage("pause/arts/tabi-fire")

    precacheImage("pause/names/my-battle")
    precacheImage("pause/names/last-chance")
    precacheImage("pause/names/genocide")


    precacheSound('scrollMenu')
    precacheSound('clickText')
end

function onPause()
    openCustomSubstate('TabiPause', true); -- PAUSES THE GAME
    return Function_Stop;
end

function onCustomSubstateCreate(name) -- ON CREATE BUT WHEN YOU PAUSE THE GAME EVERYTIME
    if name == 'TabiPause' then

    end
end

function onCustomSubstateCreatePost(name) -- ON CREATEpost BUT WHEN YOU PAUSE THE GAME EVERYTIME
    if name == 'TabiPause' then
        pause = true
        playSound("scrollMenu", 1)
        playSound("breakfast", 0, "music")
        soundFadeIn("music", 2, 0, 0.8)

        makeLuaSprite('fade', nil, 0, 0)
        makeGraphic("fade", screenWidth, screenHeight, 'black')
        setObjectCamera('fade', 'other')
        screenCenter('fade', 'xy')
        addLuaSprite('fade', true)
        setObjectOrder("fade", 7)
        setProperty('fade.alpha', 0)
        doTweenAlpha("fade", "fade", 0.6, 0.4, 'quartInOut')

        makeLuaSprite("bgOverlayingLay", "pause/bg-overlay", 0,0)
        setObjectCamera("bgOverlayingLay", 'other')
        addLuaSprite("bgOverlayingLay", false)
        setProperty('bgOverlayingLay.alpha', 0.5)
        setObjectOrder("bgOverlayingLay", 7)

        makeLuaSprite("art", "pause/arts/tabi", -300,70) -- 50
        setObjectCamera("art", 'other')
        addLuaSprite("art", false)
        setProperty('art.alpha', 0)
        setObjectOrder("art", 10)
        doTweenAlpha("arta", "art", 1, 1.5, "quartOut")

        makeLuaSprite("pausebg", "pause/bg", 0,0)
        setObjectCamera("pausebg", 'other')
        addLuaSprite("pausebg", false)
        scaleObject("pausebg", 1.02, 1.02)
        setProperty('pausebg.alpha', 1)
        setObjectOrder("pausebg", 11)

        local songID = callMethodFromClass('backend.Paths', 'formatToSongPath', {songName});

        makeLuaSprite("songName", "pause/names/" .. songID, 100,630)
        setObjectCamera("songName", 'other')
        addLuaSprite("songName", false)
        setProperty('songName.alpha', 1)
        setObjectOrder("songName", 12)
        if songID == "genocide" then
            setProperty("songName.x", 110)
        end

        if songID == "my-battle" or songID == "last-chance" then
            loadGraphic("art", "pause/arts/tabi")
            doTweenX("artx", "art", -50, 1.5, "quartOut")
            scaleObject("art", 0.3, 0.3)
        elseif songID == "genocide" then
            setProperty("art.x", -700)
            setProperty("art.y", -70)
            scaleObject("art", 0.35, 0.35)
            loadGraphic("art", "pause/arts/tabi-fire")
            doTweenX("artx", "art", -120, 1.5, "quartOut")
            
        end

        for i, button in ipairs(buttons) do
            makeLuaSprite(button, "pause/"..button, 10, 0)
            setObjectCamera(button, 'other')
            setObjectOrder(button, 13)
            addLuaSprite(button, true)
            setProperty(button..".alpha", 0.5)
        end
        setProperty("resume.alpha", 1)

    end
end

function onCustomSubstateUpdatePost(name, elapsed) -- ON UPDATE POST BUT WHEN PAUSES
    if name == 'TabiPause' then
        if keyJustPressed('accept') then
            if curSelect == 1 then
                pause = false
                closeCustomSubstate();
                stopSound("music")
                for i, bye in ipairs(allobject) do
                    removeLuaSprite(bye, false)
                end
            elseif curSelect == 2 then
                restartSong(false)
            elseif curSelect == 3 then
                runHaxeCode([[
                import options.OptionsState;
                import backend.MusicBeatState;
                game.paused = true;
                game.vocals.volume = 0;
                MusicBeatState.switchState(new OptionsState());
                if (ClientPrefs.data.pauseMusic != 'None') {
                    FlxG.sound.playMusic(Paths.music("freakyMenu"), game.modchartSounds('pauseMusic').volume);
                    FlxTween.tween(FlxG.sound.music, {volume: 1}, 0.8);
                    FlxG.sound.music.time = game.modchartSounds('pauseMusic').time;
                }
                OptionsState.onPlayState = true;
                ]])
            elseif curSelect == 4 then
                exitSong()
            end
        end
        if keyJustPressed("down") then
            if pause then
                if curSelect < 4 then
                    playSound("scrollMenu")
                    curSelect = curSelect + 1
                else
                    playSound("scrollMenu")
                    curSelect = 1
                end
                buttonCheck()
            end
        end
        
        if keyJustPressed("up") then
            if pause then
                if curSelect > 1 then
                    playSound("scrollMenu")
                    curSelect = curSelect - 1
                else
                    playSound("scrollMenu")
                    curSelect = 4
                end
                buttonCheck()
            end
        end
    end
end

function onSoundFinished(tag)
    if tag == 'music' then
        playSound("breakfast", 0.8, "music")
    end
end

function buttonCheck()
    if curSelect == 1 then
        setProperty("resume.alpha", 1)
        setProperty("retry.alpha", 0.5)
        setProperty("options.alpha", 0.5)
        setProperty("exit.alpha", 0.5)
    elseif curSelect == 2 then
        setProperty("resume.alpha", 0.5)
        setProperty("retry.alpha", 1)
        setProperty("options.alpha", 0.5)
        setProperty("exit.alpha", 0.5)
    elseif curSelect == 3 then
        setProperty("resume.alpha", 0.5)
        setProperty("retry.alpha", 0.5)
        setProperty("options.alpha", 1)
        setProperty("exit.alpha", 0.5)
    elseif curSelect == 4 then
        setProperty("resume.alpha", 0.5)
        setProperty("retry.alpha", 0.5)
        setProperty("options.alpha", 0.5)
        setProperty("exit.alpha", 1)
    end
end

function onCustomSubstateDestroy(name)

end
