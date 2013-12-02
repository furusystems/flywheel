package com.furusystems.flywheel.utils.math;

/**
 * ...
 * @author Andreas Rønning
 */
class Verlet
{
	public var value:Float;
	var prev:Float;
	public function new() 
	{
		value = prev = 0;
	}
	public inline function set(newVal:Float):Verlet {
		value = prev = newVal;
		return this;
	}
	
	static var temp:Float = 0;
	public inline function update():Verlet {
		temp = value;
		value += value - prev;
        prev = temp;
		return this;
	}
	
}