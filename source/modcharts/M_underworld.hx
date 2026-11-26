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

class M_underworld
{
	public static function updateNotePosition(note:Note, strumLine:FlxSprite)
	{
		if (note.strumTime < 24114)
		{
			if (FlxG.save.data.downscroll)
			{
				if (Std.int(Conductor.songPosition / 1518.98734177) == Std.int(note.strumTime / 1518.98734177))
					note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = (strumLine.y
						+ (Conductor.songPosition - note.strumTime - 189.873417722) * (ModchartMath.scrollSpeed()));
			}
			else
			{
				if (Std.int(Conductor.songPosition / 1518.98734177) == Std.int(note.strumTime / 1518.98734177))
					note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = (strumLine.y
						- (Conductor.songPosition - note.strumTime - 189.873417722) * (ModchartMath.scrollSpeed()));
			}
		}
		else if (note.strumTime >= 24303 && note.strumTime < 30190)
		{
			if (FlxG.save.data.downscroll)
				note.y = (PlayMoving.receptorY[note.noteData]
					+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (PlayMoving.receptorY[note.noteData]
					- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		else if (note.strumTime >= 30379 && note.strumTime < 36266)
		{
			if (!note.isSustainNote)
				note.angle += 5;
			if (FlxG.save.data.downscroll)
				note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		else if (Conductor.songPosition >= 36455.69620253167 && note.strumTime < 48418)
		{
			applyNotesFrom36455(note, strumLine);
		}
		else if (note.strumTime >= 48607 && note.strumTime < 60570)
		{
			applyNotesFrom48607(note, strumLine);
		}
		else if (note.strumTime >= 60759 && note.strumTime < 72722)
		{
			applyNotesFrom60759(note, strumLine);
		}
		else if (note.strumTime >= 78987 && note.strumTime < 91045)
		{
			applyNotesFrom78987(note, strumLine);
		}
		else if (note.strumTime >= 91139 && note.strumTime < 97026)
		{
			if (note.mustPress)
				note.x = PlayMoving.playerReceptorX[note.noteData];
			else
				note.x = PlayMoving.opponentReceptorX[note.noteData];
			if (note.isSustainNote)
				note.x += note.width;
			if (FlxG.save.data.downscroll)
				note.y = (50 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (550 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		else if (note.strumTime >= 97215 && note.strumTime < 109178)
		{
			if (note.isSustainNote)
			{
				var len:Float = Conductor.stepCrochet;
				if (!note.animation.curAnim.name.endsWith('hold'))
				{
					len /= ModchartMath.sustainScale();
				}
				var sdist = -(Conductor.songPosition - note.strumTime + Conductor.stepCrochet) * (ModchartMath.scrollSpeed());
				var edist = -(Conductor.songPosition - note.strumTime + Conductor.stepCrochet - len) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
					2));
				var x = (note.mustPress ? 690 : 520) + Note.noteWidth[note.noteData] * 0.5;
				var y = (note.mustPress ? 468 - note.noteData * 112 : 132 + note.noteData * 112) + Note.noteHeight[note.noteData] * 0.5;

				note.renderer = new RenderPath(1, [sdist, edist, x, y, note.width * 0.7, note.mustPress ? 270 : 90, 0]);
				if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet
					&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
					note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / len;
				note.pathrender();
			}
			else if (note.mustPress)
			{
				note.x = (690 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				note.y = 468 - note.noteData * 112;
			}
			else
			{
				note.x = (520 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				note.y = 132 + note.noteData * 112;
			}
		}
		else if (note.strumTime >= 109367 && note.strumTime < 121330)
		{
			/* x = ori + swagWidth / 2, y = 360, scale = 2
				eye(640,360,0), flat: z = 200
			 */
			var z:Float = 800 * (note.strumTime - Conductor.songPosition) / 379.746835444;
			var x0:Float = 640 - Note.swagWidth * (4 - note.noteData);
			var x:Float = 640 - Note.swagWidth * (4 - note.noteData) + Note.swagWidth / 1.4;
			if (note.mustPress)
			{
				x0 = 640 + Note.swagWidth * note.noteData;
				x = 640 + Note.swagWidth * note.noteData + Note.swagWidth / 1.4;
			}

			var nx0:Float = NoteObject.toScreen(x0, 360, z)[0];
			var nx:Float = NoteObject.toScreen(x, 360, z)[0];
			note.setGraphicSize(Std.int((nx - nx0) * 2));
			note.updateHitbox();
			note.x = nx - note.width / 2;
			note.y = 360 - note.height / 2;
			if (Conductor.songPosition > note.strumTime)
				note.alpha = 0;
		}
		else if (note.strumTime >= 121518 && note.strumTime < 145633)
		{
			if (note.mustPress)
			{
				note.x = 538 + (PlayMoving.defaultPlayerReceptorX[note.noteData] - 538) * Math.cos(note.strumTime / 1518.98734177 * 3.1415926);
				note.y = 300 - (100 + 50 * note.noteData) * Math.sin(note.strumTime / 1518.98734177 * 3.1415926);
			}
			else
			{
				note.x = 538 - (538 - PlayMoving.defaultOpponentReceptorX[note.noteData]) * Math.cos(note.strumTime / 1518.98734177 * 3.1415926);
				note.y = 300 + (100 + 50 * (3 - note.noteData)) * Math.sin(note.strumTime / 1518.98734177 * 3.1415926);
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
		if (Conductor.songPosition >= 24303.797468354438 && Conductor.songPosition < 30379.746835443053)
		{
			applyStrumsFrom24303(receptor, strumLine);
		}
		else if (Conductor.songPosition >= 30379.746835443053 && Conductor.songPosition < 31189.873417721534)
		{
			if (FlxG.save.data.downscroll)
				receptor.y = 550;
			else
				receptor.y = 50;
		}
		else if (Conductor.songPosition >= 36455.69620253167 && Conductor.songPosition < 48227.84810126586)
		{
			if (receptor.x > 640)
			{
				receptor.x = 1110;
				receptor.y = 132 + receptor.ID * 112;
			}
			else
			{
				receptor.x = 50;
				receptor.y = 468 - receptor.ID * 112;
			}
		}
		else if (Conductor.songPosition >= 48227.84810126586 && Conductor.songPosition < 48987.341772151936)
		{
			applyStrumsFrom48227(receptor, strumLine);
		}
		else if (Conductor.songPosition >= 48987.341772151936 && Conductor.songPosition < 49987.341772151936)
		{
			if (receptor.x > 640)
			{
				switch (receptor.ID)
				{
					case 0:
						receptor.x = 690;
						receptor.y = 300;
					case 1:
						receptor.x = 900;
						receptor.y = 510;
					case 2:
						receptor.x = 900;
						receptor.y = 90;
					case 3:
						receptor.x = 1110;
						receptor.y = 300;
				}
			}
		}
		else if (Conductor.songPosition >= 72911.39240506335 && Conductor.songPosition < 78797.46835443044)
		{
			if (Conductor.songPosition < 73101.26582278487)
				receptor.alpha = (73101.26582278487 - Conductor.songPosition) / 189.873417722;
			else
				receptor.alpha = 0;
		}
		else if (Conductor.songPosition >= 78987.34177215197 && Conductor.songPosition < 91044.30379746843)
		{
			if (Conductor.songPosition < 79177.21518987349)
				receptor.alpha = (Conductor.songPosition - 78987.34177215197) / 189.873417722;
			else
				receptor.alpha = 1;
			if (Conductor.songPosition < 85063.29113924058)
			{
				if (receptor.x < 640)
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 550 - 500 * (Conductor.songPosition - 78987.34177215197) / 6075.94936709;
					else
						receptor.y = 50 + 500 * (Conductor.songPosition - 78987.34177215197) / 6075.94936709;
				}
			}
			else
			{
				if (receptor.x > 640)
				{
					if (FlxG.save.data.downscroll)
						receptor.y = 550 - 500 * (Conductor.songPosition - 85063.29113924058) / 6075.94936709;
					else
						receptor.y = 50 + 500 * (Conductor.songPosition - 85063.29113924058) / 6075.94936709;
				}
			}
		}
		else if (Conductor.songPosition >= 91139.2405063292 && Conductor.songPosition < 97025.31645569629)
		{
			applyStrumsFrom91139(receptor, strumLine);
		}
		else if (Conductor.songPosition >= 97215.18987341781 && Conductor.songPosition < 109177.21518987352)
		{
			if (receptor.x > 640)
			{
				receptor.x = 690;
				receptor.y = 468 - receptor.ID * 112;
			}
			else
			{
				receptor.x = 520;
				receptor.y = 132 + receptor.ID * 112;
			}
		}
		else if (Conductor.songPosition >= 109367.08860759504 && Conductor.songPosition < 110886.0759493672)
		{
			if (Conductor.songPosition < 109556.962025)
			{
				receptor.scale.x = (109556.962025 - Conductor.songPosition) / 189.873417722 * 0.7;
				receptor.scale.y = (109556.962025 - Conductor.songPosition) / 189.873417722 * 0.7;
			}
			else
				receptor.alpha = 0;
		}
		else if (Conductor.songPosition >= 121139.24050632922 && Conductor.songPosition < 121329.11392405075)
		{
			if (receptor.x > 640)
				receptor.x = PlayMoving.defaultPlayerReceptorX[receptor.ID];
			else
				receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID];
			receptor.y = 300;
			receptor.alpha = 1;
			receptor.x = 538 - (538 - PlayMoving.defaultOpponentReceptorX[receptor.ID]) * Math.cos(Conductor.songPosition / 1518.98734177 * 3.1415926);
			receptor.y = 300 + (100 + 50 * (3 - receptor.ID)) * Math.sin(Conductor.songPosition / 1518.98734177 * 3.1415926);
			receptor.scale.x = (Conductor.songPosition - 121139.24050632922) / 189.873417722 * 0.7;
			receptor.scale.y = (Conductor.songPosition - 121139.24050632922) / 189.873417722 * 0.7;
		}
		else if (Conductor.songPosition >= 121518.98734177227 && Conductor.songPosition < 145822.78481)
		{
			receptor.scale.x = 0.7;
			receptor.scale.y = 0.7;
			receptor.x = 538 - (538 - PlayMoving.defaultOpponentReceptorX[receptor.ID]) * Math.cos(Conductor.songPosition / 1518.98734177 * 3.1415926);
			receptor.y = 300 + (100 + 50 * (3 - receptor.ID)) * Math.sin(Conductor.songPosition / 1518.98734177 * 3.1415926);
		}
	}

	public static function updatePlayerReceptorPosition(receptor:NoteStrum, strumLine:FlxSprite)
	{
		if (Conductor.songPosition >= 121139.24050632922 && Conductor.songPosition < 145822.78481)
		{
			receptor.scale.x = 0.7;
			receptor.scale.y = 0.7;
			receptor.x = 538 + (PlayMoving.defaultPlayerReceptorX[receptor.ID] - 538) * Math.cos(Conductor.songPosition / 1518.98734177 * 3.1415926);
			receptor.y = 300 - (100 + 50 * receptor.ID) * Math.sin(Conductor.songPosition / 1518.98734177 * 3.1415926);
		}
	}

	inline static public function shouldHideNote(note:Note):Bool
	{
		if (Conductor.songPosition >= 36455.69620253167 && note.strumTime < 48418)
		{
			if (note.isSustainNote)
				return false;
			if (note.mustPress)
				return note.x < 640;
			else
				return note.x > 640;
		}
		else if (note.strumTime >= 48607 && note.strumTime < 60570)
		{
			if (note.isSustainNote)
				return false;
			if (note.mustPress)
			{
				switch (note.noteData)
				{
					case 0:
						return note.x > 900;
					case 3:
						return note.x < 900;
					case 1:
						return note.y < 300;
					default:
						return note.y > 300;
				}
			}
			else
			{
				switch (note.noteData)
				{
					case 0:
						return note.x > 260;
					case 3:
						return note.x < 260;
					case 1:
						return note.y < 300;
					default:
						return note.y > 300;
				}
			}
		}
		else if (note.strumTime >= 109367 && note.strumTime < 121330)
			return note.strumTime - Conductor.songPosition > 379.746835444;
		else if (note.strumTime >= 121518 && note.strumTime < 145633)
			return note.strumTime - Conductor.songPosition > 759.493670885;
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
		if (Conductor.songPosition >= 36455.69620253167 && note.strumTime < 48418)
		{
			if (note.mustPress)
				return note.x > FlxG.width;
			else
				return false;
		}
		else if (note.strumTime >= 48607 && note.strumTime < 60570)
		{
			if (note.mustPress)
				return (note.x > FlxG.width || note.x < 640 || note.y < -note.height || note.y > FlxG.height)
					&& Conductor.songPosition > note.strumTime;
			else
				return false;
		}
		else if (note.strumTime >= 78987 && note.strumTime < 91045)
			return ((note.y < -note.height) || (note.y > FlxG.height)) && Conductor.songPosition > note.strumTime;
		else if (note.strumTime >= 91139 && note.strumTime < 97026)
		{
			if (FlxG.save.data.downscroll)
				return note.y < -note.height;
			else
				return note.y > FlxG.height;
		}
		else if (note.strumTime >= 97215 && note.strumTime < 109178)
		{
			if (note.mustPress)
				return note.x < -note.width;
			else
				return note.x > FlxG.width;
		}
		else if (note.strumTime >= 109367 && note.strumTime < 121330)
		{
			return Conductor.songPosition - note.strumTime > (1000 / 6);
		}
		else if (note.strumTime >= 121518 && note.strumTime < 145633)
			return Conductor.songPosition - note.strumTime > (1000 / 6);
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
		if (Conductor.songPosition >= 36455.69620253167 && note.strumTime < 48418)
		{
			if (note.mustPress)
				return 3;
			else
				return 0;
		}
		else if (note.strumTime >= 48607 && note.strumTime < 60570)
			return note.noteData;
		else if (note.strumTime >= 91139 && note.strumTime < 97026)
		{
			if (FlxG.save.data.downscroll)
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
		else if (note.strumTime >= 97215 && note.strumTime < 109178)
		{
			if (note.mustPress)
				return 0;
			else
				return 3;
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
		if (note.strumTime >= 24303 && note.strumTime < 30190)
			return PlayMoving.receptorY[note.noteData];
		if (Conductor.songPosition >= 36455.69620253167 && note.strumTime < 48418)
		{
			if (note.mustPress)
				return 1110;
			else
				return 50;
		}
		else if (note.strumTime >= 48607 && note.strumTime < 60570)
		{
			if (note.mustPress)
			{
				switch (note.noteData)
				{
					case 0:
						return 690;
					case 3:
						return 1110;
					case 1:
						return 510;
					default:
						return 90;
				}
			}
			else
			{
				switch (note.noteData)
				{
					case 0:
						return 50;
					case 3:
						return 470;
					case 1:
						return 510;
					default:
						return 90;
				}
			}
		}
		else if (note.strumTime >= 91139 && note.strumTime < 97026)
			return 550;
		else if (note.strumTime >= 97215 && note.strumTime < 109178)
		{
			if (note.mustPress)
				return 690;
			else
				return 520;
		}
		else
			return strumLine.y;
	}
	static function applyNotesFrom36455(note:Note, strumLine:FlxSprite):Void
	{
		if (note.isSustainNote)
		{
			var len:Float = Conductor.stepCrochet;
			if (!note.animation.curAnim.name.endsWith('hold'))
			{
				len /= ModchartMath.sustainScale();
			}
			var sdist = -(Conductor.songPosition - note.strumTime + Conductor.stepCrochet) * (ModchartMath.scrollSpeed());
			var edist = -(Conductor.songPosition - note.strumTime + Conductor.stepCrochet - len) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
				2));
			var x = (note.mustPress ? 1110 : 50) + Note.noteWidth[note.noteData] * 0.5;
			var y = (note.mustPress ? 132 + note.noteData * 112 : 468 - note.noteData * 112) + Note.noteHeight[note.noteData] * 0.5;

			note.renderer = new RenderPath(1, [
				sdist,
				edist,
				x,
				y,
				note.width * 0.7,
				note.mustPress ? 90 : 270,
				Math.abs(x - 640)
			]);
			if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet
				&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
				note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / len;
			note.pathrender();
		}
		else if (note.mustPress)
		{
			note.x = (1110 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			note.y = 132 + note.noteData * 112;
		}
		else
		{
			note.x = (50 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			note.y = 468 - note.noteData * 112;
		}
	}

	static function applyNotesFrom48607(note:Note, strumLine:FlxSprite):Void
	{
		if (note.isSustainNote)
		{
			var anglist:Array<Float> = [-90, 180, 0, 90];
			var len:Float = Conductor.stepCrochet;
			if (!note.animation.curAnim.name.endsWith('hold'))
			{
				len /= ModchartMath.sustainScale();
			}
			var sdist = -(Conductor.songPosition - note.strumTime + Conductor.stepCrochet) * (ModchartMath.scrollSpeed());
			var edist = -(Conductor.songPosition - note.strumTime + Conductor.stepCrochet - len) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
				2));
			var x:Float = 0;
			var y:Float = 0;

			if (note.mustPress)
			{
				switch (note.noteData)
				{
					case 0:
						y = 300;
						x = 690;
					case 3:
						y = 300;
						x = 1110;
					case 1:
						y = 510;
						x = 900;
					case 2:
						y = 90;
						x = 900;
				}
			}
			else
			{
				switch (note.noteData)
				{
					case 0:
						y = 300;
						x = 50;
					case 3:
						y = 300;
						x = 470;
					case 1:
						y = 510;
						x = 260;
					case 2:
						y = 90;
						x = 260;
				}
			}

			note.renderer = new RenderPath(1, [
				sdist,
				edist,
				x + Note.noteWidth[note.noteData] * 0.5,
				y + Note.noteHeight[note.noteData] * 0.5,
				note.width * 0.7,
				anglist[note.noteData],
				210
			]);
			if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet
				&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
				note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / len;
			note.pathrender();
		}
		else if (note.mustPress)
		{
			switch (note.noteData)
			{
				case 0:
					note.y = 300;
					note.x = (690 - (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
				case 3:
					note.y = 300;
					note.x = (1110 + (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
				case 1:
					note.y = (510 + (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
					note.x = 900;
				case 2:
					note.y = (90 - (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
					note.x = 900;
			}
		}
		else
		{
			switch (note.noteData)
			{
				case 0:
					note.y = 300;
					note.x = (50 - (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
				case 3:
					note.y = 300;
					note.x = (470 + (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
				case 1:
					note.y = (510 + (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
					note.x = 260;
				case 2:
					note.y = (90 - (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.5, 2)));
					note.x = 260;
			}
		}
	}

	static function applyNotesFrom60759(note:Note, strumLine:FlxSprite):Void
	{
		if (FlxG.save.data.downscroll)
		{
			if (!note.isSustainNote)
			{
				switch (note.noteData)
				{
					case 0:
						note.angle = -90;
					case 3:
						note.angle = 90;
					case 2:
						note.angle = 180;
				}
			}
			note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		else
		{
			if (!note.isSustainNote)
			{
				switch (note.noteData)
				{
					case 0:
						note.angle = 90;
					case 3:
						note.angle = -90;
					case 1:
						note.angle = 180;
				}
			}
			note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
	}

	static function applyNotesFrom78987(note:Note, strumLine:FlxSprite):Void
	{
		if (FlxG.save.data.downscroll)
		{
			if (note.mustPress)
			{
				if ((note.strumTime - 85063.29113924058) / 6075.94936709 < 0.5)
					note.y = ((550 - 500 * (note.strumTime - 85063.29113924058) / 6075.94936709)
						+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = ((550 - 500 * (note.strumTime - 85063.29113924058) / 6075.94936709)
						- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			}
			else
			{
				if ((note.strumTime - 78987.34177215197) / 6075.94936709 < 0.5)
					note.y = ((550 - 500 * (note.strumTime - 78987.34177215197) / 6075.94936709)
						+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = ((550 - 500 * (note.strumTime - 78987.34177215197) / 6075.94936709)
						- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			}
		}
		else
		{
			if (note.mustPress)
			{
				if ((note.strumTime - 85063.29113924058) / 6075.94936709 < 0.5)
					note.y = ((50 + 500 * (note.strumTime - 85063.29113924058) / 6075.94936709)
						- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = ((50 + 500 * (note.strumTime - 85063.29113924058) / 6075.94936709)
						+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			}
			else
			{
				if ((note.strumTime - 78987.34177215197) / 6075.94936709 < 0.5)
					note.y = ((50 + 500 * (note.strumTime - 78987.34177215197) / 6075.94936709)
						- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = ((50 + 500 * (note.strumTime - 78987.34177215197) / 6075.94936709)
						+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			}
		}
	}

	static function applyStrumsFrom24303(receptor:NoteStrum, strumLine:FlxSprite):Void
	{
		if (Conductor.songPosition % 759.493670886 < 379.746835443)
		{
			if (receptor.ID % 2 == 0)
			{
				if (FlxG.save.data.downscroll)
				{
					receptor.y = 450;
					PlayMoving.receptorY[receptor.ID] = 450;
				}
				else
				{
					receptor.y = 150;
					PlayMoving.receptorY[receptor.ID] = 150;
				}
			}
			else
			{
				if (FlxG.save.data.downscroll)
				{
					receptor.y = 550;
					PlayMoving.receptorY[receptor.ID] = 550;
				}
				else
				{
					receptor.y = 50;
					PlayMoving.receptorY[receptor.ID] = 50;
				}
			}
		}
		else
		{
			if (receptor.ID % 2 == 0)
			{
				if (FlxG.save.data.downscroll)
				{
					receptor.y = 550;
					PlayMoving.receptorY[receptor.ID] = 550;
				}
				else
				{
					receptor.y = 50;
					PlayMoving.receptorY[receptor.ID] = 50;
				}
			}
			else
			{
				if (FlxG.save.data.downscroll)
				{
					receptor.y = 450;
					PlayMoving.receptorY[receptor.ID] = 450;
				}
				else
				{
					receptor.y = 150;
					PlayMoving.receptorY[receptor.ID] = 150;
				}
			}
		}
	}

	static function applyStrumsFrom48227(receptor:NoteStrum, strumLine:FlxSprite):Void
	{
		if (Conductor.songPosition < 48607.5949367089)
		{
			if (receptor.x < 640)
			{
				switch (receptor.ID)
				{
					case 0:
						receptor.x = 50;
						receptor.y = 468 - (Conductor.songPosition - 48227.84810126586) / 379.746835443 * (168);
					case 1:
						receptor.x = 50 + (Conductor.songPosition - 48227.84810126586) / 379.746835443 * (210);
						receptor.y = 356 + (Conductor.songPosition - 48227.84810126586) / 379.746835443 * (154);
					case 2:
						receptor.x = 50 + (Conductor.songPosition - 48227.84810126586) / 379.746835443 * (210);
						receptor.y = 244 - (Conductor.songPosition - 48227.84810126586) / 379.746835443 * (154);
					case 3:
						receptor.x = 50 + (Conductor.songPosition - 48227.84810126586) / 379.746835443 * (420);
						receptor.y = 132 + (Conductor.songPosition - 48227.84810126586) / 379.746835443 * (168);
				}
			}
		}
		else
		{
			if (receptor.x > 640)
			{
				switch (receptor.ID)
				{
					case 0:
						receptor.x = 1110 - (Conductor.songPosition - 48607.5949367089) / 379.746835443 * (420);
						receptor.y = 132 + (Conductor.songPosition - 48607.5949367089) / 379.746835443 * (168);
					case 1:
						receptor.x = 1110 - (Conductor.songPosition - 48607.5949367089) / 379.746835443 * (210);
						receptor.y = 244 + (Conductor.songPosition - 48607.5949367089) / 379.746835443 * (266);
					case 2:
						receptor.x = 1110 - (Conductor.songPosition - 48607.5949367089) / 379.746835443 * (210);
						receptor.y = 356 - (Conductor.songPosition - 48607.5949367089) / 379.746835443 * (266);
					case 3:
						receptor.x = 1110;
						receptor.y = 468 - (Conductor.songPosition - 48607.5949367089) / 379.746835443 * (168);
				}
			}
			else
			{
				switch (receptor.ID)
				{
					case 0:
						receptor.x = 50;
						receptor.y = 300;
					case 1:
						receptor.x = 260;
						receptor.y = 510;
					case 2:
						receptor.x = 260;
						receptor.y = 90;
					case 3:
						receptor.x = 470;
						receptor.y = 300;
				}
			}
		}
	}

	static function applyStrumsFrom91139(receptor:NoteStrum, strumLine:FlxSprite):Void
	{
		if (Conductor.songPosition % 1518.98734177 < 379.746835443)
		{
			if (receptor.x > 640)
			{
				if (receptor.ID % 2 == 0)
				{
					receptor.x = PlayMoving.defaultPlayerReceptorX[receptor.ID]
						+ (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.defaultPlayerReceptorX[receptor.ID + 1] - PlayMoving.defaultPlayerReceptorX[receptor.ID]);
					PlayMoving.playerReceptorX[receptor.ID] = receptor.x;
				}
				else
				{
					receptor.x = PlayMoving.defaultPlayerReceptorX[receptor.ID]
						+ (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.defaultPlayerReceptorX[receptor.ID - 1] - PlayMoving.defaultPlayerReceptorX[receptor.ID]);
					PlayMoving.playerReceptorX[receptor.ID] = receptor.x;
				}
			}
			else
			{
				if (receptor.ID % 2 == 0)
				{
					receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID]
						+ (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.defaultOpponentReceptorX[receptor.ID + 1] - PlayMoving.defaultOpponentReceptorX[receptor.ID]);
					PlayMoving.opponentReceptorX[receptor.ID] = receptor.x;
				}
				else
				{
					receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID]
						+ (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.defaultOpponentReceptorX[receptor.ID - 1] - PlayMoving.defaultOpponentReceptorX[receptor.ID]);
					PlayMoving.opponentReceptorX[receptor.ID] = receptor.x;
				}
			}
		}
		else if (Conductor.songPosition % 1518.98734177 >= 759.493670886 && Conductor.songPosition % 1518.98734177 < 1139.24050633)
		{
			if (receptor.x > 640)
			{
				if (receptor.ID % 2 == 0)
				{
					receptor.x = PlayMoving.defaultPlayerReceptorX[receptor.ID + 1]
						- (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.defaultPlayerReceptorX[receptor.ID + 1] - PlayMoving.defaultPlayerReceptorX[receptor.ID]);
					PlayMoving.playerReceptorX[receptor.ID] = receptor.x;
				}
				else
				{
					receptor.x = PlayMoving.defaultPlayerReceptorX[receptor.ID - 1]
						- (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.defaultPlayerReceptorX[receptor.ID - 1] - PlayMoving.defaultPlayerReceptorX[receptor.ID]);
					PlayMoving.playerReceptorX[receptor.ID] = receptor.x;
				}
			}
			else
			{
				if (receptor.ID % 2 == 0)
				{
					receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID + 1]
						- (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.defaultOpponentReceptorX[receptor.ID + 1] - PlayMoving.defaultOpponentReceptorX[receptor.ID]);
					PlayMoving.opponentReceptorX[receptor.ID] = receptor.x;
				}
				else
				{
					receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID - 1]
						- (Conductor.songPosition % 379.746835443) / 379.746835443 * (PlayMoving.defaultOpponentReceptorX[receptor.ID - 1] - PlayMoving.defaultOpponentReceptorX[receptor.ID]);
					PlayMoving.opponentReceptorX[receptor.ID] = receptor.x;
				}
			}
		}
	}

}
