package backend.integration;

#if GAMEJOLT_CONFIG
typedef GameJoltConfig = APIStuff;
#else
class GameJoltConfig
{
    public static var gameID:Int = 0;
    public static var privateKey:String = "";
    public static var boards:Map<String, Array<Int>> = [];
    public static var fcs:Map<String, Int> = [];
    public static var comSong:Map<String, Int> = [];
    public static var comWeek:Array<Int> = [];
}
#end
