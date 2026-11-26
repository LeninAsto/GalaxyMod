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

class M_newton
{
	public static var previousLaneOrder:Array<Int> = [0, 1, 2, 3];
	public static var nextLaneOrder:Array<Int> = [0, 1, 2, 3];
	public static var projectionCenterY:Float = 720;
	public static var receptorDepth:Float = 200 / 0.7;

	public static function reset()
	{
		previousLaneOrder = [0, 1, 2, 3];
		nextLaneOrder = [0, 1, 2, 3];
		projectionCenterY = 720;
		receptorDepth = 200 / 0.7;
	}

	public static function updateNotePosition(note:Note)
	{
		if (note.strumTime >= 7058
			&& ((note.mustPress && note.strumTime < 14117) || (!note.mustPress && note.strumTime < 12000)))
		{
			applyNotesFrom7058(note);
		}
		else if (note.strumTime >= 14117 && note.strumTime < 22942)
		{
			applyNotesFrom14117(note);
		}
		else if (note.strumTime >= 28235 && note.strumTime < 35294)
		{
			applyNotesFrom28235(note);
		}
		else if (note.strumTime >= 35294 && note.strumTime < 49302 || (note.strumTime < 49412 && note.mustPress))
		{
			if (FlxG.save.data.downscroll)
				note.y = (550 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (50 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			note.x = note.mustPress ? PlayMoving.playerReceptorX[note.noteData] : PlayMoving.opponentReceptorX[note.noteData];
			if (note.isSustainNote)
				note.x += (Note.noteWidth[note.noteData] - note.width) / 2;
		}
		else if (note.strumTime >= 49411 && note.strumTime < 63528 || (note.strumTime < 63530 && note.mustPress))
		{
			if (FlxG.save.data.downscroll)
				note.y = (550 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (50 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			note.alpha = Math.cos((Conductor.songPosition / 441.176470588 * 2) * Math.PI) + 1;
			if (note.isSustainNote)
				note.alpha *= 0.6;
		}
		else if (note.strumTime >= 63529)
		{
			applyNotesFrom63529(note);
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
		if (Conductor.songPosition >= 0 && Conductor.songPosition < 60000 / 136 * 14)
		{
			if (Conductor.songPosition % (60000 / 136) / (60000 / 136) <= 0.2)
			{
				while (nextLaneOrder[0] == previousLaneOrder[0] && nextLaneOrder[1] == previousLaneOrder[1] && nextLaneOrder[2] == previousLaneOrder[2] && nextLaneOrder[3] == previousLaneOrder[3])
				{
					new FlxRandom().shuffle(nextLaneOrder);
				}
				receptor.x = FlxMath.lerp(PlayMoving.defaultOpponentReceptorX[previousLaneOrder[receptor.ID]], PlayMoving.defaultOpponentReceptorX[nextLaneOrder[receptor.ID]],
					(Conductor.songPosition % (60000 / 136) / (60000 / 136)) / 0.2);
			}
			else
			{
				receptor.x = PlayMoving.defaultOpponentReceptorX[nextLaneOrder[receptor.ID]];
				previousLaneOrder[0] = nextLaneOrder[0];
				previousLaneOrder[1] = nextLaneOrder[1];
				previousLaneOrder[2] = nextLaneOrder[2];
				previousLaneOrder[3] = nextLaneOrder[3];
			}
		}
		else if (Conductor.songPosition > 60000 / 136 * 14 && Conductor.songPosition < 60000 / 136 * 16)
		{
			var slist = [810, 900, 720, 630];
			receptor.angle = FlxMath.lerp(0, slist[receptor.ID], (Conductor.songPosition - 60000 / 136 * 14) / (60000 / 68));
			if (Conductor.songPosition > 60000 / 136 * 15)
			{
				receptor.x = FlxMath.lerp(PlayMoving.defaultOpponentReceptorX[nextLaneOrder[receptor.ID]], 218, (Conductor.songPosition - 60000 / 136 * 15) / (60000 / 136));
			}
		}
		else if (Conductor.songPosition > 60000 / 136 * 16 && Conductor.songPosition < 14117.647058823528)
		{
			applyStrumsAfterBeat16(receptor);
		}
		else if (Conductor.songPosition >= 14117.647058823528 && Conductor.songPosition < 14999.999999999998)
		{
			// FlxG.drawFramerate = 60;
			receptor.angle = 0;
			var y:Float = 50;
			if (FlxG.save.data.downscroll)
				y = 550;
			var x = PlayMoving.defaultOpponentReceptorX[receptor.ID];
			var non:Array<Array<Float>> = buildTriangles(x, y, receptor.width * 0.7, receptor.height * 0.7,
				PlayMoving.ease((Conductor.songPosition - 14117.647058823528) / 882.352941176));
			receptor.render(non[0], non[1]);
		}
		else if (Conductor.songPosition >= 14999.999999999998 && Conductor.songPosition < 21066.17647058823)
		{
			var y:Float = 50;
			if (FlxG.save.data.downscroll)
				y = 550;
			var x = PlayMoving.defaultOpponentReceptorX[receptor.ID];
			var non:Array<Array<Float>> = buildTriangles(x, y, receptor.width * 0.7, receptor.height * 0.7, 1);
			receptor.render(non[0], non[1]);
		}
		else if (Conductor.songPosition >= 21176.47058823529 && Conductor.songPosition < 21264.7058824)
		{
			var y:Float = 50;
			if (FlxG.save.data.downscroll)
				y = 550;
			var x = PlayMoving.defaultOpponentReceptorX[receptor.ID];
			var non:Array<Array<Float>> = buildTriangles(x, y, receptor.width * 0.7, receptor.height * 0.7,
				PlayMoving.ease((21264.7058824 - Conductor.songPosition) / 88.2352941176));
			receptor.render(non[0], non[1]);
		}
		else if (Conductor.songPosition >= 21264.7058824 && Conductor.songPosition < 28235)
		{
			receptor.rendermode = 0;
			receptor.scale.x = 0.7;
			receptor.scale.y = 0.7;
			if (receptor.animation.curAnim.name != 'confirm')
				receptor.updateHitbox();
			receptor.y = FlxG.save.data.downscroll ? 550 : 50;
			receptor.x = receptor.player == 0 ? PlayMoving.defaultOpponentReceptorX[receptor.ID] : PlayMoving.defaultPlayerReceptorX[receptor.ID];
		}
		else if (Conductor.songPosition >= 28235.294117647052 && Conductor.songPosition < 35294.11764705882)
		{
			if (receptor.player == 0)
			{
				receptor.x = PlayMoving.opponentReceptorX[receptor.ID]
					- (Math.cos((Conductor.songPosition - 28235.294117647052) / 441.176470588 * Math.PI) - 1) * 127;
			}
		}
		else if (Conductor.songPosition >= 35294.11764705882 && Conductor.songPosition < 49411.76470588237)
		{
			if ((Conductor.songPosition / 441.176470588) % 16 < 8)
			{
				if ((Conductor.songPosition / (441.176470588 / 2)) % 8 >= 1 && (Conductor.songPosition / (441.176470588 / 2)) % 8 < 4)
				{
					if ((Conductor.songPosition / (441.176470588 / 4)) % 2 < 1)
						receptor.x = receptor.player == 0 ? PlayMoving.defaultOpponentReceptorX[3 - receptor.ID] : PlayMoving.defaultPlayerReceptorX[3 - receptor.ID];
					else
						receptor.x = receptor.player == 0 ? PlayMoving.defaultOpponentReceptorX[receptor.ID] : PlayMoving.defaultPlayerReceptorX[receptor.ID];
					if (receptor.player == 0)
						PlayMoving.opponentReceptorX[receptor.ID] = receptor.x;
					else
						PlayMoving.playerReceptorX[receptor.ID] = receptor.x;
				}
			}
			if (Conductor.songPosition >= 42352.941176470595 && receptor.player == 0)
			{
				if ((Conductor.songPosition / (441.176470588 / 4)) % 2 < 1)
					receptor.x = PlayMoving.defaultOpponentReceptorX[3 - receptor.ID];
				else
					receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID];
				PlayMoving.opponentReceptorX[receptor.ID] = receptor.x;
			}
		}
		else if (Conductor.songPosition > 49411.76470588237 && Conductor.songPosition < 49511.76470588237)
		{
			PlayMoving.opponentReceptorX = PlayMoving.defaultOpponentReceptorX.copy();
			PlayMoving.playerReceptorX = PlayMoving.defaultPlayerReceptorX.copy();
		}
		else if (Conductor.songPosition >= 63529.411764705925)
		{
			applyStrumsFrom63529(receptor);
		}
	}

	public static function updatePlayerReceptorPosition(receptor:NoteStrum)
	{
		if (Conductor.songPosition >= 0 && Conductor.songPosition < 60000 / 136 * 14)
		{
			if (Conductor.songPosition % (60000 / 136) / (60000 / 136) <= 0.2)
			{
				receptor.x = FlxMath.lerp(PlayMoving.defaultPlayerReceptorX[previousLaneOrder[receptor.ID]], PlayMoving.defaultPlayerReceptorX[nextLaneOrder[receptor.ID]],
					(Conductor.songPosition % (60000 / 136) / (60000 / 136)) / 0.2);
			}
			else
			{
				receptor.x = PlayMoving.defaultPlayerReceptorX[nextLaneOrder[receptor.ID]];
			}
		}
		else if (Conductor.songPosition > 60000 / 136 * 15 && Conductor.songPosition < 60000 / 136 * 16)
		{
			receptor.x = FlxMath.lerp(PlayMoving.defaultPlayerReceptorX[nextLaneOrder[receptor.ID]], 858, (Conductor.songPosition - 60000 / 136 * 15) / (60000 / 136));
		}
		else if (Conductor.songPosition >= 14117.647058823528 && Conductor.songPosition < 14999.999999999998)
		{
			var slist:Array<Float> = [-90, 0, 180, 90];
			receptor.angle = slist[receptor.ID] * (14999.999999999998 - Conductor.songPosition) / 882.352941176;
			receptor.alpha = 1;
			var y:Float = 50;
			if (FlxG.save.data.downscroll)
				y = 550;
			var x = 858 - (858 - PlayMoving.defaultPlayerReceptorX[receptor.ID]) * ((Conductor.songPosition - 14117.647058823528) / 882.352941176);
			var w = receptor.width * 0.7;
			var h = receptor.height * 0.7;
			if (receptor.animation.curAnim.name == 'confirm')
			{
				x -= (238 - 157) / 2 * 0.7;
				y -= (235 - 154) / 2 * 0.7;
				w *= 238 / 157;
				h *= 235 / 154;
			}
			var non:Array<Array<Float>> = buildTriangles(x, y, w, h, PlayMoving.ease((Conductor.songPosition - 14117.647058823528) / 882.352941176));
			receptor.render(non[0], non[1]);
		}
		else if (Conductor.songPosition >= 14999.999999999998 && Conductor.songPosition < 21066.17647058823)
		{
			var y:Float = 50;
			if (FlxG.save.data.downscroll)
				y = 550;
			var x = PlayMoving.defaultPlayerReceptorX[receptor.ID];
			var w = receptor.width * 0.7;
			var h = receptor.height * 0.7;
			if (receptor.animation.curAnim.name == 'confirm')
			{
				x -= (238 - 157) / 2 * 0.7;
				y -= (235 - 154) / 2 * 0.7;
				w *= 238 / 157;
				h *= 235 / 154;
			}
			var non:Array<Array<Float>> = buildTriangles(x, y, w, h, 1);
			receptor.render(non[0], non[1]);
		}
		else if (Conductor.songPosition >= 21176.47058823529 && Conductor.songPosition < 21264.7058824)
		{
			var y:Float = 50;
			if (FlxG.save.data.downscroll)
				y = 550;
			var x = PlayMoving.defaultPlayerReceptorX[receptor.ID];
			var w = receptor.width * 0.7;
			var h = receptor.height * 0.7;
			if (receptor.animation.curAnim.name == 'confirm')
			{
				// x -= (238 - 157) / 2 * 0.7;
				// y -= (235 - 154) / 2 * 0.7;
				w *= 238 / 157;
				h *= 235 / 154;
			}
			var non:Array<Array<Float>> = buildTriangles(x, y, w, h, PlayMoving.ease((21264.7058824 - Conductor.songPosition) / 88.2352941176));
			receptor.render(non[0], non[1]);
		}
	}

	public static function applyNoteShape(note:Note, camHUD:FlxCamera):Bool
	{
		return false;
	}

	public static function shouldHideNote(note:Note):Bool
	{
		if (note.strumTime >= 14117 && note.strumTime < 21397)
		{
			if (note.verticles == null)
				return true;
			if (FlxG.save.data.downscroll)
				return note.verticles[5] < note.verticles[1] - note.verticles[5] || note.verticles[0] >= note.verticles[2];
			else
				return note.verticles[1] > FlxG.height;
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
		if ((note.strumTime >= 14117 && note.strumTime < 21397) || (note.strumTime >= 63529))
		{
			if (note.verticles == null)
				return false;
			if (FlxG.save.data.downscroll)
				return note.verticles[1] > FlxG.height;
			else
				return note.verticles[5] < note.verticles[1] - note.verticles[5] || note.verticles[0] >= note.verticles[2];
		}
		else if (note.strumTime >= 49411 && note.strumTime < 63528)
			return note.tooLate;
		else
		{
			if (FlxG.save.data.downscroll)
				return note.y > FlxG.height;
			else
				return note.y < -note.height;
		}
	}

	public static function buildTriangles(x:Float, y:Float, width:Float, height:Float, a:Float, z:Float = 200 / 0.7, midy:Float = 720):Array<Array<Float>>
	{
		return NoteObject.triangles(x, y, z, width, height, a * -15, 0, 0, 640, midy);
		// [0, 0, t0, 1, 0, t1, 0, 1, t2, 1, 1, t3]
	}
	static function applyNotesFrom7058(note:Note):Void
	{
		if (note.mustPress)
			note.x = 858;
		else
			note.x = 218;
		switch (Std.int(Conductor.songPosition / (60000 / 136)) % 4)
		{
			case 0:
				note.animation.play('greenScroll');
			case 1:
				note.animation.play('redScroll');
			case 2:
				note.animation.play('blueScroll');
			case 3:
				note.animation.play('purpleScroll');
		}
		if (Conductor.songPosition % (60000 / 136) / (60000 / 136) <= 0.7
			&& Conductor.songPosition % (60000 / 136) / (60000 / 136) >= 0.5)
		{
			note.angle = FlxMath.lerp(0, 90, (Conductor.songPosition % (60000 / 136) / (60000 / 136) - 0.5) / 0.2);
		}
		else if (Conductor.songPosition % (60000 / 136) / (60000 / 136) > 0.7)
		{
			note.angle = 90;
		}
		else
		{
			note.angle = 0;
		}
		if (FlxG.save.data.downscroll)
			note.y = (550 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		else
			note.y = (50 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
	}

	static function applyNotesFrom14117(note:Note):Void
	{
		var y:Float = (50 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		if (FlxG.save.data.downscroll)
			y = (550 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		var x:Float = PlayMoving.defaultOpponentReceptorX[note.noteData];
		if (note.mustPress)
			x = PlayMoving.defaultPlayerReceptorX[note.noteData];
		if (note.isSustainNote)
		{
			x += (Note.noteWidth[note.noteData] - note.width) / 2;
			note.alpha = 0.6;
		}
		var a:Float = 0;
		if (Conductor.songPosition >= 14117.647058823528)
			a = PlayMoving.ease((Conductor.songPosition - 14117.647058823528) / 882.352941176);
		if (Conductor.songPosition >= 14999.999999999998)
			a = 1;
		if (Conductor.songPosition >= 21176.47058823529)
			a = PlayMoving.ease((21264.7058824 - Conductor.songPosition) / 88.2352941176);
		if (Conductor.songPosition >= 21264.7058824)
			a = 0;
		var h:Float = note.height * 0.7;
		if (note.isSustainNote && note.animation.curAnim.name.endsWith('hold'))
		{
			h *= ModchartMath.sustainScale();
		}
		if (note.isSustainNote && (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
		{
			if (FlxG.save.data.downscroll && y + h > 550 + Note.swagWidth / 2)
			{
				h = 550 + Note.swagWidth / 2 - y;
			}
			else if (!FlxG.save.data.downscroll && y < 50 + Note.swagWidth / 2)
			{
				h = y + h - 50 - Note.swagWidth / 2;
				y = 50 + Note.swagWidth / 2;
			}
		}
		/*if (note.isEnd)
			{
				x -= 18;
				y -= 18;
		}*/
		var non:Array<Array<Float>> = buildTriangles(x, y, note.width * 0.7, h, a);
		if (FlxG.save.data.downscroll && note.isSustainNote)
		{
			non = buildTriangles(x, y + h, note.width * 0.7, -h, a);
		}
		note.render(non[0], non[1]);
	}

	static function applyNotesFrom28235(note:Note):Void
	{
		if (FlxG.save.data.downscroll)
			note.y = (550 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		else
			note.y = (50 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		if (!note.mustPress)
		{
			note.x = PlayMoving.opponentReceptorX[note.noteData];
			if (note.isSustainNote)
			{
				note.x += (Note.noteWidth[note.noteData] - note.width) / 2;
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
				var y:Float = note.y;
				if (FlxG.save.data.downscroll)
				{
					y += h * 1.5;
					h *= -1;
					if (note.animation.curAnim.name.endsWith('end'))
					{
						y += h / 4;
					}
				}
				note.renderer = new R_newton(0, [
					note.strumTime - Conductor.stepCrochet,
					note.strumTime - Conductor.stepCrochet + len,
					note.x,
					y,
					note.width,
					h
				]);
				if (Conductor.songPosition > note.strumTime - len * 0.75)
				{
					note.renderer.pathRatio = 1
						- (Conductor.songPosition
							- (note.strumTime - Conductor.stepCrochet + len - Conductor.stepCrochet * 0.75)) / (Conductor.stepCrochet * 0.75);
				}
				note.pathrender();
			}
		}
	}

	static function applyNotesFrom63529(note:Note):Void
	{
		var y:Float = (PlayMoving.receptorY[note.noteData]
			- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		if (FlxG.save.data.downscroll)
			y = (PlayMoving.receptorY[note.noteData] + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		var x:Float = PlayMoving.opponentReceptorX[note.noteData];
		if (note.mustPress)
			x = PlayMoving.playerReceptorX[note.noteData];
		var a:Float = 1;
		if (Conductor.songPosition > 91764.70588235292)
			a = 1 + Math.sin(Conductor.songPosition / 1764.70588235 * Math.PI) * 0.5;
		else if (Conductor.songPosition < 63529.411764705925)
			a = 0;
		else if (Conductor.songPosition < 63639.70588235298)
			a = PlayMoving.ease((Conductor.songPosition - 63529.411764705925) / 110.294117647);
		var proc:Float = (Math.abs(note.strumTime - Conductor.songPosition) % 441.176470588);
		var z:Float = receptorDepth + (proc) * (proc - 441.176470588) / 500;
		note.z = z;
		var non:Array<Array<Float>> = buildTriangles(x, y, note.width * 0.7, note.height * 0.7, a, z, projectionCenterY);
		note.render(non[0], non[1]);
		if (note.isSustainNote)
		{
			x += (Note.noteWidth[note.noteData] - note.width) / 2;
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
			note.renderer = new R_newton(2, [
				note.strumTime - Conductor.stepCrochet,
				note.strumTime - Conductor.stepCrochet + len,
				x,
				y,
				note.width,
				h,
				a,
				projectionCenterY,
				receptorDepth
			]);
			if (!FlxG.save.data.downscroll
				&& y <= PlayMoving.receptorY[note.noteData] + Note.swagWidth / 2
				&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
			{
				var cw:Float = PlayMoving.receptorY[note.noteData] + Note.swagWidth / 2 - y - note.offset.y;
				note.renderer.pathRatio = 1 - (cw / h);
			}
			if (FlxG.save.data.downscroll
				&& y >= PlayMoving.receptorY[note.noteData] + Note.swagWidth / 2
				&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
			{
				var cw:Float = y - PlayMoving.receptorY[note.noteData] - Note.swagWidth / 2;
				note.renderer.pathRatio = 1 + (cw / h);
			}
			note.pathrender();
		}
	}

	static function applyStrumsAfterBeat16(receptor:NoteStrum):Void
	{
		var show:Int = -1;
		switch (Std.int(Conductor.songPosition / (60000 / 136)) % 4)
		{
			case 0:
				show = 2;
			case 1:
				show = 3;
			case 2:
				show = 1;
			case 3:
				show = 0;
		}
		if (Conductor.songPosition > 13235.294117647058 && receptor.player == 0)
		{
			var slist:Array<Float> = [-90, 0, 180, 90];
			if (Conductor.songPosition >= 13676.470588235294)
			{
				receptor.angle = 0;
				receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID];
			}
			else
			{
				receptor.angle = slist[receptor.ID] * (13676.470588235294 - Conductor.songPosition) / 441.176470588;
				receptor.x = 218 + (PlayMoving.defaultOpponentReceptorX[receptor.ID] - 218) * (Conductor.songPosition - 13235.294117647058) / 441.176470588;
			}
			receptor.alpha = 1;
		}
		else
		{
			receptor.rendermode = 0;
			if (receptor.ID == show)
			{
				receptor.alpha = 1;
			}
			else
			{
				receptor.alpha = 0;
			}
			if (Conductor.songPosition % (60000 / 136) / (60000 / 136) <= 0.7
				&& Conductor.songPosition % (60000 / 136) / (60000 / 136) >= 0.5)
			{
				receptor.angle = FlxMath.lerp(0, 90, (Conductor.songPosition % (60000 / 136) / (60000 / 136) - 0.5) / 0.2);
			}
			else if (Conductor.songPosition % (60000 / 136) / (60000 / 136) > 0.7)
			{
				receptor.angle = 90;
			}
			else
			{
				receptor.angle = 0;
			}
		}
	}

	static function applyStrumsFrom63529(receptor:NoteStrum):Void
	{
		var y:Float = 50;
		if (FlxG.save.data.downscroll)
			y = 550;
		var x:Float = PlayMoving.defaultOpponentReceptorX[receptor.ID];
		if (receptor.player == 1)
			x = PlayMoving.defaultPlayerReceptorX[receptor.ID];
		if (Conductor.songPosition >= 91764.70588235292 + 220.588235294 * receptor.ID)
			y = FlxG.save.data.downscroll ? 550 : 50;
		else if (Conductor.songPosition >= 77647.05882352943 + 220.588235294 * receptor.ID)
		{
			y -= Math.sin((Conductor.songPosition - 220.588235294 * receptor.ID) / 441.176470588 * Math.PI) * 20;
		}
		PlayMoving.receptorY[receptor.ID] = y;
		var w = receptor.width * 0.7;
		var h = receptor.height * 0.7;
		if (receptor.animation.curAnim.name == 'confirm')
		{
			x -= (238 - 157) / 2 * 0.7;
			y -= (235 - 154) / 2 * 0.7;
			w *= 238 / 157;
			h *= 235 / 154;
		}
		var a:Float = 1;
		if (Conductor.songPosition > 91764.70588235292)
			a = 1 + Math.sin(Conductor.songPosition / 1764.70588235 * Math.PI) * 0.5;
		if (Conductor.songPosition < 63639.70588235298)
			a = PlayMoving.ease((Conductor.songPosition - 63529.411764705925) / 110.294117647);
		if (Conductor.songPosition > 92647.0588235294)
		{
			projectionCenterY = 360;
			receptorDepth = 400;
		}
		else if (Conductor.songPosition > 91764.70588235292)
		{
			projectionCenterY = 720 - (Conductor.songPosition - 91764.70588235292) / 882.352941176 * 360;
			receptorDepth = FlxMath.lerp(200 / 0.7, 400, (Conductor.songPosition - 91764.70588235292) / 882.352941176);
		}
		receptor.z = receptorDepth;
		var non:Array<Array<Float>> = buildTriangles(x, y, w, h, a, receptorDepth, projectionCenterY);
		receptor.render(non[0], non[1]);
	}

}

class R_newton extends RenderPath
{
	override function start(head:Float, tail:Float):Array<Array<Float>>
	{
		var uvt:Array<Float> = [0, head, 1, head, 0, tail, 1, tail];
		switch (mode)
		{
			case 0: // wave [startTime, endTime, x, y, w, h]
				var stime:Float = FlxMath.lerp(parameters[0], parameters[1], head);
				var etime:Float = FlxMath.lerp(parameters[0], parameters[1], tail);

				var x0:Float = parameters[2] - (Math.cos((stime - 28235.294117647052) / 441.176470588 * Math.PI) - 1) * 127;
				var x1:Float = parameters[2] - (Math.cos((etime - 28235.294117647052) / 441.176470588 * Math.PI) - 1) * 127;

				return [
					[
						x0,
						parameters[3] + head * parameters[5],
						x0 + parameters[4],
						parameters[3] + head * parameters[5],
						x1,
						parameters[3] + tail * parameters[5],
						x1 + parameters[4],
						parameters[3] + tail * parameters[5]
					],
					uvt
				];
			case 1: // spin [startTime, endTime, x, w]
				var stime:Float = FlxMath.lerp(parameters[0], parameters[1], head);
				var etime:Float = FlxMath.lerp(parameters[0], parameters[1], tail);

				var x0:Float = Math.sin(stime / 882.352941176 * Math.PI) * -(200 - parameters[3] / 2) + parameters[2];
				var x1:Float = Math.sin(stime / 882.352941176 * Math.PI) * -(200 + parameters[3] / 2) + parameters[2];
				var x2:Float = Math.sin(etime / 882.352941176 * Math.PI) * -(200 - parameters[3] / 2) + parameters[2];
				var x3:Float = Math.sin(etime / 882.352941176 * Math.PI) * -(200 + parameters[3] / 2) + parameters[2];
				var y0:Float = Math.cos(stime / 882.352941176 * Math.PI) * (200 - parameters[3] / 2) + 360;
				var y1:Float = Math.cos(stime / 882.352941176 * Math.PI) * (200 + parameters[3] / 2) + 360;
				var y2:Float = Math.cos(etime / 882.352941176 * Math.PI) * (200 - parameters[3] / 2) + 360;
				var y3:Float = Math.cos(etime / 882.352941176 * Math.PI) * (200 + parameters[3] / 2) + 360;
				return [[x0, y0, x1, y1, x2, y2, x3, y3], uvt];
			case 2: // bounce [startTime, endTime, x, y, w, h, a]
				var stime:Float = FlxMath.lerp(parameters[0], parameters[1], head);
				var etime:Float = FlxMath.lerp(parameters[0], parameters[1], tail);

				var proc:Float = (Math.abs(stime - Conductor.songPosition) % 441.176470588);
				var z0:Float = parameters[8] + (proc) * (proc - 441.176470588) / 500;

				proc = Math.abs(etime - Conductor.songPosition) % 441.176470588;
				var z1:Float = parameters[8] + (proc) * (proc - 441.176470588) / 500;

				var arr:Array<Array<Float>> = M_newton.buildTriangles(parameters[2], parameters[3] + parameters[5] * head, parameters[4], parameters[5], parameters[6], z0, parameters[7]);
				var arr2:Array<Array<Float>> = M_newton.buildTriangles(parameters[2], parameters[3], parameters[4], parameters[5] * tail, parameters[6], z1, parameters[7]);

				if ((arr[0][0] == 0 && arr[0][1] == 0 && arr[0][2] == 0 && arr[0][3] == 0 && arr[0][4] == 0 && arr[0][5] == 0 && arr[0][6] == 0
					&& arr[0][7] == 0)
					|| (arr2[0][0] == 0 && arr2[0][1] == 0 && arr2[0][2] == 0 && arr2[0][3] == 0 && arr2[0][4] == 0 && arr2[0][5] == 0 && arr2[0][6] == 0
						&& arr2[0][7] == 0))
					return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
				return [
					[
						 arr[0][0],  arr[0][1],
						 arr[0][2],  arr[0][3],
						arr2[0][4], arr2[0][5],
						arr2[0][6], arr2[0][7]
					],
					[
						0, head,  arr[1][2],
						1, head,  arr[1][5],
						0, tail, arr2[1][8],
						1, tail, arr2[1][11]
					]
				];
		}
		return null;
	}
}
