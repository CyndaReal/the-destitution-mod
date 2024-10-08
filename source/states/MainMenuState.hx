package states;

import ui.TransitionScreenshotObject;
import states.ResultsState.ResultRanks;
import util.EaseUtil;
import visuals.PixelPerfectSprite;
import lime.app.Application;
import ui.MainMenuButton;
import backend.Conductor;
import options.OptionsState;
import backend.ClientPrefs;
import util.CoolUtil;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
#if desktop
import backend.Discord.DiscordClient;
#end
#if DEVELOPERBUILD
import editors.MasterEditorMenu;
#end

class MainMenuState extends MusicBeatState
{
  #if DEVELOPERBUILD
  var debugRank:ResultRanks = GOOD;

  // before i get a character select in, thisll do for testing
  var debugChar:String = '';
  #end

  public static var curSelected:Int = 0;

  public var menuItems:FlxTypedGroup<MainMenuButton>;
  public var camGame:FlxCamera;

  public var optionShit:Array<String> = ['story_mode', 'freeplay', 'options'];

  public var magenta:PixelPerfectSprite;

  public var debugKeys:Array<FlxKey>;

  public var sideThing:PixelPerfectSprite;

  public var funkay:PixelPerfectSprite;

  override function create()
  {
    #if DEVELOPERBUILD
    var perf = new Perf("MainMenuState create()");
    #end

    persistentUpdate = true;
    persistentDraw = true;

    CoolUtil.newStateMemStuff();

    FlxG.mouse.visible = false;

    #if desktop
    // Updating Discord Rich Presence
    DiscordClient.changePresence("In the Main Menu", null, null, '-menus');
    #end

    debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

    if (FlxG.sound.music == null)
    {
      FlxG.sound.playMusic(Paths.music('mus_pauperized'), 0);
      Conductor.changeBPM(150);
    }

    camGame = new FlxCamera();

    FlxG.cameras.reset(camGame);
    FlxG.cameras.setDefaultDrawTarget(camGame, true);

    transIn = FlxTransitionableState.defaultTransIn;
    transOut = FlxTransitionableState.defaultTransOut;

    var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);

    var bg:PixelPerfectSprite = new PixelPerfectSprite(-80).loadGraphic(Paths.image('bg/menuBG'));
    bg.scrollFactor.set(0, yScroll);
    bg.updateHitbox();
    bg.screenCenter();
    add(bg);

    magenta = new PixelPerfectSprite(-80).loadGraphic(Paths.image('bg/menuDesat'));
    magenta.scrollFactor.set(0, yScroll);
    magenta.updateHitbox();
    magenta.screenCenter();
    magenta.visible = false;
    magenta.color = 0xFFfd719b;
    add(magenta);

    var transThing = new TransitionScreenshotObject();
    add(transThing);
    transThing.fadeout();

    funkay = new PixelPerfectSprite(0, 800).loadGraphic(Paths.image("mainmenu/mark_story_mode"));
    funkay.x = 1280 - funkay.width;
    funkay.antialiasing = ClientPrefs.globalAntialiasing;
    add(funkay);

    FlxTween.tween(funkay, {y: 0}, 1, {startDelay: 0.75, ease: FlxEase.expoOut});

    sideThing = new PixelPerfectSprite().loadGraphic(Paths.image("mainmenu/mm_side"));
    sideThing.scale.set(2, 2);
    sideThing.updateHitbox();
    sideThing.x -= 512;
    add(sideThing);

    menuItems = new FlxTypedGroup<MainMenuButton>();
    add(menuItems);

    var scale:Float = 1;

    for (i in 0...optionShit.length)
    {
      var menuItem:MainMenuButton = new MainMenuButton(35, 32.5 + (280 * i), optionShit[i], scale);
      menuItem.ID = i;
      menuItem.alpha = 0;
      menuItems.add(menuItem);
    }

    FlxTween.tween(sideThing, {x: 0}, 0.5,
      {
        ease: FlxEase.cubeOut,
        onComplete: function fuock(fuer:FlxTween)
        {
          for (member in menuItems.members)
          {
            FlxTween.tween(member, {alpha: 1}, 0.25, {ease: EaseUtil.stepped(4), startDelay: (0.15 * member.ID)});
          }
        }
      });

