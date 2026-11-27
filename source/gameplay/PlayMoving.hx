package gameplay;

import modcharts.M_cona;
import modcharts.M_cyber;
import modcharts.M_destiny;
import modcharts.M_familanna;
import modcharts.M_galaxy;
import modcharts.M_game;
import modcharts.M_kastimagina;
import modcharts.M_newton;
import modcharts.M_peace;
import modcharts.M_underworld;

import modcharts.ModchartMath;

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

class PlayMoving
{
	public static var receptorBaselineY:Float = 50;
	public static var opponentReceptorX:Array<Float> = [50, 162, 274, 386];
	public static var defaultOpponentReceptorX(default, null):Array<Float> = [50, 162, 274, 386];
	public static var playerReceptorX:Array<Float> = [690, 802, 914, 1026];
	public static var defaultPlayerReceptorX(default, null):Array<Float> = [690, 802, 914, 1026];
	public static var nextOpponentReceptorX:Array<Float> = [50, 162, 274, 386];
	public static var nextPlayerReceptorX:Array<Float> = [690, 802, 914, 1026];
	public static var receptorY:Array<Float> = [50, 50, 50, 50];
	public static var playerReceptorY:Array<Float> = [50, 50, 50, 50];
	public static var noteAnimationSuffix:String = "";
	public static var stage:Array<Int> = [0, 0];

	public static function reset()
	{
		if (FlxG.save.data.downscroll)
		{
			receptorBaselineY = 550;
			receptorY = [550, 550, 550, 550];
			playerReceptorY = [550, 550, 550, 550];
		}
		else
		{
			receptorBaselineY = 50;
			receptorY = [50, 50, 50, 50];
			playerReceptorY = [50, 50, 50, 50];
		}
		opponentReceptorX = [50, 162, 274, 386];
		playerReceptorX = [690, 802, 914, 1026];
		nextOpponentReceptorX = [50, 162, 274, 386];
		nextPlayerReceptorX = [690, 802, 914, 1026];
		noteAnimationSuffix = "";
		stage = [Std.int(Capabilities.screenResolutionX), Std.int(Capabilities.screenResolutionY)];

		Note.refresh();
		NoteStrum.refresh();
		NoteSplash.refresh();

		M_game.reset();
		M_familanna.reset();
		M_newton.reset();
		M_destiny.reset();
		M_peace.reset();
	}

	// trace(Lib.current.stage.stageWidth);

