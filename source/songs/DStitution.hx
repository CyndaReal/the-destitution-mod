package songs;

import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.tweens.FlxEase;

/**
 * D-stitution's song class.
 */
class DStitution extends SongClass
{
	public override function new()
    {
        super();
        this.songNameForDisplay = 'D-Stitution';
        this.songHasSections = true;
        this.introType = 'Karm';
        this.gameoverChar = 'd-bf-dead';
        //make it dsides later dumb
        this.gameoverMusicSuffix = '';
        this.songVariants = ["Normal", "Erect"];
        this.songDescription = "Mark enlists Nopeboy to test the new dimension shifter on his time machine, and shenanigans ensue!";
    }

    public override function stepHitEvent(curStep:Float)
    {
        //this is where step hit events go
        super.stepHitEvent(curStep);

        switch(curStep)
        {
            case 96:
                FlxTween.tween(PlayState.instance.camHUD, {alpha: 0}, Conductor.crochet / 250);
                FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom + 0.1}, Conductor.crochet / 500, {ease: FlxEase.cubeOut});
                PlayState.instance.defaultCamZoom += 0.1;
                PlayState.instance.dad.canDance = false;
                PlayState.instance.dad.canSing = false;
                PlayState.instance.dad.playAnim("lipsync", true);
            case 248:
                FlxTween.tween(PlayState.instance.camHUD, {alpha: 1}, Conductor.crochet / 500);
                FlxTween.tween(FlxG.camera, {zoom: PlayState.instance.defaultCamZoom + 0.2}, Conductor.crochet / 500, {ease: FlxEase.cubeInOut});
                PlayState.instance.defaultCamZoom += 0.2;
            case 256:
                PlayState.instance.dad.canDance = true;
                PlayState.instance.dad.canSing = true;
                PlayState.instance.defaultCamZoom -= 0.3;
                FlxG.camera.flash();
            case 368 | 372 | 376 | 378:
                PlayState.instance.defaultCamZoom += 0.05;
            case 380:
                PlayState.instance.defaultCamZoom -= 0.3;
                FlxG.camera.zoom = PlayState.instance.defaultCamZoom;
            case 384:
                FlxG.camera.flash();
                PlayState.instance.defaultCamZoom += 0.1;
            case 496:
                PlayState.instance.defaultCamZoom -= 0.05;
                FlxG.camera.zoom = PlayState.instance.defaultCamZoom;
                PlayState.instance.moveCamera(true);
                PlayState.instance.disallowCamMove = true;
                PlayState.instance.snapCamFollowToPos(PlayState.instance.camFollow.x, PlayState.instance.camFollow.y);
                PlayState.instance.dad.canDance = false;
                PlayState.instance.dad.canSing = false;
                PlayState.instance.dad.playAnim("coolify", true);
            case 512:
                PlayState.instance.dad.canDance = true;
                PlayState.instance.dad.canSing = true;
                FlxTween.tween(PlayState.instance.funnyBgColors, {alpha: 0.4}, Conductor.crochet / 500, {ease: FlxEase.circOut});
                PlayState.instance.disallowCamMove = false;
                PlayState.instance.defaultCamZoom += 0.25;
            case 516:
                PlayState.instance.funnyBgColorsPumpin = true;
            case 640:
                PlayState.instance.defaultCamZoom -= 0.1;
                PlayState.instance.bgColorsCrazyBeats = 2;
            case 760:
                //FlxG.camera.fade(FlxColor.WHITE, Conductor.crochet / 500);
            case 768:
                //FlxG.camera.fade(FlxColor.TRANSPARENT, 0.000001, false);
                FlxG.camera.flash();
                PlayState.instance.defaultCamZoom -= 0.1;
                PlayState.instance.bgColorsCrazyBeats = 2;
                PlayState.instance.bgColorsRandom = true;
            case 1012:
                PlayState.instance.moveCamera(true);
                PlayState.instance.disallowCamMove = true;
                PlayState.instance.snapCamFollowToPos(PlayState.instance.camFollow.x, PlayState.instance.camFollow.y);
                PlayState.instance.dad.canDance = false;
                PlayState.instance.dad.canSing = false;
                PlayState.instance.dad.playAnim("decool", true);
            case 1024:
                PlayState.instance.bgColorsRandom = false;
                PlayState.instance.funnyBgColorsPumpin = false;
                PlayState.instance.funnyBgColors.color = FlxColor.BLACK;
                PlayState.instance.funnyBgColors.alpha = 0;
                FlxG.camera.flash();
                PlayState.instance.dad.canDance = true;
                PlayState.instance.dad.canSing = true;
                PlayState.instance.disallowCamMove = false;
        }
    }
    
    public override function beatHitEvent(curBeat:Float)
    {
        //this is where beat hit events go
        super.beatHitEvent(curBeat);

        switch(curBeat)
        {
            case 512:
                //pinkerton
                PlayState.instance.lightningBg();
                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'pinkerton', false, false);
                PlayState.instance.dadGroup.add(PlayState.instance.dad);

                PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
                PlayState.instance.boyfriend = new Boyfriend(PlayState.instance.boyfriend.x, PlayState.instance.boyfriend.y, 'd-bf-dark', false);
                PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);
                
                PlayState.instance.add(PlayState.instance.lightningStrikes);

                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();

                PlayState.instance.sectionIntroThing("Sir Pinkerton III");

                PlayState.instance.karmScaredy.visible = true;

                FlxG.camera.flash();
            case 520:
                PlayState.instance.strikeyStrikes = true;
            case 920:
                PlayState.instance.karmScaredy.visible = false;
                PlayState.instance.train.visible = true;
                PlayState.instance.unLightningBg();
                PlayState.instance.strikeyStrikes = false;

                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y - 350, 'd-ili', false, false);
                PlayState.instance.dadGroup.add(PlayState.instance.dad);

                PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
                PlayState.instance.boyfriend = new Boyfriend(PlayState.instance.boyfriend.x, PlayState.instance.boyfriend.y, 'd-bf', false);
                PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);

                FlxG.camera.flash();

                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();
                PlayState.instance.iconP2.visible = false;
                PlayState.instance.dad.visible = false;
            case 992:
                PlayState.instance.iconP2.visible = true;
                PlayState.instance.train.visible = false;
                PlayState.instance.dad.visible = true;
                FlxG.camera.flash();

                PlayState.instance.sky.loadGraphic(Paths.image('dsides/iliSky'));
                PlayState.instance.backing.loadGraphic(Paths.image('dsides/iliBacking'));
                PlayState.instance.starting.loadGraphic(Paths.image('dsides/iliRoom'));

                PlayState.instance.sectionIntroThing("I LIEK ITEM");
            case 1336:
                FlxG.camera.flash();

                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'douglass', false, false);
                PlayState.instance.dadGroup.add(PlayState.instance.dad);

                PlayState.instance.sky.loadGraphic(Paths.image('dsides/dougSky'));
                PlayState.instance.backing.loadGraphic(Paths.image('dsides/dougBacking'));
                PlayState.instance.starting.loadGraphic(Paths.image('dsides/dougRoom'));

                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();

                PlayState.instance.sectionIntroThing("Douglass Dolphin");
            case 1758:
                FlxG.camera.flash();

                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'karm-scold', false, false);
                PlayState.instance.dadGroup.add(PlayState.instance.dad);

                PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
                PlayState.instance.boyfriend = new Boyfriend(PlayState.instance.boyfriend.x, PlayState.instance.boyfriend.y, 'douglass-player', false);
                PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);

                PlayState.instance.sky.loadGraphic(Paths.image('dsides/dougSky'));
                PlayState.instance.backing.loadGraphic(Paths.image('dsides/dougBacking'));
                PlayState.instance.starting.loadGraphic(Paths.image('dsides/dougRoom'));

                PlayState.instance.iconP1.changeIcon(PlayState.instance.boyfriend.healthIcon);
                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();

                PlayState.instance.sectionIntroThing("Being Rude is Not Nice!");
            case 2072:
                FlxG.camera.flash();

                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'd-rules', false, false);
                PlayState.instance.dadGroup.add(PlayState.instance.dad);

                PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
                PlayState.instance.boyfriend = new Boyfriend(PlayState.instance.boyfriend.x, PlayState.instance.boyfriend.y, 'd-bf-rules', false);
                PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);

                PlayState.instance.sky.loadGraphic(Paths.image('dsides/skyworldSky'));
                PlayState.instance.backing.visible = false;
                PlayState.instance.starting.loadGraphic(Paths.image('dsides/skyworldStage'));

                PlayState.instance.iconP1.changeIcon(PlayState.instance.boyfriend.healthIcon);
                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();

                PlayState.instance.sectionIntroThing("I, Rules");
            case 2504:
                FlxG.camera.flash();

                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'maestro', false, false);
                PlayState.instance.dadGroup.add(PlayState.instance.dad);

                PlayState.instance.boyfriendGroup.remove(PlayState.instance.boyfriend);
                PlayState.instance.boyfriend = new Boyfriend(PlayState.instance.boyfriend.x, PlayState.instance.boyfriend.y, 'd-bf-rules-flipped', false);
                PlayState.instance.boyfriendGroup.add(PlayState.instance.boyfriend);

                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();

                PlayState.instance.sectionIntroThing("Maestro Cryptehnt");
            case 3056:
                FlxG.camera.flash();

                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'zamboney', false, false);
                PlayState.instance.dadGroup.add(PlayState.instance.dad);

                PlayState.instance.boyfriend.visible = false;

                PlayState.instance.sky.visible = false;
                PlayState.instance.backing.visible = false;
                PlayState.instance.starting.visible = false;

                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();

                PlayState.instance.sectionIntroThing("Zam-boney!");
            case 3568:
                FlxG.camera.flash();

                PlayState.instance.dadGroup.remove(PlayState.instance.dad);
                PlayState.instance.dad = new Character(PlayState.instance.dad.x, PlayState.instance.dad.y, 'karm-finale', false, false);
                PlayState.instance.dadGroup.add(PlayState.instance.dad);

                PlayState.instance.iconP2.changeIcon(PlayState.instance.dad.healthIcon);
                PlayState.instance.reloadHealthBarColors();

                PlayState.instance.sectionIntroThing("Karm Kurt Karmason Jr. (Finale)");
        }
    }
}