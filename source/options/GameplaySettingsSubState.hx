package options;

import backend.TextAndLanguage;
import backend.ClientPrefs;
import flixel.FlxG;

class GameplaySettingsSubState extends BaseOptionsMenu
{
  public function new()
  {
    title = TextAndLanguage.getPhrase('opt_gps_title', 'Gameplay Settings');
    rpcTitle = 'Gameplay Settings Menu'; // for Discord Rich Presence
    backGroundColor = 0xff464cac;

    var option:Option = new Option(TextAndLanguage.getPhrase('opt_gps_ctrlMode', 'Controller Mode'),
      TextAndLanguage.getPhrase('opt_gps_ctrlModeDesc', 'Check this if you want to play with\na controller instead of using your Keyboard.'),
      'controllerMode', 'bool', false);
    option.showSprites = 'controller_mode';
    addOption(option);

    // I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
    var option:Option = new Option(TextAndLanguage.getPhrase('opt_gps_dwnScr', 'Downscroll'), // Name
      TextAndLanguage.getPhrase('opt_gps_dwnScrDesc', 'If checked, notes go Down instead of Up, simple enough.'), // Description
      'downScroll', // Save data variable name
      'bool', // Variable type
      false); // Default value
    addOption(option);

    var option:Option = new Option(TextAndLanguage.getPhrase('opt_gps_midScr', 'Middlescroll'),
      TextAndLanguage.getPhrase('opt_gps_midScrDesc', 'If checked, your notes get centered.'), 'middleScroll', 'bool', false);
    addOption(option);

    var option:Option = new Option(TextAndLanguage.getPhrase('opt_gps_oppNotes', 'Opponent Notes'),
      TextAndLanguage.getPhrase('opt_gps_oppNotesDesc', 'If unchecked, opponent notes get hidden.'), 'opponentStrums', 'bool', true);
    addOption(option);

    var option:Option = new Option(TextAndLanguage.getPhrase('opt_gps_gstap', 'Ghost Tapping'),
      TextAndLanguage.getPhrase('opt_gps_gstapDesc', "If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit."),
      'ghostTapping', 'bool', true);
    addOption(option);

    var option:Option = new Option('Disable Reset Button', "If checked, pressing Reset won't do anything.", 'noReset', 'bool', false);
    addOption(option);

    var option:Option = new Option('Hitsound Volume:', 'Funny notes does \"Tick!\" when you hit them."', 'hitsoundVolume', 'percent', 0);
    addOption(option);
    option.scrollSpeed = 1.6;
    option.minValue = 0.0;
    option.maxValue = 1;
    option.changeValue = 0.1;
    option.decimals = 1;
    option.onChange = onChangeHitsoundVolume;

    var option:Option = new Option('Rating Offset:', 'Changes how late/early you have to hit for a "Synergy!"\nHigher values mean you have to hit later.',
      'ratingOffset', 'int', 0);
    option.displayFormat = '%vms';
    option.scrollSpeed = 20;
    option.minValue = -30;
    option.maxValue = 30;
    addOption(option);

    var option:Option = new Option('Synergy! Hit Window:', 'Changes the amount of time you have\nfor hitting a "Synergy!" in milliseconds.', 'synergyWindow',
      'int', 45);
    option.displayFormat = '%vms';
    option.scrollSpeed = 15;
    option.minValue = 15;
    option.maxValue = 45;
    addOption(option);

    var option:Option = new Option('Good Hit Window:', 'Changes the amount of time you have\nfor hitting a "Good" in milliseconds.', 'goodWindow', 'int', 90);
    option.displayFormat = '%vms';
    option.scrollSpeed = 30;
    option.minValue = 15;
    option.maxValue = 90;
    addOption(option);

    var option:Option = new Option('Egh Hit Window:', 'Changes the amount of time you have\nfor hitting a "Egh" in milliseconds.', 'eghWindow', 'int', 135);
    option.displayFormat = '%vms';
    option.scrollSpeed = 60;
    option.minValue = 15;
    option.maxValue = 135;
    addOption(option);

    var option:Option = new Option('Blegh Hit Window:', 'Changes the amount of time you have\nfor hitting a "Blegh" in milliseconds.', 'bleghWindow', 'int',
      135);
    option.displayFormat = '%vms';
    option.scrollSpeed = 60;
    option.minValue = 15;
    option.maxValue = 160;
    addOption(option);

    var option:Option = new Option('Safe Frames:', 'Changes how many frames you have for\nhitting a note earlier or late.', 'safeFrames', 'float', 10);
    option.scrollSpeed = 5;
    option.minValue = 2;
    option.maxValue = 10;
    option.changeValue = 0.1;
    addOption(option);

    super();
  }

  function onChangeHitsoundVolume()
  {
    FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
  }
}