    var versionShit:FlxText = new FlxText(-4, #if DEVELOPERBUILD FlxG.height
      - 44 #else FlxG.height
      - 24 #end, FlxG.width,
      "The Destitution Mod v"
      + Application.current.meta.get('version') #if DEVELOPERBUILD
      + "\n(DEV BUILD!!! - "
      + CoolUtil.gitCommitBranch
      + " - "
      + CoolUtil.gitCommitHash
      + ")" #end, 12);
    versionShit.scrollFactor.set();
    versionShit.setFormat(Paths.font("BAUHS93.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
    versionShit.antialiasing = ClientPrefs.globalAntialiasing;
    add(versionShit);

    changeItem();

    super.create();

    #if DEVELOPERBUILD
    perf.print();
    #end
  }

  var selectedSomethin:Bool = false;

  override function update(elapsed:Float)
  {
    if (FlxG.sound.music != null)
    {
      if (FlxG.sound.music.volume < 0.8)
      {
        FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
      }

      Conductor.songPosition = FlxG.sound.music.time;
    }

    if (!selectedSomethin)
    {
      #if DEVELOPERBUILD
      // sorry man
      if (FlxG.keys.justPressed.ONE || FlxG.keys.justPressed.NUMPADONE)
      {
        FlxG.sound.play(Paths.sound('scrollMenu'));

        debugRank = BLEGH;
        debugChar = '';
      }
      else if (FlxG.keys.justPressed.TWO || FlxG.keys.justPressed.NUMPADTWO)
      {
        FlxG.sound.play(Paths.sound('scrollMenu'));

        debugRank = EGH;
        debugChar = '-bf';
      }
      else if (FlxG.keys.justPressed.THREE || FlxG.keys.justPressed.NUMPADTHREE)
      {
        FlxG.sound.play(Paths.sound('scrollMenu'));

        debugRank = GOOD;
        debugChar = '-mark';
      }
      else if (FlxG.keys.justPressed.FOUR || FlxG.keys.justPressed.NUMPADFOUR)
      {
        FlxG.sound.play(Paths.sound('scrollMenu'));

        debugRank = GREAT;
        debugChar = '-pear';
      }
      else if (FlxG.keys.justPressed.FIVE || FlxG.keys.justPressed.NUMPADFIVE)
      {
        FlxG.sound.play(Paths.sound('scrollMenu'));

        debugRank = SYNERGY;
      }

      if (FlxG.keys.justPressed.TAB)
      {
        selectedSomethin = true;

        FlxTransitionableState.skipNextTransIn = true;
        FlxTransitionableState.skipNextTransOut = true;

        if (FlxG.sound.music != null)
        {
          FlxG.sound.music.stop();
        }

        MusicBeatState.switchState(new ResultsState(999999, 999999, 9999, 999, 99, 9, FlxG.keys.pressed.SHIFT, 99.9, 99, '', debugRank));
      }
      #end

      if (controls.UI_UP_P)
      {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        changeItem(-1);
      }

      if (controls.UI_DOWN_P)
      {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        changeItem(1);
      }

      if (controls.BACK)
      {
        selectedSomethin = true;
        FlxG.sound.play(Paths.sound('cancelMenu'));
        FlxTransitionableState.skipNextTransIn = true;
        FlxTransitionableState.skipNextTransOut = true;
        MusicBeatState.switchState(new TitleState());
      }

      if (controls.ACCEPT)
      {
        selectedSomethin = true;

        FlxG.sound.play(Paths.sound('confirmMenu'));

        if (ClientPrefs.flashing)
        {
          FlxFlicker.flicker(magenta, 1.1, 0.15, false);
        }

        FlxTween.cancelTweensOf(sideThing);
        FlxTween.cancelTweensOf(funkay);

        FlxTween.tween(sideThing, {x: -512}, 0.4,
          {
            ease: FlxEase.quadOut
          });

        FlxTween.tween(funkay, {y: 800}, 0.4,
          {
            ease: FlxEase.quadOut
          });

        menuItems.forEach(function(spr:MainMenuButton) {
          if (curSelected != spr.ID)
          {
            FlxTween.completeTweensOf(spr);
            spr.alpha = 1;
            FlxTween.tween(spr, {x: -600, alpha: 0}, 0.3,
              {
                startDelay: 0.1 * spr.ID,
                ease: EaseUtil.stepped(8),
                onComplete: function(twn:FlxTween) {
                  spr.kill();
                }
              });
          }
          else
          {
            FlxTween.completeTweensOf(spr);
            spr.alpha = 1;
            spr.buttonFlicker(1, function flck()
            {
              var daChoice:String = optionShit[curSelected];

              switch (daChoice)
              {
                case 'story_mode':
                  FlxTransitionableState.skipNextTransIn = true;
                  FlxTransitionableState.skipNextTransOut = true;
                  MusicBeatState.switchState(new FreeplayState());
                case 'freeplay':
                  FlxTransitionableState.skipNextTransIn = true;
                  FlxTransitionableState.skipNextTransOut = true;
                  MusicBeatState.switchState(new FreeplayState(#if DEVELOPERBUILD debugChar #end));
                case 'options':
                  FlxTransitionableState.skipNextTransIn = true;
                  FlxTransitionableState.skipNextTransOut = true;
                  MusicBeatState.switchState(new OptionsState());
              }
            });
          }
        });
      }
      #if DEVELOPERBUILD
      else if (FlxG.keys.anyJustPressed(debugKeys))
      {
        selectedSomethin = true;
        MusicBeatState.switchState(new MasterEditorMenu());
      }
      #end
    }

    super.update(elapsed);
  }

  function changeItem(huh:Int = 0)
  {
    curSelected += huh;

    if (curSelected >= menuItems.length)
    {
      curSelected = 0;
    }

    if (curSelected < 0)
    {
      curSelected = menuItems.length - 1;
    }

    funkay.loadGraphic(Paths.image('mainmenu/mark_' + optionShit[curSelected]));

    funkay.x = 1280 - funkay.width;

    menuItems.forEach(function(spr:MainMenuButton) {
      spr.playAnim('idle');
      spr.updateHitbox();
      spr.x = 35;

      if (spr.ID == curSelected)
      {
        spr.playAnim('selected');
        spr.centerOffsets();
        spr.x = 35;
      }
    });
  }
}