package shaders;

import flixel.addons.display.FlxRuntimeShader;
import openfl.utils.Assets;

class HSVShader extends FlxRuntimeShader
{
  /**
   * for shader test state, since im too dumb to know how to convert a type name to string
   */
  public var name:String = 'HSVShader';

  public var hue(default, set):Float;
  public var saturation(default, set):Float;
  public var value(default, set):Float;

  public function new()
  {
    super(Assets.getText(Paths.frag('hsv')));
    hue = 1;
    saturation = 1;
    value = 1;
  }

  function set_hue(value:Float):Float
  {
    this.setFloat('_hue', value);
    this.hue = value;

    return this.hue;
  }

  function set_saturation(value:Float):Float
  {
    this.setFloat('_sat', value);
    this.saturation = value;

    return this.saturation;
  }

  function set_value(value:Float):Float
  {
    this.setFloat('_val', value);
    this.value = value;

    return this.value;
  }
}