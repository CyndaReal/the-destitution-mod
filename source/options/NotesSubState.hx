package options;

import ui.Alphabet;
import visuals.PixelPerfectSprite;
import backend.ClientPrefs;
import shaders.ColorSwap;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import states.MusicBeatSubstate;

class NotesSubState extends MusicBeatSubstate
{
  private static var curSelected:Int = 0;
  private static var typeSelected:Int = 0;

  private var grpNumbers:FlxTypedGroup<Alphabet>;
  private var grpNotes:FlxTypedGroup<PixelPerfectSprite>;
  private var shaderArray:Array<ColorSwap> = [];
  var curValue:Float = 0;
  var holdTime:Float = 0;
  var nextAccept:Int = 5;

  var blackBG:FlxSprite;
  var hsbText:Alphabet;

  var posX = 230;

  public function new()
  {
    super();

    var bg:PixelPerfectSprite = new PixelPerfectSprite().loadGraphic(Paths.image('options/optionsBg'));
    bg.color = 0xffe3e7ae;
    bg.screenCenter();
    add(bg);

    var clipboard:PixelPerfectSprite = new PixelPerfectSprite().loadGraphic(Paths.image('options/clipboard'));
    clipboard.scale.set(2, 2);
    clipboard.updateHitbox();
    clipboard.screenCenter();
    add(clipboard);

    blackBG = new FlxSprite(posX - 25).makeGraphic(870, 200, FlxColor.BLACK);
    blackBG.alpha = 0.4;
    add(blackBG);

    grpNotes = new FlxTypedGroup<PixelPerfectSprite>();
    add(grpNotes);
    grpNumbers = new FlxTypedGroup<Alphabet>();
    add(grpNumbers);

    for (i in 0...ClientPrefs.arrowHSV.length)
    {
      var yPos:Float = (165 * i) + 35;

      for (j in 0...3)
      {
        var optionText:Alphabet = new Alphabet(posX + (225 * j) + 250, yPos + 60, Std.string(ClientPrefs.arrowHSV[i][j]), true, true);
        grpNumbers.add(optionText);
      }

      var animations:Array<String> = ['purple', 'blue', 'green', 'red'];
      var note:PixelPerfectSprite = new PixelPerfectSprite(posX, yPos).loadGraphic(Paths.image('options/nc/' + animations[i]));
      note.antialiasing = ClientPrefs.globalAntialiasing;
      note.scale.set(1.5, 1.5);
      grpNotes.add(note);

      var newShader:ColorSwap = new ColorSwap();
      note.shader = newShader.shader;
      newShader.hue = ClientPrefs.arrowHSV[i][0] / 360;
      newShader.saturation = ClientPrefs.arrowHSV[i][1] / 100;
      newShader.brightness = ClientPrefs.arrowHSV[i][2] / 100;
      shaderArray.push(newShader);
    }

    hsbText = new Alphabet(posX + 560, 0, "Hue    Saturation  Brightness", false, true);
    hsbText.pureWhite = true;
    hsbText.scaleX = 0.6;
    hsbText.scaleY = 0.6;
    add(hsbText);

    changeSelection();
  }

  var changingNote:Bool = false;

  override function update(elapsed:Float)
  {
    if (changingNote)
    {
      if (holdTime < 0.5)
      {
        if (controls.UI_LEFT_P)
        {
          updateValue(-1);
          FlxG.sound.play(Paths.sound('scrollMenu'));
        }
        else if (controls.UI_RIGHT_P)
        {
          updateValue(1);
          FlxG.sound.play(Paths.sound('scrollMenu'));
        }
        else if (controls.RESET)
        {
          resetValue(curSelected, typeSelected);
          FlxG.sound.play(Paths.sound('scrollMenu'));
        }
        if (controls.UI_LEFT_R || controls.UI_RIGHT_R)
        {
          holdTime = 0;
        }
        else if (controls.UI_LEFT || controls.UI_RIGHT)
        {
          holdTime += elapsed;
        }
      }
      else
      {
        var add:Float = 90;
        switch (typeSelected)
        {
          case 1 | 2:
            add = 50;
        }

        if (controls.UI_LEFT)
        {
          updateValue(elapsed * -add);
        }
        else if (controls.UI_RIGHT)
        {
          updateValue(elapsed * add);
        }

        if (controls.UI_LEFT_R || controls.UI_RIGHT_R)
        {
          FlxG.sound.play(Paths.sound('scrollMenu'));
          holdTime = 0;
        }
      }
    }
    else
    {
      if (controls.UI_UP_P)
      {
        changeSelection(-1);
        FlxG.sound.play(Paths.sound('scrollMenu'));
      }
      if (controls.UI_DOWN_P)
      {
        changeSelection(1);
        FlxG.sound.play(Paths.sound('scrollMenu'));
      }
      if (controls.UI_LEFT_P)
      {
        changeType(-1);
        FlxG.sound.play(Paths.sound('scrollMenu'));
      }
      if (controls.UI_RIGHT_P)
      {
        changeType(1);
        FlxG.sound.play(Paths.sound('scrollMenu'));
      }
      if (controls.RESET)
      {
        for (i in 0...3)
        {
          resetValue(curSelected, i);
        }
        FlxG.sound.play(Paths.sound('scrollMenu'));
      }
      if (controls.ACCEPT && nextAccept <= 0)
      {
        FlxG.sound.play(Paths.sound('scrollMenu'));
        changingNote = true;
        holdTime = 0;
        for (i in 0...grpNumbers.length)
        {
          var item = grpNumbers.members[i];
          item.alpha = 0;
          if ((curSelected * 3) + typeSelected == i)
          {
            item.alpha = 1;
          }
        }
        for (i in 0...grpNotes.length)
        {
          var item = grpNotes.members[i];
          item.alpha = 0;

          if (curSelected == i)
          {
            item.alpha = 1;
          }
        }
        super.update(elapsed);
        return;
      }
    }

    if (controls.BACK || (changingNote && controls.ACCEPT))
    {
      if (!changingNote)
      {
        close();
      }
      else
      {
        changeSelection();
      }
      changingNote = false;
      FlxG.sound.play(Paths.sound('cancelMenu'));
    }

    if (nextAccept > 0)
    {
      nextAccept -= 1;
    }

    super.update(elapsed);
  }

