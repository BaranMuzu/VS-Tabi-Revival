function onCreate()
	initLuaShader('overlay');

	makeLuaSprite('bg', 'stages/restaurant/fire/bg', -1100, -550);
	scaleObject('bg', 0.825, 0.825, false);
	addLuaSprite('bg');

	makeAnimatedLuaSprite('backmostflames', 'stages/restaurant/fire/backmost flames', -483, -179);
	addAnimationByPrefix('backmostflames', 'anim', '');
	playAnim('backmostflames', 'anim');
	scaleObject('backmostflames', 1.3, 1.3, false);
	setProperty('backmostflames.alpha', 0.55);
	setSpriteShader('backmostflames', 'overlay');
	setProperty('backmostflames.blend', 0);
	addLuaSprite('backmostflames');

	if not lowQuality then
		makeLuaSprite('bg2', 'stages/restaurant/fire/tables', -1100, -550);
		scaleObject('bg2', 0.825, 0.825, false);
		addLuaSprite('bg2');

		makeLuaSprite('glow', 'stages/restaurant/fire/glow', -700, 500);
		setScrollFactor('glow', 0.1, 0.1);
		setProperty('glow.alpha', 0.75);
		setProperty('glow.blend', 0);
		addLuaSprite('glow', true);

		makeAnimatedLuaSprite('frontflameright', 'stages/restaurant/fire/front flame right', -820, 81);
		addAnimationByPrefix('frontflameright', 'anim', '');
		playAnim('frontflameright', 'anim');
		setScrollFactor('frontflameright', 1.3, 1.3);
		setProperty('frontflameright.alpha', 0.55);
		setSpriteShader('frontflameright', 'overlay');
		setProperty('frontflameright.blend', 0);
		addLuaSprite('frontflameright', true);

		makeAnimatedLuaSprite('frontflameleft', 'stages/restaurant/fire/front flame left', 1463, 125);
		addAnimationByPrefix('frontflameleft', 'anim', '');
		playAnim('frontflameleft', 'anim');
		setScrollFactor('frontflameleft', 1.3, 1.3);
		setProperty('frontflameleft.alpha', 0.55);
		setSpriteShader('frontflameleft', 'overlay');
		setProperty('frontflameleft.blend', 0);
		addLuaSprite('frontflameleft', true);
	end
end

function onCreatePost()
	makeLuaSprite('vignette', 'vignette', 0, 0);
	scaleObject('vignette', 1.1, 1.1, false);
	setObjectCamera('vignette', 'camHUD');
	setProperty('vignette.alpha', 0.4);
	setProperty('vignette.blend', 1);
	addLuaSprite('vignette', true);
end

function onUpdate(elapsed)
	setProperty('vignette.alpha', lerp(getProperty('vignette.alpha'), 0.4, 0.5 * 120 * elapsed));
end

function lerp(a, b, ratio)
	return a + ratio * (b - a);
end