package states;

import util.CoolUtil;
import backend.Highscore;
import backend.WeekData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import ui.Alphabet;
import ui.HealthIcon;

class ResetScoreSubState extends MusicBeatSubstate
{
	var bg:FlxSprite;
	var alphabetArray:Array<Alphabet> = [];
	var icon:HealthIcon;
	var onYes:Bool = false;
	var yesText:Alphabet;
	var noText:Alphabet;

	var song:String;

	public function new(song:String, character:String)
	{
		#if DEVELOPERBUILD
		var perf = new Perf("ResetScoreSubState new()");
		#end

		this.song = song;

		super();

		var name:String = song;

		name += '?';

		bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var tooLong:Float = (name.length > 18) ? 0.8 : 1; //Fucking Winter Horrorland

		var text:Alphabet = new Alphabet(0, 180, "Reset the score of", true);
		text.screenCenter(X);
		alphabetArray.push(text);
		text.alpha = 0;
		add(text);

		var text:Alphabet = new Alphabet(0, text.y + 90, name, true);
		text.scaleX = tooLong;
		text.screenCenter(X);
		text.x += 60 * tooLong;
		alphabetArray.push(text);
		text.alpha = 0;
		add(text);

		icon = new HealthIcon(character);
		icon.setGraphicSize(Std.int(icon.width * tooLong));
		icon.updateHitbox();
		icon.setPosition(text.x - icon.width + (10 * tooLong), text.y - 30);
		icon.alpha = 0;
		add(icon);

		yesText = new Alphabet(0, text.y + 150, 'Yes', true);
		yesText.screenCenter(X);
		yesText.x -= 200;
		add(yesText);

		noText = new Alphabet(0, text.y + 150, 'No', true);
		noText.screenCenter(X);
		noText.x += 200;
		add(noText);

		updateOptions();

		#if DEVELOPERBUILD
		perf.print();
		#end
	}

	override function update(elapsed:Float)
	{
		if (CoolUtil.randomAudio.bool(0.003))
		{
			#if DEVELOPERBUILD
			trace('yous won: rare sound');
			#end
			FlxG.sound.play(Paths.sound('rare'));
		}
		
		if (bg.alpha > 0.6)
		{
			bg.alpha = 0.6;
		}
		else
		{
			bg.alpha += elapsed * 1.5;
		}

		for (i in 0...alphabetArray.length)
		{
			var spr = alphabetArray[i];
			spr.alpha += elapsed * 2.5;
		}

		icon.alpha += elapsed * 2.5;

		if (controls.UI_LEFT_P || controls.UI_RIGHT_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 1);

			onYes = !onYes;

			updateOptions();
		}

		if (controls.BACK)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'), 1);

			close();
		}
		else if (controls.ACCEPT)
		{
			if (onYes)
			{
				Highscore.resetSong(song);
			}

			FlxG.sound.play(Paths.sound('cancelMenu'), 1);

			close();
		}

		super.update(elapsed);
	}

	function updateOptions()
	{
		var scales:Array<Float> = [0.75, 1];
		var alphas:Array<Float> = [0.6, 1.25];
		var confirmInt:Int = onYes ? 1 : 0;

		yesText.alpha = alphas[confirmInt];
		yesText.scale.set(scales[confirmInt], scales[confirmInt]);
		noText.alpha = alphas[1 - confirmInt];
		noText.scale.set(scales[1 - confirmInt], scales[1 - confirmInt]);

		icon.animation.curAnim.curFrame = confirmInt;
	}
}