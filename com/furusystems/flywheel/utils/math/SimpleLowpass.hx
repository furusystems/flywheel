package com.furusystems.flywheel.utils.math;

/**
 * @author Andreas Rønning
 */

class SimpleLowpass 
{
	public var value:Float;
	public var cutoff:Float;
	public var targetValue:Float;
	public function new(init:Float = 0, cutoff:Float = 0.98) 
	{
		value = targetValue = init;	
		this.cutoff = cutoff;
	}
	public function add(newValue:Float):Void {
		targetValue = newValue;
		update();
	}
	public inline function update():Void {
		value = (targetValue-value) * cutoff;
	}
	
}