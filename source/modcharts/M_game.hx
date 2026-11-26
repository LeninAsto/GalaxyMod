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

class M_game
{
	public static var rotationStep:Float = 0;
	public static var firstOpponentX:Float = 0;
	public static var firstPlayerX:Float = 0;

	public static function reset()
	{
		rotationStep = 0;
		firstOpponentX = 0;
		firstPlayerX = 0;
	}

	public static function updateNotePosition(note:Note, strumLine:FlxSprite)
	{
		if (note.strumTime > 122553)
		{
			if (note.mustPress)
				note.x = PlayMoving.playerReceptorX[note.noteData];
			else
				note.x = PlayMoving.opponentReceptorX[note.noteData];
			if (note.isSustainNote)
				note.x += note.width;
			if (FlxG.save.data.downscroll)
				note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(1.5, 2)));
			else
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(1.5, 2)));
			if (note.isSustainNote && note.animation.curAnim.name.endsWith('hold'))
			{
				note.scale.y = 0.7 * Conductor.stepCrochet / 100 * 1.5 * 1.5;
				note.updateHitbox();
			}
		}
		else if (Conductor.songPosition >= 95319.14893617031 && note.strumTime >= 95319 && note.strumTime < 122412)
		{
			if ((FlxG.save.data.downscroll && note.y <= strumLine.y)
				|| (!FlxG.save.data.downscroll && note.y >= strumLine.y)
				|| note.strumTime <= Conductor.songPosition)
			{
				if (note.mustPress)
					note.x = PlayMoving.playerReceptorX[note.noteData];
				else
					note.x = PlayMoving.opponentReceptorX[note.noteData];
			}
			else
			{
				if (note.mustPress)
					note.x = PlayMoving.nextPlayerReceptorX[note.noteData];
				else
					note.x = PlayMoving.nextOpponentReceptorX[note.noteData];
			}
			if (note.isSustainNote)
				note.x += note.width;
			if (FlxG.save.data.downscroll)
				note.y = 700
					- 775 * (((note.strumTime - 95319.14893617031) % (97021.27659574478 - 95319.14893617031)) / (97021.27659574478 - 95319.14893617031));
			else
				note.y = -75
					+ 775 * (((note.strumTime - 95319.14893617031) % (97021.27659574478 - 95319.14893617031)) / (97021.27659574478 - 95319.14893617031));
			if (note.isSustainNote && note.animation.curAnim.name.endsWith('hold'))
			{
				note.scale.y = 0.7 * Conductor.stepCrochet / 100 * 1.5 * 1;
				note.updateHitbox();
			}
		}
		else if (note.strumTime > 44255 && note.strumTime < 47517)
		{
			if (2.7 + (2.7 / 1000) * (Conductor.songPosition - note.strumTime) > 0)
			{
				if (FlxG.save.data.downscroll)
					note.y = (strumLine.y
						+ (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed * 1.5, 2))
						+ (1.35 * 0.45 * (Conductor.songPosition - note.strumTime) * (Conductor.songPosition - note.strumTime) / 1000));
				else
					note.y = (strumLine.y
						- (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed * 1.5, 2))
						- (1.35 * 0.45 * (Conductor.songPosition - note.strumTime) * (Conductor.songPosition - note.strumTime) / 1000));
			}
			else
			{
				if (FlxG.save.data.downscroll)
					note.y = -500;
				else
					note.y = 1000;
			}
		}
		else if (note.strumTime > 26382 && note.strumTime < 44114)
		{
			note.y = (PlayMoving.receptorBaselineY
				- (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(((300 - PlayMoving.receptorBaselineY) / 250) * PlayState.SONG.speed, 2)));
		}
		else if (note.strumTime > 47659 && note.strumTime < 67944)
		{
			if (rotationStep == 1)
			{
				if (note.mustPress)
					note.x = PlayMoving.playerReceptorX[note.noteData];
				else
					note.x = PlayMoving.opponentReceptorX[note.noteData];
				if (note.isSustainNote)
					note.x += note.width;
			}
			if (FlxG.save.data.downscroll)
				note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		else if (note.strumTime >= 68085 && note.strumTime <= 96880)
		{
			note.y = (PlayMoving.receptorY[note.noteData]
				- (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(((300 - PlayMoving.receptorY[note.noteData]) / 250) * PlayState.SONG.speed,
					2)));
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
		if (Conductor.songPosition >= 122553.19148936185)
		{
			PlayMoving.opponentReceptorX = [274, 50, 162, 386];
			PlayMoving.playerReceptorX = [914, 690, 802, 1026];
			if (receptor.x > 640)
				receptor.x = PlayMoving.playerReceptorX[receptor.ID];
			else
				receptor.x = PlayMoving.opponentReceptorX[receptor.ID];
			if (FlxG.save.data.downscroll)
				receptor.y = 550;
			else
				receptor.y = 50;
			strumLine.y = receptor.y;
		}
		else if (Conductor.songPosition >= 95319.14893617031 && Conductor.songPosition < 122553.19148936185)
		{
			applyStrumsFrom95319(receptor, strumLine);
		}
		else if (Conductor.songPosition >= 68085.10638297877 && Conductor.songPosition <= 95177.3049645391)
		{
			applyStrumsFrom68085(receptor, strumLine);
		}
		else if (Conductor.songPosition >= 47659.57446808513 && Conductor.songPosition <= 67943.26241134756)
		{
			applyStrumsFrom47659(receptor, strumLine);
		}
		else if (Conductor.songPosition >= 40851.06382978724 && Conductor.songPosition <= 44113.47517730498)
		{
			if (FlxG.save.data.downscroll)
				PlayMoving.receptorBaselineY = (550 - 500 * (44113.47517730498 - Conductor.songPosition) / (44113.47517730498 - 40851.06382978724));
			else
				PlayMoving.receptorBaselineY = (50 + 500 * (44113.47517730498 - Conductor.songPosition) / (44113.47517730498 - 40851.06382978724));
			strumLine.y = PlayMoving.receptorBaselineY;
			receptor.y = PlayMoving.receptorBaselineY;
		}
		else if (Conductor.songPosition >= 27092.19858156028 && Conductor.songPosition <= 40851.06382978724)
		{
			if (FlxG.save.data.downscroll)
				PlayMoving.receptorBaselineY = 50;
			else
				PlayMoving.receptorBaselineY = 550;
			strumLine.y = PlayMoving.receptorBaselineY;
			receptor.y = PlayMoving.receptorBaselineY;
		}
		else if (Conductor.songPosition >= 26382.978723404252 && Conductor.songPosition <= 27092.19858156028)
		{
			if (FlxG.save.data.downscroll)
				PlayMoving.receptorBaselineY = (50 + 500 * (27092.19858156028 - Conductor.songPosition) / (27092.19858156028 - 26382.978723404252));
			else
				PlayMoving.receptorBaselineY = (550 - 500 * (27092.19858156028 - Conductor.songPosition) / (27092.19858156028 - 26382.978723404252));
			strumLine.y = PlayMoving.receptorBaselineY;
			receptor.y = PlayMoving.receptorBaselineY;
		}
		else
		{
			receptor.y = strumLine.y;
		}
	}

	inline static public function shouldHideNote(note:Note):Bool
	{
		if (Conductor.songPosition >= 95319.14893617031 && note.strumTime >= 95319 && note.strumTime < 122412)
		{
			return (note.strumTime - Conductor.songPosition) > (96595.74468085116 - 95319.14893617031);
		}
		else if (note.strumTime > 26382 && note.strumTime < 44114)
		{
			return (Math.abs(note.y - 300) > Math.abs(((300 - PlayMoving.receptorBaselineY) / 250)) * 360);
		}
		else if (note.strumTime >= 68085 && note.strumTime <= 96880)
		{
			return (Math.abs(note.y - 300) > Math.abs(((300 - PlayMoving.receptorY[note.noteData]) / 250)) * 360);
		}
		else
		{
			if (FlxG.save.data.downscroll)
				return note.y < -note.height;
			else
				return note.y > FlxG.height;
		}
	}

	inline static public function shouldRemoveNote(note:Note):Bool
	{
		if (Conductor.songPosition >= 95319.14893617031 && note.strumTime >= 95319 && note.strumTime < 122412)
		{
			return note.tooLate;
		}
		else if (note.strumTime > 26382 && note.strumTime < 44114)
		{
			return ((Math.abs(note.y - 300) > Math.abs(((300 - PlayMoving.receptorBaselineY) / 250)) * 50) && note.tooLate);
		}
		else if (note.strumTime >= 68085 && note.strumTime <= 96880)
		{
			return ((Math.abs(note.y - 300) > Math.abs(((300 - PlayMoving.receptorY[note.noteData]) / 250)) * 50) && note.tooLate);
		}
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
		if (Conductor.songPosition >= 95319.14893617031 && note.strumTime >= 95319 && note.strumTime < 122412)
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
		else if (note.strumTime >= 68085 && note.strumTime <= 96880)
		{
			if (PlayMoving.receptorY[note.noteData] > 300)
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
			if (strumLine.y > 300)
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
		if (Conductor.songPosition >= 95319.14893617031 && note.strumTime >= 95319 && note.strumTime < 122412)
		{
			return strumLine.y;
		}
		else if (note.strumTime >= 68085 && note.strumTime <= 96880)
		{
			return PlayMoving.receptorY[note.noteData];
		}
		else
		{
			return strumLine.y;
		}
	}
	static function applyStrumsFrom95319(receptor:NoteStrum, strumLine:FlxSprite):Void
	{
		if ((Conductor.songPosition - 108936.17021276608) / (97021.27659574478 - 95319.14893617031) > rotationStep)
		{
			firstOpponentX = PlayMoving.opponentReceptorX[0];
			firstPlayerX = PlayMoving.playerReceptorX[0];
			PlayMoving.opponentReceptorX[0] = PlayMoving.opponentReceptorX[1];
			PlayMoving.opponentReceptorX[1] = PlayMoving.opponentReceptorX[2];
			PlayMoving.opponentReceptorX[2] = PlayMoving.opponentReceptorX[3];
			PlayMoving.opponentReceptorX[3] = firstOpponentX;
			PlayMoving.playerReceptorX[0] = PlayMoving.playerReceptorX[1];
			PlayMoving.playerReceptorX[1] = PlayMoving.playerReceptorX[2];
			PlayMoving.playerReceptorX[2] = PlayMoving.playerReceptorX[3];
			PlayMoving.playerReceptorX[3] = firstPlayerX;
			PlayMoving.nextOpponentReceptorX[0] = PlayMoving.opponentReceptorX[1];
			PlayMoving.nextOpponentReceptorX[1] = PlayMoving.opponentReceptorX[2];
			PlayMoving.nextOpponentReceptorX[2] = PlayMoving.opponentReceptorX[3];
			PlayMoving.nextOpponentReceptorX[3] = PlayMoving.opponentReceptorX[0];
			PlayMoving.nextPlayerReceptorX[0] = PlayMoving.playerReceptorX[1];
			PlayMoving.nextPlayerReceptorX[1] = PlayMoving.playerReceptorX[2];
			PlayMoving.nextPlayerReceptorX[2] = PlayMoving.playerReceptorX[3];
			PlayMoving.nextPlayerReceptorX[3] = PlayMoving.playerReceptorX[0];
			rotationStep += 1;
		}
		if (receptor.x > 640)
			receptor.x = PlayMoving.playerReceptorX[receptor.ID];
		else
			receptor.x = PlayMoving.opponentReceptorX[receptor.ID];
		if (FlxG.save.data.downscroll)
			receptor.y = 700
				- 775 * (((Conductor.songPosition - 95319.14893617031) % (97021.27659574478 - 95319.14893617031)) / (97021.27659574478 - 95319.14893617031));
		else
			receptor.y = -75
				+
				775 * (((Conductor.songPosition - 95319.14893617031) % (97021.27659574478 - 95319.14893617031)) / (97021.27659574478 - 95319.14893617031));
		strumLine.y = receptor.y;
	}

	static function applyStrumsFrom68085(receptor:NoteStrum, strumLine:FlxSprite):Void
	{
		rotationStep = 0;
		if (receptor.x > 640)
		{
			receptor.x = PlayMoving.defaultPlayerReceptorX[receptor.ID];
			PlayMoving.playerReceptorX[receptor.ID] = receptor.x;
		}
		else
		{
			receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID];
			PlayMoving.opponentReceptorX[receptor.ID] = receptor.x;
		}
		switch (Std.int((Conductor.songPosition - 68085.10638297877) / (68510.63829787239 - 68085.10638297877)) % 8)
		{
			case 0:
				if (receptor.ID == 0 || receptor.ID == 2)
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 550
							- (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
								- 68085.10638297877)) * 500;
					else
						receptor.y = 50
							+ (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
								- 68085.10638297877)) * 500;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
				else
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 550;
					else
						receptor.y = 50;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
			case 1:
				if (receptor.ID == 0 || receptor.ID == 2)
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 50;
					else
						receptor.y = 550;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
				else
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 550;
					else
						receptor.y = 50;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
			case 2:
				if (receptor.ID == 0 || receptor.ID == 2)
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 50;
					else
						receptor.y = 550;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
				else
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 550
							- (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
								- 68085.10638297877)) * 500;
					else
						receptor.y = 50
							+ (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
								- 68085.10638297877)) * 500;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
			case 3:
				if (receptor.ID == 0 || receptor.ID == 2)
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 50;
					else
						receptor.y = 550;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
				else
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 50;
					else
						receptor.y = 550;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
			case 4:
				if (receptor.ID == 0 || receptor.ID == 2)
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 50
							+ (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
								- 68085.10638297877)) * 500;
					else
						receptor.y = 550
							- (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
								- 68085.10638297877)) * 500;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
				else
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 50;
					else
						receptor.y = 550;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
			case 5:
				if (receptor.ID == 0 || receptor.ID == 2)
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 550;
					else
						receptor.y = 50;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
				else
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 50;
					else
						receptor.y = 550;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
			case 6:
				if (receptor.ID == 0 || receptor.ID == 2)
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 550;
					else
						receptor.y = 50;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
				else
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 50
							+ (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
								- 68085.10638297877)) * 500;
					else
						receptor.y = 550
							- (((Conductor.songPosition - 68085.10638297877) % (68510.63829787239 - 68085.10638297877)) / (68510.63829787239
								- 68085.10638297877)) * 500;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
			case 7:
				if (receptor.ID == 0 || receptor.ID == 2)
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 550;
					else
						receptor.y = 50;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
				else
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 550;
					else
						receptor.y = 50;
					PlayMoving.receptorY[receptor.ID] = receptor.y;
				}
		}
	}

	static function applyStrumsFrom47659(receptor:NoteStrum, strumLine:FlxSprite):Void
	{
		/*if (rotationStep == 0)
			{
				while (nlist[0] == PlayMoving.opponentReceptorX[0] && nlist[1] == PlayMoving.opponentReceptorX[1] && nlist[2] == PlayMoving.opponentReceptorX[2] && nlist[3] == PlayMoving.opponentReceptorX[3])
				{
					var dalist:Array<Int> = [];
					var numlist:Array<Int> = [0,1,2,3];
					for (i in 0...4)
					{
						var num = FlxG.random.int(0,3-i);
						dalist.push(numlist[num]);
						numlist.remove(numlist[num]);
						nlist[i] = PlayMoving.defaultOpponentReceptorX[dalist[i]];
						pnlist[i] = PlayMoving.defaultPlayerReceptorX[dalist[i]];
					}
					trace(nlist+" "+xlist);
				}
				for (i in 0...4)
				{
					PlayMoving.opponentReceptorX[i] = nlist[i];
					PlayMoving.playerReceptorX[i] = pnlist[i];
				}
				rotationStep += 1;
		}*/
		if (Conductor.songPosition <= 47759.57446808513)
		{
			if (receptor.x > 640)
			{
				receptor.x = 858 - (47759.57446808513 - Conductor.songPosition) / 100 * (858 - PlayMoving.defaultPlayerReceptorX[receptor.ID]);
				PlayMoving.playerReceptorX[receptor.ID] = receptor.x;
			}
			else
			{
				receptor.x = 218 - (47759.57446808513 - Conductor.songPosition) / 100 * (218 - PlayMoving.defaultOpponentReceptorX[receptor.ID]);
				PlayMoving.opponentReceptorX[receptor.ID] = receptor.x;
			}
		}
		else if (Conductor.songPosition >= 67843.26241134756)
		{
			if (receptor.x > 640)
			{
				receptor.x = PlayMoving.defaultPlayerReceptorX[receptor.ID] - (67943.26241134756 - Conductor.songPosition) / 100 * (PlayMoving.defaultPlayerReceptorX[receptor.ID] - 858);
				PlayMoving.playerReceptorX[receptor.ID] = receptor.x;
			}
			else
			{
				receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID] - (67943.26241134756 - Conductor.songPosition) / 100 * (PlayMoving.defaultOpponentReceptorX[receptor.ID] - 218);
				PlayMoving.opponentReceptorX[receptor.ID] = receptor.x;
			}
		}
		else
		{
			if (receptor.x > 640)
			{
				receptor.x = 858;
				PlayMoving.playerReceptorX[receptor.ID] = receptor.x;
			}
			else
			{
				receptor.x = 218;
				PlayMoving.opponentReceptorX[receptor.ID] = receptor.x;
			}
		}
		rotationStep = 1;
		receptor.y = strumLine.y;
	}

}
