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

class M_kastimagina
{
	public static var shinelist:Array<Float> = [
		 45082.87292817678,  46408.83977900551,  47734.80662983424,  49060.77348066297,  49723.75690607733, 50386.740331491696, 51712.707182320424,
		 53038.67403314915,  54364.64088397788, 55027.624309392246,  55690.60773480661,  57016.57458563534,  58342.54143646407, 59668.508287292796,
		 60331.49171270716,  60662.98342541434, 60994.475138121525,  62320.44198895025,  63646.40883977898,  64972.37569060771,  65635.35911602208,
		 65966.85082872926, 135248.61878453035, 136574.58563535908,  137900.5524861878, 139226.51933701654,  139889.5027624309, 140552.48618784526,
		  141878.453038674, 143204.41988950272, 144530.38674033145, 145193.37016574582, 145856.35359116018,  147182.3204419889, 148508.28729281764,
		149834.25414364637, 150497.23756906073,  151160.2209944751, 152486.18784530382, 153812.15469613255, 155138.12154696128, 155801.10497237564
	];

	public static function updateNotePosition(note:Note, strumLine:FlxSprite)
	{
		if ((note.strumTime > 2652 && note.strumTime < 12929) || (note.strumTime > 156465 && note.strumTime < 166741))
		{
			if (note.mustPress)
				note.x = PlayMoving.playerReceptorX[note.noteData];
			else
				note.x = PlayMoving.opponentReceptorX[note.noteData];
			note.y = PlayMoving.receptorY[note.noteData];
			if (Conductor.songPosition > note.strumTime)
				note.alpha = 0;
		}
		else if ((note.strumTime > 23867 && note.strumTime < 34393))
		{
			if (note.noteData % 2 == 0)
				note.y = (300 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (300 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		else if ((note.strumTime > 34475 && note.strumTime < 45000))
		{
			if (note.noteData % 2 == 1)
				note.y = (300 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (300 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		else if (note.strumTime > 103425 && note.strumTime < 135166 && Conductor.songPosition < 124640.8839779005)
		{
			if (note.noteData == 2 || note.noteData == 1)
				note.y = (300 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (300 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		else if (note.strumTime > 13259 && note.strumTime < 23785)
		{
			if (FlxG.save.data.downscroll)
				note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			if (note.strumTime - Conductor.songPosition < 100)
				note.alpha = 0;
			else if (note.strumTime - Conductor.songPosition < 500)
				note.alpha = (note.strumTime - Conductor.songPosition - 100) / 400;
		}
		else if ((note.strumTime > 45082 && note.strumTime < 66216) || (note.strumTime > 135248 && note.strumTime < 156465))
		{
			var index:Int = 0;
			for (i in shinelist)
			{
				if (Conductor.songPosition >= i)
					index += 1;
			}
			if (index % 2 == 1)
				note.y = (50 - (Conductor.songPosition - note.strumTime) * (0.25 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				note.y = (550 + (Conductor.songPosition - note.strumTime) * (0.25 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (note.strumTime > 66298 && note.strumTime < 82045)
		{
			if (FlxG.save.data.downscroll)
				note.y = (strumLine.y
					+ ((66298.34254143645 + FlxMath.roundDecimal((Conductor.songPosition - 66298.34254143645) / 165.745856354, 0) * 165.745856354)
						- note.strumTime) * (0.3 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
			else
				note.y = (strumLine.y
					- ((66298.34254143645 + FlxMath.roundDecimal((Conductor.songPosition - 66298.34254143645) / 165.745856354, 0) * 165.745856354)
						- note.strumTime) * (0.3 * FlxMath.roundDecimal(PlayState.SONG.speed, 2)));
		}
		else if (note.strumTime > 82209 && note.strumTime < 103338)
		{
			if (Std.int((note.strumTime - 82209.94475138119) / (83535.91160220992 - 82209.94475138119)) % 2 == 0)
				note.y = -75
					+ 775 * (((note.strumTime - 82209.94475138119) % (83535.91160220992 - 82209.94475138119)) / (83535.91160220992 - 82209.94475138119));
			else
				note.y = 700
					- 775 * (((note.strumTime - 82209.94475138119) % (83535.91160220992 - 82209.94475138119)) / (83535.91160220992 - 82209.94475138119));
			if (Std.int((note.strumTime - 82209.94475138119) / (83535.91160220992 - 82209.94475138119)) == Std.int((Conductor.songPosition
				- 82209.94475138119) / (83535.91160220992 - 82209.94475138119)))
				note.alpha = 1;
			else
				note.alpha = 0.7;
		}
		else if (note.strumTime >= 124640 && note.strumTime < 135166 && Conductor.songPosition >= 124640.8839779005)
		{
			if (note.mustPress)
				note.x = PlayMoving.playerReceptorX[note.noteData];
			else
				note.x = PlayMoving.opponentReceptorX[note.noteData];
			if (FlxG.save.data.downscroll)
				note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(0.75 * PlayState.SONG.speed, 2)));
			else
				note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (0.45 * FlxMath.roundDecimal(0.75 * PlayState.SONG.speed, 2)));
		}
		else if (note.strumTime >= 167071)
		{
			if (FlxG.save.data.downscroll)
			{
				if (note.noteData == 1)
				{
					if (note.animation.curAnim.name.endsWith('hold'))
						note.animation.play('greenhold');
					else if (note.animation.curAnim.name.endsWith('end'))
						note.animation.play('greenholdend');
					else
						note.animation.play('greenScroll');
					note.noteData = 2;
				}
			}
			if (note.mustPress)
				note.x = 858;
			else
				note.x = 218;
			if (FlxG.save.data.downscroll)
				note.y = (188 + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			else
				note.y = (412 - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
			if (note.isSustainNote)
				note.x += note.width;
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
		if ((Conductor.songPosition >= 2651.9337016574586 && Conductor.songPosition < 13259.668508287292)
			|| (Conductor.songPosition >= 156464.08839779 && Conductor.songPosition < 166740.33149171266))
		{
			PlayMoving.opponentReceptorX = [106, 218, 218, 330];
			PlayMoving.playerReceptorX = [746, 858, 858, 970];
			PlayMoving.receptorY = [300, 412, 188, 300];
			if (receptor.x > 640)
			{
				receptor.x = PlayMoving.playerReceptorX[receptor.ID];
				receptor.y = PlayMoving.receptorY[receptor.ID];
			}
			else
			{
				receptor.x = PlayMoving.opponentReceptorX[receptor.ID];
				receptor.y = PlayMoving.receptorY[receptor.ID];
			}
		}
		else if (Conductor.songPosition >= 13259.668508287292 && Conductor.songPosition < 23784.530386740327)
		{
			PlayMoving.opponentReceptorX = [50, 162, 274, 386];
			PlayMoving.playerReceptorX = [690, 802, 914, 1026];
			if (FlxG.save.data.downscroll)
				PlayMoving.receptorY = [550, 550, 550, 550];
			else
				PlayMoving.receptorY = [50, 50, 50, 50];
			if (receptor.x > 640)
			{
				receptor.x = PlayMoving.playerReceptorX[receptor.ID];
				receptor.y = PlayMoving.receptorY[receptor.ID];
			}
			else
			{
				receptor.x = PlayMoving.opponentReceptorX[receptor.ID];
				receptor.y = PlayMoving.receptorY[receptor.ID];
			}
		}
		else if ((Conductor.songPosition > 45082 && Conductor.songPosition < 55525)
			|| (Conductor.songPosition > 55690.60773480661 && Conductor.songPosition < 66215.46961325964)
			|| (Conductor.songPosition > 135248 && Conductor.songPosition < 156382))
		{
			var index:Int = 0;
			for (i in shinelist)
			{
				if (Conductor.songPosition >= i)
					index += 1;
			}
			PlayMoving.opponentReceptorX = [50, 162, 274, 386];
			PlayMoving.playerReceptorX = [690, 802, 914, 1026];
			if (receptor.x > 640)
				receptor.x = PlayMoving.playerReceptorX[receptor.ID];
			else
				receptor.x = PlayMoving.opponentReceptorX[receptor.ID];
			if (index % 2 == 1)
				receptor.y = 50;
			else
				receptor.y = 550;
		}
		else if ((Conductor.songPosition >= 23867.403314917123 && Conductor.songPosition < 44999.999999999985)
			|| (Conductor.songPosition >= 103425.41436464085 && Conductor.songPosition < 124558.01104972372))
		{
			receptor.y = 300;
		}
		else if (Conductor.songPosition >= 66298.34254143645 && Conductor.songPosition < 71436.46408839777)
		{
			PlayMoving.opponentReceptorX = [50, 162, 274, 386];
			PlayMoving.playerReceptorX = [690, 802, 914, 1026];
			if (receptor.x > 640)
				receptor.x = PlayMoving.playerReceptorX[receptor.ID];
			else
				receptor.x = PlayMoving.opponentReceptorX[receptor.ID];
			if (FlxG.save.data.downscroll)
				receptor.y = 550;
			else
				receptor.y = 50;
		}
		else if (Conductor.songPosition >= 82209.94475138119 && Conductor.songPosition < 103337.0165745856)
		{
			if (Std.int((Conductor.songPosition - 82209.94475138119) / (83535.91160220992 - 82209.94475138119)) % 2 == 0)
				receptor.y = -75
					+
					775 * (((Conductor.songPosition - 82209.94475138119) % (83535.91160220992 - 82209.94475138119)) / (83535.91160220992 - 82209.94475138119));
			else
				receptor.y = 700
					- 775 * (((Conductor.songPosition - 82209.94475138119) % (83535.91160220992 - 82209.94475138119)) / (83535.91160220992 - 82209.94475138119));
			strumLine.y = receptor.y;
		}
		else if (Conductor.songPosition >= 124640.8839779005 && Conductor.songPosition < 135165.74585635355)
		{
			if (receptor.x > 640)
			{
				PlayMoving.playerReceptorX[receptor.ID] = Math.sin((((Conductor.songPosition - 124640.8839779005) / 1325.96685083
					+ (-0.5 + receptor.ID / 3)) * 3.1415926535)) * 168
					+ 858;
				receptor.x = PlayMoving.playerReceptorX[receptor.ID];
			}
			else
			{
				PlayMoving.opponentReceptorX[receptor.ID] = Math.sin((((Conductor.songPosition - 124640.8839779005) / 1325.96685083
					+ (-0.5 + receptor.ID / 3)) * 3.1415926535)) * 168
					+ 218;
				receptor.x = PlayMoving.opponentReceptorX[receptor.ID];
			}
			if (FlxG.save.data.downscroll)
				receptor.y = 550;
			else
				receptor.y = 50;
			strumLine.y = receptor.y;
		}
	}

	inline static public function shouldHideNote(note:Note):Bool
	{
		if ((note.strumTime > 2652 && note.strumTime < 12929) || (note.strumTime > 156465 && note.strumTime < 166741))
		{
			return note.strumTime - Conductor.songPosition > (2983.425414364641 - 2651.9337016574586);
		}
		else if (note.strumTime > 13259 && note.strumTime < 23785)
		{
			return (note.y > FlxG.height) || Conductor.songPosition < 13259.668508287292;
		}
		else if (note.strumTime > 23867 && note.strumTime < 45000)
		{
			return (note.y < -note.height) || (note.y > FlxG.height) || Conductor.songPosition < 23867.403314917123;
		}
		else if ((note.strumTime > 45082 && note.strumTime < 66216) || (note.strumTime > 135248 && note.strumTime < 145856))
		{
			var index:Int = 0;
			for (i in shinelist)
			{
				if (note.strumTime - 331 >= i)
					index += 1;
			}
			if (note.strumTime > 135248)
				return Conductor.songPosition < shinelist[index - 1] || Conductor.songPosition < 135248;
			else
				return Conductor.songPosition < shinelist[index - 1] || Conductor.songPosition < 45082;
		}
		else if (note.strumTime > 145856 && note.strumTime < 156465)
		{
			var index:Int = 0;
			for (i in shinelist)
			{
				if (note.strumTime >= i)
					index += 1;
			}
			return (note.y < -note.height) || (note.y > FlxG.height);
		}
		else if (note.strumTime > 66298 && note.strumTime < 82045)
		{
			return (note.y > FlxG.height) || Conductor.songPosition < 66298.34254143645;
		}
		else if (note.strumTime > 82209 && note.strumTime < 103338)
		{
			return (note.strumTime - Conductor.songPosition) > (83204.41988950274 - 82209.94475138119)
				|| Conductor.songPosition < 82209.94475138119;
		}
		else if (note.strumTime > 103425 && note.strumTime < 135166 && Conductor.songPosition < 124640.8839779005)
		{
			return (note.y < -note.height) || (note.y > FlxG.height) || Conductor.songPosition < 103425.41436464085;
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
		if ((note.strumTime > 0 && note.strumTime < 12929) || (note.strumTime > 156464 && note.strumTime < 166741))
		{
			return note.tooLate;
		}
		else if ((note.strumTime > 23867 && note.strumTime < 45000)
			|| (note.strumTime > 103425 && note.strumTime < 135166 && Conductor.songPosition < 124640.8839779005))
		{
			return ((note.y < -note.height) || (note.y > FlxG.height)) && note.tooLate;
		}
		else if ((note.strumTime > 45082 && note.strumTime < 66216) || (note.strumTime > 135248 && note.strumTime < 156465))
		{
			var index:Int = 0;
			for (i in shinelist)
			{
				if (Conductor.songPosition >= i)
					index += 1;
			}
			if (index % 2 == 1)
				return note.y < -note.height;
			else
				return note.y > FlxG.height;
		}
		else if (note.strumTime > 82209 && note.strumTime < 103338)
		{
			return Conductor.songPosition - note.strumTime > (1000 / 6);
		}
		else
		{
			if (FlxG.save.data.downscroll)
				return note.y > FlxG.height;
			else
				return note.y < -note.height;
		}
	}

	inline static public function getSustainClipPosition(note:Note, strumLine:FlxSprite)
	{
		if (FlxG.save.data.downscroll)
			return 188;
		else
			return 412;
	}
}
