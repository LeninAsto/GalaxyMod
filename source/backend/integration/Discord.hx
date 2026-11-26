package backend.integration;

import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;

class DiscordClient
{
    static var running:Bool = false;
    public static function initialize():Void
    {
        if (running) return;
        running = true;
        var handlers = new DiscordEventHandlers();
        Discord.Initialize("847320098464727041", cpp.RawPointer.addressOf(handlers), false, null);
        sys.thread.Thread.create(() -> {
            while (running) {
                Discord.RunCallbacks();
                Sys.sleep(2);
            }
        });
        changePresence("In the Menus", null);
    }

    public static function shutdown():Void
    {
        running = false;
        Discord.Shutdown();
    }

    public static function changePresence(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float):Void
    {
        var start:Float = hasStartTimestamp ? Date.now().getTime() : 0;
        var presence = new DiscordRichPresence();
        presence.details = details;
        presence.state = state;
        presence.largeImageKey = "icon";
        presence.largeImageText = "Friday Night Funkin' - In the Galaxy";
        presence.smallImageKey = smallImageKey;
        presence.startTimestamp = Std.int(start / 1000);
        presence.endTimestamp = endTimestamp != null && endTimestamp > 0 ? Std.int((start + endTimestamp) / 1000) : 0;
        Discord.UpdatePresence(cpp.RawConstPointer.addressOf(presence));
    }
}
