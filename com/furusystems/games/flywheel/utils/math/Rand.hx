package com.furusystems.utils;
import nme.errors.Error;
class Rand 
{
	private static var _seed:Int = 123;
	
	public static function fromSeed(seed:Int):Float
	{
		return ((seed * 16807) % 2147483647) / 2147483647;
	}
	
	public static function getFloat(range:Float):Float
	{
		return range * getValue();
	}
	
	public static function getFloatRange(min:Float, max:Float):Float
	{
		return min + (max - min) * getValue();
	}
	
	public static function getInt(range:Int):Int
	{
		return range * getValue();
	}
	
	public static function getIntRange(min:Int, max:Int):Int
	{
		if (max > min)
			return min + ((max + 1) - min) * getValue();
		else
			return max + ((min + 1) - max) * getValue();
	}
	
	public static function randomizeSeed():Void
	{
		_seed = 2147483647 * Math.random();
	}
	
	public static function choose(values:Dynamic):Dynamic
	{
		if (values.length > 1)
			return values[int(values.length * value)];
		else
		{
			try {
				return values[0][int(values[0].length * value)];
			} catch (e:Error) {
				throw new Error("Invalid choose type. Provide arguments to choose from or an array of values.");
			}
		}
	}
	
	public static inline function chance(percent:Float):Bool
	{
		return getValue() < percent;
	}
	
	public static inline function getSeed():Int
	{
		return _seed;
	}
	public static inline function setSeed(value:Int):Void
	{
		_seed = Math.max(getValue(), 1);
	}
	
	public static inline function getValue():Float
	{
		_seed = (_seed * 16807) % 2147483647;
		return _seed / 2147483647;
	}
	
	public static inline function getAngle():Float
	{
		return 360 * getValue();
	}
	public static inline function getRadian():Float
	{
		return Math.PI * 2 * getValue();
	}
	
	public static inline function getBool():Bool
	{
		return getValue() < 0.5;
	}
	
	public static inline function getColor():Int
	{
		return 0xFFFFFF * getValue();
	}
}