package modcharts;

import backend.data.Song.SwagSong;
import Std;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxStrip;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import haxe.Exception;
import modcharts.RenderPath;
import openfl.Lib;
import openfl.system.Capabilities;

using StringTools;

class M_peace
{
	public static var generatedPhase:Int = 0;

	public static function reset()
	{
		generatedPhase = 0;
	}

	public static function updateNotePosition(note:Note)
	{
		if (note.strumTime < 38100.0 || (note.strumTime <= 38400.0 && note.mustPress))
		{
			applyNotesBefore38100(note);
		}
		else if (note.strumTime >= 38100 && (note.strumTime < 57525 || (note.strumTime <= 57600 && note.mustPress)))
		{
			applyNotesFrom38100(note);
		}
		else if (note.strumTime >= 57600 && (note.strumTime < 76500 || (note.strumTime < 76800 && note.mustPress)))
		{
			applyNotesFrom57600(note);
		}
		else if (note.strumTime >= 76800 && note.strumTime < 96000)
		{
			applyNotesFrom76800(note);
		}
		else if (note.strumTime >= 96000 && note.strumTime <= 115050)
		{
			applyNotesFrom96000(note);
		}
		else if (note.strumTime >= 115200 && (note.strumTime < 134400 || (note.strumTime < 134500 && note.mustPress)))
		{
			applyNotesFrom115200(note);
		}
		else if (note.strumTime >= 134400 && (note.strumTime < 153600 || (note.strumTime < 153700 && note.mustPress)))
		{
			applyNotesFrom134400(note);
		}
		else if (note.strumTime >= 153600 && (note.strumTime < 172800 || (note.strumTime < 172900 && note.mustPress)))
		{
			applyNotesFrom153600(note);
		}
		else if (note.strumTime >= 172800 && !note.mustPress)
		{
			applyNotesFrom172800(note);
		}
		else
		{
			if (FlxG.save.data.downscroll)
				note.y = (550 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (50 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
	}

	public static function updateReceptorPosition(receptor:NoteStrum)
	{
		if (Conductor.songPosition < 0)
			receptor.mustBeKilled = true;
		else if (Conductor.songPosition > 38100 && Conductor.songPosition < 57600 && receptor.spec != 2)
		{
			applyStrumsFrom38100(receptor);
		}
		else if (Conductor.songPosition >= 57400
			&& (Conductor.songPosition < 76500 || (Conductor.songPosition < 77100 && receptor.spec == 2)))
		{
			if (receptor.spec == 2)
			{
				var cang:Float = 0.125 + 0.25 * receptor.ID;
				if (Conductor.songPosition >= 67200)
					cang += Conductor.songPosition / 1200;
				receptor.z = 200 + 640 * Math.sin(cang * Math.PI);
				receptor.renderer = new R_peace(2, [
					2,
					(receptor.animation.curAnim.name == 'confirm' ? 1 : 0),
					receptor.width,
					receptor.height,
					cang
				]);
				receptor.pathrender();
				if (Conductor.songPosition >= 77000)
					receptor.mustBeKilled = true;
			}
			else
			{
				receptor.alpha -= 0.05;
				if (receptor.alpha <= 0)
					receptor.mustBeKilled = true;
			}
		}
		else if (Conductor.songPosition >= 76500 && Conductor.songPosition < 96000)
		{
			applyStrumsFrom76500(receptor);
		}
		else if (Conductor.songPosition > 96000 && Conductor.songPosition < 116000 && receptor.spec < 2)
		{
			applyStrumsFrom96000(receptor);
		}
		else if (Conductor.songPosition > 112800 && Conductor.songPosition < 140000 && receptor.spec > 1 && receptor.spec < 5)
		{
			applyStrumsFrom112800(receptor);
		}
		else if (Conductor.songPosition > 134300 && Conductor.songPosition < 154500 && (receptor.spec <= 1 || receptor.spec == 5))
		{
			applyStrumsFrom134300(receptor);
		}
		else if (Conductor.songPosition > 153500 && receptor.spec == 2)
		{
			applyStrumsFrom153500(receptor);
		}
		else if (Conductor.songPosition > 172700 && receptor.spec == 0)
		{
			if (Conductor.songPosition < 72800)
				receptor.alpha = (Conductor.songPosition - 172700) / 100;
			else
				receptor.alpha = 1;
			receptor.wx = 640;
			receptor.wy = 360;
			receptor.z = 1000;
			receptor.scaleW();
		}
	}

	public static function shouldHideNote(note:Note):Bool
	{
		if (note.strumTime >= 115200
			&& (note.strumTime < 134400 || (note.strumTime < 134500 && note.mustPress))
			&& note.spec == 0)
			return note.strumTime - Conductor.songPosition > 1500;
		else
			return false;
	}

	public static function shouldRemoveNote(note:Note):Bool
	{
		if (note.strumTime < 57525 || (note.strumTime < 57600 && note.mustPress))
			return true;
		else if (note.strumTime >= 57600 && (note.strumTime < 76500 || (note.strumTime < 76800 && note.mustPress)))
			return Conductor.songPosition - note.strumTime > 1000;
		else if (note.strumTime >= 76800 && note.strumTime < 96000)
		{
			if (note.spec == 1)
				return true;
			else
				return note.y > FlxG.height || note.y < -note.height || note.x > FlxG.width || note.x < -note.width;
		}
		else if (note.strumTime >= 96000 && note.strumTime <= 115050 && note.spec != 0)
			return true;
		if (note.strumTime >= 115200 && (note.strumTime < 134400 || (note.strumTime < 134500 && note.mustPress)))
		{
			if (note.spec == 0)
			{
				var dood:Bool = Conductor.songPosition - note.strumTime > 1000;
				if (dood)
					PlayState.playstate.destroyObject(note.clones[0]);
				return dood;
			}
			else
				return true;
		}
		else
		{
			if (FlxG.save.data.downscroll)
				return note.y > FlxG.height;
			else
				return note.y < -note.height;
		}
	}

	public static function onGoodNoteHit(note:Note):Void
	{
		if (PlayState.storyDifficulty != 0
			&& note.strumTime >= 115200
			&& (note.strumTime < 134400 || (note.strumTime < 134500 && note.mustPress))
			&& note.spec == 0)
		{
			PlayState.playstate.destroyObject(note.clones[0]);
		}
		else if (note.strumTime >= 172800 && !note.mustPress)
			PlayState.playstate.changeHealth(-0.023);
	}

	public static function cloneNote(note:Note)
	{
		if (note.strumTime >= 115200
			&& (note.strumTime < 134400 || (note.strumTime < 134500 && note.mustPress))
			&& note.spec == 0)
		{
			var clone = new Note(note.strumTime, note.noteData, note.prevNote, note.synced, note.isSustainNote, note.isEnd);
			clone.scrollFactor.set();
			clone.visible = false;
			clone.isClone = true;
			note.clones.push(clone);
			PlayState.playstate.addObject(clone);
		}
	}

	public static function updateSpecialReceptors(state:PlayState)
	{
		if (Conductor.songPosition >= 38100 && generatedPhase < 1)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 0);
				ar.alpha = 0;
			}
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 1);
				ar.alpha = 0;
			}
			generatedPhase = 1;
		}
		if (Conductor.songPosition >= 57400 && generatedPhase < 2)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 2);
			}
			generatedPhase = 2;
		}
		if (Conductor.songPosition >= 76500 && generatedPhase < 3)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 0);
				ar.y = -200;
			}
			var ar:NoteStrum = state.generateStaticArrow(1, 2, "null", -1);
			ar.y = -200;
			var ar:NoteStrum = state.generateStaticArrow(0, 0, "null", -2);
			ar.y = -200;
			generatedPhase = 3;
		}
		if (Conductor.songPosition > 96000 && generatedPhase < 4)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(0, i, "null", 0);
				ar.y = -200;
				var ar:NoteStrum = state.generateStaticArrow(0, i, "null", 1);
				ar.alpha = 0;
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 1);
				ar.alpha = 0;
			}
			var ar:NoteStrum = state.generateStaticArrow(0, 2, "null", -1);
			ar.y = -200;
			generatedPhase = 4;
		}
		if (Conductor.songPosition > 112800 && generatedPhase < 5)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(0, i, "null", 2);
				ar.y = -200;
				ar = state.generateStaticArrow(1, i, "null", 2);
				ar.y = -200;
				ar = state.generateStaticArrow(0, i, "null", 3);
				ar.y = -200;
				ar = state.generateStaticArrow(1, i, "null", 3);
				ar.y = -200;
				ar = state.generateStaticArrow(1, i, "null", 4);
				ar.alpha = 0;
			}
			generatedPhase = 5;
		}
		if (Conductor.songPosition > 134300 && generatedPhase < 6)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 0);
				ar.alpha = 0;
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 1);
				ar.alpha = 0;
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 5);
				ar.alpha = 0;
			}
			generatedPhase = 6;
		}
		if (Conductor.songPosition > 153500 && generatedPhase < 7)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 2);
				ar.alpha = 0;
			}
			generatedPhase = 7;
		}
		if (Conductor.songPosition > 172700 && generatedPhase < 8)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(0, i, "null", 0);
				ar.alpha = 0;
			}
			generatedPhase = 8;
		}
	}

	public static function onBeatHit(curBeat:Int)
	{
		if (curBeat == 319)
			PlayState.playstate.dad.playAnim("singPOSE1", true);
		if (curBeat == 336)
			PlayState.playstate.dad.playAnim("singPOSE2", true);
		if (curBeat == 368)
			PlayState.playstate.dad.playAnim("singPOSE2", true);
		if (curBeat == 383)
			PlayState.playstate.dad.playAnim("singPOSE1", true);
	}
	static function applyNotesBefore38100(note:Note):Void
	{
		if (!note.mustPress)
		{
			note.alpha = note.isSustainNote ? 0.48 : 0.8;
		}
		if (note.isSustainNote)
		{
			note.z = (note.strumTime - Conductor.songPosition) * 2.5;
			var len:Float = Conductor.stepCrochet;
			if (!note.animation.curAnim.name.endsWith('hold'))
			{
				len /= ModchartMath.sustainScale();
			}
			note.renderer = new R_peace(0, [
				note.strumTime - Conductor.stepCrochet,
				note.strumTime - Conductor.stepCrochet + len,
				note.width,
				note.noteData,
				note.sustainOrder
			]);
			if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet
				&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
				note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / len;
			note.pathrender();
		}
		else
		{
			note.wy = 360 + Math.sin(Conductor.songPosition / 1200 * Math.PI) * 200;
			note.wx = 100 + note.noteData * 360 + Math.cos(note.strumTime / 1200 * Math.PI) * 100;
			note.z = (note.strumTime - Conductor.songPosition) * 2.5;
			if (note.isEnd)
			{
				note.wy = 360 + Math.sin((Conductor.songPosition + note.sustainLength * Conductor.stepCrochet) / 1200 * Math.PI) * 200;
				note.offsetWhenDraw = false;
			}
			note.scaleW();
		}
	}

	static function applyNotesFrom38100(note:Note):Void
	{
		if (!note.mustPress)
		{
			note.alpha = note.isSustainNote ? 0.48 : 0.8;
		}

		if (note.isSustainNote)
		{
			note.z = 250 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
			var len:Float = Conductor.stepCrochet;
			if (!note.animation.curAnim.name.endsWith('hold'))
			{
				len /= ModchartMath.sustainScale();
			}
			note.renderer = new R_peace(1, [
				note.strumTime - Conductor.stepCrochet,
				note.strumTime - Conductor.stepCrochet + len,
				note.width,
				note.noteData,
				note.spec
			]);
			if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet
				&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
				note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / len;
			note.pathrender();
		}
		else if (note.spec == 0)
		{
			var x:Float = 280 + note.noteData * 240;
			var y:Float = 600
				+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()) * FlxMath.SQUARE_ROOT_OF_TWO;
			var abc = NoteObject.triangles(x - note.width / 2, y - note.height / 2, 250, note.width, note.height, -45, 0, 0, x, 600, 250, false);
			note.z = 250 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
			note.render(abc[0], abc[1]);
		}
		else
		{
			note.z = 250 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
			note.wx = 640 + Math.cos(note.strumTime / 600 * Math.PI) * 500;
			note.wy = 400
				+ Math.sin(note.strumTime / 600 * Math.PI) * 200
				+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
			if (note.strumTime >= 48000)
			{
				note.wx = 640 + Math.cos(note.strumTime / 600 * Math.PI) * 500;
				note.wy = 400
					+ Math.sin(note.strumTime / 300 * Math.PI) * 200
					+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
			}
			if (note.isEnd)
			{
				note.offsetWhenDraw = false;
			}
			note.scaleW();
		}
	}

	static function applyNotesFrom57600(note:Note):Void
	{
		if (!note.mustPress)
		{
			note.alpha = note.isSustainNote ? 0.36 : 0.6;
		}
		var cang:Float = 0.125 + 0.25 * note.noteData;
		if (Conductor.songPosition >= 67200)
			cang += Conductor.songPosition / 1200;
		note.z = 200 + 640 * Math.sin(cang * Math.PI);
		if (note.isSustainNote)
		{
			var len:Float = Conductor.stepCrochet;
			if (!note.animation.curAnim.name.endsWith('hold'))
			{
				len /= ModchartMath.sustainScale();
			}
			note.renderer = new R_peace(2, [
				1,
				note.strumTime - Conductor.stepCrochet,
				note.strumTime - Conductor.stepCrochet + len,
				note.width,
				cang,
				((Conductor.songPosition > note.strumTime - Conductor.stepCrochet
					&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit)))) ? 1 : 0)
			]);
			note.pathrender();
		}
		else
		{
			note.renderer = new R_peace(2, [0, note.strumTime, note.width, note.height, cang]);
			note.pathrender();
		}
	}

	static function applyNotesFrom76800(note:Note):Void
	{
		if (!note.mustPress)
		{
			note.alpha = note.isSustainNote ? 0.48 : 0.8;
		}
		note.visible = true;
		var ang:Float = 0;
		var anglist:Array<Float> = [-90, 180, 0, 90];

		if (Conductor.songPosition < 76800)
			ang = (76800 - Conductor.songPosition) / 300 * 180;
		if (Conductor.songPosition >= 86700)
		{
			if (Conductor.songPosition % 300 < 50)
				ang = (Math.floor(Conductor.songPosition / 300) - 1 + (Conductor.songPosition % 300) / 50) * 380 / 16;
			else
				ang = Math.floor(Conductor.songPosition / 300) * 380 / 16;
		}

		if (note.spec == 1)
		{
			if (note.mustPress)
				note.visible = Conductor.songPosition >= 90900;
			else
				note.visible = note.strumTime - Conductor.songPosition < 300;
			note.x = 640 - note.width / 2;
			note.y = 260 - note.height / 2;
		}
		else if (note.isSustainNote)
		{
			var len:Float = Conductor.stepCrochet;
			if (!note.animation.curAnim.name.endsWith('hold'))
			{
				len /= ModchartMath.sustainScale();
			}
			var sdist = -(Conductor.songPosition - note.strumTime + Conductor.stepCrochet) * (ModchartMath.scrollSpeed()) / 2;
			var edist = -(Conductor.songPosition - note.strumTime + Conductor.stepCrochet - len) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
				2)) / 2;
			ang = ang + anglist[note.noteData];

			note.renderer = new RenderPath(1, [
				sdist,
				edist,
				640 + 300 * Math.sin(ang / 180 * Math.PI),
				360 - 300 * Math.cos(ang / 180 * Math.PI),
				note.width * 0.7,
				ang,
				300
			]);
			if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet
				&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
				note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / len;
			note.pathrender();
		}
		else
		{
			var dis:Float = 300 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()) / 2;
			note.angle = ang;

			ang = ang + anglist[note.noteData];
			note.x = 640 + Math.sin(ang / 180 * Math.PI) * dis - note.width / 2;
			note.y = 360 - Math.cos(ang / 180 * Math.PI) * dis - note.height / 2;

			if (dis < 0)
				note.visible = false;
		}
	}

	static function applyNotesFrom96000(note:Note):Void
	{
		var ang:Float = 0;
		if (Conductor.songPosition >= 105600)
			ang = Conductor.songPosition / 1200 * 360;
		else if (Conductor.songPosition >= 96000)
			ang = Conductor.songPosition / 2400 * 360;

		note.wy = NoteObject.toWorld(640,
			FlxG.save.data.downscroll ? (450 + Note.noteHeight[note.noteData] / 2) : (150 + Note.noteHeight[note.noteData] / 2))[1];
		var cx = NoteObject.toWorld(note.mustPress ? 1040 : 240, 360)[0];
		var dx:Float = 0;
		var adj:Bool = true;

		if (note.spec == 3)
		{
			if (!note.mustPress)
			{
				if (Conductor.songPosition >= 105300)
				{
					note.visible = true;
					adj = false;
					note.angle = (-540 + 540 * (Conductor.songPosition % 300) / 300) * (FlxG.save.data.downscroll ? 1 : -1);
					var x = (Conductor.songPosition % 300) / 50;
					note.wy += (-x * x + 6 * x) * 50 / 3 * (FlxG.save.data.downscroll ? -1 : 1);
					var ex = NoteObject.toWorld(1040, 360)[0];
					note.wx = FlxMath.lerp(ex + 240, cx - 240, (Conductor.songPosition - 105300) / 300);
					note.z = 200 / 0.7 + Math.sin(ang / 180 * Math.PI) * (-100 + (Conductor.songPosition - 105300) / 3 * 2);
				}
				else if (Conductor.songPosition >= 94800 && note.strumTime < 105300)
				{
					note.visible = true;
					if (Conductor.songPosition < 94900)
					{
						dx = -240 - note.width + note.width * (Conductor.songPosition - 83900) / 100;
						note.wy = NoteObject.toWorld(640, 300 + Note.noteHeight[note.noteData] / 2)[1];
					}
					else if (Conductor.songPosition < 95100)
					{
						dx = -240;
						note.wy = NoteObject.toWorld(640, 300 + Note.noteHeight[note.noteData] / 2)[1];
					}
					else if (Conductor.songPosition < 95700)
					{
						dx = -240;
						note.angle = 360 * (Conductor.songPosition % 150) / 150;
						note.wy = NoteObject.toWorld(640, 300 + Note.noteHeight[note.noteData] / 2)[1];
					}
					else
					{
						dx = -240;
						note.angle = 360 * (Conductor.songPosition % 150) / 150;
						var x = (Conductor.songPosition - 95700) / 50;
						note.wy = NoteObject.toWorld(640,
							(-0.485702260396 * x * x + 2.41421356237 * x) * 50 * (FlxG.save.data.downscroll ? -1 : 1) + 300 +
							Note.noteHeight[note.noteData] / 2)[1];
					}
				}
				else
					note.visible = false;
			}
			else
			{
				if (Conductor.songPosition >= 110100)
				{
					note.visible = true;
					adj = false;
					note.angle = (-540 + 540 * (Conductor.songPosition % 300) / 300) * (FlxG.save.data.downscroll ? -1 : 1);
					var x = (Conductor.songPosition % 300) / 50;
					note.wy += (-x * x + 6 * x) * 50 / 3 * (FlxG.save.data.downscroll ? -1 : 1);
					var ex = NoteObject.toWorld(240, 360)[0];
					note.wx = FlxMath.lerp(ex + 240, cx - 240, (Conductor.songPosition - 110100) / 300);
					note.z = 200 / 0.7 + Math.sin(ang / 180 * Math.PI) * (-100 + (Conductor.songPosition - 110100) / 3 * 2);
				}
				else if (Conductor.songPosition >= 100500 && note.strumTime < 110100)
				{
					note.visible = true;
					adj = false;
					note.angle = (-540 + 540 * (Conductor.songPosition % 300) / 300) * (FlxG.save.data.downscroll ? -1 : 1);
					var x = (Conductor.songPosition % 300) / 50;
					note.wy += (-x * x + 6 * x) * 50 / 3 * (FlxG.save.data.downscroll ? -1 : 1);
					var ex = NoteObject.toWorld(240, 360)[0];
					note.wx = FlxMath.lerp(ex + 240, cx - 240, (Conductor.songPosition - 100500) / 300);
					note.z = 200 / 0.7 + Math.sin(ang / 180 * Math.PI) * (-100 + (Conductor.songPosition - 100500) / 3 * 2);
				}
				else
					note.visible = false;
			}
		}
		else if (note.spec == 0)
		{
			dx = 160 * (note.noteData - 1.5);
			if ((Conductor.songPosition >= 96000 && Conductor.songPosition < 100800 && !note.mustPress)
				|| (Conductor.songPosition >= 100800 && Conductor.songPosition < 105600 && note.mustPress)
				|| (Conductor.songPosition >= 105600 && Conductor.songPosition < 110400 && !note.mustPress)
				|| (Conductor.songPosition >= 110400 && Conductor.songPosition < 115200 && note.mustPress))
			{
				var x = (Conductor.songPosition % 300) / 50;
				note.wy += (-x * x + 6 * x) * 100 / 6.3 * (FlxG.save.data.downscroll ? 1 : -1);
			}
			if (FlxG.save.data.downscroll)
				note.wy += (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
			else
				note.wy -= (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
		}
		else
		{
			if (((Conductor.songPosition >= 96000 && Conductor.songPosition < 100500)
				|| (Conductor.songPosition >= 105600 && Conductor.songPosition < 110100))
				&& !note.mustPress)
			{
				note.visible = true;
				if (Conductor.songPosition % 600 < 300)
				{
					note.animation.play('redsync');
					dx = -240 + (Conductor.songPosition % 300) / 300 * 480;
					note.angle = (540 - 540 * (Conductor.songPosition % 300) / 300) * (FlxG.save.data.downscroll ? -1 : 1);
				}
				else
				{
					note.animation.play('purplesync');
					dx = 240 - (Conductor.songPosition % 300) / 300 * 480;
					note.angle = (-540 + 540 * (Conductor.songPosition % 300) / 300) * (FlxG.save.data.downscroll ? -1 : 1);
				}
				var x = (Conductor.songPosition % 300) / 50;
				note.wy += (-x * x + 6 * x) * 50 / 3 * (FlxG.save.data.downscroll ? -1 : 1);
			}
			else if (((Conductor.songPosition >= 100800 && Conductor.songPosition < 105300) || Conductor.songPosition >= 110400)
				&& note.mustPress)
			{
				note.visible = true;
				if (Conductor.songPosition % 600 < 300)
				{
					note.animation.play('redsync');
					dx = -240 + (Conductor.songPosition % 300) / 300 * 480;
					note.angle = (540 - 540 * (Conductor.songPosition % 300) / 300) * (FlxG.save.data.downscroll ? -1 : 1);
				}
				else
				{
					note.animation.play('purplesync');
					dx = 240 - (Conductor.songPosition % 300) / 300 * 480;
					note.angle = (-540 + 540 * (Conductor.songPosition % 300) / 300) * (FlxG.save.data.downscroll ? -1 : 1);
				}
				var x = (Conductor.songPosition % 300) / 50;
				if (Conductor.songPosition < 114900)
					note.wy += (-x * x + 6 * x) * 50 / 3 * (FlxG.save.data.downscroll ? -1 : 1);
			}
			else
				note.visible = false;
		}
		if (adj)
		{
			note.wx = 640 + Math.cos(ang / 180 * Math.PI) * (cx - 640);
			note.wx += dx;
			note.z = 200 / 0.7 + Math.sin(ang / 180 * Math.PI) * (note.mustPress ? 100 : -100);
		}
		note.scaleW();
		if (note.spec != 0)
			note.z -= 1;
	}

	static function applyNotesFrom115200(note:Note):Void
	{
		if (note.spec == 0)
		{
			var tx:Float = Conductor.songPosition % 300;
			var x:Float = (tx >= 150 ? tx - 300 : tx) / 50;
			note.z = (-0.1 * x * x * x + 0.233333333333 * x) * 100 + 200;
			if (tx < 150)
				note.z += 400;
			if (Conductor.songPosition < 115200)
				note.z += Math.floor((115200 - Conductor.songPosition) / 1200) * 1600;
			note.wx = NoteObject.toWorld((note.mustPress ? PlayMoving.defaultPlayerReceptorX[note.noteData] : PlayMoving.defaultOpponentReceptorX[note.noteData])
				+ Note.noteWidth[note.noteData] / 2,
				360)[0];
			note.wy = NoteObject.toWorld(640, (FlxG.save.data.downscroll ? 550 : 50) + Note.noteHeight[note.noteData] / 2)[1];
			note.wy += (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
				2)) / (FlxG.save.data.downscroll ? 0.7 : -0.7);
			note.z += 400 * (1 - (Math.floor(Conductor.songPosition / 300) % 2)) - 200;
			if (note.mustPress && Conductor.songPosition % 1200 >= 600)
				note.z += 800;
			if (!note.mustPress && Conductor.songPosition % 1200 < 600)
				note.z += 800;

			if (Conductor.songPosition > 124800)
			{
				if (note.isEnd && Conductor.songPosition < note.strumTime)
				{
					var sum:Float = note.sustainLength * 300 / 4;
					var len:Float = 0;
					if (Conductor.songPosition > note.strumTime - note.sustainLength * 300 / 4)
						len = Conductor.songPosition - note.strumTime + note.sustainLength * 300 / 4;
					len = (sum - len) / sum;
					var diff = 100 * Math.sin(((Conductor.songPosition + 150 - 150 * len) % 300) / 300 * Math.PI);
					if ((Conductor.songPosition % 300) / 300 >= (len + 1) / 2)
						diff = 0;
					switch (note.noteData)
					{
						case 0:
							note.wx -= diff;
						case 1:
							note.wy += diff;
						case 2:
							note.wy -= diff;
						case 3:
							note.wx += diff;
					}
				}
				else if (Conductor.songPosition % 300 <= 150)
				{
					var diff = 100 * Math.cos((Conductor.songPosition % 150) / 300 * Math.PI);
					switch (note.noteData)
					{
						case 0:
							note.wx -= diff;
						case 1:
							note.wy += diff;
						case 2:
							note.wy -= diff;
						case 3:
							note.wx += diff;
					}
				}
			}

			if (note.isEnd)
			{
				note.offsetWhenDraw = false;
				note.clones[0].offsetWhenDraw = false;
			}

			if (note.isSustainNote)
			{
				var len:Float = Conductor.stepCrochet;
				if (!note.animation.curAnim.name.endsWith('hold'))
				{
					len /= ModchartMath.sustainScale();
				}
				note.renderer = new R_peace(3, [
					note.strumTime - Conductor.stepCrochet,
					note.strumTime - Conductor.stepCrochet + len,
					note.width,
					note.noteData,
					note.mustPress ? 1 : 0,
					note.z,
					note.sustainOrder,
					note.sustainLength
				]);
				if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet
					&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
					note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / len;
				note.pathrender();

				if (note.strumTime - Conductor.songPosition <= 1500)
				{
					note.clones[0].renderer = new R_peace(3, [
						note.strumTime - Conductor.stepCrochet,
						note.strumTime - Conductor.stepCrochet + len,
						note.width,
						note.noteData,
						note.mustPress ? 1 : 0,
						note.z + 1600
					]);
					note.clones[0].renderer.pathRatio = note.renderer.pathRatio;
					note.clones[0].pathrender();
				}
			}
			else
			{
				note.scaleW();

				if (note.strumTime - Conductor.songPosition <= 1500)
				{
					note.clones[0].visible = true;
					note.clones[0].alpha = note.alpha;
					note.clones[0].wx = note.wx;
					note.clones[0].wy = note.wy;
					note.clones[0].z = note.z + 1600;
					note.clones[0].scaleW();
				}
			}
		}
		else
		{
			note.alpha = note.mustPress ? 1 : 0.6;
			note.visible = note.mustPress ? (note.noteData == 1 ? ((Conductor.songPosition >= 119400 && note.strumTime < 126000)
				|| Conductor.songPosition >= 129000) : ((Conductor.songPosition >= 119700 && note.strumTime < 126000)
					|| Conductor.songPosition >= 129300)) : (note.strumTime - Conductor.songPosition <= 600);
			note.wy = 360;
			note.wx = 640 + 250 * Math.cos(note.strumTime / 300 * Math.PI);
			note.z = 200 / 0.7 - 100 * Math.sin(note.strumTime / 300 * Math.PI);
			note.scaleW();
		}
	}

	static function applyNotesFrom134400(note:Note):Void
	{
		if (!note.mustPress)
		{
			note.alpha = note.isSustainNote ? 0.48 : 0.8;
		}

		if (note.isSustainNote)
		{
			note.z = 250 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
			var len:Float = Conductor.stepCrochet;
			if (!note.animation.curAnim.name.endsWith('hold'))
			{
				len /= ModchartMath.sustainScale();
			}
			note.renderer = new R_peace(1, [
				note.strumTime - Conductor.stepCrochet,
				note.strumTime - Conductor.stepCrochet + len,
				note.width,
				note.noteData,
				note.spec
			]);
			if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet
				&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
				note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / len;
			note.pathrender();
		}
		else if (note.spec == 0)
		{
			var x:Float = 280 + note.noteData * 240;
			var y:Float = 600
				+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()) * FlxMath.SQUARE_ROOT_OF_TWO;
			var abc = NoteObject.triangles(x - note.width / 2, y - note.height / 2, 250, note.width, note.height, -45, 0, 0, x, 600, 250, false);
			note.z = 250 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
			note.render(abc[0], abc[1]);
		}
		else
		{
			note.z = 250 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
			note.wx = 340 + Math.cos(note.strumTime / 600 * Math.PI) * 200;
			note.wy = 400
				+ Math.sin(note.strumTime / 600 * Math.PI) * 200
				+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
			if (note.spec == 2)
			{
				note.wx = 940 - Math.cos(note.strumTime / 600 * Math.PI) * 200;
			}
			if (note.isEnd)
			{
				note.offsetWhenDraw = false;
			}
			note.scaleW();
		}
	}

	static function applyNotesFrom153600(note:Note):Void
	{
		if (!note.mustPress)
		{
			note.alpha = note.isSustainNote ? 0.48 : 0.8;
		}

		var ang:Float = (Conductor.songPosition / 2400) * 360;
		var anglist:Array<Float> = [-90, 180, 0, 90];

		if (note.isSustainNote)
		{
			var len:Float = Conductor.stepCrochet;
			if (!note.animation.curAnim.name.endsWith('hold'))
			{
				len /= ModchartMath.sustainScale();
			}

			note.renderer = new R_peace(4, [
				note.strumTime - Conductor.stepCrochet,
				note.strumTime - Conductor.stepCrochet + len,
				note.width * 0.7,
				anglist[note.noteData]
			]);
			if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet
				&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
				note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / len;
			note.pathrender();
		}
		else
		{
			var dis:Float = 300 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()) / 2;

			var x:Float = 640 + Math.sin(anglist[note.noteData] / 180 * Math.PI) * dis - note.width * 0.35;
			var y:Float = 360 - Math.cos(anglist[note.noteData] / 180 * Math.PI) * dis - note.height * 0.35;
			var z:Float = 200 + 360 * Math.sin(Math.PI / 12);

			var abc = NoteObject.multiTriangles(x, y, z, note.width * 0.7, note.height * 0.7, [0, -15, 0], [0, 0, 0], [ang, 0, -ang], [640, 640, 640],
				[360, 360, 360], [z, z, z]);
			note.render(abc[0], abc[1]);

			if (dis < 0)
				note.visible = false;
		}
	}

	static function applyNotesFrom172800(note:Note):Void
	{
		note.z = 1000 - 100 * (note.strumTime - Conductor.songPosition) / 300;

		note.alpha = note.isSustainNote ? 0.48 : 0.8;

		if (note.isSustainNote)
		{
			var len:Float = Conductor.stepCrochet;
			if (!note.animation.curAnim.name.endsWith('hold'))
			{
				len /= ModchartMath.sustainScale();
			}

			note.renderer = new R_peace(5, [
				note.strumTime - Conductor.stepCrochet,
				note.strumTime - Conductor.stepCrochet + len,
				note.width
			]);
			if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet
				&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
				note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / len;
			note.pathrender();
		}
		else
		{
			var dis:Float = (note.strumTime - Conductor.songPosition) * (ModchartMath.scrollSpeed()) / 4;
			var ang:Float = (note.strumTime - Conductor.songPosition) / 600;

			note.wx = 640 + Math.cos(ang * Math.PI) * dis;
			note.wy = 360 + Math.sin(ang * Math.PI) * dis;
			note.scaleW();
		}
	}

	static function applyStrumsFrom38100(receptor:NoteStrum):Void
	{
		if (receptor.spec == 0)
		{
			if (Conductor.songPosition < 38200)
				receptor.alpha = (Conductor.songPosition - 38100) / 100;
			else
				receptor.alpha = 1;
			var x:Float = 280 + receptor.ID * 240;
			var y:Float = 600;
			var w = receptor.width;
			var h = receptor.height;
			if (receptor.animation.curAnim.name == 'confirm')
			{
				w *= 238 / 157;
				h *= 235 / 154;
			}
			var abc = NoteObject.triangles(x - w / 2, y - h / 2, 250, w, h, -45, 0, 0, x, 600, 250, false);
			receptor.z = 250;
			receptor.render(abc[0], abc[1]);
			receptor.z = 99999;
		}
		else
		{
			if (Conductor.songPosition < 38200)
				receptor.alpha = (Conductor.songPosition - 38100) / 1000;
			else
				receptor.alpha = 0.1;
			receptor.z = 250;
			receptor.wx = 640 + Math.cos(Conductor.songPosition / 600 * Math.PI) * 500;
			receptor.wy = 400 + Math.sin(Conductor.songPosition / 600 * Math.PI) * 200;
			if (Conductor.songPosition >= 48000)
			{
				receptor.wx = 640 + Math.cos(Conductor.songPosition / 600 * Math.PI) * 500;
				receptor.wy = 400 + Math.sin(Conductor.songPosition / 300 * Math.PI) * 200;
			}
			receptor.scaleW();
		}
	}

	static function applyStrumsFrom76500(receptor:NoteStrum):Void
	{
		var r:Float = 300;
		receptor.alpha = 1;
		if (Conductor.songPosition < 76800)
		{
			r = 300 * (Conductor.songPosition - 76500) / 300;
			receptor.alpha = (Conductor.songPosition - 76500) / 300;
		}
		var ang:Float = 0;
		var anglist:Array<Float> = [-90, 180, 0, 90];

		if (Conductor.songPosition < 76800)
			ang = (76800 - Conductor.songPosition) / 300 * 180;
		if (Conductor.songPosition >= 86700)
		{
			if (Conductor.songPosition % 300 < 50)
				ang = (Math.floor(Conductor.songPosition / 300) - 1 + (Conductor.songPosition % 300) / 50) * 380 / 16;
			else
				ang = Math.floor(Conductor.songPosition / 300) * 380 / 16;
		}

		if (receptor.spec == 0)
		{
			receptor.angle = ang;

			ang = ang + anglist[receptor.ID];
			receptor.x = 640 + Math.sin(ang / 180 * Math.PI) * r - receptor.width / 2;
			receptor.y = 360 - Math.cos(ang / 180 * Math.PI) * r - receptor.height / 2;
		}
		else if (receptor.spec == -1)
		{
			ang = 0;

			if (Conductor.songPosition >= 86400)
				ang = Conductor.songPosition / 150 * 180;

			receptor.angle = ang;
			receptor.x = 640 + Math.sin(ang / 180 * Math.PI) * r / 3 - receptor.width / 2;
			receptor.y = 360 - Math.cos(ang / 180 * Math.PI) * r / 3 - receptor.height / 2;
		}
		else if (receptor.spec == -2)
		{
			var x:Float = 190;
			var y:Float = 360;
			var w = receptor.width * 0.7;
			var h = receptor.height * 0.7;
			ang = 0;
			if (Conductor.songPosition < 76800)
				x = 190 - (190 + receptor.width) * (76800 - Conductor.songPosition) / 300;
			else if (Conductor.songPosition >= 87000)
				receptor.mustBeKilled = true;
			else if (Conductor.songPosition >= 86700)
				x = 190 - (190 + receptor.width) * (Conductor.songPosition - 86700) / 300;
			else
			{
				if (Conductor.songPosition % 1200 < 200)
					ang = (Conductor.songPosition % 1200) / 200 * 180;
			}
			var abc = NoteObject.triangles(x - w / 2, y - h / 2, 200 / 0.7, w, h, ang, 0, 0, 240, 360, 200 / 0.7);
			receptor.render(abc[0], abc[1]);
		}
	}

	static function applyStrumsFrom96000(receptor:NoteStrum):Void
	{
		var bang:Float = 0;
		if (Conductor.songPosition >= 105600)
			bang = Conductor.songPosition / 1200 * 360;
		else if (Conductor.songPosition >= 96000)
			bang = Conductor.songPosition / 2400 * 360;

		if (receptor.spec == 0)
		{
			if (receptor.player == 1)
				receptor.mustBeKilled = true;
			var ang:Float = 0;
			if (Conductor.songPosition % 300 < 50)
				ang = (Math.floor(Conductor.songPosition / 300) - 1 + (Conductor.songPosition % 300) / 50) * 380 / 16;
			else
				ang = Math.floor(Conductor.songPosition / 300) * 380 / 16;

			var x = 640 - receptor.width * 0.7 / 2;
			var y = 360 - receptor.height * 0.7 / 2;
			switch (receptor.ID)
			{
				case 0:
					x -= 300;
				case 1:
					y += 300;
				case 2:
					y -= 300;
				case 3:
					x += 300;
			}
			var w = receptor.width * 0.7;
			var h = receptor.height * 0.7;

			var ppp:Float = 45;
			if (Conductor.songPosition < 96100)
			{
				ppp = (Conductor.songPosition - 96000) * 45 / 100;
				receptor.alpha = 1 - (Conductor.songPosition - 96000) / 200;
			}

			var abc = NoteObject.multiTriangles(x, y, 200 / 0.7, w, h, [0, ppp, 0], [0, 0, bang], [ang, 0, 0], [640, 640, 640], [360, 360, 360],
				[200 / 0.7, 200 / 0.7, 200 / 0.7]);
			receptor.z = NoteObject.multiWorldSpin(x + receptor.width * 0.7 / 2, y + 260 - receptor.height * 0.7 / 2, 200 / 0.7, [0, ppp, 0], [0, 0, bang],
				[ang, 0, 0], [640, 640, 640], [360, 360, 360], [200 / 0.7, 200 / 0.7, 200 / 0.7])[1][0];
			receptor.render(abc[0], abc[1]);
		}
		else if (receptor.spec == -1)
		{
			if (receptor.player == 1)
				receptor.mustBeKilled = true;
			var ang = (Conductor.songPosition - 96000) * 45 / 100;

			var x = 640 - receptor.width * 0.7 / 2;
			var y = 260 - receptor.height * 0.7 / 2;
			var w = receptor.width * 0.7;
			var h = receptor.height * 0.7;

			var ppp:Float = 45;
			if (Conductor.songPosition < 96100)
			{
				ppp = Conductor.songPosition - 96000;
				receptor.alpha = 1 - (Conductor.songPosition - 96000) / 200;
			}

			var abc = NoteObject.multiTriangles(x, y, 200 / 0.7, w, h, [0, ppp, 0], [0, 0, bang], [ang, 0, 0], [640, 640, 640], [360, 360, 360],
				[200 / 0.7, 200 / 0.7, 200 / 0.7]);
			receptor.z = NoteObject.multiWorldSpin(x + receptor.width * 0.7 / 2, y + 260 - receptor.height * 0.7 / 2, 200 / 0.7, [0, ppp, 0], [0, 0, bang],
				[ang, 0, 0], [640, 640, 640], [360, 360, 360], [200 / 0.7, 200 / 0.7, 200 / 0.7])[1][0];
			receptor.render(abc[0], abc[1]);
		}
		else
		{
			if (Conductor.songPosition < 96100)
				receptor.alpha = (Conductor.songPosition - 96000) / 100;
			else
				receptor.alpha = 1;
			receptor.wy = NoteObject.toWorld(640,
				FlxG.save.data.downscroll ? (450 + Note.noteHeight[receptor.ID] / 2) : (150 + Note.noteHeight[receptor.ID] / 2))[1];
			if ((Conductor.songPosition >= 96000 && Conductor.songPosition < 100800 && receptor.player == 0)
				|| (Conductor.songPosition >= 100800 && Conductor.songPosition < 105600 && receptor.player == 1)
				|| (Conductor.songPosition >= 105600 && Conductor.songPosition < 110400 && receptor.player == 0)
				|| (Conductor.songPosition >= 110400 && Conductor.songPosition < 115200 && receptor.player == 1))
			{
				var x = (Conductor.songPosition % 300) / 50;
				receptor.wy += (-x * x + 6 * x) * 100 / 6.3 * (FlxG.save.data.downscroll ? 1 : -1);
			}
			var cx = NoteObject.toWorld(receptor.player == 1 ? 1040 : 240, 360)[0];
			var dx = 160 * (receptor.ID - 1.5);
			receptor.wx = 640 + Math.cos(bang / 180 * Math.PI) * (cx - 640);
			receptor.wx += dx;
			receptor.z = 200 / 0.7 + Math.sin(bang / 180 * Math.PI) * (receptor.player == 1 ? 100 : -100);
			receptor.scaleW();
		}

		if (Conductor.songPosition >= 115200)
		{
			receptor.alpha = (115300 - Conductor.songPosition) / 100;
			if (receptor.spec < 1)
				receptor.alpha *= -1;
			if (Conductor.songPosition >= 115300)
				receptor.mustBeKilled = true;
		}
	}

	static function applyStrumsFrom112800(receptor:NoteStrum):Void
	{
		if (receptor.spec < 4)
		{
			if (Conductor.songPosition > 134300)
			{
				receptor.alpha = (134400 - Conductor.songPosition) / 100;
				if (Conductor.songPosition > 134400)
					receptor.mustBeKilled = true;
			}
			var tx:Float = Conductor.songPosition % 300;
			var x:Float = (tx >= 150 ? tx - 300 : tx) / 50;
			receptor.z = (-0.1 * x * x * x + 0.233333333333 * x) * 100 + 200;
			if (tx < 150)
				receptor.z += 400;
			if (Conductor.songPosition < 115200)
				receptor.z += Math.floor((115200 - Conductor.songPosition) / 1200) * 1600;
			receptor.wx = NoteObject.toWorld((receptor.player == 1 ? PlayMoving.defaultPlayerReceptorX[receptor.ID] : PlayMoving.defaultOpponentReceptorX[receptor.ID])
				+ Note.noteWidth[receptor.ID] / 2, 360)[0];
			receptor.wy = NoteObject.toWorld(640, (FlxG.save.data.downscroll ? 550 : 50) + Note.noteHeight[receptor.ID] / 2)[1];

			if (Conductor.songPosition > 124800)
			{
				if (Conductor.songPosition % 300 <= 150)
				{
					var diff = 100 * Math.cos((Conductor.songPosition % 150) / 300 * Math.PI);
					switch (receptor.ID)
					{
						case 0:
							receptor.wx -= diff;
						case 1:
							receptor.wy += diff;
						case 2:
							receptor.wy -= diff;
						case 3:
							receptor.wx += diff;
					}
				}
			}

			receptor.z += 400 * (1 - (Math.floor(Conductor.songPosition / 300) % 2));
			if (receptor.player == 1 && Conductor.songPosition % 1200 >= 600)
				receptor.z += 800;
			if (receptor.player == 0 && Conductor.songPosition % 1200 < 600)
				receptor.z += 800;
			receptor.z += (receptor.spec - 2) * 1600 - 200;
			receptor.scaleW();
		}
		else if (receptor.spec == 4)
		{
			receptor.alpha = 0.2;
			if (Conductor.songPosition > 134300)
			{
				receptor.alpha = (134400 - Conductor.songPosition) / 500;
				if (Conductor.songPosition > 134400)
					receptor.mustBeKilled = true;
			}
			receptor.wy = 360;
			receptor.wx = 640 + 250 * Math.cos(Conductor.songPosition / 300 * Math.PI);
			receptor.z = 200 / 0.7 - 100 * Math.sin(Conductor.songPosition / 300 * Math.PI);
			receptor.scaleW();
		}
	}

	static function applyStrumsFrom134300(receptor:NoteStrum):Void
	{
		if (receptor.spec == 0)
		{
			if (Conductor.songPosition < 134400)
				receptor.alpha = (Conductor.songPosition - 134300) / 100;
			else if (Conductor.songPosition >= 153600)
			{
				receptor.alpha = (153700 - Conductor.songPosition) / 100;
				if (Conductor.songPosition >= 153700)
					receptor.mustBeKilled = true;
			}
			else
				receptor.alpha = 1;
			var x:Float = 280 + receptor.ID * 240;
			var y:Float = 600;
			var w = receptor.width;
			var h = receptor.height;
			if (receptor.animation.curAnim.name == 'confirm')
			{
				w *= 238 / 157;
				h *= 235 / 154;
			}
			var abc = NoteObject.triangles(x - w / 2, y - h / 2, 250, w, h, -45, 0, 0, x, 600, 250, false);
			receptor.z = 250;
			receptor.render(abc[0], abc[1]);
			receptor.z = 99999;
		}
		else
		{
			if (Conductor.songPosition < 134400)
				receptor.alpha = (Conductor.songPosition - 134300) / 1000;
			else if (Conductor.songPosition >= 153600)
			{
				receptor.alpha = (153700 - Conductor.songPosition) / 1000;
				if (Conductor.songPosition >= 153700)
					receptor.mustBeKilled = true;
			}
			else
				receptor.alpha = 0.1;
			receptor.z = 250;
			receptor.wx = 340 + Math.cos(Conductor.songPosition / 600 * Math.PI) * 200;
			receptor.wy = 400 + Math.sin(Conductor.songPosition / 600 * Math.PI) * 200;
			if (receptor.spec == 5)
			{
				receptor.wx = 940 - Math.cos(Conductor.songPosition / 600 * Math.PI) * 200;
			}
			receptor.scaleW();
		}
	}

	static function applyStrumsFrom153500(receptor:NoteStrum):Void
	{
		if (Conductor.songPosition < 153600)
			receptor.alpha = (Conductor.songPosition - 153500) / 100;
		else if (Conductor.songPosition >= 172800)
		{
			receptor.alpha = (172900 - Conductor.songPosition) / 100;
			if (Conductor.songPosition >= 172900)
				receptor.mustBeKilled = true;
		}
		else
			receptor.alpha = 1;

		var ang:Float = (Conductor.songPosition / 2400) * 360;
		var anglist:Array<Float> = [-90, 180, 0, 90];

		var dis:Float = 300;

		var x:Float = 640 + Math.sin(anglist[receptor.ID] / 180 * Math.PI) * dis - receptor.width * 0.35;
		var y:Float = 360 - Math.cos(anglist[receptor.ID] / 180 * Math.PI) * dis - receptor.height * 0.35;
		var w = receptor.width * 0.7;
		var h = receptor.height * 0.7;
		var z:Float = 200 + 360 * Math.sin(Math.PI / 12);

		if (receptor.animation.curAnim.name == 'confirm')
		{
			x -= (238 - 157) / 2 * 0.7;
			y -= (235 - 154) / 2 * 0.7;
			w *= 238 / 157;
			h *= 235 / 154;
		}

		var abc = NoteObject.multiTriangles(x, y, z, w, h, [0, -15, 0], [0, 0, 0], [ang, 0, -ang], [640, 640, 640], [360, 360, 360], [z, z, z]);
		receptor.render(abc[0], abc[1]);
	}

}

