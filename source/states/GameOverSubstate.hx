package states;

import util.EaseUtil;
import flixel.tweens.FlxTween;
import visuals.Character;
import flixel.FlxSprite;
import backend.ClientPrefs;
import flixel.addons.transition.FlxTransitionableState;
import flixel.sound.FlxSound;
import util.MemoryUtil;
import backend.Conductor;
import visuals.Boyfriend;
import util.CoolUtil;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class GameOverSubstate extends MusicBeatSubstate
{
  public var dad:Character;
  public var boyfriend:Boyfriend;

  public var camFollow:FlxPoint;
  public var camFollowPos:FlxObject;

  public var updateCamera:Bool = false;

  public var playingDeathSound:Bool = false;

  public static var characterName:String = 'bf-dead';
  public static var deathSoundName:String = 'deathsting_default';
  public static var loopSoundName:String = 'mus_overtime';
  public static var endSoundName:String = 'mus_overtime_end';

  public static var instance:GameOverSubstate;

  public static function resetVariables()
  {
    characterName = 'bf-dead';
    deathSoundName = 'deathsting_default';
    loopSoundName = 'mus_overtime';
    endSoundName = 'mus_overtime_end';
  }

  override function create()
  {
    instance = this;
    super.create();
  }

  public function new(x:Float, y:Float, camX:Float, camY:Float, bfCamOffset:Array<Float>, dadName:String, dadX:Float, dadY:Float, bfVisible:Bool,
      followNonMidpoint:Bool)
  {
    super();

    #if DEVELOPERBUILD
    var perf = new Perf("Total GameOverSubstate new()");
    #end

    var bg:FlxSprite = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
    bg.scale.set(2560, 2560);
    bg.updateHitbox();
    bg.screenCenter();
    bg.scrollFactor.set();
    bg.alpha = 0.75;
    add(bg);

    FlxTween.tween(bg, {alpha: 1}, 0.25, {ease: EaseUtil.stepped(8)});

    CoolUtil.newStateMemStuff(false);

    Conductor.songPosition = 0;

    dad = new Character(dadX, dadY, dadName, false, false);
    add(dad);

    boyfriend = new Boyfriend(x, y, characterName);
    boyfriend.visible = bfVisible;
    add(boyfriend);

    camFollow = new FlxPoint(boyfriend.getGraphicMidpoint().x, boyfriend.getGraphicMidpoint().y);

    if (followNonMidpoint)
    {
      camFollow.set(boyfriend.x, boyfriend.y);
    }
    else
    {
      camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
      camFollow.x -= boyfriend.cameraPosition[0] - bfCamOffset[0];
      camFollow.y += boyfriend.cameraPosition[1] + bfCamOffset[1];
      camFollow.x += boyfriend.curFunnyPosition[0];
      camFollow.y += boyfriend.curFunnyPosition[1];
    }

    FlxG.sound.play(Paths.sound(deathSoundName), 1, false, null, true, function oncompey()
    {
      playingDeathSound = false;
    });
    playingDeathSound = true;
    Conductor.changeBPM(95);

    boyfriend.playAnim('firstDeath', true);
    boyfriend.animation.pause();

    dad.dance();
    dad.finishAnimation();

    var fuckingHell:FlxTimer = new FlxTimer().start(0.05, function the(f:FlxTimer)
    {
      boyfriend.playAnim('firstDeath', true);

      if (dad.animOffsets.exists('gameover'))
      {
        dad.playAnim('gameover', true);
      }
    });

    #if DEVELOPERBUILD
    var versionShit:FlxText = new FlxText(-4, FlxG.height - 24, FlxG.width,
      "(DEV BUILD!!! - " + CoolUtil.gitCommitBranch + " - " + CoolUtil.gitCommitHash + ")", 12);
    versionShit.scrollFactor.set();
    versionShit.setFormat(Paths.font("BAUHS93.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
    versionShit.antialiasing = ClientPrefs.globalAntialiasing;
    add(versionShit);
    #end

    camFollowPos = new FlxObject(0, 0, 1, 1);
    camFollowPos.setPosition(camX, camY);
    add(camFollowPos);

    FlxG.camera.follow(camFollowPos, LOCKON, 1);
    FlxG.camera.focusOn(camFollowPos.getPosition());

    #if DEVELOPERBUILD
    perf.print();
    #end
  }

  var isFollowingAlready:Bool = false;

  override function update(elapsed:Float)
  {
    super.update(elapsed);

    if (FlxG.sound.music != null)
    {
      Conductor.songPosition = FlxG.sound.music.time;
    }

    if (updateCamera)
    {
      var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * PlayState.instance.cameraSpeed, 0, 1);

      camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
    }

    if (controls.ACCEPT)
    {
      endBullshit();
    }

    if (controls.BACK)
    {
      FlxG.sound.music.stop();
      FlxG.sound.list.forEach(function ficks(fuc:FlxSound)
      {
        fuc.stop();
      });
      PlayState.deathCounter = 0;
      PlayState.seenCutscene = false;
      #if DEVELOPERBUILD
      PlayState.chartingMode = false;
      #end

      MemoryUtil.collect(true);
      MemoryUtil.compact();

      FlxTransitionableState.skipNextTransIn = true;
      FlxTransitionableState.skipNextTransOut = true;

      MusicBeatState.switchState(new MainMenuState());

      FlxG.sound.playMusic(Paths.music('mus_pauperized'));
    }

    if (boyfriend.animation.curAnim != null && boyfriend.animation.curAnim.name == 'firstDeath')
    {
      if (boyfriend.animation.curAnim.curFrame >= 12 && !isFollowingAlready)
      {
        updateCamera = true;
        isFollowingAlready = true;
      }

      if (boyfriend.animation.curAnim.finished && !playingDeathSound)
      {
        coolStartDeath();
        boyfriend.startedDeath = true;
      }
    }

    if (FlxG.sound.music.playing)
    {
      Conductor.songPosition = FlxG.sound.music.time;
    }
  }

  override function beatHit()
  {
    super.beatHit();

    if (boyfriend.startedDeath)
    {
      boyfriend.playAnim('deathLoop', true);
    }
  }

  var isEnding:Bool = false;

  function coolStartDeath(?volume:Float = 1):Void
  {
    FlxG.sound.playMusic(Paths.music(loopSoundName), volume);
  }

  function endBullshit():Void
  {
    if (!isEnding)
    {
      isEnding = true;
      boyfriend.playAnim('deathConfirm', true);
      FlxG.sound.music.stop();
      FlxG.sound.list.forEach(function ficks(fuc:FlxSound)
      {
        fuc.stop();
      });
      FlxG.sound.play(Paths.music(endSoundName));
      new FlxTimer().start(1, function(tmr:FlxTimer) {
        FlxG.camera.fade(FlxColor.BLACK, 2, false, function() {
          FlxTransitionableState.skipNextTransIn = false;
          FlxTransitionableState.skipNextTransOut = false;
          MusicBeatState.switchState(new PlayState());
        });
      });
    }
  }
}