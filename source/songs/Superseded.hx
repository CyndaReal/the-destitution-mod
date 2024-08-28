package songs;

import ui.SubtitleObject.SubtitleTypes;
import backend.ClientPrefs;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import visuals.Boyfriend;
import visuals.Character;
import backend.Conductor;
import states.PlayState;

/**
 * Superseded's song class.
 */
class Superseded extends SongClass
{
	public override function new()
    {
        super();
        this.songNameForDisplay = 'Superseded';
        this.songHasSections = false;
        this.introType = 'Mark'; //wont be used anyways because superseded skips the countdown
        this.gameoverChar = 'bf-dead';
        this.gameoverMusicSuffix = '';
        this.songVariants = ["Normal", "Erect"];
        this.songDescription = "Mark's experimental time machine brings Nopeboy back to 2022 - 20, when everything was terrible!";
        this.startSwing = false;
        this.ratingsType = "";
        this.skipCountdown = true;
        this.preloadCharacters = ['mark-old', 'mark-old-turn', 'bf-old', 'the-creature', 'the-creature-gorilla', 'puppet-ploinky', 'puppet-ili', 'puppet-whale', 'puppet-rulez', 'puppet-crypteh', 'puppet-zam', 'bf-hunter', 'stop-loading'];
        this.startPpCam = false;
    }

    public override function stepHitEvent(curStep:Float)
    {
        //this is where step hit events go
        super.stepHitEvent(curStep);
    }
    
