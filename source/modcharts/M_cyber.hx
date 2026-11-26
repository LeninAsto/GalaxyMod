package modcharts;

import backend.data.Song.SwagSong;
import Std;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxStrip;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.scaleModes.FixedScaleMode;
import flixel.system.scaleModes.RatioScaleMode;
import haxe.Exception;
import openfl.Lib;
import openfl.system.Capabilities;

using StringTools;

class M_cyber
{
	public static var count:Int = 0;

	public static function resetWindowEffects()
	{
		count = 0;
	}

	public static function updateNotePosition(note:Note, strumLine:FlxSprite)
	{
		if (Conductor.songPosition >= 70280.8988764045 && Conductor.songPosition < 91595.50561797764)
			note.y = (PlayMoving.receptorBaselineY
				- (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(((300 - PlayMoving.receptorBaselineY) / 250) * PlayState.SONG.speed, 2)));
		else if (Conductor.songPosition >= 124044.94382022502 && Conductor.songPosition < 145617.977528)
		{
			if (FlxG.save.data.downscroll)
				note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			if ((!FlxG.save.data.downscroll
				&& (((Conductor.songPosition - 124044.94382022502) % 2696.62921348 < 1348.31460674 && note.y <= PlayMoving.receptorBaselineY)
					|| ((Conductor.songPosition - 124044.94382022502) % 2696.62921348 >= 1348.31460674 && note.y > PlayMoving.receptorBaselineY)))
				|| (FlxG.save.data.downscroll
					&& (((Conductor.songPosition - 124044.94382022502) % 2696.62921348 < 1348.31460674 && note.y >= PlayMoving.receptorBaselineY)
						|| ((Conductor.songPosition - 124044.94382022502) % 2696.62921348 >= 1348.31460674 && note.y < PlayMoving.receptorBaselineY))))
			{
				if (note.mustPress)
					note.x = PlayMoving.defaultPlayerReceptorX[note.noteData];
				else
					note.x = PlayMoving.defaultOpponentReceptorX[note.noteData];
			}
			else
			{
				if (note.mustPress)
					note.x = PlayMoving.defaultPlayerReceptorX[3 - note.noteData];
				else
					note.x = PlayMoving.defaultOpponentReceptorX[3 - note.noteData];
			}
			if (note.isSustainNote)
				note.x += note.width;
		}
		else if (note.strumTime >= 145617 && note.strumTime < 156236)
		{
			if (note.mustPress)
				note.x = PlayMoving.defaultPlayerReceptorX[note.noteData];
			else
				note.x = PlayMoving.defaultOpponentReceptorX[note.noteData];
			if (note.isSustainNote)
				note.x += note.width;
			else
				note.angle += 5;
			if (FlxG.save.data.downscroll)
				note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		else if (note.strumTime >= 156404 && note.strumTime < 168456 && Conductor.songPosition < 167191.0112359552)
		{
			if (note.mustPress)
				note.x = PlayMoving.defaultPlayerReceptorX[note.noteData]
					+ (Math.sin((note.strumTime - 156404.49438202268) / (2696.62921348) * 3.1415926535) * (PlayWindow.stage[0] * 2 / 10)
						+ PlayWindow.stage[0] / 2 - Lib.application.window.x - 320) * 2;
			else
				note.x = PlayMoving.defaultOpponentReceptorX[note.noteData]
					+ (Math.sin((note.strumTime - 156404.49438202268) / (2696.62921348) * 3.1415926535) * (PlayWindow.stage[0] * 2 / 10)
						+ PlayWindow.stage[0] / 2 - Lib.application.window.x - 320) * 2;
			note.y = strumLine.y
				+ (Math.cos((note.strumTime - 156404.49438202268) / (2696.62921348) * 3.1415926535) * (PlayWindow.stage[1] * -2 / 10)
					+ PlayWindow.stage[1] / 2 - Lib.application.window.y - 180) * 2;
		}
		else if (Conductor.songPosition >= 167191.0112359552 && Conductor.songPosition < 172584.26966292146)
		{
			if (note.mustPress)
				note.x = PlayMoving.defaultPlayerReceptorX[note.noteData];
			else
				note.x = PlayMoving.defaultOpponentReceptorX[note.noteData];
			if (note.strumTime % 2696.62921348 < 1348.31460674)
				if (note.strumTime % 1348.31460674 < 674.157303371)
					note.y = (50
						+ 500 * (note.strumTime % 1348.31460674) / 1348.31460674
						- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = (50
						+ 500 * (note.strumTime % 1348.31460674) / 1348.31460674
						+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else if (note.strumTime % 1348.31460674 < 674.157303371)
				note.y = (550
					- 500 * (note.strumTime % 1348.31460674) / 1348.31460674
					+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (550
					- 500 * (note.strumTime % 1348.31460674) / 1348.31460674
					- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		else if (Conductor.songPosition >= 172584.26966292146 && Conductor.songPosition < 177977.52808988772)
		{
			if (note.mustPress)
				note.x = PlayMoving.playerReceptorX[note.noteData];
			else
				note.x = PlayMoving.opponentReceptorX[note.noteData];
			if (FlxG.save.data.downscroll)
				note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		/*if(Conductor.songPosition >= 91685.3932584271 && Conductor.songPosition < 102387.64044943838)
			{
				if (Conductor.songPosition % 40 < 20)
				{
					if (note.noteData < 2)
						note.alpha = 0;
					else 
						note.alpha = 1;
				}
				else
				{
					if (note.noteData < 2)
						note.alpha = 1;
					else 
						note.alpha = 0;
				}
				if(!note.mustPress)
					note.x = PlayMoving.defaultOpponentReceptorX[1 + note.noteData % 2];
				else
					note.x = PlayMoving.defaultPlayerReceptorX[1 + note.noteData % 2];
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}*/
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
		if (Conductor.songPosition >= 48707.86516853933 && Conductor.songPosition < 58988.76404494382)
		{
			if (FlxG.save.data.downscroll)
				receptor.y = 550 + ((Conductor.songPosition - 48707.86516853933) / 10280.8988764) * 160;
			else
				receptor.y = 50 - ((Conductor.songPosition - 48707.86516853933) / 10280.8988764) * 160;
			strumLine.y = receptor.y;
		}
		else if (Conductor.songPosition >= 59325.84269662921 && Conductor.songPosition < 59494.38202247191)
		{
			if (FlxG.save.data.downscroll)
				receptor.y = 550;
			else
				receptor.y = 50;
			strumLine.y = receptor.y;
		}
		else if (Conductor.songPosition >= 59494.38202247191 && Conductor.songPosition < 69775.28089887642)
		{
			if (FlxG.save.data.downscroll)
				receptor.y = 550 + ((Conductor.songPosition - 59494.38202247191) / 10280.8988764) * 160;
			else
				receptor.y = 50 - ((Conductor.songPosition - 59494.38202247191) / 10280.8988764) * 160;
			strumLine.y = receptor.y;
		}
		else if (Conductor.songPosition >= 70112.35955056181 && Conductor.songPosition < 70280.8988764045)
		{
			if (FlxG.save.data.downscroll)
				receptor.y = 550;
			else
				receptor.y = 50;
			strumLine.y = receptor.y;
		}
		else if (Conductor.songPosition >= 70280.8988764045 && Conductor.songPosition < 91595.50561797764)
		{
			receptor.y = 300 - Math.sin(((Conductor.songPosition - 70280.8988764045) / 1348.31460674 - 0.5) * 3.1415926535) * 250;
			strumLine.y = receptor.y;
			PlayMoving.receptorBaselineY = receptor.y;
		}
		else if (Conductor.songPosition >= 91685.3932584271 && Conductor.songPosition < 93033.70786516868)
		{
			if (FlxG.save.data.downscroll)
				receptor.y = 550;
			else
				receptor.y = 50;
			strumLine.y = receptor.y;
		}
		else if (Conductor.songPosition >= 124044.94382022502 && Conductor.songPosition < 145617.977528)
		{
			if ((Conductor.songPosition - 124044.94382022502) % 2696.62921348 < 1348.31460674)
			{
				if (receptor.x > 640)
					receptor.x = PlayMoving.defaultPlayerReceptorX[receptor.ID];
				else
					receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID];
			}
			else
			{
				if (receptor.x > 640)
					receptor.x = PlayMoving.defaultPlayerReceptorX[3 - receptor.ID];
				else
					receptor.x = PlayMoving.defaultOpponentReceptorX[3 - receptor.ID];
			}
			if (FlxG.save.data.downscroll)
				PlayMoving.receptorBaselineY = 550 - ((Conductor.songPosition - 124044.94382022502) % 1348.31460674) / 1348.31460674 * 1230;
			else
				PlayMoving.receptorBaselineY = 50 + ((Conductor.songPosition - 124044.94382022502) % 1348.31460674) / 1348.31460674 * 1230;
		}
		else if (Conductor.songPosition >= 145617.97752809015 && Conductor.songPosition < 156067.4157303373)
		{
			if (receptor.x > 640)
				receptor.x = PlayMoving.defaultPlayerReceptorX[receptor.ID];
			else
				receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID];
		}
		else if (Conductor.songPosition >= 156067.4157303373 && Conductor.songPosition < 156235.95505617998)
		{
			if (FlxG.save.data.downscroll)
				receptor.y = 550 - (Conductor.songPosition - 156067.4157303373) / 168.539325843 * 250;
			else
				receptor.y = 50 + (Conductor.songPosition - 156067.4157303373) / 168.539325843 * 250;
			strumLine.y = receptor.y;
		}
		else if (Conductor.songPosition >= 167191.0112359552 && Conductor.songPosition < 172584.26966292146)
		{
			if (Conductor.songPosition % 2696.62921348 < 1348.31460674)
				receptor.y = 50 + 500 * (Conductor.songPosition % 1348.31460674) / 1348.31460674;
			else
				receptor.y = 550 - 500 * (Conductor.songPosition % 1348.31460674) / 1348.31460674;
		}
		else if (Conductor.songPosition >= 172584.26966292146 && Conductor.songPosition < 177977.52808988772)
		{
			if (FlxG.save.data.downscroll)
				receptor.y = 550;
			else
				receptor.y = 50;
			strumLine.y = receptor.y;
			receptor.scale.x = 0.7;
			receptor.scale.y = 0.7;
			if (receptor.x > 640)
			{
				receptor.x = PlayMoving.defaultPlayerReceptorX[receptor.ID];
			}
			else
			{
				receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID];
			}
		}
		/*else if(Conductor.songPosition >= 91685.3932584271 && Conductor.songPosition < 102387.64044943838)
			{
				if (Conductor.songPosition % 40 < 20)
				{
					if (receptor.ID < 2)
						receptor.alpha = 0;
					else 
						receptor.alpha = 1;
				}
				else
				{
					if (receptor.ID < 2)
						receptor.alpha = 1;
					else 
						receptor.alpha = 0;
				}
				if(receptor.x<640)
					receptor.x = PlayMoving.defaultOpponentReceptorX[1 + receptor.ID % 2];
				else
					receptor.x = PlayMoving.defaultPlayerReceptorX[1 + receptor.ID % 2];
		}*/
	}

	inline static public function shouldHideNote(note:Note):Bool
	{
		if (Conductor.songPosition >= 70280.8988764045 && Conductor.songPosition < 91595.50561797764)
			return (Math.abs(note.y - 300) > Math.abs(((300 - PlayMoving.receptorBaselineY) / 250)) * 360);
		else if (note.strumTime >= 156404 && note.strumTime < 168456 && Conductor.songPosition < 167191.0112359552)
			return Conductor.songPosition < 156404 || note.strumTime - Conductor.songPosition > 2696.62921348;
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
		if (note.strumTime >= 48707 && note.strumTime < 70029)
		{
			if (FlxG.save.data.downscroll)
				return note.y > FlxG.height && Conductor.songPosition > note.strumTime + 1000 / 6;
			else
				return note.y < -note.height && Conductor.songPosition > note.strumTime + 1000 / 6;
		}
		else if (Conductor.songPosition >= 70280.8988764045 && Conductor.songPosition < 91595.50561797764)
			return ((Math.abs(note.y - 300) > Math.abs(((300 - PlayMoving.receptorBaselineY) / 250)) * 50)
				&& Conductor.songPosition - note.strumTime > 1000 / 6);
		else if (note.strumTime >= 156404 && note.strumTime < 168456 && Conductor.songPosition < 167191.0112359552)
			return Conductor.songPosition > note.strumTime + 1000 / 6;
		else if (Conductor.songPosition >= 167191.0112359552 && Conductor.songPosition < 172584.26966292146)
			return Conductor.songPosition > note.strumTime + 1000 / 6;
		else
		{
			if (FlxG.save.data.downscroll)
				return note.y > FlxG.height;
			else
				return note.y < -note.height;
		}
	}

	public static function updateWindowEffects(camHUD:FlxCamera)
	{
		if (FlxG.fullscreen)
			FlxG.fullscreen = false;
		if (Conductor.songPosition % 20 < 10)
		{
			if (Conductor.songPosition < 5393.258426966292)
			{
				PlayWindow.reset();
			}
			else if (Conductor.songPosition >= 5393.258426966292 && Conductor.songPosition < 10702.247191011236)
			{ // 640 360
				var tar:Array<Int> = [Std.int(PlayWindow.stage[0] / 2 - 320), Std.int(PlayWindow.stage[1] / 2 - 180)];
				Lib.application.window.width = Std.int(640 + (10702.247191011236 - Conductor.songPosition) / (5308.98876404) * (PlayWindow.res[2] - 640));
				Lib.application.window.height = Std.int(360 + (10702.247191011236 - Conductor.songPosition) / (5308.98876404) * (PlayWindow.res[3] - 360));
				Lib.application.window.x = Std.int(tar[0] + (10702.247191011236 - Conductor.songPosition) / (5308.98876404) * (PlayWindow.res[0] - tar[0]));
				Lib.application.window.y = Std.int(tar[1] + (10702.247191011236 - Conductor.songPosition) / (5308.98876404) * (PlayWindow.res[1] - tar[1]));
			}
			else if (Conductor.songPosition >= 10786.516853932584 && Conductor.songPosition < 16089.887640449437)
			{
				var bef:Array<Int> = [Std.int(PlayWindow.stage[0] / 2 - 320), Std.int(PlayWindow.stage[1] / 2 - 180)];
				var tar:Array<Int> = [
					Std.int(PlayWindow.stage[0] / 2 - 320),
					Std.int(PlayWindow.stage[1] * 3 / 10 - 180)
				];
				if (Lib.application.window.width != 640 || Lib.application.window.height != 360)
				{
					Lib.application.window.width = 640;
					Lib.application.window.height = 360;
				}
				Lib.application.window.x = Std.int(tar[0] + (16089.887640449437 - Conductor.songPosition) / (5303.37078652) * (bef[0] - tar[0]));
				Lib.application.window.y = Std.int(tar[1] + (16089.887640449437 - Conductor.songPosition) / (5303.37078652) * (bef[1] - tar[1]));
			}
			else if (Conductor.songPosition >= 16179.775280898875 && Conductor.songPosition < 25617.977528089887)
			{
				if (Lib.application.window.width != 640 || Lib.application.window.height != 360)
				{
					Lib.application.window.width = 640;
					Lib.application.window.height = 360;
				}
				Lib.application.window.x = Std.int(Math.sin((Conductor.songPosition - 16179.775280898875) / (2696.62921348) * 3.1415926535) * (PlayWindow.stage[0] * 2 / 10)
					+ PlayWindow.stage[0] / 2
						- 320);
				Lib.application.window.y = Std.int(Math.cos((Conductor.songPosition - 16179.775280898875) / (2696.62921348) * 3.1415926535) * (PlayWindow.stage[1] * -2 / 10)
					+ PlayWindow.stage[1] / 2
						- 180);
			}
			else if (Conductor.songPosition >= 25617.977528089887 && Conductor.songPosition < 26629.213483146068)
			{
				if (Lib.application.window.width != 640 || Lib.application.window.height != 360)
				{
					Lib.application.window.width = 640;
					Lib.application.window.height = 360;
				}
				Lib.application.window.x = Std.int(PlayWindow.stage[0] * 3 / 10 - 320);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 180);
			}
			else if (Conductor.songPosition >= 26629.213483146068 && Conductor.songPosition < 26882.02247191011)
			{
				if (Lib.application.window.width != 640 || Lib.application.window.height != 360)
				{
					Lib.application.window.width = 640;
					Lib.application.window.height = 360;
				}
				Lib.application.window.x = Std.int(PlayWindow.stage[0] * 3 / 10 - 320);
				Lib.application.window.y = Std.int((PlayWindow.stage[1] / -4)
					- 180
					+ (26882.02247191011 - Conductor.songPosition) / (252.808988764) * (PlayWindow.stage[1] / 2 + PlayWindow.stage[1] / 4));
			}
			else if (Conductor.songPosition >= 26966.29213483146 && Conductor.songPosition < 37673.49636483807)
			{
				if (Lib.application.window.width != 640 || Lib.application.window.height != 360)
				{
					Lib.application.window.width = 640;
					Lib.application.window.height = 360;
				}
				if (Conductor.songPosition < 27303.370786516854)
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] - (Conductor.songPosition - 26966.29213483146) / 337.078651685 * 320);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 180);
				}
				else if (Conductor.songPosition < 32022.47191011236)
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] - 320 - (Conductor.songPosition - 27303.370786516854) / 4719.1011236 * 160);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 180);
				}
				else if (Conductor.songPosition < 32359.55056179775)
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0]
						- 480
						- (Conductor.songPosition - 32022.47191011236) / 337.078651685 * (PlayWindow.stage[0] - 320));
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 180);
				}
				else
					Lib.application.window.x = Std.int(-160 - (Conductor.songPosition - 33707.86516853933) / 4719.1011236 * (160));
				Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 180);
			}
			else if (Conductor.songPosition >= 37752.808988764045 && Conductor.songPosition < 48117.9775281)
			{
				if (Std.int((Conductor.songPosition - 37752.808988764045) / 674.15730337) >= count)
				{
					PlayWindow.pos = [
						FlxG.random.int(480, PlayWindow.stage[0] - 480),
						FlxG.random.int(270, PlayWindow.stage[1] - 270)
					];
					count += 1;
				}
				if (Std.int((Conductor.songPosition - 37752.808988764045) / 337.078651685) % 2 == 0)
				{
					Lib.application.window.width = 960;
					Lib.application.window.height = 540;
				}
				else
				{
					Lib.application.window.width = Std.int(960 - ((Conductor.songPosition - 37752.808988764045) % 337.078651685) / 337.078651685 * 640);
					Lib.application.window.height = Std.int(540 - ((Conductor.songPosition - 37752.808988764045) % 337.078651685) / 337.078651685 * 360);
				}
				Lib.application.window.x = Std.int(PlayWindow.pos[0] - Lib.application.window.width / 2);
				Lib.application.window.y = Std.int(PlayWindow.pos[1] - Lib.application.window.height / 2);
			}
			else if (Conductor.songPosition >= 48117.9775281 && Conductor.songPosition < 48455.05617977528)
			{
				Lib.application.window.width = 960;
				Lib.application.window.height = 540;
				if (FlxG.save.data.downscroll)
				{
					Lib.application.window.x = Std.int(PlayWindow.pos[0] - 480);
					Lib.application.window.y = Std.int(PlayWindow.pos[1]
						+ (Conductor.songPosition - 48117.9775281) / 337.078651685 * (PlayWindow.stage[1] * (-0.3) - PlayWindow.pos[1])
						- 270);
				}
				else
				{
					Lib.application.window.x = Std.int(PlayWindow.pos[0] - 480);
					Lib.application.window.y = Std.int(PlayWindow.pos[1]
						+ (Conductor.songPosition - 48117.9775281) / 337.078651685 * (PlayWindow.stage[1] * 1.3 - PlayWindow.pos[1])
						- 270);
				}
			}
			else if (Conductor.songPosition >= 48539.32584269663 && Conductor.songPosition < 70112.3595505)
			{
				updateWindowFrom48539(camHUD);
			}
			else if (Conductor.songPosition >= 70112.35955056181 && Conductor.songPosition < 70280.8988764045)
			{
				camHUD.x = 0;
				PlayWindow.camz = 1;
				FlxG.scaleMode = new RatioScaleMode();
				if (Lib.application.window.width != 640 || Lib.application.window.height != 360)
				{
					Lib.application.window.width = 640;
					Lib.application.window.height = 360;
				}
				Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2 - 320);
				Lib.application.window.y = Std.int(PlayWindow.stage[1]
					- (Conductor.songPosition - 70112.35955056181) / 168.539325843 * (PlayWindow.stage[1] / 2 + 55));
			}
			else if (Conductor.songPosition >= 70280.8988764045 && Conductor.songPosition < 91595.50561797764)
			{
				if (Lib.application.window.width != 640 || Lib.application.window.height != 360)
				{
					Lib.application.window.width = 640;
					Lib.application.window.height = 360;
				}
				if (Conductor.songPosition >= 80898.87640449445)
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2
						+ Math.sin(((Conductor.songPosition - 80898.87640449445) / 1348.31460674) * 3.1415926535) * PlayWindow.stage[0] / 5 - 320);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2
						+ Math.sin(((Conductor.songPosition - 70280.8988764045) / 1348.31460674 - 0.5) * 3.1415926535) * 125
						- 180);
				}
				else
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2 - 320);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2
						+ Math.sin(((Conductor.songPosition - 70280.8988764045) / 1348.31460674 - 0.5) * 3.1415926535) * 125
						- 180);
				}
			}
			else if (Conductor.songPosition >= 91685.3932584271 && Conductor.songPosition < 102471.91011235974)
			{
				if (Lib.application.window.width != 640 || Lib.application.window.height != 360)
				{
					Lib.application.window.width = 640;
					Lib.application.window.height = 360;
				}
				if (Conductor.songPosition % 40 < 20)
				{
					Lib.application.window.x = Std.int(Math.sin(((Conductor.songPosition - 16179.775280898875) / (2696.62921348)
						+ 1) * 3.1415926535) * (PlayWindow.stage[0] * 2 / 10)
						+ PlayWindow.stage[0] / 2
							- 320);
					Lib.application.window.y = Std.int(Math.cos(((Conductor.songPosition - 16179.775280898875) / (2696.62921348)
						+ 1) * 3.1415926535) * (PlayWindow.stage[1] * -2 / 10)
						+ PlayWindow.stage[1] / 2
							- 180);
				}
				else
				{
					Lib.application.window.x = Std.int(Math.sin((Conductor.songPosition - 16179.775280898875) / (2696.62921348) * 3.1415926535) * (PlayWindow.stage[0] * 2 / 10)
						+ PlayWindow.stage[0] / 2
							- 320);
					Lib.application.window.y = Std.int(Math.cos((Conductor.songPosition - 16179.775280898875) / (2696.62921348) * 3.1415926535) * (PlayWindow.stage[1] * -2 / 10)
						+ PlayWindow.stage[1] / 2
							- 180);
				}
			}
			else if (Conductor.songPosition >= 102471.91011235974 && Conductor.songPosition < 113258.42696629238)
			{
				if (Lib.application.window.width != 640 || Lib.application.window.height != 360)
				{
					Lib.application.window.width = 640;
					Lib.application.window.height = 360;
				}
				if ((Conductor.songPosition - 102471.91011235974) % 674.157303371 < 337.078651685)
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] * 4 / 10
						+ (((Conductor.songPosition - 102471.91011235974) % 337.078651685) / 337.078651685) * PlayWindow.stage[0] / 5 - 320);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2
						- Math.abs(Math.sin(((Conductor.songPosition - 102471.91011235974) % 337.078651685) / 337.078651685 * 3.1415926)) * PlayWindow.stage[1] / 10 - 180);
				}
				else
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] * 6 / 10
						- (((Conductor.songPosition - 102471.91011235974) % 337.078651685) / 337.078651685) * PlayWindow.stage[0] / 5 - 320);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2
						- Math.abs(Math.sin(((Conductor.songPosition - 102471.91011235974) % 337.078651685) / 337.078651685 * 3.1415926)) * PlayWindow.stage[1] / 10 - 180);
				}
			}
			else if (Conductor.songPosition >= 113258.42696629238 && Conductor.songPosition < 123707.86516853962)
			{
				if (Lib.application.window.width != 640 || Lib.application.window.height != 360)
				{
					Lib.application.window.width = 640;
					Lib.application.window.height = 360;
				}
				if ((Conductor.songPosition - 102471.91011235974) % 674.157303371 < 337.078651685)
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2 - 640);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 180);
				}
				else
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 180);
				}
			}
			else if (Conductor.songPosition >= 123707.86516853962 && Conductor.songPosition < 156235.95505617998)
			{
				updateWindowFrom123707(camHUD);
			}
			else if (Conductor.songPosition >= 156404.49438202268 && Conductor.songPosition < 167106.74157303385)
			{
				PlayWindow.camz = 1;
				PlayState.defaultCamZoom = 0.85;
				FlxG.scaleMode = new RatioScaleMode();
				if (Lib.application.window.width != 640 || Lib.application.window.height != 360)
				{
					Lib.application.window.width = 640;
					Lib.application.window.height = 360;
				}
				Lib.application.window.x = Std.int(Math.sin((Conductor.songPosition - 156404.49438202268) / (2696.62921348) * 3.1415926535) * (PlayWindow.stage[0] * 2 / 10)
					+ PlayWindow.stage[0] / 2
						- 320);
				Lib.application.window.y = Std.int(Math.cos((Conductor.songPosition - 156404.49438202268) / (2696.62921348) * 3.1415926535) * (PlayWindow.stage[1] * -2 / 10)
					+ PlayWindow.stage[1] / 2
						- 180);
			}
			else if (Conductor.songPosition >= 167191.0112359552 && Conductor.songPosition < 172584.26966292146)
			{
				updateWindowFrom167191(camHUD);
			}
			else if (Conductor.songPosition >= 172584.26966292146 && Conductor.songPosition < 177977.52808988772)
			{
				updateWindowFrom172584(camHUD);
			}
		}
	}
	static function updateWindowFrom48539(camHUD:FlxCamera):Void
	{
		count = 0;
		FlxG.scaleMode = new FixedScaleMode();
		if (Lib.application.window.width != 480 || Lib.application.window.height != 640)
		{
			Lib.application.window.width = 480;
			Lib.application.window.height = 640;
		}
		PlayWindow.camz = 0.9;
		if (Conductor.songPosition < 48707.86516853933)
		{
			if (FlxG.save.data.downscroll)
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.3 - 240);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] * (1.3)
					- ((Conductor.songPosition - 48539.32584269663) / 168.539325843) * (PlayWindow.stage[1] * 0.8)
					- 320);
			}
			else
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.3 - 240);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] * (-0.3)
					+ ((Conductor.songPosition - 48539.32584269663) / 168.539325843) * (PlayWindow.stage[1] * 0.8)
					- 320);
			}
			camHUD.x = 320;
		}
		else if (Conductor.songPosition < 58988.76404494382)
		{
			if (FlxG.save.data.downscroll)
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.3 - 240);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] * (0.5)
					- ((Conductor.songPosition - 48707.86516853933) / 10280.8988764) * 144
					- 320);
			}
			else
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.3 - 240);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] * (0.5)
					+ ((Conductor.songPosition - 48707.86516853933) / 10280.8988764) * 144
					- 320);
			}
			camHUD.x = 320;
		}
		else if (Conductor.songPosition < 59325.84269662921)
		{
			if (FlxG.save.data.downscroll)
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.3 - 240);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] * (0.5)
					- 144
					- ((Conductor.songPosition - 58988.76404494382) / 337.078651685) * (PlayWindow.stage[1] * 0.8 - 144)
					- 320);
			}
			else
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.3 - 240);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] * (0.5)
					+ 144
					+ ((Conductor.songPosition - 58988.76404494382) / 337.078651685) * (PlayWindow.stage[1] * 0.8 - 144)
					- 320);
			}
			camHUD.x = 320;
		}
		else if (Conductor.songPosition < 59494.38202247191)
		{
			if (FlxG.save.data.downscroll)
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.7 - 240);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] * (1.3)
					- ((Conductor.songPosition - 59325.84269662921) / 168.539325843) * (PlayWindow.stage[1] * 0.8)
					- 320);
			}
			else
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.7 - 240);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] * (-0.3)
					+ ((Conductor.songPosition - 59325.84269662921) / 168.539325843) * (PlayWindow.stage[1] * 0.8)
					- 320);
			}
			camHUD.x = -260;
		}
		else if (Conductor.songPosition < 69775.28089887642)
		{
			if (FlxG.save.data.downscroll)
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.7 - 240);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] * (0.5)
					- ((Conductor.songPosition - 59494.38202247191) / 10280.8988764) * 144
					- 320);
			}
			else
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.7 - 240);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] * (0.5)
					+ ((Conductor.songPosition - 59494.38202247191) / 10280.8988764) * 144
					- 320);
			}
			camHUD.x = -260;
		}
		else if (Conductor.songPosition < 70112.3595505)
		{
			if (FlxG.save.data.downscroll)
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.7 - 240);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] * (0.5)
					- 144
					- ((Conductor.songPosition - 69775.28089887642) / 337.078651685) * (PlayWindow.stage[1] * 0.8 - 144)
					- 320);
			}
			else
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.7 - 240);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] * (0.5)
					+ 144
					+ ((Conductor.songPosition - 69775.28089887642) / 337.078651685) * (PlayWindow.stage[1] * 0.8 - 144)
					- 320);
			}
			camHUD.x = -260;
		}
	}

	static function updateWindowFrom123707(camHUD:FlxCamera):Void
	{
		count = 0;
		FlxG.scaleMode = new FixedScaleMode();
		if (Conductor.songPosition < 145617.97752809015)
			PlayWindow.camz = 0.9;
		if (Conductor.songPosition < 124044.94382022502)
		{
			Lib.application.window.width = 480;
			Lib.application.window.height = 1;
			Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.3 - 240);
			Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 320);
			camHUD.x = 320;
		}
		else if (Conductor.songPosition < 124213.48314606771)
		{
			Lib.application.window.width = 480;
			Lib.application.window.height = Std.int((Conductor.songPosition - 124044.94382022502) / 168.539325843 * 640);
			Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.3 - 240);
			Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 320);
			camHUD.x = 320;
		}
		else if (Conductor.songPosition < 134494.38202247224)
		{
			Lib.application.window.width = 480;
			Lib.application.window.height = 640 + Std.int((Conductor.songPosition - 124213.48314606771) / 10280.8988764 * 80);
			Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.3 - 240);
			Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 320);
			camHUD.x = 320;
		}
		else if (Conductor.songPosition < 134662.92134831494)
		{
			Lib.application.window.width = 480;
			Lib.application.window.height = 720 - Std.int((Conductor.songPosition - 134494.38202247224) / 168.539325843 * 719);
			Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.3
				+ (Conductor.songPosition - 134494.38202247224) / 168.539325843 * (PlayWindow.stage[0] * 0.4))
				- 240;
			Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 320);
			camHUD.x = 320;
		}
		else if (Conductor.songPosition < 134831.46067415763)
		{
			Lib.application.window.width = 480;
			Lib.application.window.height = 1;
			Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.7) - 240;
			Lib.application.window.x = Std.int(PlayWindow.stage[1] / 2 - 320);
			camHUD.x = 320;
		}
		else if (Conductor.songPosition < 135000.00000000032)
		{
			Lib.application.window.width = 480;
			Lib.application.window.height = Std.int((Conductor.songPosition - 134831.46067415763) / 168.539325843 * 640);
			Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.7) - 240;
			Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 320);
			camHUD.x = -260;
		}
		else if (Conductor.songPosition < 145280.89887640477)
		{
			Lib.application.window.width = 480;
			Lib.application.window.height = 640 + Std.int((Conductor.songPosition - 135000.00000000032) / 10280.8988764 * 80);
			Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.7) - 240;
			Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 320);
			camHUD.x = -260;
		}
		else if (Conductor.songPosition < 145449.43820224746)
		{
			Lib.application.window.width = 480 + Std.int((Conductor.songPosition - 145280.89887640477) / 168.539325843 * 160);
			Lib.application.window.height = 720 - Std.int((Conductor.songPosition - 145280.89887640477) / 168.539325843 * 719);
			Lib.application.window.x = Std.int(PlayWindow.stage[0] * 0.7
				- 240
				- (Conductor.songPosition - 145280.89887640477) / 168.539325843 * (PlayWindow.stage[0] * 0.2 + 80));
			Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 320 + (Conductor.songPosition - 145280.89887640477) / 168.539325843 * 140);
			camHUD.x = -260;
		}
		else if (Conductor.songPosition < 145617.97752809015)
		{
			Lib.application.window.width = 640;
			Lib.application.window.height = 1;
			Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2) - 320;
			Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 180);
			camHUD.x = -260;
		}
		else if (Conductor.songPosition < 145786.51685393284)
		{
			Lib.application.window.width = 640;
			Lib.application.window.height = Std.int((Conductor.songPosition - 145617.97752809015) / 168.539325843 * 320);
			Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2) - 320;
			Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 180);
			camHUD.x = 0;
			PlayWindow.camz = 0.45;
			PlayState.defaultCamZoom = 0.425;
		}
		else if (Conductor.songPosition < 156067.4157303373)
		{
			Lib.application.window.width = 640;
			Lib.application.window.height = 320 + Std.int((Conductor.songPosition - 145786.51685393284) / 10280.8988764 * 40);
			Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2) - 320;
			Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 180);
			camHUD.x = 0;
			PlayWindow.camz = 0.5;
			PlayState.defaultCamZoom = 0.425;
		}
		else
		{
			if (Lib.application.window.width != 640 || Lib.application.window.height != 360)
			{
				Lib.application.window.width = 640;
				Lib.application.window.height = 360;
			}
			Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2 - 320);
			Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2
				- (Conductor.songPosition - 156067.4157303373) / 168.539325843 * PlayWindow.stage[1] / 5)
				- 180;
			camHUD.x = 0;
			PlayWindow.camz = 0.5;
			PlayState.defaultCamZoom = 0.425;
		}
	}

	static function updateWindowFrom167191(camHUD:FlxCamera):Void
	{
		if (Lib.application.window.width != 640 || Lib.application.window.height != 360)
		{
			Lib.application.window.width = 640;
			Lib.application.window.height = 360;
		}
		switch (Std.int((Conductor.songPosition - 167191.0112359552) / 337.078651685) % 4)
		{
			case 0:
				if (Conductor.songPosition % 40 < 20)
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2 - 480);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 360);
				}
				else
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2 - 160);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2);
				}
			case 1:
				if (Conductor.songPosition % 40 < 20)
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2
						- 480
						+ 320 * ((Conductor.songPosition - 167191.0112359552) % 337.078651685) / 337.078651685);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 360);
				}
				else
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2
						- 160
						- 320 * ((Conductor.songPosition - 167191.0112359552) % 337.078651685) / 337.078651685);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2);
				}
			case 2:
				if (Conductor.songPosition % 40 < 20)
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2 - 160);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 360);
				}
				else
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2 - 480);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2);
				}
			case 3:
				if (Conductor.songPosition % 40 < 20)
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2 - 160);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2
						- 360
						+ 360 * ((Conductor.songPosition - 167191.0112359552) % 337.078651685) / 337.078651685);
				}
				else
				{
					Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2 - 480);
					Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2
						- 360 * ((Conductor.songPosition - 167191.0112359552) % 337.078651685) / 337.078651685);
				}
		}
	}

	static function updateWindowFrom172584(camHUD:FlxCamera):Void
	{
		if (Lib.application.window.width != 640 || Lib.application.window.height != 360)
		{
			Lib.application.window.width = 640;
			Lib.application.window.height = 360;
		}
		if (Conductor.songPosition % 1348.31460674 < 674.15730337)
		{
			if (Conductor.songPosition % 40 < 20)
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2
					+ 320 * Math.sin((Conductor.songPosition % 674.15730337) / 674.15730337 * 3.1415926535)
					- 320);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 180);
			}
			else
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2
					- 320 * Math.sin((Conductor.songPosition % 674.15730337) / 674.15730337 * 3.1415926535)
					- 320);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2 - 180);
			}
		}
		else
		{
			if (Conductor.songPosition % 40 < 20)
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2 - 320);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2
					+ 180 * Math.sin((Conductor.songPosition % 674.15730337) / 674.15730337 * 3.1415926535)
					- 180);
			}
			else
			{
				Lib.application.window.x = Std.int(PlayWindow.stage[0] / 2 - 320);
				Lib.application.window.y = Std.int(PlayWindow.stage[1] / 2
					- 180 * Math.sin((Conductor.songPosition % 674.15730337) / 674.15730337 * 3.1415926535)
					- 180);
			}
		}
	}

}