class R_peace extends RenderPath
{
	override function start(head:Float, tail:Float):Array<Array<Float>>
	{
		var uvt:Array<Float> = [0, head, 1, head, 0, tail, 1, tail];
		switch (mode)
		{
			case 0: // forward [stime, etime, width, noteData, order]
				var stime:Float = FlxMath.lerp(parameters[0], parameters[1], head);
				var etime:Float = FlxMath.lerp(parameters[0], parameters[1], tail);

				var y1 = 360 + Math.sin((Conductor.songPosition + (parameters[4] + head) * Conductor.stepCrochet) / 1200 * Math.PI) * 200;
				var x1 = 100 + parameters[3] * 360 + Math.cos(stime / 1200 * Math.PI) * 100;
				var z1 = (stime - Conductor.songPosition) * 2.5;

				var y2 = 360 + Math.sin((Conductor.songPosition + (parameters[4] + tail) * Conductor.stepCrochet) / 1200 * Math.PI) * 200;
				var x2 = 100 + parameters[3] * 360 + Math.cos(etime / 1200 * Math.PI) * 100;
				var z2 = (etime - Conductor.songPosition) * 2.5;

				var p0:Array<Float> = NoteObject.toScreen(x1 - parameters[2], y1, z1);
				var p1:Array<Float> = NoteObject.toScreen(x1 + parameters[2], y1, z1);
				var p2:Array<Float> = NoteObject.toScreen(x2 - parameters[2], y2, z2);
				var p3:Array<Float> = NoteObject.toScreen(x2 + parameters[2], y2, z2);

				if (z1 < 0)
					return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
			case 1: // arcaea [stime, etime, width, noteData,spec]
				var stime:Float = FlxMath.lerp(parameters[0], parameters[1], head);
				var etime:Float = FlxMath.lerp(parameters[0], parameters[1], tail);

				if (parameters[4] == 0)
				{
					var x:Float = 280 + parameters[3] * 240;
					var y:Float = 600 + (Conductor.songPosition - stime) * (ModchartMath.scrollSpeed()) * FlxMath.SQUARE_ROOT_OF_TWO;
					var y2 = 600 + (Conductor.songPosition - etime) * (ModchartMath.scrollSpeed()) * FlxMath.SQUARE_ROOT_OF_TWO;
					var p0 = NoteObject.worldSpin(x - parameters[2] / 2, y, 250, -45, 0, 0, x, 600, 250, false);
					var p1 = NoteObject.worldSpin(x + parameters[2] / 2, y, 250, -45, 0, 0, x, 600, 250, false);
					var p2 = NoteObject.worldSpin(x - parameters[2] / 2, y2, 250, -45, 0, 0, x, 600, 250, false);
					var p3 = NoteObject.worldSpin(x + parameters[2] / 2, y2, 250, -45, 0, 0, x, 600, 250, false);
					if (p0[1][0] < 0)
						return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
					return [
						[p0[0][0], p0[0][1], p1[0][0], p1[0][1], p2[0][0], p2[0][1], p3[0][0], p3[0][1]],
						uvt
					];
				}
				else
				{
					var z = 250 - (Conductor.songPosition - stime) * (ModchartMath.scrollSpeed());
					var x = 640 + Math.cos(stime / 600 * Math.PI) * 500;
					var y = 400
						+ Math.sin(stime / 600 * Math.PI) * 200
						+ (Conductor.songPosition - stime) * (ModchartMath.scrollSpeed());

					var z2 = 250 - (Conductor.songPosition - etime) * (ModchartMath.scrollSpeed());
					var x2 = 640 + Math.cos(etime / 600 * Math.PI) * 500;
					var y2 = 400
						+ Math.sin(stime / 600 * Math.PI) * 200
						+ (Conductor.songPosition - etime) * (ModchartMath.scrollSpeed());

					if (stime >= 134400)
					{
						x = 340 + Math.cos(stime / 600 * Math.PI) * 200;
						x2 = 340 + Math.cos(etime / 600 * Math.PI) * 200;
						if (parameters[4] == 2)
						{
							x = 940 - Math.cos(stime / 600 * Math.PI) * 200;
							x2 = 940 - Math.cos(etime / 600 * Math.PI) * 200;
						}
					}
					else if (stime >= 48000)
					{
						x = 640 + Math.cos(stime / 600 * Math.PI) * 500;
						y = 400
							+ Math.sin(stime / 300 * Math.PI) * 200
							+ (Conductor.songPosition - stime) * (ModchartMath.scrollSpeed());
						x2 = 640 + Math.cos(etime / 600 * Math.PI) * 500;
						y2 = 400
							+ Math.sin(etime / 300 * Math.PI) * 200
							+ (Conductor.songPosition - etime) * (ModchartMath.scrollSpeed());
					}
					var p0:Array<Float> = NoteObject.toScreen(x - parameters[2], y, z);
					var p1:Array<Float> = NoteObject.toScreen(x + parameters[2], y, z);
					var p2:Array<Float> = NoteObject.toScreen(x2 - parameters[2], y2, z2);
					var p3:Array<Float> = NoteObject.toScreen(x2 + parameters[2], y2, z2);

					if (z < 0)
						return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
					return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
				}
			case 2: // Circ note:[0,time,width,height,cang] hold:[1,stime,etime,width,cang,cut?] strum:[2,confirm?,width,height,cang]
				// r = 800
				if (parameters[0] == 0)
				{
					var wid = parameters[2];
					var hi = parameters[3];
					if (isSplash)
					{
						wid *= 2;
						hi *= 2;
					}
					var sumang = wid / (640 * Math.PI);
					var sang = parameters[4] - sumang * (0.5 - head);
					sang %= 1;
					var eang = parameters[4] - sumang * (0.5 - tail);
					eang %= 1;
					if (eang < sang)
						eang += 1;
					var y:Float = (FlxG.save.data.downscroll ? 720 : 0)
						+ (Conductor.songPosition - parameters[1]) * (ModchartMath.scrollSpeed()) * (FlxG.save.data.downscroll ? 1 : -1);
					if (isSplash)
						y = (FlxG.save.data.downscroll ? 720 : 0);
					var x1 = 640 - 640 * Math.cos(sang * Math.PI);
					var x2 = 640 - 640 * Math.cos(eang * Math.PI);
					var z1 = 200 + 300 * Math.sin(sang * Math.PI);
					var z2 = 200 + 300 * Math.sin(eang * Math.PI);

					var p0:Array<Float> = NoteObject.toScreen(x1, y - hi / 2, z1);
					var p1:Array<Float> = NoteObject.toScreen(x2, y - hi / 2, z2);
					var p2:Array<Float> = NoteObject.toScreen(x1, y + hi / 2, z1);
					var p3:Array<Float> = NoteObject.toScreen(x2, y + hi / 2, z2);

					uvt = [head, 0, 200 / z1, tail, 0, 200 / z2, head, 1, 200 / z1, tail, 1, 200 / z2];

					return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
				}
				else if (parameters[0] == 1)
				{
					var sumang = parameters[3] / (640 * Math.PI);
					var sang = parameters[4] - sumang * (0.5 - head);
					sang %= 1;
					var eang = parameters[4] - sumang * (0.5 - tail);
					eang %= 1;
					if (eang < sang)
						eang += 1;
					var y1:Float = (FlxG.save.data.downscroll ? 720 : 0)
						+ (Conductor.songPosition - parameters[1]) * (ModchartMath.scrollSpeed()) * (FlxG.save.data.downscroll ? 1 : -1);
					var y2:Float = (FlxG.save.data.downscroll ? 720 : 0)
						+ (Conductor.songPosition - parameters[2]) * (ModchartMath.scrollSpeed()) * (FlxG.save.data.downscroll ? 1 : -1);
					var shead:Float = 0;
					if (parameters[5] == 1)
					{
						shead = (Conductor.songPosition - parameters[1]) / (parameters[2] - parameters[1]);
						y1 = FlxG.save.data.downscroll ? 550 : 50;
						if ((FlxG.save.data.downscroll && y2 > y1) || (!FlxG.save.data.downscroll && y2 < y1))
							return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
					}
					var x1 = 640 - 640 * Math.cos(sang * Math.PI);
					var x2 = 640 - 640 * Math.cos(eang * Math.PI);
					var z1 = 200 + 300 * Math.sin(sang * Math.PI);
					var z2 = 200 + 300 * Math.sin(eang * Math.PI);

					var p0:Array<Float> = NoteObject.toScreen(x1, y1, z1);
					var p1:Array<Float> = NoteObject.toScreen(x2, y1, z2);
					var p2:Array<Float> = NoteObject.toScreen(x1, y2, z1);
					var p3:Array<Float> = NoteObject.toScreen(x2, y2, z2);

					uvt = [
						head, shead, 200 / z1, tail, shead, 200 / z2, head, 1, 200 / z1, tail, 1, 200 / z2
					];

					return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
				}
				else if (parameters[0] == 2)
				{
					var wid = parameters[2];
					var hi = parameters[3];
					if (parameters[1] == 1)
					{
						wid *= (238 / 157);
						hi *= (235 / 154);
					}
					var sumang = wid / (640 * Math.PI);
					var sang = parameters[4] - sumang * (0.5 - head);
					sang %= 1;
					var eang = parameters[4] - sumang * (0.5 - tail);
					eang %= 1;
					if (eang < sang)
						eang += 1;
					var y:Float = FlxG.save.data.downscroll ? 720 : 0;
					if (Conductor.songPosition < 57600)
						y += (57600 - Conductor.songPosition) * (FlxG.save.data.downscroll ? 2 : -2);
					if (Conductor.songPosition >= 76800)
						y += (Conductor.songPosition - 76800) * (FlxG.save.data.downscroll ? 2 : -2);
					var x1 = 640 - 640 * Math.cos(sang * Math.PI);
					var x2 = 640 - 640 * Math.cos(eang * Math.PI);
					var z1 = 200 + 300 * Math.sin(sang * Math.PI);
					var z2 = 200 + 300 * Math.sin(eang * Math.PI);

					var p0:Array<Float> = NoteObject.toScreen(x1, y - hi / 2, z1);
					var p1:Array<Float> = NoteObject.toScreen(x2, y - hi / 2, z2);
					var p2:Array<Float> = NoteObject.toScreen(x1, y + hi / 2, z1);
					var p3:Array<Float> = NoteObject.toScreen(x2, y + hi / 2, z2);

					uvt = [head, 0, 200 / z1, tail, 0, 200 / z2, head, 1, 200 / z1, tail, 1, 200 / z2];

					return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
				}
			case 3: // multi note[stime,etime,width,noteData,mustPress,z,order,len]
				var stime:Float = FlxMath.lerp(parameters[0], parameters[1], head);
				var etime:Float = FlxMath.lerp(parameters[0], parameters[1], tail);

				var sorder:Float = parameters[6] + head;
				var eorder:Float = parameters[6] + tail;

				var x:Float = NoteObject.toWorld((parameters[4] == 1 ? PlayMoving.defaultPlayerReceptorX[Std.int(parameters[3])] : PlayMoving.defaultOpponentReceptorX[Std.int(parameters[3])])
					+ Note.noteWidth[Std.int(parameters[3])] / 2, 360)[0];
				var y:Float = NoteObject.toWorld(640, (FlxG.save.data.downscroll ? 550 : 50) + Note.noteHeight[Std.int(parameters[3])] / 2)[1];
				var y1:Float = y
					+ (Conductor.songPosition - stime) * (ModchartMath.scrollSpeed()) / (FlxG.save.data.downscroll ? 0.7 : -0.7);
				var y2:Float = y
					+ (Conductor.songPosition - etime) * (ModchartMath.scrollSpeed()) / (FlxG.save.data.downscroll ? 0.7 : -0.7);
				var x1:Float = x;
				var x2:Float = x;

				if (Conductor.songPosition > 124800)
				{
					if (Conductor.songPosition < etime)
					{
						var slen = sorder / parameters[7];
						var elen = eorder / parameters[7];
						if (Conductor.songPosition > stime - sorder * 300 / 4)
						{
							slen = (sorder - (Conductor.songPosition - stime + sorder * 300 / 4) / (300 / 4)) / parameters[7];
							elen = (eorder - (Conductor.songPosition - stime + sorder * 300 / 4) / (300 / 4)) / parameters[7];
						}
						var sdiff = 100 * Math.sin(((Conductor.songPosition + 150 - 150 * slen) % 300) / 300 * Math.PI);
						var ediff = 100 * Math.sin(((Conductor.songPosition + 150 - 150 * elen) % 300) / 300 * Math.PI);
						if ((Conductor.songPosition % 300) / 300 >= (slen + 1) / 2)
							sdiff = 0;
						if ((Conductor.songPosition % 300) / 300 >= (elen + 1) / 2)
							ediff = 0;
						switch (parameters[3])
						{
							case 0:
								x1 -= sdiff;
								x2 -= ediff;
							case 1:
								y1 += sdiff;
								y2 += ediff;
							case 2:
								y1 -= sdiff;
								y2 -= ediff;
							case 3:
								x1 += sdiff;
								x2 += ediff;
						}
					}
					else if (Conductor.songPosition % 300 <= 150)
					{
						var diff = 100 * Math.cos((Conductor.songPosition % 150) / 300 * Math.PI);
						switch (parameters[3])
						{
							case 0:
								x1 -= diff;
								x2 -= diff;
							case 1:
								y1 += diff;
								y2 += diff;
							case 2:
								y1 -= diff;
								y2 -= diff;
							case 3:
								x1 += diff;
								x2 += diff;
						}
					}
				}

				var p0:Array<Float> = NoteObject.toScreen(x1 - parameters[2] / 2, y1, parameters[5]);
				var p1:Array<Float> = NoteObject.toScreen(x1 + parameters[2] / 2, y1, parameters[5]);
				var p2:Array<Float> = NoteObject.toScreen(x2 - parameters[2] / 2, y2, parameters[5]);
				var p3:Array<Float> = NoteObject.toScreen(x2 + parameters[2] / 2, y2, parameters[5]);

				if (parameters[5] < 0)
					return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
			case 4: // lol [stime,etime,width,ang]
				var ang:Float = (Conductor.songPosition / 2400) * 360;

				var tael:Float = tail;

				var stime:Float = FlxMath.lerp(parameters[0], parameters[1], head);
				var etime:Float = FlxMath.lerp(parameters[0], parameters[1], tail);

				var sdis:Float = 300 + (Conductor.songPosition - stime) * (ModchartMath.scrollSpeed()) / 2;
				var edis:Float = 300 + (Conductor.songPosition - etime) * (ModchartMath.scrollSpeed()) / 2;

				if (sdis < 0)
					return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
				if (edis < 0)
				{
					tael = head + (sdis) / (sdis - edis) * (tail - head);
					edis = 0;
				}

				var x1:Float = 640 - Math.cos(parameters[3] / 180 * Math.PI) * parameters[2] / 2 + Math.sin(parameters[3] / 180 * Math.PI) * sdis;
				var y1:Float = 360 - Math.sin(parameters[3] / 180 * Math.PI) * parameters[2] / 2 - Math.cos(parameters[3] / 180 * Math.PI) * sdis;
				var x2:Float = 640 + Math.cos(parameters[3] / 180 * Math.PI) * parameters[2] / 2 + Math.sin(parameters[3] / 180 * Math.PI) * sdis;
				var y2:Float = 360 + Math.sin(parameters[3] / 180 * Math.PI) * parameters[2] / 2 - Math.cos(parameters[3] / 180 * Math.PI) * sdis;
				var x3:Float = 640 - Math.cos(parameters[3] / 180 * Math.PI) * parameters[2] / 2 + Math.sin(parameters[3] / 180 * Math.PI) * edis;
				var y3:Float = 360 - Math.sin(parameters[3] / 180 * Math.PI) * parameters[2] / 2 - Math.cos(parameters[3] / 180 * Math.PI) * edis;
				var x4:Float = 640 + Math.cos(parameters[3] / 180 * Math.PI) * parameters[2] / 2 + Math.sin(parameters[3] / 180 * Math.PI) * edis;
				var y4:Float = 360 + Math.sin(parameters[3] / 180 * Math.PI) * parameters[2] / 2 - Math.cos(parameters[3] / 180 * Math.PI) * edis;

				var z:Float = 200 + 360 * Math.sin(Math.PI / 12);

				var p0 = NoteObject.multiWorldSpin(x1, y1, z, [0, -15, 0], [0, 0, 0], [ang, 0, -ang], [640, 640, 640], [360, 360, 360], [z, z, z])[0];
				var p1 = NoteObject.multiWorldSpin(x2, y2, z, [0, -15, 0], [0, 0, 0], [ang, 0, -ang], [640, 640, 640], [360, 360, 360], [z, z, z])[0];
				var p2 = NoteObject.multiWorldSpin(x3, y3, z, [0, -15, 0], [0, 0, 0], [ang, 0, -ang], [640, 640, 640], [360, 360, 360], [z, z, z])[0];
				var p3 = NoteObject.multiWorldSpin(x4, y4, z, [0, -15, 0], [0, 0, 0], [ang, 0, -ang], [640, 640, 640], [360, 360, 360], [z, z, z])[0];

				uvt = [0, head, 1, head, 0, tael, 1, tael];
				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
			case 5: // [stime,etime,width]
				var stime:Float = FlxMath.lerp(parameters[0], parameters[1], head);
				var etime:Float = FlxMath.lerp(parameters[0], parameters[1], tail);

				var sz:Float = 1000 - 100 * (stime - Conductor.songPosition) / 300;
				var sdis:Float = (stime - Conductor.songPosition) * (ModchartMath.scrollSpeed()) / 4;
				var sang:Float = (stime - Conductor.songPosition) / 600;

				var ez:Float = 1000 - 100 * (stime - Conductor.songPosition) / 300;
				var edis:Float = (etime - Conductor.songPosition) * (ModchartMath.scrollSpeed()) / 4;
				var eang:Float = (etime - Conductor.songPosition) / 600;

				// x+cos,y+sin
				var x1:Float = 640 - Math.sin(sang * Math.PI) * parameters[2] / 2 + Math.cos(sang * Math.PI) * sdis;
				var y1:Float = 360 + Math.cos(sang * Math.PI) * parameters[2] / 2 + Math.sin(sang * Math.PI) * sdis;
				var x2:Float = 640 + Math.sin(sang * Math.PI) * parameters[2] / 2 + Math.cos(sang * Math.PI) * sdis;
				var y2:Float = 360 - Math.cos(sang * Math.PI) * parameters[2] / 2 + Math.sin(sang * Math.PI) * sdis;
				var x3:Float = 640 - Math.sin(eang * Math.PI) * parameters[2] / 2 + Math.cos(eang * Math.PI) * edis;
				var y3:Float = 360 + Math.cos(eang * Math.PI) * parameters[2] / 2 + Math.sin(eang * Math.PI) * edis;
				var x4:Float = 640 + Math.sin(eang * Math.PI) * parameters[2] / 2 + Math.cos(eang * Math.PI) * edis;
				var y4:Float = 360 - Math.cos(eang * Math.PI) * parameters[2] / 2 + Math.sin(eang * Math.PI) * edis;

				var p0:Array<Float> = NoteObject.toScreen(x1, y1, sz);
				var p1:Array<Float> = NoteObject.toScreen(x2, y2, sz);
				var p2:Array<Float> = NoteObject.toScreen(x3, y3, ez);
				var p3:Array<Float> = NoteObject.toScreen(x4, y4, ez);

				if (ez < 0)
					return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
		}
		return null;
	}
}