    public override function beatHitEvent(curBeat:Float)
    {
        //this is where beat hit events go
        super.beatHitEvent(curBeat);

        switch(curBeat)
        {
            case 28:
                PlayState.instance.supersededIntro.animation.play("open", true);
                //PlayState.instance.boyfriend.visible = false;
            case 29:
                PlayState.instance.defaultCamZoom += 15;
                FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom}, Conductor.crochet / 500, {ease: FlxEase.quadInOut});
                FlxTween.tween(PlayState.instance.supersededIntro, {y: PlayState.instance.supersededIntro.y - 75}, Conductor.crochet / 500, {ease: FlxEase.quadInOut});
            case 31:
                PlayState.instance.supersededIntro.y += 75;
                PlayState.instance.supersededIntro.visible = false;
                PlayState.instance.defaultCamZoom -= 15.1;
                FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom}, Conductor.crochet / 1000, {ease: FlxEase.circOut});
            case 32:
                PlayState.instance.tweeningCam = false;
            case 156:
                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad.destroy();
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'mark-old-turn', false, false);
                PlayState.instance.dadGroup.add(PlayState.instance.dad);
                //PlayState.instance.boyfriend.visible = true;
            case 160:
                FlxG.camera.flash();
                PlayState.instance.defaultCamZoom = 0.875;
            case 304:
                FlxTween.tween(PlayState.instance.theSmog, {alpha: 1}, (Conductor.crochet / 250) * 4, {ease: FlxEase.expoIn});
            case 312:
                PlayState.instance.boyfriend.canSing = false;
                PlayState.instance.boyfriend.canDance = false;
                PlayState.instance.boyfriend.playAnim('notice', true);
            case 320:
                PlayState.instance.shoulderCam = true;

                PlayState.instance.sectionIntroThing('The Creature and His Puppets');

                var fuckel:Int = 0;

                for (fuck in PlayState.instance.opponentStrums.members)
                {
                    FlxTween.tween(fuck, {alpha: 0}, 2 / PlayState.instance.playbackRate, {startDelay: 0.05 * fuckel, ease: FlxEase.expoOut});
                    fuckel++;
                }

                PlayState.instance.boyfriend.canSing = true;
                PlayState.instance.boyfriend.canDance = true;
                FlxG.camera.flash();
                PlayState.instance.defaultCamZoom = 1;
                FlxTween.completeTweensOf(PlayState.instance.theSmog);
                PlayState.instance.theSmog.visible = false;
                //PlayState.instance.theSmog.destroy();

                switchPuppetBg('mark');

                //PlayState.instance.supersededOverlay.visible = true;

                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad.destroy();
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'the-creature', false, false);
                PlayState.instance.dad.screenCenter();
                PlayState.instance.dad.y = creatureBaseY;
                PlayState.instance.dad.y += creatureHidingAdditive;
                PlayState.instance.dad.x += 56;
                PlayState.instance.dadGroup.add(PlayState.instance.dad);

                PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
                PlayState.instance.boyfriend.destroy();
                PlayState.instance.boyfriend = new Boyfriend(PlayState.instance.boyfriend.x, PlayState.instance.boyfriend.y, 'bf-hunter', false);
                PlayState.instance.boyfriend.screenCenter();
                PlayState.instance.boyfriend.y += 208;
                PlayState.instance.boyfriend.y += bfHidingAdditive;
                PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);
                FlxTween.tween(PlayState.instance.boyfriend, {y: PlayState.instance.boyfriend.y - 832}, 2 / PlayState.instance.playbackRate, {ease: FlxEase.cubeOut});

                PlayState.instance.dadGroup.x = 0;
                PlayState.instance.dadGroup.y = 0;
                PlayState.instance.dadGroup.scrollFactor.set(0, 0);
                PlayState.instance.boyfriendGroup.x = 0;
                PlayState.instance.boyfriendGroup.y = 0;
                PlayState.instance.boyfriendGroup.scrollFactor.set(0, 0);

                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();
            case 328:
                FlxTween.tween(PlayState.instance.dad, {y: creatureBaseY}, 1 / PlayState.instance.playbackRate, {ease: FlxEase.backInOut});

                if (!ClientPrefs.middleScroll)
                {
                    PlayState.instance.timerGoMiddlescroll(false);

                    var targetXes:Array<Float> = [82, 194, 971, 1083];

                    var fuckel:Int = 0;

                    for (fuck in PlayState.instance.playerStrums.members)
                    {
                        FlxTween.tween(fuck, {x: targetXes[fuckel]}, 2, {startDelay: 0.05 * fuckel, ease: FlxEase.circOut});
                        fuckel++;
                    }
                }
            case 384 | 608 | 912 | 1296 | 1376:
                FlxG.camera.flash();
                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();
            case 512 | 592 | 736 | 816 | 896 | 1040 | 1120 | 1200 | 1280 | 1360:
                //TRANSITION
                FlxG.camera.flash();
                FlxTween.tween(PlayState.instance.dad, {y: creatureBaseY + creatureHidingAdditive}, (Conductor.crochet / 250) * 1.75, {ease: FlxEase.backInOut});
                switchPuppetBg('mark');
            case 524:
                FlxTween.completeTweensOf(PlayState.instance.dad);
                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad.destroy();
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'puppet-ploinky', false, false);
                PlayState.instance.dad.screenCenter();
                PlayState.instance.dad.y = creatureBaseY;
                PlayState.instance.dad.y += creatureHidingAdditive;
                PlayState.instance.dad.x += 56;
                PlayState.instance.dadGroup.add(PlayState.instance.dad);
                FlxTween.tween(PlayState.instance.dad, {y: creatureBaseY}, (Conductor.crochet / 250), {ease: FlxEase.backInOut});
            case 528:
                FlxG.camera.flash();
                switchPuppetBg('ploinky');
                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();
            case 604 | 908 | 1292:
                FlxTween.completeTweensOf(PlayState.instance.dad);
                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad.destroy();
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'the-creature', false, false);
                PlayState.instance.dad.screenCenter();
                PlayState.instance.dad.y = creatureBaseY;
                PlayState.instance.dad.y += creatureHidingAdditive;
                PlayState.instance.dad.x += 56;
                PlayState.instance.dadGroup.add(PlayState.instance.dad);
                FlxTween.tween(PlayState.instance.dad, {y: creatureBaseY}, (Conductor.crochet / 250), {ease: FlxEase.backInOut});
            case 748:
                FlxTween.completeTweensOf(PlayState.instance.dad);
                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad.destroy();
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'puppet-ili', false, false);
                PlayState.instance.dad.screenCenter();
                PlayState.instance.dad.y = creatureBaseY;
                PlayState.instance.dad.y += creatureHidingAdditive;
                PlayState.instance.dad.x += 56;
                PlayState.instance.dadGroup.add(PlayState.instance.dad);
                FlxTween.tween(PlayState.instance.dad, {y: creatureBaseY}, (Conductor.crochet / 250), {ease: FlxEase.backInOut});
            case 752:
                FlxG.camera.flash();
                switchPuppetBg('ili');
                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();
            case 828:
                FlxTween.completeTweensOf(PlayState.instance.dad);
                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad.destroy();
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'puppet-whale', false, false);
                PlayState.instance.dad.screenCenter();
                PlayState.instance.dad.y = creatureBaseY;
                PlayState.instance.dad.y += creatureHidingAdditive;
                PlayState.instance.dad.x += 56;
                PlayState.instance.dadGroup.add(PlayState.instance.dad);
                FlxTween.tween(PlayState.instance.dad, {y: creatureBaseY}, (Conductor.crochet / 250), {ease: FlxEase.backInOut});
            case 832:
                FlxG.camera.flash();
                switchPuppetBg('whale');
                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();
            case 1052:
                FlxTween.completeTweensOf(PlayState.instance.dad);
                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad.destroy();
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'puppet-rulez', false, false);
                PlayState.instance.dad.screenCenter();
                PlayState.instance.dad.y = creatureBaseY;
                PlayState.instance.dad.y += creatureHidingAdditive;
                PlayState.instance.dad.x += 56;
                PlayState.instance.dadGroup.add(PlayState.instance.dad);
                FlxTween.tween(PlayState.instance.dad, {y: creatureBaseY}, (Conductor.crochet / 250), {ease: FlxEase.backInOut});
            case 1056:
                FlxG.camera.flash();
                switchPuppetBg('rulez');
                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();
            case 1132:
                FlxTween.completeTweensOf(PlayState.instance.dad);
                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad.destroy();
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'puppet-crypteh', false, false);
                PlayState.instance.dad.screenCenter();
                PlayState.instance.dad.y = creatureBaseY;
                PlayState.instance.dad.y += creatureHidingAdditive;
                PlayState.instance.dad.x += 56;
                PlayState.instance.dadGroup.add(PlayState.instance.dad);
                FlxTween.tween(PlayState.instance.dad, {y: creatureBaseY}, (Conductor.crochet / 250), {ease: FlxEase.backInOut});
            case 1136:
                FlxG.camera.flash();
                switchPuppetBg('crypteh');
                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();
            case 1212:
                FlxTween.completeTweensOf(PlayState.instance.dad);
                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad.destroy();
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'puppet-zam', false, false);
                PlayState.instance.dad.screenCenter();
                PlayState.instance.dad.y = creatureBaseY;
                PlayState.instance.dad.y += creatureHidingAdditive;
                PlayState.instance.dad.x += 56;
                PlayState.instance.dadGroup.add(PlayState.instance.dad);
                FlxTween.tween(PlayState.instance.dad, {y: creatureBaseY}, (Conductor.crochet / 250), {ease: FlxEase.backInOut});
            case 1216:
                FlxG.camera.flash();
                switchPuppetBg('zam');
                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();
            case 1372:
                FlxTween.completeTweensOf(PlayState.instance.dad);
                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad.destroy();
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'the-creature-gorilla', false, false);
                PlayState.instance.dad.screenCenter();
                PlayState.instance.dad.y = creatureBaseY;
                PlayState.instance.dad.y += creatureHidingAdditive;
                PlayState.instance.dad.x += 56;
                PlayState.instance.dadGroup.add(PlayState.instance.dad);
                FlxTween.tween(PlayState.instance.dad, {y: creatureBaseY}, (Conductor.crochet / 250), {ease: FlxEase.backInOut});
            case 1632:
                FlxG.camera.flash();
                FlxTween.tween(PlayState.instance.dad, {y: creatureBaseY + creatureHidingAdditive, alpha: 0}, (Conductor.crochet / 250) * 2, {ease: FlxEase.backInOut});
                FlxTween.tween(PlayState.instance.iconP2, {alpha: 0}, (Conductor.crochet / 250) * 2, {ease: FlxEase.expoInOut});
                PlayState.instance.shoulderCam = false;
                PlayState.instance.defaultCamZoom += 0.1;
            case 1640 | 1644 | 1660 | 1664 | 1677:
                PlayState.instance.defaultCamZoom += 0.05;
            case 1648 | 1668:
                PlayState.instance.defaultCamZoom -= 0.1;
            case 1675:
                PlayState.instance.defaultCamZoom += 0.1;
            case 1678 | 1679:
                PlayState.instance.defaultCamZoom -= 0.05;
            case 1680:
                PlayState.instance.defaultCamZoom = 1;
            case 1688:
                PlayState.instance.theSmog.alpha = 0;
                PlayState.instance.theSmog.visible = true;
                FlxTween.tween(PlayState.instance.theSmog, {alpha: 1}, (Conductor.crochet / 250) * 2, {ease: FlxEase.quadOut});
                FlxTween.tween(PlayState.instance.camHUD, {alpha: 0}, (Conductor.crochet / 250) * 2, {ease: FlxEase.quadOut});
            case 1696:
                //fade into science monitor. use custom style for subtitles for this
                PlayState.instance.defaultCamZoom = 1.01;
                PlayState.instance.boyfriend.visible = false;
                PlayState.instance.boyfriendGroup.visible = false;
                PlayState.instance.dad.visible = false;
                PlayState.instance.dadGroup.visible = false;
                PlayState.instance.starting.visible = false;
                FlxTween.completeTweensOf(PlayState.instance.theSmog);
                FlxTween.tween(PlayState.instance.theSmog, {alpha: 0}, (Conductor.crochet / 250), {ease: FlxEase.quadOut});
            case 1700:
                //subtitle: "Attempt 72 has failed."
                PlayState.instance.addSubtitleObj("Attempt 72 has failed.", (Conductor.crochet / 1000) * 7, SubtitleTypes.SCIENCEY);
            case 1707:
                //subtitle: "After this many attempts,"
                PlayState.instance.addSubtitleObj("After this many attempts,", (Conductor.crochet / 1000) * 5, SubtitleTypes.SCIENCEY);
            case 1712:
                //subtitle: "I almost feel bad for Nopeboy."
                PlayState.instance.addSubtitleObj("I almost feel bad for Nopeboy.", (Conductor.crochet / 1000) * 10, SubtitleTypes.SCIENCEY);
            case 1722:
                //subtitle: "Whatever."
                PlayState.instance.addSubtitleObj("Whatever.", (Conductor.crochet / 1000) * 2, SubtitleTypes.SCIENCEY);
            case 1724:
                //subtitle: "How many times he dies is of no consequence."
                PlayState.instance.addSubtitleObj("How many times he dies is of no consequence.", (Conductor.crochet / 1000) * 13, SubtitleTypes.SCIENCEY);
            case 1737:
                //subtitle: "Science marches on."
                PlayState.instance.addSubtitleObj("Science marches on.", 999999999 / PlayState.instance.playbackRate, SubtitleTypes.SCIENCEY);
        }
    }

    public var creatureBaseY:Float = -16;
    public var creatureHidingAdditive:Float = -1512;
    public var bfHidingAdditive:Float = 832;

    public function switchPuppetBg(puppet:String)
    {
        PlayState.instance.starting.loadGraphic(Paths.image('superseded/bg_puppet_$puppet'));
        PlayState.instance.starting.scale.set(2, 2);
        PlayState.instance.starting.updateHitbox();
        PlayState.instance.starting.screenCenter();
        PlayState.instance.starting.shader = PlayState.instance.spaceWiggle.shader;
        PlayState.instance.starting.scrollFactor.set();
    }
}