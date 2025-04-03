// ADDS THE FUNCTIONALITY OF MULTIPLE VOICE FILES TO PRE-0.7.3!!!

import backend.Paths;
import flixel.sound.FlxSound;
import states.MainMenuState;
import StringTools;
import Main;

var vocalsOpponent:FlxSound;
var dontDoAnything:Bool = false;

function onCreate()
{
	var songKey:String = Paths.formatToSongPath(PlayState.SONG.song) + '/Voices';
	var sound = Paths.returnSound('songs', songKey);

	if(sound != null && sound.length > 0)
		dontDoAnything = true;

	var versionsSupportSplitVocals:Array<String> = ['0.7.3', '1.0'];
	for(version in versionsSupportSplitVocals)
	{
		if(StringTools.startsWith(MainMenuState.psychEngineVersion, version))
			dontDoAnything = true;
	}

	// psych online is special :)
	if(Main.PSYCH_ONLINE_VERSION != null)
		dontDoAnything = true;

	if(dontDoAnything)
	{
		trace("Voices Helper is disabled!");
	}
}

function onStartCountdown()
{
	if(dontDoAnything)
		return;

	var songKeyPlayer:String = Paths.formatToSongPath(PlayState.SONG.song) + '/Voices-Player';
	var soundPlayer = Paths.returnSound('songs', songKeyPlayer);

	var songKeyOpponent:String = Paths.formatToSongPath(PlayState.SONG.song) + '/Voices-Opponent';
	var soundOpponent = Paths.returnSound('songs', songKeyOpponent);

	game.vocals = new FlxSound();
	game.vocals.loadEmbedded(soundPlayer);
	game.vocals.pitch = game.playbackRate;
	FlxG.sound.list.add(game.vocals);

	vocalsOpponent = new FlxSound();
	vocalsOpponent.loadEmbedded(soundOpponent);
	vocalsOpponent.pitch = game.playbackRate;
	FlxG.sound.list.add(vocalsOpponent);
}

function onUpdatePost()
{
	if(dontDoAnything)
		return;

	if(game.vocals != null && vocalsOpponent != null)
	{
		if(game.vocals.playing != vocalsOpponent.playing)
		{
			if(game.vocals.playing)
			{
				vocalsOpponent.play();
			}
			else
			{
				vocalsOpponent.stop();
			}
		}

		if(game.vocals._paused != vocalsOpponent._paused)
		{
			if(game.vocals._paused)
			{
				vocalsOpponent.pause();
			}
			else
			{
				vocalsOpponent.resume();
			}
		}

		if(game.vocals.pitch != vocalsOpponent.pitch)
		{
			vocalsOpponent.pitch = game.vocals.pitch;
		}

		if(game.vocals.time != vocalsOpponent.time)
		{
			vocalsOpponent.time = game.vocals.time;
		}
	}
}

var keepPlayerVocalQuiet:Bool = false;
function noteMiss(note:Note)
{
	if(dontDoAnything)
		return;

	keepPlayerVocalQuiet = true;
}

function opponentNoteMiss(note:Note)
{
	if(dontDoAnything)
		return;

	vocalsOpponent.volume = 0;
}

function goodNoteHit(note:Note)
{
	if(dontDoAnything)
		return;

	keepPlayerVocalQuiet = false;
}

function opponentNoteHit(note:Note)
{
	if(dontDoAnything)
		return;

	vocalsOpponent.volume = 1;

	if(keepPlayerVocalQuiet)
	{
		game.vocals.volume = 0;
	}
}