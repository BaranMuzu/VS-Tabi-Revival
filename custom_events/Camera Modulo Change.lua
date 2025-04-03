local interval = 4
local stength = nil

function onCreate()
    setProperty('camZoomingMult', 0)
end

function onEvent(name, value1, value2)
    if name == 'Camera Modulo Change' then
        interval = tonumber(value1)
        stength = tonumber(value2)
    end
end


local didBump = true
function onBeatHit()
    didBump = false
    if stength == nil then
        if curBeat % interval == 0 and getProperty('camZooming') then
            triggerEvent('Add Camera Zoom', 0.015, 0.03)
        end
    else
        if curBeat % interval == 0 and getProperty('camZooming') then
            triggerEvent('Add Camera Zoom', 0.015 * stength, 0.03 * stength)
        end
    end
end
