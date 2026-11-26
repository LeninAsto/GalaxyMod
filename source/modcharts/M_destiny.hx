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

class M_destiny
{
	public static var generatedPhase:Int = 0;
	public static var remainingNotesByGroup:Array<Int> = [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4];
	public static var counterObjects:Array<NoteObject> = [];

	public static function reset()
	{
		generatedPhase = 0;
		remainingNotesByGroup = [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4];
		counterObjects = [];
	}

	public static function updateNotePosition(note:Note)
	{
		if (note.strumTime < 12715.23178807947)
		{
			applyNotesBefore12715(note);
		}
		else if (note.strumTime > 14304 && (note.strumTime < 27019 || (note.strumTime < 27218 && note.mustPress)))
		{
			applyNotesFrom14304(note);
		}
		else if (note.strumTime >= 27019 && (note.strumTime < 39734 || (note.strumTime < 39835 && note.mustPress)))
		{
			if (!note.mustPress)
			{
				note.alpha = note.isSustainNote ? 0.48 : 0.8;
			}
			note.wx = 100 + 320 * note.noteData + Math.sin((note.strumTime / 794.701986755 + note.noteData) * Math.PI) * 150;
			note.z = 200 / 0.7 + Math.cos((note.strumTime / 794.701986755 + note.noteData) * Math.PI) * 50;
			if (FlxG.save.data.downscroll)
				note.wy = (670 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.wy = (50 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			note.scaleW();
			if (note.isSustainNote)
			{
				note.renderer = new R_destiny(1, [
					note.strumTime - Conductor.stepCrochet,
					note.strumTime,
					note.noteData,
					note.width
				]);
				if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet
					&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
					note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / Conductor.stepCrochet;
				note.pathrender();
			}
		}
		else if (note.strumTime >= 39735 && note.strumTime < 65165)
		{
			applyNotesFrom39735(note);
		}
		else if (note.strumTime >= 65165 && note.strumTime < 90503)
		{
			applyNotesFrom65165(note);
		}
		else if (note.strumTime >= 90596 && note.strumTime < 115828)
		{
			applyNotesFrom90596(note);
		}
		else if (note.strumTime > 116026)
		{
			applyNotesFrom116026(note);
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
		if (Conductor.songPosition < 12715.23178807947)
		{
			applyStrumsBefore12715(receptor);
		}
		if (Conductor.songPosition > 12715.23178807947 && Conductor.songPosition <= 13907.2847682)
		{
			if (receptor.spec == -1)
			{
				receptor.wy = NoteObject.toWorld(0, FlxG.save.data.downscroll ? 550 : 50 + Note.noteHeight[receptor.ID] / 2)[1]
					+ (Conductor.songPosition - 12715.23178807947) * (Conductor.songPosition - 12715.23178807947) / 500;
				var x2:Float = NoteObject.toScreen(receptor.wx + Note.noteWidth[receptor.ID] / 1.4, receptor.wy, receptor.z)[0];
				var x1:Float = NoteObject.toScreen(receptor.wx - Note.noteWidth[receptor.ID] / 1.4, receptor.wy, receptor.z)[0];
				receptor.setGraphicSize(Std.int(x2 - x1));
				receptor.updateHitbox();
				receptor.x = x1;
				receptor.y = NoteObject.toScreen(receptor.wx - Note.noteWidth[receptor.ID] / 1.4, receptor.wy - Note.noteWidth[receptor.ID] / 1.4, receptor.z)[1];
				if (receptor.y >= FlxG.height)
					receptor.mustBeKilled = true;
			}
			else if (receptor.player == 0)
			{
				if (FlxG.save.data.downscroll)
				{
					receptor.y = 550 + PlayMoving.ease((13907.2847682 - Conductor.songPosition) / 397.350993377, 0) * (FlxG.height - 550);
				}
				else
				{
					receptor.y = 50 + PlayMoving.ease((13907.2847682 - Conductor.songPosition) / 397.350993377, 0) * (-receptor.height - 50);
				}
			}
		}
		else if (Conductor.songPosition > 14304.635761589405 && Conductor.songPosition <= 26622.516556291383 && receptor.spec > 0)
		{
			var times:Array<Float> = [
				0,
				15894.039735099339,
				16291.390728476823,
				16688.741721854305,
				22251.65562913907,
				22649.006622516554,
				23046.357615894038
			];
			var holds:Array<Float> = [0, 1, 1, 1.5, 1, 1, 1.5];
			receptor.alpha = (Conductor.songPosition - times[receptor.spec] + 794.701986755) / 397.350993377;
			if (Conductor.songPosition > times[receptor.spec] + 397.350993377 * holds[receptor.spec])
				receptor.mustBeKilled = true;
		}
		else if (Conductor.songPosition >= 27019.867549668867 && Conductor.songPosition < 39635.09933774834)
		{
			if (receptor.spec == 1)
			{
				receptor.alpha += 0.05;
				receptor.wx = 100 + 320 * receptor.ID + Math.sin((Conductor.songPosition / 794.701986755 + receptor.ID) * Math.PI) * 150;
				receptor.z = 200 / 0.7 + Math.cos((Conductor.songPosition / 794.701986755 + receptor.ID) * Math.PI) * 50;
				receptor.scaleW();
			}
			else
			{
				receptor.y = (FlxG.save.data.downscroll ? 550 : 50)
					+ (Conductor.songPosition - 27019.867549668867) * (Conductor.songPosition - 27019.867549668867) / 500;
				receptor.angle += receptor.player == 0 ? -3 : 3;
				if (receptor.y >= FlxG.height)
					receptor.mustBeKilled = true;
			}
		}
		else if (Conductor.songPosition >= 39635.09933774834 && Conductor.songPosition < 39735.09933774834)
		{
			receptor.wx = FlxMath.lerp(100 + 320 * receptor.ID + Math.sin(receptor.ID * Math.PI) * 150, 640,
				(Conductor.songPosition - 39635.09933774834) / 100);
			receptor.wy = FlxMath.lerp(FlxG.save.data.downscroll ? 670 : 50, 360, (Conductor.songPosition - 39635.09933774834) / 100);
			receptor.z = FlxMath.lerp(200 / 0.7 + Math.cos(receptor.ID * Math.PI) * 50, 200 / 0.7, (Conductor.songPosition - 39635.09933774834) / 100);
			receptor.scaleW();
		}
		else if (Conductor.songPosition >= 39735.09933774834 && Conductor.songPosition < 65165.56291390731)
		{
			applyStrumsFrom39735(receptor);
		}
		else if (Conductor.songPosition >= 65165.56291390731 && Conductor.songPosition < 65265.56291390731)
		{
			receptor.alpha = (65265.56291390731 - Conductor.songPosition) / 100;
		}
		else if (Conductor.songPosition >= 65265.56291390731 && Conductor.songPosition < 90596.02649006629)
		{
			applyStrumsFrom65265(receptor);
		}
		else if (Conductor.songPosition > 90596.02649006629 && Conductor.songPosition < 115926.49006622526)
		{
			applyStrumsFrom90596(receptor);
		}
		else if (Conductor.songPosition > 115926.49006622526)
		{
			applyStrumsFrom115926(receptor);
		}
	}

	public static function shouldHideNote(note:Note):Bool
	{
		if (note.strumTime < 9537)
		{
			return note.strumTime - Conductor.songPosition > 1192.05298013;
		}
		else
		{
			if (FlxG.save.data.downscroll)
				return note.y < -note.height;
			else
				return note.y > FlxG.height;
		}
	}

	public static function shouldRemoveNote(note:Note):Bool
	{
		if (note.strumTime > 14304 && note.strumTime < 27020 && note.spec > 0)
		{
			return true;
		}
		else if (note.strumTime >= 39735 && note.strumTime < 65165)
		{
			return Conductor.songPosition > 65165.56291390731;
		}
		else if (note.strumTime >= 65165 && note.strumTime < 90503)
		{
			if (note.spec != 0)
			{
				remainingNotesByGroup[note.spec] -= 1;
			}
			return true;
		}
		else if (note.strumTime >= 90596 && note.strumTime < 115828)
			return Conductor.songPosition > 116026.49006622526;
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
		if (note.strumTime >= 65165 && note.strumTime < 90502)
		{
			if (note.spec != 0)
			{
				remainingNotesByGroup[note.spec] -= 1;
			}
		}
	}

	public static function updateSpecialReceptors(state:PlayState)
	{
		if (Conductor.songPosition > 13509.933774834437 && generatedPhase < 1)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(0, i);
				ar.y = FlxG.height;
			}
			generatedPhase = 1;
		}
		if (Conductor.songPosition > 14304.635761589405 && generatedPhase < 2)
		{
			for (i in 1...7)
			{
				var poses:Array<Array<Float>> = [[], [168, 150], [468, 360], [168, 570], [808, 150], [1108, 360], [808, 570]];
				var ids:Array<Int> = [0, 0, 3, 1, 0, 3, 1];
				var ar:NoteStrum = state.generateStaticArrow(i < 4 ? 0 : 1, ids[i], "null", i);
				ar.x = poses[i][0] - ar.width / 2;
				ar.y = poses[i][1] - ar.height / 2;
				ar.z = 250;
				ar.alpha = 0;
			}
			generatedPhase = 2;
		}
		if (Conductor.songPosition > 27019.867549668867 && generatedPhase < 3)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 1);
				ar.wy = FlxG.save.data.downscroll ? 670 : 50;
				ar.alpha = 0;
			}
			generatedPhase = 3;
		}
		if (Conductor.songPosition >= 63576.15894039738 && Conductor.songPosition < 90502.53213868335)
		{
			if (generatedPhase < 4)
			{
				for (i in 1...21)
				{
					var counterObject:NoteObject = new NoteObject(0, 0);
					counterObject.spec = i;
					counterObjects.push(counterObject);
					state.addObject(counterObject);
				}
				generatedPhase = 4;
			}
			for (note in counterObjects)
			{
				var st:Float = (Conductor.songPosition - 65165.56291390731) / 397.350993377;
				var times:Array<Float> = [
					0, 65165.56291390731, 65960.26490066228, 66754.96688741725, 67549.66887417222, 68344.37086092719, 69139.07284768215, 71523.17880794706,
					72317.88079470203, 73112.582781457, 73907.28476821196, 74701.98675496693, 75496.6887417219, 77880.7947019868, 78675.49668874177,
					79470.19867549674, 80264.9006622517, 84238.41059602654, 85033.11258278151, 85827.81456953648, 86622.51655629145
				];
				var datas:Array<Float> = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3, 0, 1, 2, 3, 0, 1];
				note.loadGraphic(Paths.image('num' + remainingNotesByGroup[note.spec]));
				note.strumTime = 0;
				var time:Float = times[note.spec];
				var mst:Float = (time - 65165.56291390731) / 397.350993377;
				note.wx = 640 + 300 * Math.cos(time / 794.701986755 * Math.PI);
				note.wy = 360 + 200 * Math.sin(time / 794.701986755 * Math.PI);
				if (mst >= 32)
				{
					note.wx = 190 + 300 * datas[note.spec];
					note.wy = 360 + 400 * Math.sin(time / 794.701986755 * Math.PI);
				}
				var group:Float = Math.floor(Math.floor(mst / 2) - st / 2);
				if ((st > 12 && st < 16) || (st > 28 && st < 32) || (st > 40 && st < 48) || (st > 56 && st < 64) || st < 0)
				{
					note.z = 200 + 1050 * (mst - st) / 2;
				}
				else if (st % 2 > 1.5)
				{
					note.z = 200 + 1050 * group + 50 + 2000 * (2 - st % 2);
				}
				else
				{
					group += 1;
					note.z = 200 + 1050 * group + 50 * (1.5 - st % 2) / 1.5;
				}
				note.scaleW();
				note.z -= 100;
				if (remainingNotesByGroup[note.spec] <= 0)
				{
					state.destroyObject(note);
					counterObjects.remove(note);
				}
			}
		}
		if (Conductor.songPosition > 90596.02649006629 && generatedPhase < 5)
		{
			for (i in 0...4)
			{
				var ar:NoteStrum = state.generateStaticArrow(1, i, "null", 0);
				ar.alpha = 0;
			}
			var ar:NoteStrum = state.generateStaticArrow(0, 2, "null", 0);
			ar.alpha = 0.4;
			generatedPhase = 5;
		}
		if (Conductor.songPosition > 115926.49006622526 && generatedPhase < 6)
		{
			for (i in 0...8)
			{
				var ar:NoteStrum = state.generateStaticArrow(i < 4 ? 0 : 1, i % 4, "null", -1);
				ar.y = FlxG.height;
			}
			var ar:NoteStrum = state.generateStaticArrow(0, 2, "null", -2);
			ar.alpha = 0.8;
			var ar:NoteStrum = state.generateStaticArrow(0, 2, "null", -3);
			ar.alpha = 0.6;
			generatedPhase = 6;
		}
	}

	public static function onBeatHit(state:PlayState, curBeat:Int)
	{
		if (curBeat >= 36 && curBeat < 100)
		{
			if (state.camZooming && FlxG.camera.zoom < 1.35)
			{
				FlxG.camera.zoom += 0.015;
				state.camHUD.zoom += 0.03;
			}
		}
	}
	static function applyNotesBefore12715(note:Note):Void
	{
		if (!note.mustPress)
		{
			note.alpha = 1 - (note.strumTime - Conductor.songPosition - 794.701986755) / 397.350993377;
			if (note.isSustainNote)
				note.alpha *= 0.6;
			var ylist:Array<Float> = [-40, 160, 560, 760];
			var y:Float = ylist[note.noteData];
			if (note.strumTime >= 9536.423841059603)
			{
				if (FlxG.save.data.downscroll)
					y = NoteObject.toWorld(0,
						(550
							+ (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
								2))) + Note.noteHeight[note.noteData] / 2)[1];
				else
					y = NoteObject.toWorld(0,
						(50
							- (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
								2))) + Note.noteHeight[note.noteData] / 2)[1];
			}
			else if (note.strumTime > 6357.6158940397345)
				y = FlxMath.lerp(360, NoteObject.toWorld(0, FlxG.save.data.downscroll ? 550 : 50 + Note.noteHeight[note.noteData] / 2)[1],
					(note.strumTime - 6357.6158940397345) / 3178.80794702);
			else if (note.strumTime > 4768.2119205298)
				y = 360;
			else if (note.strumTime > 3178.8079470198672)
				y = FlxMath.lerp(ylist[note.noteData], 360, (note.strumTime - 3178.8079470198672) / 1589.40397351);
			note.z = 200 / 0.7 + Math.sin((note.strumTime / 794.701986755 - 1 + note.noteData * 0.5) * Math.PI) * 50;
			note.wx = 150 + Math.cos((note.strumTime / 794.701986755 - 1 + note.noteData * 0.5) * Math.PI) * 270;
			if (note.strumTime > 11125.827814569537)
			{
				note.z = 200 / 0.7 + Math.sin((note.strumTime / 794.701986755 * 2 - 1 + note.noteData * 0.5) * Math.PI) * 50;
				note.wx = 150 + Math.cos((note.strumTime / 794.701986755 * 2 - 1 + note.noteData * 0.5) * Math.PI) * 270;
			}
			note.wy = y;
			var x2:Float = NoteObject.toScreen(note.wx + Note.noteWidth[note.noteData] / 1.4, note.wy, note.z)[0];
			var x1:Float = NoteObject.toScreen(note.wx - Note.noteWidth[note.noteData] / 1.4, note.wy, note.z)[0];
			if (!note.isSustainNote)
			{
				note.setGraphicSize(Std.int(x2 - x1));
				note.updateHitbox();
			}
			note.x = x1;
			note.y = NoteObject.toScreen(note.wx - Note.noteWidth[note.noteData] / 1.4, note.wy - Note.noteWidth[note.noteData] / 1.4,
				note.z)[1];
			if (note.isSustainNote)
			{
				var h:Float = note.height * 0.7;
				var len:Float = Conductor.stepCrochet;
				if (note.animation.curAnim.name.endsWith('hold'))
				{
					h *= ModchartMath.sustainScale();
				}
				else
				{
					len /= ModchartMath.sustainScale();
				}
				if (FlxG.save.data.downscroll)
				{
					y += h;
					h *= -1;
				}
				note.renderer = new R_destiny(0, [
					note.strumTime - Conductor.stepCrochet,
					note.strumTime - Conductor.stepCrochet + len,
					note.noteData,
					note.width
				]);
				if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet)
					note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / len;
				note.pathrender();
			}
		}
	}

	static function applyNotesFrom14304(note:Note):Void
	{
		var diff = (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
		diff = (diff + 250) * (diff + 250) * (diff + 250) / (250 * 250) - 250;
		if (FlxG.save.data.downscroll)
			note.y = (550 + diff);
		else
			note.y = (50 - (diff));
		if (note.isSustainNote && note.animation.curAnim.name.endsWith('hold'))
		{
			var diff2 = (Conductor.songPosition - note.strumTime - Conductor.stepCrochet) * (ModchartMath.scrollSpeed());
			diff2 = (diff2 + 250) * (diff2 + 250) * (diff2 + 250) / (250 * 250) - 250;
			var diff3 = Std.int(Math.abs(diff - diff2));
			if (diff3 == 0)
				note.setGraphicSize(Std.int(note.width), 1);
			else
				note.setGraphicSize(Std.int(note.width), diff3);
			note.updateHitbox();
		}
		if (note.spec > 0)
		{
			var poses:Array<Array<Float>> = [[], [168, 150], [468, 360], [168, 570], [808, 150], [1108, 360], [808, 570]];

			if (note.isEnd)
			{
				note.scale.set(0.5, 0.5);
				note.updateHitbox();
				note.x = poses[note.spec][0] - (note.width + note.offset.x) / 2;
				note.y = poses[note.spec][1] - (note.height + note.offset.y) / 2;
				note.z = 250;
				note.alpha = (Conductor.songPosition - note.strumTime + 794.701986755) / 397.350993377;
			}
			else if (note.isSustainNote)
			{
				switch (note.noteData)
				{
					case 0:
						note.animation.play('purplehold');
					case 1:
						note.animation.play('bluehold');
					case 2:
						note.animation.play('greenhold');
					case 3:
						note.animation.play('redhold');
				}
				note.z = 280;
				note.alpha = ((Conductor.songPosition - note.strumTime + Conductor.stepCrochet * (note.sustainOrder + 1) +
					794.701986755) / 397.350993377) * 0.8;
				if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet * (note.sustainOrder + 1) - 397.350993377)
					note.alpha = 0.8;
				note.renderer = new RenderPath(0, [
					note.sustainOrder,
					note.sustainLength,
					poses[note.spec][0],
					poses[note.spec][1],
					90
				]);
				if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet
					&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
					note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / Conductor.stepCrochet;
				note.pathrender();
			}
			else
			{
				var sc = (1 + (note.strumTime - Conductor.songPosition) / 397.350993377) * 0.7;
				if (Conductor.songPosition > note.strumTime)
					sc = 0.7;
				note.scale.set(sc, sc);
				note.x = poses[note.spec][0] - note.width / 2;
				note.y = poses[note.spec][1] - note.height / 2;
				note.z = 200;
				note.alpha = 1 - (note.strumTime - Conductor.songPosition) / 794.701986755;
			}
		}
	}

	static function applyNotesFrom39735(note:Note):Void
	{
		if (!note.mustPress)
		{
			note.alpha = note.isSustainNote ? 0.36 : 0.6;
		}
		var spins:Array<Array<Float>> = [
			[
				0, 0, -30, 0, 30, 0, 0, 0, -30, 0, 30, 0, 0, 0, -30, 0, 30, 0, 0, 0, -30, 0, 30, 0, 0, -20, -10, 5, 20, 0, 5, -20, -10, 5, 20, 0, 5, -20,
				-10,
				5, 20, 0, 5, -20, -10, 5, 20, 0, 5
			],
			[
				0, -15, 0, 20, 0, -20, 15, -15, 0, 20, 0, -20, 15, -15, 0, 20, 0, -20, 15, -15, 0, 20, 0, -20, 15, -15, 0, 0, 0, 15, 5, -15, 0, 0, 0, 15, 5,
				-15, 0, 0, 0, 15, 5, -15, 0, 0, 0, 15, 5
			],
			[
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0
			],
			[
				640, 1280, 640, 640, 640, 640, 1280, 1280, 640, 640, 640, 640, 1280, 1280, 640, 640, 640, 640, 1280, 1280, 640, 640, 640, 640, 1280, 1280,
				640, 640, 1280, 1280, 640, 1280, 640, 640, 1280, 1280, 640, 1280, 640, 640, 1280, 1280, 640, 1280, 640, 640, 1280, 1280, 640
			],
			[
				360, 360, 360, 720, 360, 720, 360, 360, 360, 720, 360, 720, 360, 360, 360, 720, 360, 720, 360, 360, 360, 720, 360, 720, 360, 360, 720, 720,
				360, 360, 720, 360, 720, 720, 360, 360, 720, 360, 720, 720, 360, 360, 720, 360, 720, 720, 360, 360, 720
			],
			[
				200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7,
				200 / 0.7,
				200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7,
				200 / 0.7,
				200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7,
				200 / 0.7,
				200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7
			]
		];
		var st:Float = (Conductor.songPosition - 39735.09933774834) / 397.350993377;
		if (Conductor.songPosition < 39735.09933774834)
			st = 0;
		var round:Int = Std.int(Math.floor(st / 4));
		var non:Array<Array<Float>> = [];
		if (st % 4 > 3.9)
		{
			for (i in 0...6)
			{
				if (i < 3)
					spins[i][round * 3 + 3] *= PlayMoving.ease((st % 4 - 3.9) * 10, 1);
				non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 4));
			}
		}
		else if (st % 4 >= 3)
		{
			for (i in 0...6)
			{
				non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 3));
			}
		}
		else if (st % 4 > 2.9)
		{
			for (i in 0...6)
			{
				if (i < 3)
					spins[i][round * 3 + 2] *= PlayMoving.ease((st % 4 - 2.9) * 10, 1);
				non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 3));
			}
		}
		else if (st % 4 >= 1.5)
		{
			for (i in 0...6)
			{
				non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 2));
			}
		}
		else if (st % 4 > 1.4)
		{
			for (i in 0...6)
			{
				if (i < 3)
					spins[i][round * 3 + 1] *= PlayMoving.ease((st % 4 - 1.4) * 10, 1);
				non.push(spins[i].slice(round < 2 ? 0 : Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 2));
			}
		}
		else
		{
			for (i in 0...6)
			{
				non.push(spins[i].slice(round < 2 ? 0 : Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 1));
			}
		}
		var x:Float = 640 - note.width * 0.35;
		var y:Float = 360 - note.height * 0.35;
		switch (note.noteData)
		{
			case 0:
				x += (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
			case 1:
				y -= (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
			case 2:
				y += (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
			case 3:
				x -= (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed());
		}
		var w:Float = note.width * 0.7;
		var h:Float = note.height * 0.7;
		var tri:Array<Array<Float>> = NoteObject.multiTriangles(x, y, 200 / 0.7, w, h, non[0], non[1], non[2], non[3], non[4], non[5]);
		note.render(tri[0], tri[1]);
	}

	static function applyNotesFrom65165(note:Note):Void
	{
		if (!note.mustPress)
			note.alpha = note.isSustainNote ? 0.48 : 0.8;
		var st:Float = (Conductor.songPosition - 65165.56291390731) / 397.350993377;
		var times:Array<Float> = [
			0, 65165.56291390731, 65960.26490066228, 66754.96688741725, 67549.66887417222, 68344.37086092719, 69139.07284768215, 71523.17880794706,
			72317.88079470203, 73112.582781457, 73907.28476821196, 74701.98675496693, 75496.6887417219, 77880.7947019868, 78675.49668874177,
			79470.19867549674, 80264.9006622517, 84238.41059602654, 85033.11258278151, 85827.81456953648, 86622.51655629145
		];
		if (note.isSustainNote)
		{
			var len:Float = Conductor.stepCrochet;
			if (!note.animation.curAnim.name.endsWith('hold'))
			{
				len /= ModchartMath.sustainScale();
			}
			note.renderer = new R_destiny(2, [
				note.strumTime - Conductor.stepCrochet,
				note.strumTime - Conductor.stepCrochet + len,
				note.width,
				note.noteData
			]);
			if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet
				&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
				note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / len;
			note.pathrender();
		}
		else
		{
			var time:Float = note.strumTime;
			if (note.spec != 0)
			{
				time = times[note.spec];
				if ((note.strumTime / 397.350993377) % 2 < 1.2 || (note.strumTime / 397.350993377) % 2 > 1.8)
					note.alpha = 0;
			}
			var mst:Float = (time - 65165.56291390731) / 397.350993377;
			note.wx = 640 + 300 * Math.cos(time / 794.701986755 * Math.PI);
			note.wy = 360 + 200 * Math.sin(time / 794.701986755 * Math.PI);
			if (mst >= 32)
			{
				note.wx = 190 + 300 * note.noteData;
				note.wy = 360 + 400 * Math.sin(time / 794.701986755 * Math.PI);
			}
			var group:Float = Math.floor(Math.floor(mst / 2) - st / 2);
			if (note.spec == 0)
			{
				group += (mst / 2) % 1;
			}
			if ((st > 12 && st < 16) || (st > 28 && st < 32) || (st > 40 && st < 48) || (st > 56 && st < 64) || st < 0)
			{
				note.z = 200 + 1050 * (mst - st) / 2;
			}
			else if (st % 2 > 1.5)
			{
				note.z = 200 + 1050 * group + 50 + 2000 * (2 - st % 2);
			}
			else
			{
				group += 1;
				note.z = 200 + 1050 * group + 50 * (1.5 - st % 2) / 1.5;
			}
			note.scaleW();
		}
	}

	static function applyNotesFrom90596(note:Note):Void
	{
		/*if (!note.mustPress)
			note.alpha = note.isSustainNote ? 0.48 : 0.8; */
		if (note.isSustainNote)
		{
			note.z = 300;
			if (Conductor.songPosition > 103311.25827814577)
				note.z = 300
					+ 300 * Math.abs(Math.sin(((Conductor.songPosition +
						note.sustainOrder * Conductor.stepCrochet) % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
			var len:Float = Conductor.stepCrochet;
			if (!note.animation.curAnim.name.endsWith('hold'))
			{
				len /= ModchartMath.sustainScale();
			}
			note.renderer = new R_destiny(3, [
				note.strumTime - Conductor.stepCrochet,
				note.strumTime - Conductor.stepCrochet + len,
				note.width,
				note.noteData,
				note.sustainOrder,
				(note.mustPress ? 1 : 0)
			]);
			if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet
				&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
				note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / len;
			note.pathrender();
		}
		else
		{
			var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
			if (Conductor.songPosition % 794.701986755 > 694.701986755)
				ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
			if (Conductor.songPosition < 90596.02649006629)
				ang = 0;
			var x = 160 * (1.5 - note.noteData);
			var y = (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
				2)) * (FlxG.save.data.downscroll ? 1 : -1) * (note.mustPress ? 1 : -1);
			note.wx = 640 - Math.cos(ang) * x - Math.sin(ang) * y;
			note.wy = 360 - Math.sin(ang) * x + Math.cos(ang) * y;
			note.z = 300;
			if (Conductor.songPosition > 103311.25827814577)
				note.z = 300 + 300 * Math.abs(Math.sin((Conductor.songPosition % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
			note.scaleW();
		}
	}

	static function applyNotesFrom116026(note:Note):Void
	{
		if (note.isSustainNote)
		{
			var len:Float = Conductor.stepCrochet;
			if (!note.animation.curAnim.name.endsWith('hold'))
			{
				len /= ModchartMath.sustainScale();
			}
			note.renderer = new R_destiny(4, [
				note.strumTime - Conductor.stepCrochet,
				note.strumTime - Conductor.stepCrochet + len,
				note.width,
				note.noteData,
				(note.mustPress ? 1 : 0)
			]);
			if (Conductor.songPosition > note.strumTime - Conductor.stepCrochet
				&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
				note.renderer.pathRatio = 1 - (Conductor.songPosition - note.strumTime + Conductor.stepCrochet) / len;
			note.pathrender();
			var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
			if (Conductor.songPosition % 794.701986755 > 694.701986755)
				ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
			if (Conductor.songPosition < 116026.49006622526)
				ang = 0;
			note.z = 200 / 0.7 - Math.sin(ang) * (note.mustPress ? 100 : -100);
		}
		else
		{
			var x = NoteObject.toWorld(note.mustPress ? 1040 : 240, 360)[0];
			note.wy = NoteObject.toWorld(640,
				(FlxG.save.data.downscroll ? (550 + Note.noteHeight[note.noteData] / 2) : (50 + Note.noteHeight[note.noteData] / 2)) +
				(Conductor.songPosition
					- note.strumTime) * (ModchartMath.scrollSpeed()) * (FlxG.save.data.downscroll ? 1 : -1))[1];
			var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
			if (Conductor.songPosition % 794.701986755 > 694.701986755)
				ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
			if (Conductor.songPosition < 116026.49006622526)
				ang = 0;
			note.z = 200 / 0.7 - Math.sin(ang) * (note.mustPress ? 100 : -100);
			note.wx = 640 + Math.cos(ang) * (x - 640) + 160 * (note.noteData - 1.5);
			if (note.isEnd)
			{
				note.offsetWhenDraw = false;
				// note.wx -= 18;
				// note.wy -= FlxG.save.data.downscroll ? 36 : 18;
			}
			note.scaleW();
		}
	}

	static function applyStrumsBefore12715(receptor:NoteStrum):Void
	{
		if (receptor.player == 0)
		{
			var zlist:Array<Float> = [200 / 0.7, 200 / 0.7 - 50, 200 / 0.7, 200 / 0.7 + 50];
			var ylist:Array<Float> = [-40, 160, 560, 760];
			var y:Float = ylist[receptor.ID];
			if (Conductor.songPosition > 9536.423841059603)
				y = NoteObject.toWorld(0, FlxG.save.data.downscroll ? 550 : 50 + Note.noteHeight[receptor.ID] / 2)[1];
			else if (Conductor.songPosition > 6357.6158940397345)
				y = FlxMath.lerp(360, NoteObject.toWorld(0, FlxG.save.data.downscroll ? 550 : 50 + Note.noteHeight[receptor.ID] / 2)[1],
					(Conductor.songPosition - 6357.6158940397345) / 3178.80794702);
			else if (Conductor.songPosition > 4768.2119205298)
				y = 360;
			else if (Conductor.songPosition > 3178.8079470198672)
				y = FlxMath.lerp(ylist[receptor.ID], 360, (Conductor.songPosition - 3178.8079470198672) / 1589.40397351);
			receptor.z = 200 / 0.7 + Math.sin((Conductor.songPosition / 794.701986755 - 1 + receptor.ID * 0.5) * Math.PI) * 50;
			receptor.wx = 150 + Math.cos((Conductor.songPosition / 794.701986755 - 1 + receptor.ID * 0.5) * Math.PI) * 270;
			if (Conductor.songPosition > 11125.827814569537)
			{
				receptor.z = 200 / 0.7 + Math.sin((Conductor.songPosition / 794.701986755 * 2 - 1 + receptor.ID * 0.5) * Math.PI) * 50;
				receptor.wx = 150 + Math.cos((Conductor.songPosition / 794.701986755 * 2 - 1 + receptor.ID * 0.5) * Math.PI) * 270;
			}
			receptor.wy = y;
			var x2:Float = NoteObject.toScreen(receptor.wx + Note.noteWidth[receptor.ID] / 1.4, receptor.wy, receptor.z)[0];
			var x1:Float = NoteObject.toScreen(receptor.wx - Note.noteWidth[receptor.ID] / 1.4, receptor.wy, receptor.z)[0];
			receptor.setGraphicSize(Std.int(x2 - x1));
			receptor.updateHitbox();
			receptor.x = x1;
			receptor.y = NoteObject.toScreen(receptor.wx - Note.noteWidth[receptor.ID] / 1.4, receptor.wy - Note.noteWidth[receptor.ID] / 1.4, receptor.z)[1];
			receptor.spec = -1;
		}
	}

	static function applyStrumsFrom39735(receptor:NoteStrum):Void
	{
		receptor.z = 200 / 0.7;
		var spins:Array<Array<Float>> = [
			[
				0, 0, -30, 0, 30, 0, 0, 0, -30, 0, 30, 0, 0, 0, -30, 0, 30, 0, 0, 0, -30, 0, 30, 0, 0, -20, -10, 5, 20, 0, 5, -20, -10, 5, 20, 0, 5, -20,
				-10,
				5, 20, 0, 5, -20, -10, 5, 20, 0, 5
			],
			[
				0, -15, 0, 20, 0, -20, 15, -15, 0, 20, 0, -20, 15, -15, 0, 20, 0, -20, 15, -15, 0, 20, 0, -20, 15, -15, 0, 0, 0, 15, 5, -15, 0, 0, 0, 15, 5,
				-15, 0, 0, 0, 15, 5, -15, 0, 0, 0, 15, 5
			],
			[
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				0, 0
			],
			[
				640, 1280, 640, 640, 640, 640, 1280, 1280, 640, 640, 640, 640, 1280, 1280, 640, 640, 640, 640, 1280, 1280, 640, 640, 640, 640, 1280, 1280,
				640, 640, 1280, 1280, 640, 1280, 640, 640, 1280, 1280, 640, 1280, 640, 640, 1280, 1280, 640, 1280, 640, 640, 1280, 1280, 640
			],
			[
				360, 360, 360, 720, 360, 720, 360, 360, 360, 720, 360, 720, 360, 360, 360, 720, 360, 720, 360, 360, 360, 720, 360, 720, 360, 360, 720, 720,
				360, 360, 720, 360, 720, 720, 360, 360, 720, 360, 720, 720, 360, 360, 720, 360, 720, 720, 360, 360, 720
			],
			[
				200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7,
				200 / 0.7,
				200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7,
				200 / 0.7,
				200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7,
				200 / 0.7,
				200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7, 200 / 0.7
			]
		];
		var st:Float = (Conductor.songPosition - 39735.09933774834) / 397.350993377;
		var round:Int = Std.int(Math.floor(st / 4));
		var non:Array<Array<Float>> = [];
		if (st % 4 > 3.9)
		{
			for (i in 0...6)
			{
				if (i < 3)
					spins[i][round * 3 + 3] *= PlayMoving.ease((st % 4 - 3.9) * 10, 1);
				non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 4));
			}
		}
		else if (st % 4 >= 3)
		{
			for (i in 0...6)
			{
				non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 3));
			}
		}
		else if (st % 4 > 2.9)
		{
			for (i in 0...6)
			{
				if (i < 3)
					spins[i][round * 3 + 2] *= PlayMoving.ease((st % 4 - 2.9) * 10, 1);
				non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 3));
			}
		}
		else if (st % 4 >= 1.5)
		{
			for (i in 0...6)
			{
				non.push(spins[i].slice(Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 2));
			}
		}
		else if (st % 4 > 1.4)
		{
			for (i in 0...6)
			{
				if (i < 3)
					spins[i][round * 3 + 1] *= PlayMoving.ease((st % 4 - 1.4) * 10, 1);
				non.push(spins[i].slice(round < 2 ? 0 : Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 2));
			}
		}
		else
		{
			for (i in 0...6)
			{
				non.push(spins[i].slice(round < 2 ? 0 : Std.int(Math.floor(round / 2)) * 6 + 1, round * 3 + 1));
			}
		}
		var x:Float = 640 - receptor.width * 0.35;
		var y:Float = 360 - receptor.height * 0.35;
		var w:Float = receptor.width * 0.7;
		var h:Float = receptor.height * 0.7;
		if (receptor.animation.curAnim.name == 'confirm')
		{
			x -= (238 - 157) / 2 * 0.7;
			y -= (235 - 154) / 2 * 0.7;
			w *= 238 / 157;
			h *= 235 / 154;
		}
		var tri:Array<Array<Float>> = NoteObject.multiTriangles(x, y, 200 / 0.7, w, h, non[0], non[1], non[2], non[3], non[4], non[5]);

		receptor.render(tri[0], tri[1]);
	}

	static function applyStrumsFrom65265(receptor:NoteStrum):Void
	{
		receptor.rendermode = 0;
		if (Conductor.songPosition > 79470.19867549674)
		{
			receptor.wx = 190 + 300 * receptor.ID;
			receptor.wy = 360 + 400 * Math.sin(Conductor.songPosition / 794.701986755 * Math.PI);
		}
		else
		{
			receptor.wx = 640 + 300 * Math.cos(Conductor.songPosition / 794.701986755 * Math.PI);
			receptor.wy = 360 + 200 * Math.sin(Conductor.songPosition / 794.701986755 * Math.PI);
		}
		receptor.z = 200;
		if (Conductor.songPosition > 69933.77483443712 && Conductor.songPosition < 71523.17880794706)
			receptor.alpha = 0.1;
		else if (Conductor.songPosition > 69833.77483443712 && Conductor.songPosition < 69933.77483443712)
			receptor.alpha = (Conductor.songPosition - 69833.77483443712) / 1000;
		else if (Conductor.songPosition > 76291.39072847686 && Conductor.songPosition < 77880.7947019868)
			receptor.alpha = 0.1;
		else if (Conductor.songPosition > 76191.39072847686 && Conductor.songPosition < 76291.39072847686)
			receptor.alpha = (Conductor.songPosition - 76191.39072847686) / 1000;
		else if (Conductor.songPosition > 81059.60264900667 && Conductor.songPosition < 84238.41059602654)
			receptor.alpha = 0.4;
		else if (Conductor.songPosition > 80959.60264900667 && Conductor.songPosition < 81059.60264900667)
			receptor.alpha = (Conductor.songPosition - 80959.60264900667) / 250;
		else if (Conductor.songPosition > 87417.21854304642 && Conductor.songPosition < 90596.02649006629)
			receptor.alpha = 0.4;
		else if (Conductor.songPosition > 87317.21854304642 && Conductor.songPosition < 87417.21854304642)
			receptor.alpha = (Conductor.songPosition - 87317.21854304642) / 250;
		else
			receptor.alpha = 0;
		receptor.scaleW();
	}

	static function applyStrumsFrom90596(receptor:NoteStrum):Void
	{
		if (receptor.spec == 0)
		{
			receptor.alpha = 1;
			if (Conductor.songPosition < 90696.02649006629)
				receptor.alpha = (Conductor.songPosition - 90596.02649006629) / 100;
			receptor.z = 300;
			if (Conductor.songPosition > 103311.25827814577)
				receptor.z = 300 + 300 * Math.abs(Math.sin((Conductor.songPosition % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
			if (receptor.player == 1)
			{
				if (Conductor.songPosition < 90696.02649006629)
					receptor.alpha = (Conductor.songPosition - 90596.02649006629) / 100;
				var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
				if (Conductor.songPosition % 794.701986755 > 694.701986755)
					ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
				receptor.wx = 640 + 160 * (receptor.ID - 1.5) * Math.cos(ang);
				receptor.wy = 360 + 160 * (receptor.ID - 1.5) * Math.sin(ang);
				receptor.scaleW();
			}
			else
			{
				receptor.alpha *= 0.8;
				var ang:Float = (Conductor.songPosition % 794.701986755) / 794.701986755;
				receptor.wx = 640 + 500 * Math.sin(ang * 2 * Math.PI);
				receptor.wy = 360 - 500 * Math.cos(ang * 2 * Math.PI);
				receptor.angle = ang * 360;
				receptor.scaleW();
			}
		}
		else
		{
			receptor.z += 10;
			receptor.scaleW();
			if (receptor.z > 10000)
			{
				receptor.mustBeKilled = true;
			}
		}
	}

	static function applyStrumsFrom115926(receptor:NoteStrum):Void
	{
		if (receptor.spec == -1)
		{
			receptor.alpha = 1;
			if (Conductor.songPosition < 116026.49006622526)
				receptor.alpha = (Conductor.songPosition - 115926.49006622526) / 100;
			var x = NoteObject.toWorld(receptor.player == 1 ? 1040 : 240, 360)[0];
			receptor.wy = NoteObject.toWorld(640,
				FlxG.save.data.downscroll ? (550 + Note.noteHeight[receptor.ID] / 2) : (50 + Note.noteHeight[receptor.ID] / 2))[1];
			var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
			if (Conductor.songPosition % 794.701986755 > 694.701986755)
				ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
			receptor.z = 200 / 0.7 - Math.sin(ang) * (receptor.player == 1 ? 100 : -100);
			receptor.wx = 640 + Math.cos(ang) * (x - 640) + 160 * (receptor.ID - 1.5);
			receptor.scaleW();
		}
		else if (receptor.spec == -2)
		{
			receptor.alpha = 1;
			if (Conductor.songPosition < 116026.49006622526)
				receptor.alpha = (Conductor.songPosition - 115926.49006622526) / 100;
			receptor.alpha *= 0.8;
			receptor.x = 640 - receptor.width / 2;
			receptor.y = 360 - receptor.height / 2;
			var ang:Float = (Conductor.songPosition % 794.701986755) / 794.701986755;
			receptor.angle = Math.floor(ang * 48) / 48 * 360;
		}
		else if (receptor.spec == -3)
		{
			receptor.alpha = 1;
			if (Conductor.songPosition < 116026.49006622526)
				receptor.alpha = (Conductor.songPosition - 115926.49006622526) / 100;
			receptor.alpha *= 0.6;
			var ang:Float = (Conductor.songPosition % 16.5562913907) / 16.5562913907;
			ang = Math.floor(ang * 48) / 48;
			receptor.x = 640 + 150 * Math.sin(ang * 2 * Math.PI) - receptor.width / 2;
			receptor.y = 360 - 150 * Math.cos(ang * 2 * Math.PI) - receptor.height / 2;
			receptor.angle = ang * 360;
		}
		else
		{
			if (receptor.player == 1)
			{
				var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
				if (Conductor.songPosition % 794.701986755 > 694.701986755)
					ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
				receptor.wx = 640 + 160 * (receptor.ID - 1.5) * Math.cos(ang);
				receptor.wy = 360 + 160 * (receptor.ID - 1.5) * Math.sin(ang);
				receptor.scaleW();
			}
			else
			{
				var ang:Float = (Conductor.songPosition % 794.701986755) / 794.701986755;
				receptor.wx = 640 + 500 * Math.sin(ang * 2 * Math.PI);
				receptor.wy = 360 - 500 * Math.cos(ang * 2 * Math.PI);
				receptor.angle = ang * 360;
				receptor.scaleW();
			}
			if (Conductor.songPosition > 116026.49006622526)
				receptor.z += 10;
			receptor.scaleW();
			if (receptor.z > 10000)
			{
				receptor.mustBeKilled = true;
			}
		}
	}

}

class R_destiny extends RenderPath
{
	override function start(head:Float, tail:Float):Array<Array<Float>>
	{
		var uvt:Array<Float> = [0, head, 1, head, 0, tail, 1, tail];
		switch (mode)
		{
			case 0: // 3dspin [stime, etime, noteData, width]
				var stime:Float = FlxMath.lerp(parameters[0], parameters[1], head);
				var etime:Float = FlxMath.lerp(parameters[0], parameters[1], tail);

				var ylist:Array<Float> = [-40, 160, 560, 760];
				var y:Float = ylist[Std.int(parameters[2])];
				var y2:Float = ylist[Std.int(parameters[2])];
				if (stime >= 9536.423841059603)
				{
					if (FlxG.save.data.downscroll)
						y = NoteObject.toWorld(0,
							(550
								+ (Conductor.songPosition - stime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
									2))) + Note.noteHeight[Std.int(parameters[2])] / 2)[1];
					else
						y = NoteObject.toWorld(0,
							(50
								- (Conductor.songPosition - stime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
									2))) + Note.noteHeight[Std.int(parameters[2])] / 2)[1];
				}
				else if (stime > 6357.6158940397345)
					y = FlxMath.lerp(360, NoteObject.toWorld(0, FlxG.save.data.downscroll ? 550 : 50 + Note.noteHeight[Std.int(parameters[2])] / 2)[1],
						(stime - 6357.6158940397345) / 3178.80794702);
				else if (stime > 4768.2119205298)
					y = 360;
				else if (stime > 3178.8079470198672)
					y = FlxMath.lerp(ylist[Std.int(parameters[2])], 360, (stime - 3178.8079470198672) / 1589.40397351);

				if (etime > 9536.423841059603)
				{
					if (FlxG.save.data.downscroll)
						y2 = NoteObject.toWorld(0,
							(550
								+ (Conductor.songPosition - etime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
									2))) + Note.noteHeight[Std.int(parameters[2])] / 2)[1];
					else
						y2 = NoteObject.toWorld(0,
							(50
								- (Conductor.songPosition - etime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
									2))) + Note.noteHeight[Std.int(parameters[2])] / 2)[1];
				}
				else if (etime > 6357.6158940397345)
					y2 = FlxMath.lerp(360, NoteObject.toWorld(0, FlxG.save.data.downscroll ? 550 : 50 + Note.noteHeight[Std.int(parameters[2])] / 2)[1],
						(etime - 6357.6158940397345) / 3178.80794702);
				else if (etime > 4768.2119205298)
					y2 = 360;
				else if (etime > 3178.8079470198672)
					y2 = FlxMath.lerp(ylist[Std.int(parameters[2])], 360, (etime - 3178.8079470198672) / 1589.40397351);

				var z1:Float = 200 / 0.7 + Math.sin((stime / 794.701986755 - 1 + Std.int(parameters[2]) * 0.5) * Math.PI) * 50;
				var x1:Float = 150 + Math.cos((stime / 794.701986755 - 1 + Std.int(parameters[2]) * 0.5) * Math.PI) * 270;
				if (stime > 11125.827814569537)
				{
					z1 = 200 / 0.7 + Math.sin((stime / 794.701986755 * 2 - 1 + Std.int(parameters[2]) * 0.5) * Math.PI) * 50;
					x1 = 150 + Math.cos((stime / 794.701986755 * 2 - 1 + Std.int(parameters[2]) * 0.5) * Math.PI) * 270;
				}

				var z2:Float = 200 / 0.7 + Math.sin((etime / 794.701986755 - 1 + Std.int(parameters[2]) * 0.5) * Math.PI) * 50;
				var x2:Float = 150 + Math.cos((etime / 794.701986755 - 1 + Std.int(parameters[2]) * 0.5) * Math.PI) * 270;
				if (etime > 11125.827814569537)
				{
					z2 = 200 / 0.7 + Math.sin((etime / 794.701986755 * 2 - 1 + Std.int(parameters[2]) * 0.5) * Math.PI) * 50;
					x2 = 150 + Math.cos((etime / 794.701986755 * 2 - 1 + Std.int(parameters[2]) * 0.5) * Math.PI) * 270;
				}

				var p0:Array<Float> = NoteObject.toScreen(x1, y - parameters[3] / 2, z1);
				var p1:Array<Float> = NoteObject.toScreen(x1, y + parameters[3] / 2, z1);
				if (stime > 9536.423841059603)
				{
					p0 = NoteObject.toScreen(x1 - parameters[3] / 2, y, z1);
					p1 = NoteObject.toScreen(x1 + parameters[3] / 2, y, z1);
				}
				var p2:Array<Float> = NoteObject.toScreen(x2, y2 - parameters[3] / 2, z2);
				var p3:Array<Float> = NoteObject.toScreen(x2, y2 + parameters[3] / 2, z2);
				if (etime > 9536.423841059603)
				{
					p2 = NoteObject.toScreen(x2 - parameters[3] / 2, y2, z2);
					p3 = NoteObject.toScreen(x2 + parameters[3] / 2, y2, z2);
				}

				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
			case 1: // spin2 [stime, etime, noteData, width]
				var stime:Float = FlxMath.lerp(parameters[0], parameters[1], head);
				var etime:Float = FlxMath.lerp(parameters[0], parameters[1], tail);

				var wx:Float = 100 + 320 * parameters[2] + Math.sin((stime / 794.701986755 + parameters[2]) * Math.PI) * 150;
				var z:Float = 200 / 0.7 + Math.cos((stime / 794.701986755 + parameters[2]) * Math.PI) * 50;
				var wy:Float = (50 - (Conductor.songPosition - stime) * (ModchartMath.scrollSpeed()));
				if (FlxG.save.data.downscroll)
					wy = (670 + (Conductor.songPosition - stime) * (ModchartMath.scrollSpeed()));
				var wx2:Float = 100 + 320 * parameters[2] + Math.sin((etime / 794.701986755 + parameters[2]) * Math.PI) * 150;
				var z2:Float = 200 / 0.7 + Math.cos((etime / 794.701986755 + parameters[2]) * Math.PI) * 50;
				var wy2:Float = (50 - (Conductor.songPosition - etime) * (ModchartMath.scrollSpeed()));
				if (FlxG.save.data.downscroll)
					wy2 = (670 + (Conductor.songPosition - etime) * (ModchartMath.scrollSpeed()));
				var w0 = NoteObject.toScreen(wx - parameters[3] / 2, wy, z);
				var w1 = NoteObject.toScreen(wx + parameters[3] / 2, wy, z);
				var w2 = NoteObject.toScreen(wx2 - parameters[3] / 2, wy2, z2);
				var w3 = NoteObject.toScreen(wx2 + parameters[3] / 2, wy2, z2);
				return [[w0[0], w0[1], w1[0], w1[1], w2[0], w2[1], w3[0], w3[1]], uvt];
			case 2: // whatever [stime, etime, width,noteData]
				var st:Float = (Conductor.songPosition - 65165.56291390731) / 397.350993377;
				var times:Array<Float> = [
					0, 65165.56291390731, 65960.26490066228, 66754.96688741725, 67549.66887417222, 68344.37086092719, 69139.07284768215, 71523.17880794706,
					72317.88079470203, 73112.582781457, 73907.28476821196, 74701.98675496693, 75496.6887417219, 77880.7947019868, 78675.49668874177,
					79470.19867549674, 80264.9006622517, 84238.41059602654, 85033.11258278151, 85827.81456953648, 86622.51655629145
				];
				var stime:Float = FlxMath.lerp(parameters[0], parameters[1], head);
				var etime:Float = FlxMath.lerp(parameters[0], parameters[1], tail);

				var mst1:Float = (stime - 65165.56291390731) / 397.350993377;
				var x1:Float = 640 + 300 * Math.cos(stime / 794.701986755 * Math.PI);
				var y1:Float = 360 + 200 * Math.sin(stime / 794.701986755 * Math.PI);
				var group1:Float = Math.floor(Math.floor(mst1 / 2) - st / 2);
				group1 += (mst1 / 2) % 1;

				var mst2:Float = (etime - 65165.56291390731) / 397.350993377;
				var x2:Float = 640 + 300 * Math.cos(etime / 794.701986755 * Math.PI);
				var y2:Float = 360 + 200 * Math.sin(etime / 794.701986755 * Math.PI);
				var group2:Float = Math.floor(Math.floor(mst2 / 2) - st / 2);
				group2 += (mst2 / 2) % 1;
				if (mst1 >= 32)
				{
					x1 = 190 + 300 * parameters[3];
					y1 = 360 + 400 * Math.sin(stime / 794.701986755 * Math.PI);
					x2 = 190 + 300 * parameters[3];
					y2 = 360 + 400 * Math.sin(etime / 794.701986755 * Math.PI);
				}

				var z1:Float = 0;
				var z2:Float = 0;

				if ((st > 12 && st < 16) || (st > 28 && st < 32) || (st > 40 && st < 48) || (st > 56 && st < 64) || st < 0)
				{
					z1 = 200 + 1050 * (mst1 - st) / 2;
					z2 = 200 + 1050 * (mst2 - st) / 2;
				}
				else if (st % 2 > 1.5)
				{
					z1 = 200 + 1050 * group1 + 50 + 2000 * (2 - st % 2);
					z2 = 200 + 1050 * group2 + 50 + 2000 * (2 - st % 2);
				}
				else
				{
					group1 += 1;
					z1 = 200 + 1050 * group1 + 50 * (1.5 - st % 2) / 1.5;
					group2 += 1;
					z2 = 200 + 1050 * group2 + 50 * (1.5 - st % 2) / 1.5;
				}

				var p0:Array<Float> = NoteObject.toScreen(x1, y1 - parameters[2] / 2, z1);
				var p1:Array<Float> = NoteObject.toScreen(x1, y1 + parameters[2] / 2, z1);
				var p2:Array<Float> = NoteObject.toScreen(x2, y2 - parameters[2] / 2, z2);
				var p3:Array<Float> = NoteObject.toScreen(x2, y2 + parameters[2] / 2, z2);

				if (z1 < 0)
					return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
			case 3: // stupid [stime, etime, width, noteData, order]
				var stime:Float = FlxMath.lerp(parameters[0], parameters[1], head);
				var etime:Float = FlxMath.lerp(parameters[0], parameters[1], tail);

				var z1:Float = 300;
				var z2:Float = 300;
				if (stime > 103311.25827814577)
				{
					if (Conductor.songPosition > stime - parameters[4] * Conductor.stepCrochet)
					{
						var abb = (Conductor.songPosition - stime + parameters[4] * Conductor.stepCrochet) / Conductor.stepCrochet;
						if (abb > parameters[4] + head)
							z1 = 300 + 300 * Math.abs(Math.sin((Conductor.songPosition % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
						else
							z1 = 300
								+ 300 * Math.abs(Math.sin(((Conductor.songPosition - (parameters[4] +
									head - abb) * 100) % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
						if (abb > parameters[4] + tail)
							z2 = 300 + 300 * Math.abs(Math.sin((Conductor.songPosition % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
						else
							z2 = 300
								+ 300 * Math.abs(Math.sin(((Conductor.songPosition - (parameters[4] +
									tail - abb) * 100) % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
					}
					else
					{
						z1 = 300
							+ 300 * Math.abs(Math.sin(((Conductor.songPosition - (parameters[4] + head) * 100) % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
						z2 = 300
							+ 300 * Math.abs(Math.sin(((Conductor.songPosition - (parameters[4] + tail) * 100) % 1589.40397351) / 1589.40397351 * 2 * Math.PI));
					}
				}

				var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
				if (Conductor.songPosition % 794.701986755 > 694.701986755)
					ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
				if (Conductor.songPosition < 90596.02649006629)
					ang = 0;
				var x01 = 160 * (1.5 - parameters[3]) - parameters[2] / 2;
				var x02 = 160 * (1.5 - parameters[3]) + parameters[2] / 2;
				var y01 = (Conductor.songPosition - stime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
					2)) * (FlxG.save.data.downscroll ? 1 : -1) * (parameters[5] == 1 ? 1 : -1);
				var y02 = (Conductor.songPosition - etime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed,
					2)) * (FlxG.save.data.downscroll ? 1 : -1) * (parameters[5] == 1 ? 1 : -1);
				var x0 = 640 - Math.cos(ang) * x01 - Math.sin(ang) * y01;
				var y0 = 360 - Math.sin(ang) * x01 + Math.cos(ang) * y01;
				var x1 = 640 - Math.cos(ang) * x02 - Math.sin(ang) * y01;
				var y1 = 360 - Math.sin(ang) * x02 + Math.cos(ang) * y01;
				var x2 = 640 - Math.cos(ang) * x01 - Math.sin(ang) * y02;
				var y2 = 360 - Math.sin(ang) * x01 + Math.cos(ang) * y02;
				var x3 = 640 - Math.cos(ang) * x02 - Math.sin(ang) * y02;
				var y3 = 360 - Math.sin(ang) * x02 + Math.cos(ang) * y02;

				var p0:Array<Float> = NoteObject.toScreen(x0, y0, z1);
				var p1:Array<Float> = NoteObject.toScreen(x1, y1, z1);
				var p2:Array<Float> = NoteObject.toScreen(x2, y2, z2);
				var p3:Array<Float> = NoteObject.toScreen(x3, y3, z2);

				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
			case 4: // renderer is too great to not use  [stime, etime, width, noteData, mustpress]
				var stime:Float = FlxMath.lerp(parameters[0], parameters[1], head);
				var etime:Float = FlxMath.lerp(parameters[0], parameters[1], tail);

				var x = NoteObject.toWorld((parameters[4] == 1) ? 1040 : 240, 360)[0];
				var y1 = NoteObject.toWorld(640,
					(FlxG.save.data.downscroll ? (550 + Note.noteHeight[Std.int(parameters[3])] / 2) : (50 + Note.noteHeight[Std.int(parameters[3])] / 2)) +
					(Conductor.songPosition
						- stime) * (ModchartMath.scrollSpeed()) * (FlxG.save.data.downscroll ? 1 : -1))[1];
				var y2 = NoteObject.toWorld(640,
					(FlxG.save.data.downscroll ? (550 + Note.noteHeight[Std.int(parameters[3])] / 2) : (50 + Note.noteHeight[Std.int(parameters[3])] / 2)) +
					(Conductor.songPosition
						- etime) * (ModchartMath.scrollSpeed()) * (FlxG.save.data.downscroll ? 1 : -1))[1];
				var ang:Float = Math.floor((Conductor.songPosition - 90596.02649006629) / 794.701986755) * Math.PI / 8;
				if (Conductor.songPosition % 794.701986755 > 694.701986755)
					ang += ((Conductor.songPosition % 794.701986755) - 694.701986755) / 800 * Math.PI;
				if (Conductor.songPosition < 116026.49006622526)
					ang = 0;
				var z = 200 / 0.7 - Math.sin(ang) * (parameters[4] == 1 ? 100 : -100);
				x = 640 + Math.cos(ang) * (x - 640) + 160 * (parameters[3] - 1.5);

				var p0:Array<Float> = NoteObject.toScreen(x - parameters[2] / 2, y1, z);
				var p1:Array<Float> = NoteObject.toScreen(x + parameters[2] / 2, y1, z);
				var p2:Array<Float> = NoteObject.toScreen(x - parameters[2] / 2, y2, z);
				var p3:Array<Float> = NoteObject.toScreen(x + parameters[2] / 2, y2, z);
				return [[p0[0], p0[1], p1[0], p1[1], p2[0], p2[1], p3[0], p3[1]], uvt];
		}
		return null;
	}
}
