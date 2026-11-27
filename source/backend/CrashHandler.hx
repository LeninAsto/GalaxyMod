package backend;

#if (sys && desktop)
import flixel.FlxG;
import haxe.CallStack;
import haxe.io.Path;
import lime.app.Application;
import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
import states.PlayState;
import sys.FileSystem;
import sys.io.File;

class CrashHandler
{
	static var logPath:String;
	static var handlingError:Bool = false;
	static var lastCheckpoint:Float = 0;

	public static function checkpoint():Void
	{
		var now = haxe.Timer.stamp();
		if (now - lastCheckpoint < 10) return;
		lastCheckpoint = now;
		write("Gameplay checkpoint | gcBytes=" + openfl.system.System.totalMemory);
	}

	public static function install():Void
	{
		logPath = createLogPath();
		write("Session started");
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onError);

		var window = Application.current.window;
		window.onFocusOut.add(function() write("Focus lost"));
		window.onFocusIn.add(function() write("Focus gained"));
		window.onMinimize.add(function() write("Window minimized"));
		window.onRestore.add(function() write("Window restored"));
		window.onClose.add(function() write("Window closed"));
	}

	static function createLogPath():String
	{
		var locations = [
			Path.join([Path.directory(Sys.programPath()), "logs", "crash"]),
			Path.join([lime.system.System.applicationStorageDirectory, "logs", "crash"])
		];
		for (directory in locations)
		{
			try
			{
				if (!FileSystem.exists(directory)) FileSystem.createDirectory(directory);
				var filename = "session-" + Std.string(Date.now().getTime()) + ".log";
				var path = Path.join([directory, filename]);
				File.saveContent(path, "");
				return path;
			}
			catch (_:Dynamic) {}
		}
		return null;
	}

	static function context():String
	{
		var details = [];
		try
		{
			var window = Application.current.window;
			details.push("fullscreen=" + window.fullscreen);
			details.push("window=" + window.width + "x" + window.height + " at " + window.x + "," + window.y);
		}
		catch (_:Dynamic) {}
		try
		{
			var state = FlxG.game != null ? FlxG.state : null;
			if (state != null)
			{
				details.push("state=" + Type.getClassName(Type.getClass(state)));
				if (Std.isOfType(state, PlayState) && PlayState.SONG != null)
				{
					details.push("song=" + PlayState.SONG.song);
					details.push("difficulty=" + PlayState.storyDifficulty);
					details.push("positionMs=" + Math.round(Conductor.songPosition));
				}
			}
		}
		catch (_:Dynamic) {}
		return details.join(" | ");
	}

	static function write(message:String):Void
	{
		if (logPath == null) return;
		try
		{
			var line = "[" + Date.now().toString() + "] " + message + " | " + context() + "\n";
			var output = File.append(logPath, false);
			output.writeString(line);
			output.close();
		}
		catch (_:Dynamic) {}
	}

	static function onError(event:UncaughtErrorEvent):Void
	{
		if (handlingError) return;
		handlingError = true;
		var stack = CallStack.toString(CallStack.exceptionStack(true));
		if (StringTools.trim(stack).length == 0) stack = "Stack trace unavailable.";
		var message = Std.string(event.error);
		var details = "Uncaught error: " + message + "\n" + context() + "\n" + stack;
		write("Uncaught error: " + message + "\n" + stack);
		event.preventDefault();
		try
		{
			var location = logPath != null ? "\n\nLog: " + logPath : "\n\nCould not write a log file.";
			Application.current.window.alert(details + location, "GalaxyMod - Error");
		}
		catch (_:Dynamic) {}
		Sys.exit(1);
	}
}
#end
