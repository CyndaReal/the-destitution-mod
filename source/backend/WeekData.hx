package backend;

import util.CoolUtil;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;
import haxe.Json;

/**
 * Week typedef.
 * @param songs The week's songs.
 * @param weekBefore The week directly before this week.
 * @param storyName The story name of this week. This is only used in the score reset menu.
 * @param weekName The week's proper name.
 * @param freeplayColor The week's freeplay colors.
 */
typedef WeekFile =
{
  var songs:Array<Dynamic>;
  var weekBefore:String;
  var storyName:String;
  var weekName:String;
  var freeplayColor:Array<Int>;
}

/**
 * Week data.
 */
class WeekData
{
  public static var weeksLoaded:Map<String, WeekData> = new Map<String, WeekData>();
  public static var weeksList:Array<String> = [];

  public var folder:String = '';

  public var songs:Array<Dynamic>;
  public var weekBefore:String;
  public var storyName:String;
  public var weekName:String;
  public var freeplayColor:Array<Int>;

  public var fileName:String;

  /**
   * Generates a template week file.
   * @return WeekFile
   */
  public static function createWeekFile():WeekFile
  {
    var weekFile:WeekFile =
      {
        songs: [["Destitution", "mark", [146, 113, 253]]],
        weekBefore: 'tutorial',
        storyName: 'Your New Week',
        weekName: 'Custom Week',
        freeplayColor: [146, 113, 253]
      };

    return weekFile;
  }

  public function new(weekFile:WeekFile, fileName:String)
  {
    songs = weekFile.songs;
    weekBefore = weekFile.weekBefore;
    storyName = weekFile.storyName;
    weekName = weekFile.weekName;
    freeplayColor = weekFile.freeplayColor;

    this.fileName = fileName;
  }

  public static function reloadWeekFiles(isStoryMode:Null<Bool> = false, ?playerCharacterSuffix:String = '')
  {
    weeksList = [];
    weeksLoaded.clear();

    var directories:Array<String> = [Paths.getPreloadPath()];

    var sexList:Array<String> = CoolUtil.coolTextFile(Paths.getPreloadPath('weeks/weekList$playerCharacterSuffix.txt'));

    for (i in 0...sexList.length)
    {
      for (j in 0...directories.length)
      {
        var fileToCheck:String = directories[j] + 'weeks/' + sexList[i] + '.json';

        if (!weeksLoaded.exists(sexList[i]))
        {
          var week:WeekFile = getWeekFile(fileToCheck);

          if (week != null)
          {
            var weekFile:WeekData = new WeekData(week, sexList[i]);

            if (weekFile != null)
            {
              weeksLoaded.set(sexList[i], weekFile);
              weeksList.push(sexList[i]);
            }
          }
        }
      }
    }
  }

  private static function addWeek(weekToCheck:String, path:String, directory:String, i:Int, originalLength:Int)
  {
    if (!weeksLoaded.exists(weekToCheck))
    {
      var week:WeekFile = getWeekFile(path);

      if (week != null)
      {
        var weekFile:WeekData = new WeekData(week, weekToCheck);

        weeksLoaded.set(weekToCheck, weekFile);
        weeksList.push(weekToCheck);
      }
    }
  }

  private static function getWeekFile(path:String):WeekFile
  {
    var rawJson:String = null;

    if (OpenFlAssets.exists(path))
    {
      rawJson = Assets.getText(path);
    }

    if (rawJson != null && rawJson.length > 0)
    {
      return cast Json.parse(rawJson);
    }

    return null;
  }

  public static function getWeekFileName(weekNum:Int = 0):String
  {
    return weeksList[weekNum];
  }

  public static function getCurrentWeek(weekNum:Int = 0):WeekData
  {
    return weeksLoaded.get(weeksList[weekNum]);
  }

  public static function setDirectoryFromWeek(?data:WeekData = null)
  {
    Paths.currentModDirectory = '';

    if (data != null && data.folder != null && data.folder.length > 0)
    {
      Paths.currentModDirectory = data.folder;
    }
  }
}