package backend.integration;

import flixel.FlxG;
import flixel.util.FlxTimer;
import hxvlc.flixel.FlxVideo;
import openfl.events.Event;

class BossVideo extends FlxVideo
{
    public var finishCallback:Void->Void;
    public var canSkip:Bool = false;
    var finished:Bool = false;

    public function playVideo(path:String):Void
    {
        onEndReached.add(finish);
        onEncounteredError.add(_ -> finish());
        FlxG.addChildBelowMouse(this);
        FlxG.stage.addEventListener(Event.ENTER_FRAME, update);
        if (!load(path)) {
            finish();
            return;
        }
        FlxTimer.wait(0.001, () -> {
            if (!finished && !play()) finish();
        });
    }

    function update(_:Event):Void
    {
        volume = FlxG.sound.muted ? 0 : FlxG.sound.volume;
        if (canSkip && PlayerSettings.player1.controls.ACCEPT) {
            FlxG.sound.music.stop();
            finish();
        }
    }

    function finish():Void
    {
        if (finished) return;
        finished = true;
        FlxG.stage.removeEventListener(Event.ENTER_FRAME, update);
        FlxG.removeChild(this);
        dispose();
        if (finishCallback != null) finishCallback();
    }
}
