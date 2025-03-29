function onCreate()
	makeLuaSprite('bg', 'stages/restaurant/bg', -1100, -550);
	scaleObject('bg', 0.825, 0.825, false);
	addLuaSprite('bg');

	if not lowQuality then
		makeLuaSprite('chandelier', 'stages/restaurant/chandelier', 250, -400);
		setScrollFactor('chandelier', 1.05, 1.05);
		addLuaSprite('chandelier');

		makeLuaSprite('fg', 'stages/restaurant/fg', -800, 600);
		setScrollFactor('fg', 1.25, 1.25);
		setProperty('fg.alpha', 0.75);
		addLuaSprite('fg', true);
	end
end