  function changeSelection(change:Int = 0)
  {
    curSelected += change;

    if (curSelected < 0) curSelected = ClientPrefs.arrowHSV.length - 1;
    if (curSelected >= ClientPrefs.arrowHSV.length) curSelected = 0;

    curValue = ClientPrefs.arrowHSV[curSelected][typeSelected];
    updateValue();

    for (i in 0...grpNumbers.length)
    {
      var item = grpNumbers.members[i];
      item.alpha = 0.6;

      if ((curSelected * 3) + typeSelected == i)
      {
        item.alpha = 1;
      }
    }

    for (i in 0...grpNotes.length)
    {
      var item = grpNotes.members[i];
      item.alpha = 0.6;
      item.scale.set(1, 1);

      if (curSelected == i)
      {
        item.alpha = 1;
        item.scale.set(1.5, 1.5);
        hsbText.y = item.y - 70;
        blackBG.y = item.y - 20;
      }
    }

    FlxG.sound.play(Paths.sound('scrollMenu'));
  }

  function changeType(change:Int = 0)
  {
    typeSelected += change;

    if (typeSelected < 0) typeSelected = 2;
    if (typeSelected > 2) typeSelected = 0;

    curValue = ClientPrefs.arrowHSV[curSelected][typeSelected];
    updateValue();

    for (i in 0...grpNumbers.length)
    {
      var item = grpNumbers.members[i];
      item.alpha = 0.6;

      if ((curSelected * 3) + typeSelected == i)
      {
        item.alpha = 1;
      }
    }
  }

  function resetValue(selected:Int, type:Int)
  {
    curValue = 0;

    ClientPrefs.arrowHSV[selected][type] = 0;

    switch (type)
    {
      case 0:
        shaderArray[selected].hue = 0;
      case 1:
        shaderArray[selected].saturation = 0;
      case 2:
        shaderArray[selected].brightness = 0;
    }

    var item = grpNumbers.members[(selected * 3) + type];
    item.text = '0';

    var add = (40 * (item.letters.length - 1)) / 2;
    for (letter in item.letters)
    {
      letter.offset.x += add;
    }
  }

  function updateValue(change:Float = 0)
  {
    curValue += change;
    var roundedValue:Int = Math.round(curValue);
    var max:Float = 180;

    switch (typeSelected)
    {
      case 1 | 2:
        max = 100;
    }

    if (roundedValue < -max)
    {
      curValue = -max;
    }
    else if (roundedValue > max)
    {
      curValue = max;
    }

    roundedValue = Math.round(curValue);
    ClientPrefs.arrowHSV[curSelected][typeSelected] = roundedValue;

    switch (typeSelected)
    {
      case 0:
        shaderArray[curSelected].hue = roundedValue / 360;
      case 1:
        shaderArray[curSelected].saturation = roundedValue / 100;
      case 2:
        shaderArray[curSelected].brightness = roundedValue / 100;
    }

    var item = grpNumbers.members[(curSelected * 3) + typeSelected];
    item.text = Std.string(roundedValue);

    var add = (40 * (item.letters.length - 1)) / 2;
    for (letter in item.letters)
    {
      letter.offset.x += add;
      if (roundedValue < 0) letter.offset.x += 10;
    }
  }
}