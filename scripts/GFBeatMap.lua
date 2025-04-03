local gfBeatMap = {
	{0, 1},
	{1, 1},
	{2, 2},
	{4, 2},
	{8, 2}
};

function onEvent(name, value1, value2)
    if name == 'Camera Modulo Change' then
        local beatThign = 1;

		local value1Float = tonumber(value1);
		for i=1,#gfBeatMap do
			if value1Float == gfBeatMap[i][1] then
				beatThign = gfBeatMap[i][2];
			end
		end

		triggerEvent("Set GF Speed", tostring(beatThign), "")
    end
end