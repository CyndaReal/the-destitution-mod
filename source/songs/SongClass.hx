package songs;

/**
 * This class is used for storing song events, as opposed to crowding playstate.
 * each song has an override of it.
 * can probably even be used for storing extra data eventually! potentially?
 */
class SongClass
{
    public var songNameForDisplay:String = "";

    public var introType:String = "Default";

    public var gameoverChar:String = "bf-dead";

    public var gameoverMusicSuffix:String = "";

    public var songDescription:String = 'Placeholder';

    public var songVariants:Array<String> = ["Normal"];

    public var songHasSections:Bool = false;

    public var startSwing:Bool = false;

	public function new()
    {
        
    }

    public function stepHitEvent(curStep:Float)
    {
        //this is where step hit events will be overrided by the song class
    }
    
    public function beatHitEvent(curBeat:Float)
    {
        //this is where beat hit events will be overrided by the song class
    }
}