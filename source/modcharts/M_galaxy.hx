package modcharts;

import backend.data.Song.SwagSong;
import Std;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxStrip;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import haxe.Exception;
import openfl.Lib;
import openfl.system.Capabilities;

using StringTools;

class M_galaxy
{
	public static function updateNotePosition(note:Note, strumLine:FlxSprite)
	{
		if ((note.strumTime > 12387 && note.strumTime < 24581)
			|| (note.strumTime > 38709 && note.strumTime < 41613)
			|| (!note.isSustainNote
				&& note.strumTime > 49548
				&& note.strumTime < 74232
				&& Std.int(FlxMath.roundDecimal((note.strumTime - 49548.387096774226) / 193.548387097, 0)) % 2 == 1)
			|| (Std.int(note.strumTime) == 81677 || Std.int(note.strumTime) == 83225)
			|| (note.strumTime > 84387 && note.strumTime < 84968)
			|| (note.strumTime > 85935 && note.strumTime < 86517)
			|| (note.strumTime > 99096 && note.strumTime < 111291))
		{
			if (FlxG.save.data.downscroll)
				note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(0.8, 2)));
			else
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(0.8, 2)));
		}
		else if ((note.strumTime > 37161 && note.strumTime < 38517) || (note.strumTime > 41806 && note.strumTime < 43162))
		{
			if (FlxG.save.data.downscroll)
				note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(2, 2)));
			else
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(2, 2)));
		}
		else if ((note.strumTime > 43354 && note.strumTime < 49355)
			|| (note.strumTime > 74322 && note.strumTime < 77226)
			|| (note.strumTime > 77419 && note.strumTime < 78774 && !note.mustPress)
			|| (note.strumTime > 78967 && note.strumTime < 80323 && note.mustPress))
		{
			if (FlxG.save.data.downscroll)
			{
				if (Conductor.songPosition >= note.strumTime)
					note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = (strumLine.y - (0.9 * (Conductor.songPosition - note.strumTime) * (Conductor.songPosition - note.strumTime) / 1000));
			}
			else
			{
				if (Conductor.songPosition >= note.strumTime)
					note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = (strumLine.y + (0.9 * (Conductor.songPosition - note.strumTime) * (Conductor.songPosition - note.strumTime) / 1000));
			}
		}
		else
		{
			if (FlxG.save.data.downscroll)
				note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
	}
}
