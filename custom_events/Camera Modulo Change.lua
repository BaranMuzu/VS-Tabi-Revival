local interval = 4
local stength = nil

function onEvent(name, value1, value2)
    if name == 'Camera Modulo Change' then
        interval = tonumber(value1)
        stength = tonumber(value2)

        if interval == 0 or interval == 1 then
            triggerEvent("Set GF Speed", "1", "")
        elseif interval == 2 or interval == 4 or interval == 8 then
            triggerEvent("Set GF Speed", "2", "")
        else
            triggerEvent("Set GF Speed", "1", "")
        end
    end
end


local didBump = true
function onBeatHit()
    didBump = false
    if stength == nil then
        if curBeat % interval == 0 and getProperty('camZooming') then
            triggerEvent('Add Camera Zoom', 0.015 * getProperty('camZoomingMult'), 0.03 * getProperty('camZoomingMult'))
        end
    else
        if curBeat % interval == 0 and getProperty('camZooming') then
            triggerEvent('Add Camera Zoom', 0.015 * stength * getProperty('camZoomingMult'), 0.03 * stength * getProperty('camZoomingMult'))
        end
    end
end

function onSectionHit()
    if interval ~= 0 and getProperty('camZooming') then
        -- it adds a bump every new section
        triggerEvent('Add Camera Zoom', -(0.015 * getProperty('camZoomingMult')), -(0.03 * getProperty('camZoomingMult')));
    end
end
