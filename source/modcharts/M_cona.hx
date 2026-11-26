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

class M_cona
{
	public static function updateNotePosition(note:Note, strumLine:FlxSprite)
	{
		if (note.strumTime >= 15000 && note.strumTime < 21562)
		{
			if (Conductor.songPosition < 15000)
			{
				if (FlxG.save.data.downscroll)
					note.y = (strumLine.y
						+ (15000 - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)))
						+ (Conductor.songPosition - 15000) * (ModchartMath.scrollSpeed());
				else
					note.y = (strumLine.y
						- (15000 - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)))
						- (Conductor.songPosition - 15000) * (ModchartMath.scrollSpeed());
			}
			else
			{
				if (FlxG.save.data.downscroll)
					note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
				else
					note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
			}
			if (note.isSustainNote && note.animation.curAnim.name.endsWith('hold'))
			{
				note.scale.y = 0.7 * Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed / 1.5;
				note.updateHitbox();
			}
		}
		else if (note.strumTime >= 22500 && note.strumTime < 26016)
		{
			if (Conductor.songPosition < 22500)
			{
				if (FlxG.save.data.downscroll)
					note.y = (strumLine.y
						+ (22500 - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)))
						+ (Conductor.songPosition - 22500) * (ModchartMath.scrollSpeed());
				else
					note.y = (strumLine.y
						- (22500 - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)))
						- (Conductor.songPosition - 22500) * (ModchartMath.scrollSpeed());
			}
			else
			{
				if (FlxG.save.data.downscroll)
					note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
				else
					note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
			}
			if (note.isSustainNote && note.animation.curAnim.name.endsWith('hold'))
			{
				note.scale.y = 0.7 * Conductor.stepCrochet / 100 * 1.5 * PlayState.SONG.speed / 1.5;
				note.updateHitbox();
			}
		}
		else if ((note.strumTime >= 45000 && note.strumTime < 59766)
			|| (note.strumTime >= 45000 && note.strumTime < 65625.0 && note.mustPress))
		{
			if (FlxG.save.data.downscroll)
				note.y = (PlayMoving.receptorY[note.noteData]
					+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (PlayMoving.receptorY[note.noteData]
					- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		else if (note.strumTime >= 60000 && note.strumTime < 74766)
		{
			applyNotesFrom60000(note, strumLine);
		}
		else if (note.strumTime >= 90000 && note.strumTime < 120000)
		{
			applyNotesFrom90000(note, strumLine);
		}
		else if (note.strumTime >= 120000)
		{
			if (note.mustPress)
			{
				note.x = PlayMoving.playerReceptorX[note.noteData];
				if (FlxG.save.data.downscroll)
					note.y = (PlayMoving.receptorY[0] + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = (PlayMoving.receptorY[0] - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				if (note.isSustainNote)
					note.x += note.width;
			}
			else
			{
				note.x = PlayMoving.opponentReceptorX[note.noteData];
				if (FlxG.save.data.downscroll)
					note.y = (PlayMoving.receptorY[1] - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = (PlayMoving.receptorY[1] + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				if (note.isSustainNote)
					note.x += note.width;
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

	public static function updateReceptorPosition(receptor:NoteStrum, strumLine:FlxSprite)
	{
		if (Conductor.songPosition >= 30000 && Conductor.songPosition < 45000)
		{
			if (FlxG.save.data.downscroll)
			{
				if (Std.int((Conductor.songPosition - 30000) / 937.5) % 2 == 0)
					receptor.y = 550 - ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
				else
					receptor.y = 350 + ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
			}
			else
			{
				if (Std.int((Conductor.songPosition - 30000) / 937.5) % 2 == 0)
					receptor.y = 50 + ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
				else
					receptor.y = 250 - ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
			}
			strumLine.y = receptor.y;
		}
		else if (Conductor.songPosition >= 45000 && Conductor.songPosition < 59531.25)
		{
			applyStrumsFrom45000(receptor, strumLine);
		}
		else if (Conductor.songPosition >= 59531.25 && Conductor.songPosition < 73125)
		{
			applyStrumsFrom59531(receptor, strumLine);
		}
		else if (Conductor.songPosition >= 74531.25 && Conductor.songPosition < 75468.75)
		{
			if (Conductor.songPosition < 75000.0)
			{
				if (receptor.x < 640)
				{
					receptor.x = 218 - (Conductor.songPosition - 74531.25) / 468.75 * (218 - PlayMoving.defaultOpponentReceptorX[receptor.ID]);
					if (FlxG.save.data.downscroll)
						receptor.y = 300 + (Conductor.songPosition - 74531.25) / 468.75 * 250;
					else
						receptor.y = 300 - (Conductor.songPosition - 74531.25) / 468.75 * 250;
				}
			}
			else if (Conductor.songPosition >= 75000.0 && Conductor.songPosition < 75468.75)
			{
				if (receptor.x > 640)
				{
					receptor.x = 858 + (Conductor.songPosition - 75000.0) / 468.75 * (PlayMoving.defaultPlayerReceptorX[receptor.ID] - 858);
					if (FlxG.save.data.downscroll)
						receptor.y = 300 + (Conductor.songPosition - 75000.0) / 468.75 * 250;
					else
						receptor.y = 300 - (Conductor.songPosition - 75000.0) / 468.75 * 250;
				}
			}
		}
		else if (Conductor.songPosition >= 89531.25 && Conductor.songPosition < 90000)
		{
			if (receptor.x < 640)
			{
				if (FlxG.save.data.downscroll)
					receptor.y = 550 - (Conductor.songPosition - 89531.25) / 468.75 * 500;
				else
					receptor.y = 50 + (Conductor.songPosition - 89531.25) / 468.75 * 500;
			}
		}
		else if (Conductor.songPosition >= 90000 && Conductor.songPosition < 120000)
		{
			applyStrumsFrom90000(receptor, strumLine);
		}
		else if (Conductor.songPosition >= 120000 && Conductor.songPosition < 120937.5)
		{
			if (receptor.x > 472 + receptor.ID * 112)
			{
				receptor.x = PlayMoving.defaultPlayerReceptorX[receptor.ID]
					+ ((Conductor.songPosition - 120000) % 937.5) / 937.5 * (472 + receptor.ID * 112 - PlayMoving.defaultPlayerReceptorX[receptor.ID]);
				if (FlxG.save.data.downscroll)
					receptor.y = 550 - ((Conductor.songPosition - 120000) % 937.5) / 937.5 * 250;
				else
					receptor.y = 50 + ((Conductor.songPosition - 120000) % 937.5) / 937.5 * 250;
				PlayMoving.receptorY[0] = receptor.y;
				PlayMoving.playerReceptorX[receptor.ID] = receptor.x;
			}
			else
			{
				receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID]
					+ ((Conductor.songPosition - 120000) % 937.5) / 937.5 * (472 + receptor.ID * 112 - PlayMoving.defaultOpponentReceptorX[receptor.ID]);
				if (FlxG.save.data.downscroll)
					receptor.y = 50 + ((Conductor.songPosition - 120000) % 937.5) / 937.5 * 250;
				else
					receptor.y = 550 - ((Conductor.songPosition - 120000) % 937.5) / 937.5 * 250;
				PlayMoving.receptorY[1] = receptor.y;
				PlayMoving.opponentReceptorX[receptor.ID] = receptor.x;
			}
		}
		else if (Conductor.songPosition >= 120937.5)
		{
			receptor.x = 472 + receptor.ID * 112;
			receptor.y = 300;
			PlayMoving.receptorY[0] = receptor.y;
			PlayMoving.playerReceptorX[receptor.ID] = receptor.x;
			PlayMoving.receptorY[1] = receptor.y;
			PlayMoving.opponentReceptorX[receptor.ID] = receptor.x;
		}
	}

	inline static public function shouldRemoveNote(note:Note):Bool
	{
		if (note.strumTime >= 60000 && note.strumTime < 74766)
			return ((note.x < -note.width)
				|| (note.x > FlxG.width)
				|| (note.y < -note.height)
				|| (note.y > FlxG.height)
				|| (note.alpha <= 0))
				&& Conductor.songPosition > note.strumTime;
		else if (note.strumTime >= 90000)
			return ((note.y < -note.height) || (note.y > FlxG.height)) && note.tooLate;
		else
		{
			if (FlxG.save.data.downscroll)
				return note.y > FlxG.height;
			else
				return note.y < -note.height;
		}
	}

	inline static public function updateSustainDirection(note:Note, strumLine:FlxSprite)
	{
		if (note.strumTime >= 90000 && note.strumTime < 120000)
		{
			if (FlxG.save.data.downscroll)
			{
				if ((Std.int((note.strumTime - 90000) / 7500) % 2 == 0 && note.mustPress)
					|| Std.int((note.strumTime - 90000) / 7500) % 2 == 1
					&& !note.mustPress)
				{
					note.angle = 180;
					return 1;
				}
				else
				{
					note.angle = 0;
					return 2;
				}
			}
			else
			{
				if ((Std.int((note.strumTime - 90000) / 7500) % 2 == 0 && note.mustPress)
					|| Std.int((note.strumTime - 90000) / 7500) % 2 == 1
					&& !note.mustPress)
				{
					note.angle = 0;
					return 2;
				}
				else
				{
					note.angle = 180;
					return 1;
				}
			}
		}
		else if (note.strumTime > 120000)
		{
			if (FlxG.save.data.downscroll)
			{
				if (note.mustPress)
				{
					note.angle = 180;
					return 1;
				}
				else
				{
					note.angle = 0;
					return 2;
				}
			}
			else
			{
				if (note.mustPress)
				{
					note.angle = 0;
					return 2;
				}
				else
				{
					note.angle = 180;
					return 1;
				}
			}
		}
		else
		{
			if (FlxG.save.data.downscroll)
			{
				note.angle = 180;
				return 1;
			}
			else
			{
				note.angle = 0;
				return 2;
			}
		}
	}

	inline static public function getSustainClipPosition(note:Note, strumLine:FlxSprite)
	{
		if ((note.strumTime >= 45000 && note.strumTime < 59766)
			|| (note.strumTime >= 45000 && note.strumTime < 65625.0 && note.mustPress))
			return PlayMoving.receptorY[note.noteData];
		else if (note.strumTime >= 90000)
		{
			if (note.mustPress)
				return PlayMoving.receptorY[0];
			else
				return PlayMoving.receptorY[1];
		}
		else
			return strumLine.y;
	}
	static function applyNotesFrom60000(note:Note, strumLine:FlxSprite):Void
	{
		if (!note.mustPress)
		{
			switch (note.noteData)
			{
				case 0:
					note.x = (218 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
					note.y = 300;
					if (note.x > 500)
						note.alpha = (550 - note.x) / 50;
					else
						note.alpha = 1;
				case 1:
					note.x = 218;
					note.y = (300 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				case 2:
					note.x = 218;
					note.y = (300 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				case 3:
					note.x = (218 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
					note.y = 300;
					if (note.x > 500)
						note.alpha = (550 - note.x) / 50;
					else
						note.alpha = 1;
			}
		}
		else
		{
			switch (note.noteData)
			{
				case 0:
					note.x = (858 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
					note.y = 300;
					if (note.x < 570)
						note.alpha = (note.x - 520) / 50;
					else
						note.alpha = 1;
				case 1:
					note.x = 858;
					note.y = (300 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				case 2:
					note.x = 858;
					note.y = (300 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				case 3:
					note.x = (858 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
					note.y = 300;
					if (note.x < 570)
						note.alpha = (note.x - 520) / 50;
					else
						note.alpha = 1;
			}
		}
	}

	static function applyNotesFrom90000(note:Note, strumLine:FlxSprite):Void
	{
		if (FlxG.save.data.downscroll)
		{
			if ((Std.int((note.strumTime - 90000) / 7500) % 2 == 0 && note.mustPress)
				|| Std.int((note.strumTime - 90000) / 7500) % 2 == 1
				&& !note.mustPress)
			{
				if (note.mustPress)
					note.y = (PlayMoving.receptorY[0]
						+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = (PlayMoving.receptorY[1]
						+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			}
			else
			{
				if (note.mustPress)
					note.y = (PlayMoving.receptorY[0]
						- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = (PlayMoving.receptorY[1]
						- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			}
		}
		else
		{
			if ((Std.int((note.strumTime - 90000) / 7500) % 2 == 0 && note.mustPress)
				|| Std.int((note.strumTime - 90000) / 7500) % 2 == 1
				&& !note.mustPress)
			{
				if (note.mustPress)
					note.y = (PlayMoving.receptorY[0]
						- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = (PlayMoving.receptorY[1]
						- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			}
			else
			{
				if (note.mustPress)
					note.y = (PlayMoving.receptorY[0]
						+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = (PlayMoving.receptorY[1]
						+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			}
		}
	}

	static function applyStrumsFrom45000(receptor:NoteStrum, strumLine:FlxSprite):Void
	{
		switch (Std.int((Conductor.songPosition - 30000) / 937.5) % 4)
		{
			case 0:
				if (receptor.ID % 2 == 0)
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 550 - ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
					else
						receptor.y = 50 + ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
				}
			case 1:
				if (receptor.ID % 2 == 0)
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 350 + ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
					else
						receptor.y = 250 - ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
				}
			case 2:
				if (receptor.ID % 2 == 1)
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 550 - ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
					else
						receptor.y = 50 + ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
				}
			case 3:
				if (receptor.ID % 2 == 1)
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 350 + ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
					else
						receptor.y = 250 - ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
				}
		}
		PlayMoving.receptorY[receptor.ID] = receptor.y;
	}

	static function applyStrumsFrom59531(receptor:NoteStrum, strumLine:FlxSprite):Void
	{
		if (Conductor.songPosition < 60000.0)
		{
			if (receptor.x > 640)
			{
				if (receptor.ID % 2 == 1)
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 350 + ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
					else
						receptor.y = 250 - ((Conductor.songPosition - 30000) % 937.5) / 937.5 * 200;
				}
				PlayMoving.receptorY[receptor.ID] = receptor.y;
			}
			else
			{
				receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID] - (Conductor.songPosition - 59531.25) / 468.75 * (PlayMoving.defaultOpponentReceptorX[receptor.ID] - 218);
				if (FlxG.save.data.downscroll)
					receptor.y = 550 - (Conductor.songPosition - 59531.25) / 468.75 * 250;
				else
					receptor.y = 50 + (Conductor.songPosition - 59531.25) / 468.75 * 250;
			}
		}
		else if (Conductor.songPosition >= 63750.0 && Conductor.songPosition < 64218.75)
		{
			if (receptor.x > 640)
			{
				receptor.x = PlayMoving.defaultPlayerReceptorX[receptor.ID] - (Conductor.songPosition - 63750.0) / 468.75 * (PlayMoving.defaultPlayerReceptorX[receptor.ID] - 858);
				if (FlxG.save.data.downscroll)
					receptor.y = 550 - (Conductor.songPosition - 63750.0) / 468.75 * 250;
				else
					receptor.y = 50 + (Conductor.songPosition - 63750.0) / 468.75 * 250;
			}
		}
	}

	static function applyStrumsFrom90000(receptor:NoteStrum, strumLine:FlxSprite):Void
	{
		if (FlxG.save.data.downscroll)
		{
			if ((Std.int((Conductor.songPosition - 90000) / 7500) % 2 == 0 && receptor.x > 640)
				|| Std.int((Conductor.songPosition - 90000) / 7500) % 2 == 1
				&& receptor.x < 640)
			{
				if (Std.int((Conductor.songPosition - 90000) / 937.5) % 8 > 5)
					receptor.y = 550 - ((Conductor.songPosition - 90000) % 1875) / 1875 * 500;
				else if (Std.int((Conductor.songPosition - 90000) / 937.5) % 2 == 0)
					receptor.y = 550 - ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
				else
					receptor.y = 350 + ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
			}
			else
			{
				if (Std.int((Conductor.songPosition - 90000) / 937.5) % 8 > 5)
					receptor.y = 50 + ((Conductor.songPosition - 90000) % 1875) / 1875 * 500;
				else if (Std.int((Conductor.songPosition - 90000) / 937.5) % 2 == 0)
					receptor.y = 50 + ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
				else
					receptor.y = 250 - ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
			}
		}
		else
		{
			if ((Std.int((Conductor.songPosition - 90000) / 7500) % 2 == 0 && receptor.x > 640)
				|| Std.int((Conductor.songPosition - 90000) / 7500) % 2 == 1
				&& receptor.x < 640)
			{
				if (Std.int((Conductor.songPosition - 90000) / 937.5) % 8 > 5)
					receptor.y = 50 + ((Conductor.songPosition - 90000) % 1875) / 1875 * 500;
				else if (Std.int((Conductor.songPosition - 90000) / 937.5) % 2 == 0)
					receptor.y = 50 + ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
				else
					receptor.y = 250 - ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
			}
			else
			{
				if (Std.int((Conductor.songPosition - 90000) / 937.5) % 8 > 5)
					receptor.y = 550 - ((Conductor.songPosition - 90000) % 1875) / 1875 * 500;
				else if (Std.int((Conductor.songPosition - 90000) / 937.5) % 2 == 0)
					receptor.y = 550 - ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
				else
					receptor.y = 350 + ((Conductor.songPosition - 90000) % 937.5) / 937.5 * 200;
			}
		}
		if (receptor.x < 640)
			PlayMoving.receptorY[1] = receptor.y;
		else
			PlayMoving.receptorY[0] = receptor.y;
	}

}
