package util;

import haxe.Unserializer;
import haxe.Serializer;
import flixel.FlxG;
import haxe.Json;
import haxe.io.Bytes;
import thx.semver.Version;

/**
 * @param key The key pressed.
 * @param duration The duration of the key press.
 * @param time The keypress's starting timestamp.
 */
typedef ScoreInput =
{
  var key:Int;
  var duration:Int;
  var time:Int;
}

/**
 * Functions dedicated to serializing and deserializing data.
 * NOTE: Use `json2object` wherever possible, it's way more efficient.
 */
class SerializerUtil
{
  static final INDENT_CHAR = "\t";

  /**
   * Convert a Haxe object to a JSON string.
   * NOTE: Use `json2object.JsonWriter<T>` WHEREVER POSSIBLE. Do not use this one unless you ABSOLUTELY HAVE TO it's SLOW!
   * And don't even THINK about using `haxe.Json.stringify` without the replacer!
   */
  public static function toJSON(input:Dynamic, pretty:Bool = true):String
  {
    return Json.stringify(input, replacer, pretty ? INDENT_CHAR : null);
  }

  /**
   * Convert a JSON string to a Haxe object.
   */
  public static function fromJSON(input:String):Dynamic
  {
    try
    {
      return Json.parse(input);
    }
    catch (error)
    {
      #if DEVELOPERBUILD
      trace('An error occurred while parsing JSON from string data.');
      trace(error);
      #end

      return null;
    }
  }

  /**
   * Convert a JSON byte array to a Haxe object.
   */
  public static function fromJSONBytes(input:Bytes):Dynamic
  {
    try
    {
      return Json.parse(input.toString());
    }
    catch (error:Dynamic)
    {
      #if DEVELOPERBUILD
      trace('An error occurred while parsing JSON from byte data.');
      trace(error);
      #end

      return null;
    }
  }

  public static function initSerializer():Void
  {
    Unserializer.DEFAULT_RESOLVER = new FunkinTypeResolver();
  }

  /**
   * Serialize a Haxe object using the built-in Serializer.
   * @param input The object to serialize
   * @return The serialized object as a string
   */
  public static function fromHaxeObject(input:Dynamic):String
  {
    return Serializer.run(input);
  }

  /**
   * Convert a serialized Haxe object back into a Haxe object.
   * @param input The serialized object as a string
   * @return The deserialized object
   */
  public static function toHaxeObject(input:String):Dynamic
  {
    return Unserializer.run(input);
  }

  /**
   * Customize how certain types are serialized when converting to JSON.
   */
  static function replacer(key:String, value:Dynamic):Dynamic
  {
    // Hacky because you can't use `isOfType` on a struct.
    if (key == "version")
    {
      if (Std.isOfType(value, String))
      {
        return value;
      }

      // Stringify Version objects.
      return serializeVersion(cast value);
    }

    // Else, return the value as-is.
    return value;
  }

  static inline function serializeVersion(value:Version):String
  {
    var result = '${value.major}.${value.minor}.${value.patch}';

    if (value.hasPre)
    {
      result += '-${value.pre}';
    }

    if (value.build.length > 0)
    {
      result += '+${value.build}';
    }

    return result;
  }
}

class FunkinTypeResolver
{
  public function new()
  {
    // Blank constructor.
  }

  public function resolveClass(name:String):Class<Dynamic>
  {
    if (name.toLowerCase() == 'dynamic')
    {
      #if DEVELOPERBUILD
      FlxG.log.warn('Found invalid class type in save data, indicates partial save corruption.');
      #end

      return null;
    }

    return Type.resolveClass(name);
  };

  public function resolveEnum(name:String):Enum<Dynamic>
  {
    return Type.resolveEnum(name);
  };
}