	public static function updateNotePosition(note:Note, strumLine:FlxSprite)
	{
		switch (PlayState.SONG.song.toLowerCase())
		{
			case "galaxy" if (PlayState.storyDifficulty != 0):
				M_galaxy.updateNotePosition(note, strumLine);
			case "game" if (PlayState.storyDifficulty != 0):
				M_game.updateNotePosition(note, strumLine);
			case "kastimagina" if (PlayState.storyDifficulty != 0):
				M_kastimagina.updateNotePosition(note, strumLine);
			case "cona" if (PlayState.storyDifficulty != 0):
				M_cona.updateNotePosition(note, strumLine);
			case "underworld" if (PlayState.storyDifficulty != 0):
				M_underworld.updateNotePosition(note, strumLine);
			case "cyber" if (PlayState.storyDifficulty != 0):
				M_cyber.updateNotePosition(note, strumLine);
			case "familanna":
				M_familanna.updateNotePosition(note, strumLine);
			case "newton" if (PlayState.storyDifficulty != 0):
				M_newton.updateNotePosition(note);
			case "destiny" if (PlayState.storyDifficulty != 0):
				M_destiny.updateNotePosition(note);
			case "peace" if (PlayState.storyDifficulty != 0):
				M_peace.updateNotePosition(note);
			default:
				if (FlxG.save.data.downscroll)
					note.y = (strumLine.y + (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
				else
					note.y = (strumLine.y - (Conductor.songPosition - note.strumTime) * (ModchartMath.scrollSpeed()));
		}
		note.positionUpdated = true;
	}

	public static function updateReceptorPosition(receptor:NoteStrum, strumLine:FlxSprite)
	{
		switch (PlayState.SONG.song.toLowerCase())
		{
			case "game" if (PlayState.storyDifficulty != 0):
				M_game.updateReceptorPosition(receptor, strumLine);
			case "kastimagina" if (PlayState.storyDifficulty != 0):
				M_kastimagina.updateReceptorPosition(receptor, strumLine);
			case "cona" if (PlayState.storyDifficulty != 0):
				M_cona.updateReceptorPosition(receptor, strumLine);
			case "underworld" if (PlayState.storyDifficulty != 0):
				M_underworld.updateReceptorPosition(receptor, strumLine);
			case "cyber" if (PlayState.storyDifficulty != 0):
				M_cyber.updateReceptorPosition(receptor, strumLine);
			case "familanna":
				M_familanna.updateReceptorPosition(receptor, strumLine);
			case "newton" if (PlayState.storyDifficulty != 0):
				M_newton.updateReceptorPosition(receptor);
			case "destiny" if (PlayState.storyDifficulty != 0):
				M_destiny.updateReceptorPosition(receptor);
			case "peace" if (PlayState.storyDifficulty != 0):
				M_peace.updateReceptorPosition(receptor);
		}
	}

	public static function updatePlayerReceptorPosition(receptor:NoteStrum, strumLine:FlxSprite)
	{
		switch (PlayState.SONG.song.toLowerCase())
		{
			case "underworld" if (PlayState.storyDifficulty != 0):
				M_underworld.updatePlayerReceptorPosition(receptor, strumLine);
			case "familanna":
				M_familanna.updatePlayerReceptorPosition(receptor, strumLine);
			case "newton" if (PlayState.storyDifficulty != 0):
				M_newton.updatePlayerReceptorPosition(receptor);
		}
	}

	public static function onGoodNoteHit(note:Note):Void
	{
		if (PlayState.SONG.song.toLowerCase() == "familanna")
		{
			M_familanna.onGoodNoteHit(note);
		}
		if (PlayState.SONG.song.toLowerCase() == "destiny" && PlayState.storyDifficulty != 0)
		{
			M_destiny.onGoodNoteHit(note);
		}
		if (PlayState.SONG.song.toLowerCase() == "peace")
		{
			M_peace.onGoodNoteHit(note);
		}
	}

	public static function onNoteRemoved(note:Note):Void
	{
		if (note.clones.length > 0)
			M_peace.removeNoteClones(note);
	}

	public static function applyNoteShape(note:Note, strumLine:FlxSprite, camHUD:FlxCamera):Void
	{
		if (PlayState.SONG.song.toLowerCase() == "newton" && PlayState.storyDifficulty != 0)
		{
			if (M_newton.applyNoteShape(note, camHUD))
				return;
		}
		if (note.isSustainNote && note.rendermode == 0)
		{
			var direction = updateSustainDirection(note, strumLine);
			if (direction == 1)
			{
				if (note.animation.curAnim.name.endsWith('end'))
					note.y += note.height;
			}
			if (direction == 1 || direction == 2)
			{
				alignSustainEnd(note, direction == 1);
				clipVerticalSustain(note, getSustainClipPosition(note, strumLine) + Note.swagWidth / 2, direction == 1);
				return;
			}
			note.clipRect = null;
		}
		// i am so fucking sorry for this if condition
		if (note.isSustainNote
			&& ((updateSustainDirection(note, strumLine) == 1
				&& note.y - note.offset.y * note.scale.y + note.height >= getSustainClipPosition(note, strumLine) + Note.swagWidth / 2)
				|| (updateSustainDirection(note, strumLine) == 2 && note.y + note.offset.y <= getSustainClipPosition(note, strumLine) + Note.swagWidth / 2)
				|| (updateSustainDirection(note, strumLine) == 0 && note.x + note.offset.x <= getSustainClipPosition(note, strumLine) + Note.swagWidth / 2)
				|| (updateSustainDirection(note, strumLine) == 3
					&& note.x - note.offset.x * note.scale.y + note.height >= getSustainClipPosition(note, strumLine) + Note.swagWidth / 2))
			&& (!note.mustPress || (note.wasGoodHit || (note.prevNote.wasGoodHit && !note.canBeHit))))
		{
			var sustainClipRect = new FlxRect(0, getSustainClipPosition(note, strumLine) + Note.swagWidth / 2 - note.y, note.width * 2, note.height * 2);
			switch (updateSustainDirection(note, strumLine))
			{
				case 0:
					sustainClipRect.y = getSustainClipPosition(note, strumLine) + Note.swagWidth / 2 - note.x;
					sustainClipRect.x /= note.scale.y;
					sustainClipRect.height -= sustainClipRect.y;
				case 1:
					sustainClipRect.height = (getSustainClipPosition(note, strumLine) + Note.swagWidth / 2 - note.y) / note.scale.y;
					sustainClipRect.y = note.frameHeight - sustainClipRect.height;
				case 2:
					sustainClipRect.y /= note.scale.y;
					sustainClipRect.height -= sustainClipRect.y;
				case 3:
					sustainClipRect.height = (getSustainClipPosition(note, strumLine) + Note.swagWidth / 2 - note.x) / note.scale.y;
					sustainClipRect.y = note.frameWidth - sustainClipRect.height;
			}
			note.clipRect = sustainClipRect;
		}
	}

	static function alignSustainEnd(note:Note, downscroll:Bool):Void
	{
		if (note.animation.curAnim == null || !note.animation.curAnim.name.endsWith('end')) return;
		var previous = note.prevNote;
		if (previous == null || previous == note || !previous.isSustainNote) return;

		if (previous.alive && previous.exists && previous.positionUpdated && previous.rendermode == 0
			&& Math.abs(previous.angle - note.angle) < 0.01)
		{
			var gap = downscroll ? previous.y - (note.y + note.height) : note.y - (previous.y + previous.height);
			note.sustainEndJoinOffset = gap > 0 && gap <= Math.max(previous.height, note.height)
				? (downscroll ? gap : -gap) : 0;
		}
		else if (previous.alive && previous.exists && previous.positionUpdated)
			note.sustainEndJoinOffset = 0;
		note.y += note.sustainEndJoinOffset;
	}

	static function clipVerticalSustain(note:Note, center:Float, downscroll:Bool):Void
	{
		var canClip = !note.mustPress || note.wasGoodHit || (note.prevNote != null && note.prevNote.wasGoodHit && !note.canBeHit);
		if (!canClip || note.scale.y <= 0 || note.scale.x <= 0)
		{
			note.clipRect = null;
			return;
		}

		var crossed = downscroll
			? note.y - note.offset.y * note.scale.y + note.height >= center
			: note.y + note.offset.y * note.scale.y <= center;
		if (!crossed)
		{
			note.clipRect = null;
			return;
		}

		var rect = note.clipRect;
		if (rect == null) rect = new FlxRect();
		var frameHeight = note.frameHeight;
		var clipAmount = FlxMath.bound((center - note.y) / note.scale.y, 0, frameHeight);
		if (downscroll)
			rect.set(0, frameHeight - clipAmount, note.frameWidth, clipAmount);
		else
			rect.set(0, clipAmount, note.frameWidth, frameHeight - clipAmount);
		note.clipRect = rect;
	}

	inline static public function shouldHideNote(note:Note):Bool
	{
		if (Conductor.songPosition > note.strumTime)
			return false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case "game" if (PlayState.storyDifficulty != 0):
				return M_game.shouldHideNote(note);
			case "kastimagina" if (PlayState.storyDifficulty != 0):
				return M_kastimagina.shouldHideNote(note);
			case "underworld" if (PlayState.storyDifficulty != 0):
				return M_underworld.shouldHideNote(note);
			case "cyber" if (PlayState.storyDifficulty != 0):
				return M_cyber.shouldHideNote(note);
			case "familanna":
				return M_familanna.shouldHideNote(note);
			case "newton" if (PlayState.storyDifficulty != 0):
				return M_newton.shouldHideNote(note);
			case "destiny" if (PlayState.storyDifficulty != 0):
				return M_destiny.shouldHideNote(note);
			case "peace" if (PlayState.storyDifficulty != 0):
				return M_peace.shouldHideNote(note);
			default:
				if (FlxG.save.data.downscroll)
					return note.y < -note.height;
				else
					return note.y > FlxG.height;
		}
	}

	inline static public function shouldRemoveNote(note:Note):Bool
	{
		if (!note.tooLate || !note.mustPress)
			return false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case "game" if (PlayState.storyDifficulty != 0):
				return M_game.shouldRemoveNote(note);
			case "kastimagina" if (PlayState.storyDifficulty != 0):
				return M_kastimagina.shouldRemoveNote(note);
			case "cona" if (PlayState.storyDifficulty != 0):
				return M_cona.shouldRemoveNote(note);
			case "underworld" if (PlayState.storyDifficulty != 0):
				return M_underworld.shouldRemoveNote(note);
			case "cyber" if (PlayState.storyDifficulty != 0):
				return M_cyber.shouldRemoveNote(note);
			case "familanna":
				return M_familanna.shouldRemoveNote(note);
			case "newton" if (PlayState.storyDifficulty != 0):
				return M_newton.shouldRemoveNote(note);
			case "destiny" if (PlayState.storyDifficulty != 0):
				return M_destiny.shouldRemoveNote(note);
			case "peace" if (PlayState.storyDifficulty != 0):
				return M_peace.shouldRemoveNote(note);
			default:
				if (FlxG.save.data.downscroll)
					return note.y > FlxG.height;
				else
					return note.y < -note.height;
		}
	}

