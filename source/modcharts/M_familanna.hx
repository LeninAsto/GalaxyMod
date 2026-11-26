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

class M_familanna
{
	public static var receptorCenter:Array<Float> = [0, 0];

	public static function reset()
	{
		receptorCenter = [0, 0];
	}

	public static function updateNotePosition(note:Note, strumLine:FlxSprite)
	{
		if (note.strumTime > 20983 && note.strumTime < 31388)
		{
			if (FlxG.save.data.downscroll)
				note.y = (50 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (550 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		else if (note.strumTime > 115409 && note.strumTime < 157296)
		{
			if (FlxG.save.data.downscroll)
			{
				note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.2, 2)));
				if (note.mustPress)
					note.x = PlayMoving.defaultPlayerReceptorX[note.noteData]
						- ((note.y - 550) / (-note.height - 550)) * (PlayMoving.defaultPlayerReceptorX[note.noteData] - PlayMoving.defaultOpponentReceptorX[note.noteData]);
				else
					note.x = PlayMoving.defaultOpponentReceptorX[note.noteData]
						- ((note.y - 550) / (-note.height - 550)) * (PlayMoving.defaultOpponentReceptorX[note.noteData] - PlayMoving.defaultPlayerReceptorX[note.noteData]);
			}
			else
			{
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(PlayState.SONG.speed / 1.2, 2)));
				if (note.mustPress)
					note.x = PlayMoving.defaultPlayerReceptorX[note.noteData]
						- ((note.y - 50) / (FlxG.height - 50)) * (PlayMoving.defaultPlayerReceptorX[note.noteData] - PlayMoving.defaultOpponentReceptorX[note.noteData]);
				else
					note.x = PlayMoving.defaultOpponentReceptorX[note.noteData]
						- ((note.y - 50) / (FlxG.height - 50)) * (PlayMoving.defaultOpponentReceptorX[note.noteData] - PlayMoving.defaultPlayerReceptorX[note.noteData]);
			}
		}
		else if (note.strumTime > 73442 && note.strumTime < 83847)
		{
			applyNotesFrom73442(note, strumLine);
		}
		else if (note.strumTime >= 104918.0327868854 && note.strumTime < 107540.98360655754)
		{
			if (FlxG.save.data.downscroll)
				receptorCenter = [
					218,
					FlxMath.lerp(550, 300, (note.strumTime - 104918.0327868854) / 2622.95081967)
				];
			else
				receptorCenter = [
					218,
					FlxMath.lerp(50, 300, (note.strumTime - 104918.0327868854) / 2622.95081967)
				];
			note.x = receptorCenter[0] + (note.noteData - 1.5) * 112 * Math.cos(note.strumTime * 3.1415926 / 163.93442623);
			note.y = receptorCenter[1] + (1.5 - note.noteData) * 112 * Math.sin(note.strumTime * 3.1415926 / 163.93442623);
		}
		else if (note.strumTime >= 107540.98360655754 && note.strumTime < 108852.45901639361)
		{
			receptorCenter = [
				FlxMath.lerp(218, 1000, (note.strumTime - 107540.98360655754) / 1311.47540983),
				300
			];
			note.x = receptorCenter[0] + (note.noteData - 1.5) * 112 * Math.cos(note.strumTime * 3.1415926 / 163.93442623);
			note.y = receptorCenter[1] + (1.5 - note.noteData) * 112 * Math.sin(note.strumTime * 3.1415926 / 163.93442623);
		}
		else if (note.strumTime >= 108852.45901639361 && note.strumTime < 109508.19672131164)
		{
			receptorCenter = [
				FlxMath.lerp(1000, 218, (note.strumTime - 108852.45901639361) / 655.737704917),
				300
			];
			note.x = receptorCenter[0] + (note.noteData - 1.5) * 112 * Math.cos(note.strumTime * 3.1415926 / 163.93442623);
			note.y = receptorCenter[1] + (1.5 - note.noteData) * 112 * Math.sin(note.strumTime * 3.1415926 / 163.93442623);
		}
		else if (note.strumTime >= 109508.19672131164 && note.strumTime < 110163.93442622968)
		{
			receptorCenter = [
				FlxMath.lerp(218, 1000, (note.strumTime - 109508.19672131164) / 655.737704917),
				300
			];
			note.x = receptorCenter[0] + (note.noteData - 1.5) * 112 * Math.cos(note.strumTime * 3.1415926 / 163.93442623);
			note.y = receptorCenter[1] + (1.5 - note.noteData) * 112 * Math.sin(note.strumTime * 3.1415926 / 163.93442623);
		}
		else if (note.strumTime >= 110163.93442622968 && note.strumTime < 112786.88524590182)
		{
			if (FlxG.save.data.downscroll)
				receptorCenter = [
					FlxMath.lerp(1000, 218, (note.strumTime - 110163.93442622968) / 2622.95081967),
					FlxMath.lerp(300, 50, (note.strumTime - 110163.93442622968) / 2622.95081967)
				];
			else
				receptorCenter = [
					FlxMath.lerp(1000, 218, (note.strumTime - 110163.93442622968) / 2622.95081967),
					FlxMath.lerp(300, 550, (note.strumTime - 110163.93442622968) / 2622.95081967)
				];
			note.x = receptorCenter[0] + (note.noteData - 1.5) * 112 * Math.cos(note.strumTime * 3.1415926 / 163.93442623);
			note.y = receptorCenter[1] + (1.5 - note.noteData) * 112 * Math.sin(note.strumTime * 3.1415926 / 163.93442623);
		}
		else if (note.strumTime >= 112786.88524590182 && note.strumTime < 115409.836066)
		{
			if (FlxG.save.data.downscroll)
				receptorCenter = [
					218,
					FlxMath.lerp(50, 550, (note.strumTime - 112786.88524590182) / 2622.95081967)
				];
			else
				receptorCenter = [
					218,
					FlxMath.lerp(550, 50, (note.strumTime - 112786.88524590182) / 2622.95081967)
				];
			note.x = receptorCenter[0] + (note.noteData - 1.5) * 112 * Math.cos(note.strumTime * 3.1415926 / 163.93442623);
			note.y = receptorCenter[1] + (1.5 - note.noteData) * 112 * Math.sin(note.strumTime * 3.1415926 / 163.93442623);
		}
		else if (note.strumTime >= 83934 && note.strumTime < 94426)
		{
			if (FlxG.save.data.downscroll)
				note.y = (PlayMoving.receptorY[note.noteData]
					+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (PlayMoving.receptorY[note.noteData]
					- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		else if (note.strumTime >= 94426 && note.strumTime < 104918)
		{
			if (FlxG.save.data.downscroll)
				note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			if (note.mustPress)
				note.x = PlayMoving.playerReceptorX[note.noteData];
			else
				note.x = PlayMoving.opponentReceptorX[note.noteData];
			if (note.isSustainNote)
				note.x += note.width;
		}
		else if (note.strumTime >= 157377 && note.strumTime < 178274)
		{
			if (FlxG.save.data.downscroll)
				note.y = (PlayMoving.receptorY[note.noteData]
					+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (PlayMoving.receptorY[note.noteData]
					- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		else if (note.strumTime >= 188852 && note.strumTime < 199257)
		{
			if (FlxG.save.data.downscroll)
				note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			if (note.mustPress)
				note.x = PlayMoving.playerReceptorX[note.noteData];
			else
				note.x = PlayMoving.opponentReceptorX[note.noteData];
		}
		else if (note.strumTime >= 199344 && note.strumTime < 209755)
		{
			if (PlayMoving.receptorBaselineY > 300)
				note.y = (PlayMoving.receptorBaselineY + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (PlayMoving.receptorBaselineY - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		else if (note.strumTime >= 209836 && note.strumTime < 220164)
		{
			if (note.mustPress)
			{
				if (FlxG.save.data.downscroll)
					note.y = (PlayMoving.playerReceptorY[note.noteData]
						+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = (PlayMoving.playerReceptorY[note.noteData]
						- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			}
			else
			{
				if (FlxG.save.data.downscroll)
					note.y = (PlayMoving.receptorY[note.noteData]
						+ (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = (PlayMoving.receptorY[note.noteData]
						- (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			}
		}
		else if (note.strumTime >= 220327 && note.strumTime < 241230)
		{
			if (FlxG.save.data.downscroll)
				note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(3, 2)));
			else
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(3, 2)));
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
		if (Conductor.songPosition >= 20655.737704918025 && Conductor.songPosition < 20819.672131147534)
		{
			if (receptor.x < 640)
			{
				if (FlxG.save.data.downscroll)
					receptor.y = 550 - (Conductor.songPosition - 20655.737704918025) / 163.93442623 * (FlxG.height - 550);
				else
					receptor.y = 50 - (Conductor.songPosition - 20655.737704918025) / 163.93442623 * (receptor.height - 50);
			}
		}
		else if (Conductor.songPosition >= 20819.672131147534 && Conductor.songPosition < 20983.60655737704)
		{
			if (receptor.x < 640)
			{
				if (FlxG.save.data.downscroll)
					receptor.y = receptor.height - (Conductor.songPosition - 20819.672131147534) / 163.93442623 * (receptor.height - 50);
				else
					receptor.y = FlxG.height - (Conductor.songPosition - 20819.672131147534) / 163.93442623 * (FlxG.height - 550);
			}
		}
		else if (Conductor.songPosition >= 20983.60655737704 && Conductor.songPosition < 21147.54098360655)
		{
			if (receptor.x > 640)
			{
				if (FlxG.save.data.downscroll)
					receptor.y = 550 - (Conductor.songPosition - 20983.60655737704) / 163.93442623 * (FlxG.height - 550);
				else
					receptor.y = 50 - (Conductor.songPosition - 20983.60655737704) / 163.93442623 * (receptor.height - 50);
			}
		}
		else if (Conductor.songPosition >= 21147.54098360655 && Conductor.songPosition < 21311.475409836057)
		{
			if (receptor.x > 640)
			{
				if (FlxG.save.data.downscroll)
					receptor.y = receptor.height - (Conductor.songPosition - 21147.54098360655) / 163.93442623 * (receptor.height - 50);
				else
					receptor.y = FlxG.height - (Conductor.songPosition - 21147.54098360655) / 163.93442623 * (FlxG.height - 550);
			}
		}
		else if (Conductor.songPosition >= 31475.409836065555 && Conductor.songPosition < 31576)
		{
			if (FlxG.save.data.downscroll)
				receptor.y = 550;
			else
				receptor.y = 50;
		}
		else if (Conductor.songPosition >= 73442.62295081967 && Conductor.songPosition < 74442.62295081967)
		{
			switch (receptor.ID)
			{
				case 0:
					receptor.x = 584;
					receptor.y = 162;
				case 1:
					receptor.x = 584;
					receptor.y = 50;
				case 2:
					receptor.x = 696;
					receptor.y = 50;
				case 3:
					receptor.x = 696;
					receptor.y = 162;
			}
		}
		else if (Conductor.songPosition >= 104918.0327868854 && Conductor.songPosition < 107540.98360655754)
		{
			if (FlxG.save.data.downscroll)
				receptorCenter = [
					218,
					FlxMath.lerp(550, 300, (Conductor.songPosition - 104918.0327868854) / 2622.95081967)
				];
			else
				receptorCenter = [
					218,
					FlxMath.lerp(50, 300, (Conductor.songPosition - 104918.0327868854) / 2622.95081967)
				];
			receptor.x = receptorCenter[0] + (receptor.ID - 1.5) * 112 * Math.cos(Conductor.songPosition * 3.1415926 / 163.93442623);
			receptor.y = receptorCenter[1] + (1.5 - receptor.ID) * 112 * Math.sin(Conductor.songPosition * 3.1415926 / 163.93442623);
		}
		else if (Conductor.songPosition >= 107540.98360655754 && Conductor.songPosition < 108852.45901639361)
		{
			receptorCenter = [
				FlxMath.lerp(218, 1000, (Conductor.songPosition - 107540.98360655754) / 1311.47540983),
				300
			];
			receptor.x = receptorCenter[0] + (receptor.ID - 1.5) * 112 * Math.cos(Conductor.songPosition * 3.1415926 / 163.93442623);
			receptor.y = receptorCenter[1] + (1.5 - receptor.ID) * 112 * Math.sin(Conductor.songPosition * 3.1415926 / 163.93442623);
		}
		else if (Conductor.songPosition >= 108852.45901639361 && Conductor.songPosition < 109508.19672131164)
		{
			receptorCenter = [
				FlxMath.lerp(1000, 218, (Conductor.songPosition - 108852.45901639361) / 655.737704917),
				300
			];
			receptor.x = receptorCenter[0] + (receptor.ID - 1.5) * 112 * Math.cos(Conductor.songPosition * 3.1415926 / 163.93442623);
			receptor.y = receptorCenter[1] + (1.5 - receptor.ID) * 112 * Math.sin(Conductor.songPosition * 3.1415926 / 163.93442623);
		}
		else if (Conductor.songPosition >= 109508.19672131164 && Conductor.songPosition < 110163.93442622968)
		{
			receptorCenter = [
				FlxMath.lerp(218, 1000, (Conductor.songPosition - 109508.19672131164) / 655.737704917),
				300
			];
			receptor.x = receptorCenter[0] + (receptor.ID - 1.5) * 112 * Math.cos(Conductor.songPosition * 3.1415926 / 163.93442623);
			receptor.y = receptorCenter[1] + (1.5 - receptor.ID) * 112 * Math.sin(Conductor.songPosition * 3.1415926 / 163.93442623);
		}
		else if (Conductor.songPosition >= 110163.93442622968 && Conductor.songPosition < 112786.88524590182)
		{
			if (FlxG.save.data.downscroll)
				receptorCenter = [
					FlxMath.lerp(1000, 218, (Conductor.songPosition - 110163.93442622968) / 2622.95081967),
					FlxMath.lerp(300, 50, (Conductor.songPosition - 110163.93442622968) / 2622.95081967)
				];
			else
				receptorCenter = [
					FlxMath.lerp(1000, 218, (Conductor.songPosition - 110163.93442622968) / 2622.95081967),
					FlxMath.lerp(300, 550, (Conductor.songPosition - 110163.93442622968) / 2622.95081967)
				];
			receptor.x = receptorCenter[0] + (receptor.ID - 1.5) * 112 * Math.cos(Conductor.songPosition * 3.1415926 / 163.93442623);
			receptor.y = receptorCenter[1] + (1.5 - receptor.ID) * 112 * Math.sin(Conductor.songPosition * 3.1415926 / 163.93442623);
		}
		else if (Conductor.songPosition >= 112786.88524590182 && Conductor.songPosition < 115409.836066)
		{
			if (FlxG.save.data.downscroll)
				receptorCenter = [
					218,
					FlxMath.lerp(50, 550, (Conductor.songPosition - 112786.88524590182) / 2622.95081967)
				];
			else
				receptorCenter = [
					218,
					FlxMath.lerp(550, 50, (Conductor.songPosition - 112786.88524590182) / 2622.95081967)
				];
			receptor.x = receptorCenter[0] + (receptor.ID - 1.5) * 112 * Math.cos(Conductor.songPosition * 3.1415926 / 163.93442623);
			receptor.y = receptorCenter[1] + (1.5 - receptor.ID) * 112 * Math.sin(Conductor.songPosition * 3.1415926 / 163.93442623);
		}
		else if (Conductor.songPosition >= 83934.42622950824 && Conductor.songPosition < 94426.22950819682)
		{
			receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID];
			if (FlxG.save.data.downscroll)
				receptor.y = 550 - 30 * (receptor.ID);
			else
				receptor.y = 50 + 30 * (receptor.ID);
			PlayMoving.receptorY[receptor.ID] = receptor.y;
		}
		else if (Conductor.songPosition >= 94426.22950819682 && Conductor.songPosition < 104918.0327868854)
		{
			if (Conductor.songPosition < 94508.19672131157)
			{
				if (FlxG.save.data.downscroll)
					receptor.y = FlxMath.lerp(550 - 30 * (receptor.ID), 550, (Conductor.songPosition - 94426.22950819682) / 81.9672131148);
				else
					receptor.y = FlxMath.lerp(50 + 30 * (receptor.ID), 50, (Conductor.songPosition - 94426.22950819682) / 81.9672131148);
			}
			else
				receptor.y = strumLine.y;
			if (receptor.x < 640)
			{
				receptor.x = 218 + (receptor.ID - 1.5) * 112 * Math.cos(Conductor.songPosition * 3.1415926 / 655.73770492);
				PlayMoving.opponentReceptorX[receptor.ID] = receptor.x;
			}
			else
			{
				receptor.x = 858 + (receptor.ID - 1.5) * 112 * Math.cos(Conductor.songPosition * 3.1415926 / 655.73770492);
				PlayMoving.playerReceptorX[receptor.ID] = receptor.x;
			}
		}
		else if (Conductor.songPosition >= 115409.83606557397 && Conductor.songPosition < 115509.83606557397)
		{
			if (receptor.x < 640)
				receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID];
			else
				receptor.x = PlayMoving.defaultPlayerReceptorX[receptor.ID];
			receptor.y = strumLine.y;
		}
		else if (Conductor.songPosition >= 157377.04918032826 && Conductor.songPosition < 178273.22404371633)
		{
			if (FlxG.save.data.downscroll)
				receptor.y = FlxMath.lerp(550, 550 - 30 * (receptor.ID), (Conductor.songPosition % 1311.47540984) / 1311.47540984);
			else
				receptor.y = FlxMath.lerp(50, 50 + 30 * (receptor.ID), (Conductor.songPosition % 1311.47540984) / 1311.47540984);
			PlayMoving.receptorY[receptor.ID] = receptor.y;
		}
		else if (Conductor.songPosition >= 178360.6557377054 && Conductor.songPosition < 178460.6557377054)
		{
			if (FlxG.save.data.downscroll)
				receptor.y = 550;
			else
				receptor.y = 50;
			PlayMoving.receptorY[receptor.ID] = receptor.y;
		}
		else if (Conductor.songPosition >= 188852.459016394 && Conductor.songPosition < 199344.26229508256)
		{
			if (receptor.x < 640)
			{
				receptor.x = 50 + 56 * receptor.ID * (Math.cos(Conductor.songPosition / 1311.47540984 * 3.1415926) + 1);
				PlayMoving.opponentReceptorX[receptor.ID] = receptor.x;
			}
			else
			{
				receptor.x = 1026 - 56 * (3 - receptor.ID) * (Math.cos(Conductor.songPosition / 1311.47540984 * 3.1415926) + 1);
				PlayMoving.playerReceptorX[receptor.ID] = receptor.x;
			}
		}
		else if (Conductor.songPosition >= 199344.26229508256 && Conductor.songPosition < 209836.065574)
		{
			if (Conductor.songPosition >= 204590.16393442685 && Conductor.songPosition < 204640.16393442685)
			{
				if (FlxG.save.data.downscroll)
					PlayMoving.receptorBaselineY = 550;
				else
					PlayMoving.receptorBaselineY = 50;
			}
			if (Conductor.songPosition >= 207213.114754099 && Conductor.songPosition < 207263.114754099)
			{
				if (FlxG.save.data.downscroll)
					PlayMoving.receptorBaselineY = 550;
				else
					PlayMoving.receptorBaselineY = 50;
			}
			if (receptor.x < 640)
				receptor.x = PlayMoving.defaultOpponentReceptorX[receptor.ID];
			else
				receptor.x = PlayMoving.defaultPlayerReceptorX[receptor.ID];
			receptor.y = PlayMoving.receptorBaselineY;
		}
		else if (Conductor.songPosition >= 209836.065574 && Conductor.songPosition < 220327.868852)
		{
			if (receptor.x < 640)
				receptor.y = PlayMoving.receptorY[receptor.ID];
			else
				receptor.y = PlayMoving.playerReceptorY[receptor.ID];
		}
		else if (Conductor.songPosition >= 220327.8688524597 && Conductor.songPosition < 241229.5081967221)
		{
			if (FlxG.save.data.downscroll)
				receptor.y = 550;
			else
				receptor.y = 50;
		}
	}

	public static function updatePlayerReceptorPosition(receptor:NoteStrum, strumLine:FlxSprite)
	{
		if (Conductor.songPosition >= 73442.62295081967 && Conductor.songPosition < 74442.62295081967)
		{
			switch (receptor.ID)
			{
				case 0:
					receptor.x = 584;
					receptor.y = 468;
				case 1:
					receptor.x = 584;
					receptor.y = 356;
				case 2:
					receptor.x = 696;
					receptor.y = 356;
				case 3:
					receptor.x = 696;
					receptor.y = 468;
			}
		}
		else if (Conductor.songPosition >= 83934.42622950824 && Conductor.songPosition < 94426.22950819682)
		{
			receptor.x = PlayMoving.defaultPlayerReceptorX[receptor.ID];
		}
		else if (Conductor.songPosition >= 104918.0327868854 && Conductor.songPosition < 115409.836066)
		{
			receptor.x = 858 + (receptor.ID - 1.5) * 112 * Math.cos(Conductor.songPosition * 3.1415926 / 163.93442623);
			receptor.y = strumLine.y + (1.5 - receptor.ID) * 112 * Math.sin(Conductor.songPosition * 3.1415926 / 163.93442623);
		}
	}

	public static function onGoodNoteHit(note:Note):Void
	{
		if (note.strumTime >= 199344 && note.strumTime < 204427)
		{
			PlayMoving.receptorBaselineY = 600 - PlayMoving.receptorBaselineY;
		}
		else if (note.strumTime >= 204590 && note.strumTime < 209755)
		{
			if (FlxG.save.data.downscroll)
				PlayMoving.receptorBaselineY -= 5;
			else
				PlayMoving.receptorBaselineY += 5;
		}
		else if (note.strumTime >= 209836 && note.strumTime < 220164)
		{
			if (FlxG.save.data.downscroll)
			{
				if (note.mustPress)
					PlayMoving.playerReceptorY[note.noteData] -= 30;
				else
					PlayMoving.receptorY[note.noteData] -= 30;
			}
			else
			{
				if (note.mustPress)
					PlayMoving.playerReceptorY[note.noteData] += 30;
				else
					PlayMoving.receptorY[note.noteData] += 30;
			}
		}
	}

	inline static public function shouldHideNote(note:Note):Bool
	{
		if (note.strumTime > 20983 && note.strumTime < 31388)
		{
			if (FlxG.save.data.downscroll)
				return note.y > FlxG.height;
			else
				return note.y < -note.height;
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
		if (note.strumTime > 20983 && note.strumTime < 31388)
		{
			if (FlxG.save.data.downscroll)
				return note.y < -note.height;
			else
				return note.y > FlxG.height;
		}
		else if (note.strumTime > 73442 && note.strumTime < 83847)
		{
			return (note.x > FlxG.width || note.x < -note.width) && Conductor.songPosition > note.strumTime;
		}
		else if (note.strumTime >= 199344 && note.strumTime < 220164)
		{
			return Conductor.songPosition > note.strumTime + 1000 / 6;
		}
		else
		{
			if (FlxG.save.data.downscroll)
				return note.y > FlxG.height;
			else
				return note.y < -note.height;
		}
	}
	static function applyNotesFrom73442(note:Note, strumLine:FlxSprite):Void
	{
		if (note.mustPress)
		{
			switch (note.noteData)
			{
				case 0:
					note.x = (584 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
					note.y = 468;
				case 1:
					note.x = (584 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
					note.y = 356;
				case 2:
					note.x = (696 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
					note.y = 356;
				case 3:
					note.x = (696 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
					note.y = 468;
			}
		}
		else
		{
			switch (note.noteData)
			{
				case 0:
					note.x = (584 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
					note.y = 162;
				case 1:
					note.x = (584 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
					note.y = 50;
				case 2:
					note.x = (696 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
					note.y = 50;
				case 3:
					note.x = (696 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
					note.y = 162;
			}
		}
	}

}
