package util;

#if FLX_DEBUG
import flixel.system.debug.watch.Tracker;
import flixel.FlxG;

/**
 * Utility class that helps manage adding profiles to the flixel debugger tracker
 */
class TrackerUtil
{
  /**
   * Adds profiles to the debugger to help track certain game objects.
   * NOTE: This isn't the full list of profiles made, as sometimes they're made
   * in various places in code for random debugging purposes!
   * Might be good to put them all here though!
   */
  public static function initTrackers():Void
  {
    Tracker.addProfile(new TrackerProfile(Highscore, ['tallies']));
    FlxG.console.registerClass(Highscore);
  }
}
#end