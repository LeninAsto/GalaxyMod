package modcharts;

import backend.data.Song.SwagSong;
import Std;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.tile.FlxDrawTrianglesItem.DrawData;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.math.FlxRect;
import haxe.Exception;
import openfl.Lib;
import openfl.system.Capabilities;

using StringTools;

class RenderPath
{
	public var mode:Int;
	public var parameters:Array<Float>;
	public var isSplash:Bool = false;

	public var pathRatio:Float = 1;

	public function new(mode:Int, params:Array<Float>, isSplash:Bool = false)
	{
		this.mode = mode;
		parameters = params;
		this.isSplash = isSplash;
	}

	public function start(head:Float, tail:Float):Array<Array<Float>>
	{
		var uvt:Array<Float> = [0, head, 1, head, 0, tail, 1, tail];
		switch (mode)
		{
			case 0: // circle [num, all, x, y, r]
				var startOrder:Float = (parameters[0] + head) / parameters[1];
				var endOrder:Float = (parameters[0] + tail) / parameters[1];

				var ang1 = startOrder * (2 * Math.PI);
				var ang2 = endOrder * (2 * Math.PI);

				var x1 = parameters[2] - Math.sin(ang1) * parameters[4];
				var y1 = parameters[3] + Math.cos(ang1) * parameters[4];
				var x2 = parameters[2] - Math.sin(ang2) * parameters[4];
				var y2 = parameters[3] + Math.cos(ang2) * parameters[4];

				return [[parameters[2], parameters[3], x1, y1, parameters[2], parameters[3], x2, y2], uvt];
			case 1: // angle [startDistance, endDistance, x, y, width, angleDegrees, maxDistance]
				var startDistance:Float = FlxMath.lerp(parameters[0], parameters[1], head);
				var endDistance:Float = FlxMath.lerp(parameters[0], parameters[1], tail);

				var clippedTail:Float = tail;
				if (parameters[6] > 0 && startDistance > parameters[6])
					return [[0, 0, 0, 0, 0, 0, 0, 0], uvt];
				if (parameters[6] > 0 && endDistance > parameters[6])
				{
					clippedTail = head + (parameters[6] - startDistance) / (endDistance - startDistance) * (tail - head);
					endDistance = parameters[6];
				}

				var angleRadians:Float = parameters[5] / 180 * Math.PI;

				var x1:Float = parameters[2] - Math.cos(angleRadians) * parameters[4] / 2 - Math.sin(angleRadians) * startDistance;
				var y1:Float = parameters[3] - Math.sin(angleRadians) * parameters[4] / 2 + Math.cos(angleRadians) * startDistance;
				var x2:Float = parameters[2] + Math.cos(angleRadians) * parameters[4] / 2 - Math.sin(angleRadians) * startDistance;
				var y2:Float = parameters[3] + Math.sin(angleRadians) * parameters[4] / 2 + Math.cos(angleRadians) * startDistance;
				var x3:Float = parameters[2] - Math.cos(angleRadians) * parameters[4] / 2 - Math.sin(angleRadians) * endDistance;
				var y3:Float = parameters[3] - Math.sin(angleRadians) * parameters[4] / 2 + Math.cos(angleRadians) * endDistance;
				var x4:Float = parameters[2] + Math.cos(angleRadians) * parameters[4] / 2 - Math.sin(angleRadians) * endDistance;
				var y4:Float = parameters[3] + Math.sin(angleRadians) * parameters[4] / 2 + Math.cos(angleRadians) * endDistance;

				uvt = [0, head, 1, head, 0, clippedTail, 1, clippedTail];
				return [[x1, y1, x2, y2, x3, y3, x4, y4], uvt];
		}
		return null;
	}
}
