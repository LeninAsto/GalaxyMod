package modcharts;

import backend.Conductor;
import flixel.math.FlxMath;
import states.PlayState;

class ModchartMath
{
	public static inline function scrollSpeed():Float
	{
		return 0.45 * FlxMath.roundDecimal(PlayState.SONG.speed, 2);
	}

	public static inline function sustainScale():Float
	{
		return Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed;
	}
}
