package com.furusystems.games.flywheel.utils.math;

/**
 * ...
 * @author Andreas Rønning
 */

class RollingAverage 
{

	public var value:Float;
	private var values:Array<Float>;
	private var count:Int;
	private var idx:Int;
	private var n:Int;
	public function new(count:Int = 4) 
	{
		value = 0;
		idx = 0;
		n = 0;
		this.count = count;
		values = new Array<Float>();
		for (i in 0...count) {
			values[i] = 0;
		}
	}
	public function add(v:Float):Float {
		values[idx] = v;
		if (idx >= count) {
			idx = 0;
		}
		if (n < count) {
			n++;
		}
		
		value = 0;
		for (i in 0...n) {
			value += values[i];
		}
		value /= values.length;
		return value;
	}
	public function clear():Void {
		for (i in 0...count) {
			values[i] = 0;
		}
	}
	
}