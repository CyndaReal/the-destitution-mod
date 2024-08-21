package states;

import backend.Conductor;
import flixel.graphics.FlxGraphic;
import flixel.system.FlxAssets.FlxGraphicAsset;
import options.OptionsState;
import backend.ClientPrefs;
import backend.WeekData;
import util.CoolUtil;
import util.MemoryUtil;
import openfl.system.System;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

#if desktop
import backend.Discord.DiscordClient;
#end

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '3'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'options'
	];

	var magenta:FlxSprite;
	
	var debugKeys:Array<FlxKey>;

	var sideThing:FlxSprite;

	var funkay:FlxSprite;

	override function create()
	{
		#if DEVELOPERBUILD
        var perf = new Perf("MainMenuState create()");
		#end

		CoolUtil.rerollRandomness();

        MemoryUtil.collect(true);
        MemoryUtil.compact();

		FlxG.mouse.visible = false;

		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
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

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('bg/menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('bg/menuDesat'));
		magenta.scrollFactor.set(0, yScroll);
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		var transThing:FlxSprite = new FlxSprite();

		if (CoolUtil.lastStateScreenShot != null)
		{
			transThing.loadGraphic(FlxGraphic.fromBitmapData(CoolUtil.lastStateScreenShot.bitmapData));
			add(transThing);
			FlxTween.tween(transThing, {alpha: 0}, 0.35, {startDelay: 0.05, ease: FlxEase.sineOut, onComplete: function transThingDiesIrl(stupidScr:FlxTween)
			{
				transThing.visible = false;
				transThing.destroy();
			}});
		}

        funkay = new FlxSprite(0, 800).loadGraphic(Paths.image("mainmenu/mark_story_mode"));
		funkay.antialiasing = ClientPrefs.globalAntialiasing;
        add(funkay);

		FlxTween.tween(funkay, {y: 0}, 1, {startDelay: 0.75, ease: FlxEase.expoOut});

		sideThing = new FlxSprite().loadGraphic(Paths.image("mainmenu/mm_side"));
		sideThing.scale.set(2, 2);
		sideThing.updateHitbox();
		sideThing.x -= 512;
		add(sideThing);
		
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(35, 32.5 + (280 * i));
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.alpha = 0;
			menuItems.add(menuItem);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			menuItem.updateHitbox();
		}

		FlxTween.tween(sideThing, {x: 0}, 0.5, {ease: FlxEase.cubeOut, onComplete: function fuock(fuer:FlxTween)
		{
			for(member in menuItems.members)
			{
				FlxTween.tween(member, {alpha: 1}, 0.35, {ease: FlxEase.sineOut, startDelay: (0.15 * member.ID)});
			}
		}});

		var versionShit:FlxText = new FlxText(-4, #if DEVELOPERBUILD FlxG.height - 44 #else FlxG.height - 24 #end, FlxG.width, "The Destitution Mod v" + psychEngineVersion #if DEVELOPERBUILD + "\n(DEV BUILD!!! - " + CoolUtil.gitCommitBranch + " - " + CoolUtil.gitCommitHash + ")" #end, 12);
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
		if (CoolUtil.randomAudio.bool(0.0003))
		{
			#if DEVELOPERBUILD
			trace('yous won: rare sound');
			#end
			FlxG.sound.play(Paths.sound('rare'));
		}

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
			if (FlxG.keys.justPressed.TAB)
			{
				selectedSomethin = true;

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
	
				if (FlxG.sound.music != null)
				{
					FlxG.sound.music.stop();
				}
				
				MusicBeatState.switchState(new ResultsState(999999, 999999, 9999, 999, 99, 9, FlxG.keys.pressed.SHIFT, 99.9, 99));
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

				if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

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

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.cancelTweensOf(spr);
						spr.alpha = 1;
						FlxTween.tween(spr, {x: -600, alpha: 0}, 0.4,
						{
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxTween.cancelTweensOf(spr);
						spr.alpha = 1;
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
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
									MusicBeatState.switchState(new FreeplayState());
								case 'options':
									FlxTransitionableState.skipNextTransIn = true;
									FlxTransitionableState.skipNextTransOut = true;
									MusicBeatState.switchState(new OptionsState());
							}
						});
					}
				});
			}
			#if desktop
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

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();
			spr.x = 35;

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected', true);
				spr.centerOffsets();
				spr.x = 35;
			}
		});
	}
}