	inline static public function updateSustainDirection(note:Note, strumLine:FlxSprite)
	{
		switch (PlayState.SONG.song.toLowerCase())
		{
			case "game" if (PlayState.storyDifficulty != 0):
				return M_game.updateSustainDirection(note, strumLine);
			case "cona" if (PlayState.storyDifficulty != 0):
				return M_cona.updateSustainDirection(note, strumLine);
			case "underworld" if (PlayState.storyDifficulty != 0):
				return M_underworld.updateSustainDirection(note, strumLine);
			default:
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
		if (PlayState.SONG.song.toLowerCase() == "game" && PlayState.storyDifficulty != 0)
		{
			return M_game.getSustainClipPosition(note, strumLine);
		}
		if (PlayState.SONG.song.toLowerCase() == "kastimagina" && PlayState.storyDifficulty != 0)
		{
			return M_kastimagina.getSustainClipPosition(note, strumLine);
		}
		if (PlayState.SONG.song.toLowerCase() == "cona" && PlayState.storyDifficulty != 0)
		{
			return M_cona.getSustainClipPosition(note, strumLine);
		}
		if (PlayState.SONG.song.toLowerCase() == "underworld" && PlayState.storyDifficulty != 0)
		{
			return M_underworld.getSustainClipPosition(note, strumLine);
		}
		else
		{
			return strumLine.y;
		}
	}

	public static function cloneNote(note:Note)
	{
		if (PlayState.SONG.song.toLowerCase() == "peace" && PlayState.storyDifficulty != 0)
		{
			M_peace.cloneNote(note);
		}
	}

	public static function updateSpecialReceptors(state:PlayState)
	{
		if (PlayState.SONG.song.toLowerCase() == "destiny" && PlayState.storyDifficulty != 0)
		{
			M_destiny.updateSpecialReceptors(state);
		}
		if (PlayState.SONG.song.toLowerCase() == "peace" && PlayState.storyDifficulty != 0)
		{
			M_peace.updateSpecialReceptors(state);
		}
	}

	public static function onBeatHit(state:PlayState, curBeat:Int)
	{
		if (PlayState.SONG.song.toLowerCase() == "destiny" && PlayState.storyDifficulty != 0)
		{
			M_destiny.onBeatHit(state, curBeat);
		}
		if (PlayState.SONG.song.toLowerCase() == "peace")
		{
			M_peace.onBeatHit(curBeat);
		}
	}

	public static function ease(num:Float, mode:Int = 2):Float // 0:in 1:out 2:in and out
	{
		if (num > 1)
			return 1;
		if (num < 0)
			return 0;
		if (mode == 0)
			return (Math.cos(num * Math.PI / 2) * -1 + 1);
		else if (mode == 1)
			return (Math.sin(num * Math.PI / 2) + 1);
		return (Math.cos(num * Math.PI) * -1 + 1) / 2;
	}
}
