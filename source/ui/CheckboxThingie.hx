package ui;

import backend.ClientPrefs;
import flixel.FlxSprite;

class CheckboxThingie extends FlxSprite
{
  public var sprTracker:FlxSprite;
  public var daValue(default, set):Bool;
  public var copyAlpha:Bool = true;
  public var offsetX:Float = 0;
  public var offsetY:Float = 0;

  public function new(x:Float = 0, y:Float = 0, ?checked = false)
  {
    super(x, y);

    frames = Paths.getSparrowAtlas('options/checkboxanim');
    animation.addByPrefix("unchecked", "unselected0", 24, false);
    animation.addByPrefix("unchecking", "deselect0", 24, false);
    animation.addByPrefix("checking", "select0", 24, false);
    animation.addByPrefix("checked", "static checked0", 24, false);

    antialiasing = ClientPrefs.globalAntialiasing;
    setGraphicSize(Std.int(0.9 * width));
    updateHitbox();

    animationFinished(checked ? 'checking' : 'unchecking');
    animation.onFinish.add(animationFinished);
    daValue = checked;
  }

  override function update(elapsed:Float)
  {
    if (sprTracker != null)
    {
      setPosition(sprTracker.x - 130 + offsetX, sprTracker.y + 30 + offsetY);

      if (copyAlpha)
      {
        alpha = sprTracker.alpha;
      }
    }

    super.update(elapsed);
  }

  public function set_daValue(check:Bool):Bool
  {
    if (check)
    {
      if (animation.curAnim.name != 'checked' && animation.curAnim.name != 'checking')
      {
        animation.play('checking', true);
      }
    }
    else if (animation.curAnim.name != 'unchecked' && animation.curAnim.name != 'unchecking')
    {
      animation.play("unchecking", true);
    }

    return check;
  }

  public function animationFinished(name:String)
  {
    switch (name)
    {
      case 'checking':
        animation.play('checked', true);
      case 'unchecking':
        animation.play('unchecked', true);
    }
  }
}