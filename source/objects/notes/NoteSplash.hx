package objects.notes;

import flash.geom.ColorTransform;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import modcharts.RenderPath;
import openfl.Vector;

class NoteSplash extends NoteObject
{
	public var verticles:DrawData<Float>;
	public var uvtData:DrawData<Float>;

	public var rendermode:Int = 0;

	public var type = "null";


	public var renderer:RenderPath;

	public static function refresh()
	{
		NoteObject.clearPathGraphics();
	}

	public function new(daNote:Note, note:Int)
	{
		super(daNote.x, daNote.y);
		var type:Int = FlxG.random.int(1, 2);
		this.type = PlayState.notetype;
		switch (PlayState.notetype)
		{
			case "kali":
				frames = Paths.getSparrowAtlas('noteSplashes');
				animation.addByPrefix('green1', 'note splash purple 1', 24, false);
				animation.addByPrefix('blue1', 'note splash purple 1', 24, false);
				animation.addByPrefix('purple1', 'note splash purple 1', 24, false);
				animation.addByPrefix('red1', 'note splash purple 1', 24, false);
				animation.addByPrefix('green2', 'note splash purple 2', 24, false);
				animation.addByPrefix('blue2', 'note splash purple 2', 24, false);
				animation.addByPrefix('purple2', 'note splash purple 2', 24, false);
				animation.addByPrefix('red2', 'note splash purple 2', 24, false);
			default:
				frames = Paths.getSparrowAtlas('noteSplashes');
				animation.addByPrefix('green1', 'note splash green 1', 24, false);
				animation.addByPrefix('blue1', 'note splash blue 1', 24, false);
				animation.addByPrefix('purple1', 'note splash purple 1', 24, false);
				animation.addByPrefix('red1', 'note splash red 1', 24, false);
				animation.addByPrefix('green2', 'note splash green 2', 24, false);
				animation.addByPrefix('blue2', 'note splash blue 2', 24, false);
				animation.addByPrefix('purple2', 'note splash purple 2', 24, false);
				animation.addByPrefix('red2', 'note splash red 2', 24, false);
		}

		offset.set(10, 10);

		switch (note)
		{
			case 0:
				animation.play('purple' + type);
			case 1:
				animation.play('blue' + type);
			case 2:
				animation.play('green' + type);
			case 3:
				animation.play('red' + type);
		}
		scale.x = daNote.scale.x / 0.7;
		scale.y = daNote.scale.y / 0.7;
		updateHitbox();
		x = x + Note.noteWidth[daNote.noteData] * daNote.scale.x / 1.4 - width / 2;
		y = y + Note.noteHeight[daNote.noteData] * daNote.scale.y / 1.4 - height / 2;
		alpha = 0.6;
		rendermode = daNote.rendermode;
		switch (rendermode)
		{
			case 2:
				x = 0;
				y = 0;
				scale.x = 1;
				scale.y = 1;
				updateHitbox();
				renderer = daNote.renderer;
				renderer.isSplash = true;
			case 1:
				var cent:Array<Float> = [
					(daNote.verticles[0] + daNote.verticles[2] + daNote.verticles[4] + daNote.verticles[6]) / 4,
					(daNote.verticles[1] + daNote.verticles[3] + daNote.verticles[5] + daNote.verticles[7]) / 4
				];
				x = 0;
				y = 0;
				scale.x = 1;
				scale.y = 1;
				updateHitbox();
				var over:Array<Float> = [0, 0, 0, 0, 0, 0, 0, 0];
				for (i in 0...8)
				{
					if (i % 2 == 0)
						over[i] = cent[0] + (daNote.verticles[i] - cent[0]) * (width / Note.noteWidth[daNote.noteData]);
					else
						over[i] = cent[1] + (daNote.verticles[i] - cent[1]) * (height / Note.noteHeight[daNote.noteData]);
				}
				verticles = new Vector(8, true, over);
				uvtData = daNote.uvtData;
		}
	}

	override function draw()
	{
		switch (rendermode)
		{
			case 2:
				drawPath(renderer);
			case 1:
				if (verticles == null || uvtData == null)
					return;
				var inc:Vector<Int> = new Vector(6, true, [0, 1, 2, 1, 3, 2]);
				var gdata:FlxGraphic = mapData();
				for (camera in cameras)
				{
					if (!camera.visible || !camera.exists)
					{
						continue;
					}
					getScreenPosition(_point, camera).subtract(offset);
					camera.drawTriangles(gdata, verticles, inc, uvtData, null, _point, blend, false, antialiasing, colorTransform);
				}
			default:
				super.draw();
		}
	}

	override function update(elapsed:Float)
	{
		if (animation.curAnim != null)
		{
			if (animation.curAnim.finished)
				kill();
		}

		super.update(elapsed);
	}

}
