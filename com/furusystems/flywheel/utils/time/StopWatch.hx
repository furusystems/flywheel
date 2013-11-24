package com.furusystems.flywheel.utils.time;
import haxe.Timer;

/**
 * ...
 * @author Andreas Rønning
 */
class StopWatch
{
	public var tickTime:Float;
	public function new() 
	{
		tickTime = 0;
	}
	public function tick():Void {
		tickTime = Timer.stamp();
	}
	public function tock():Float {
		return Timer.stamp() - tickTime;
	}
	
	public static var staticTickTime:Float;
	public static inline function staticTick():Void {
		staticTickTime = Timer.stamp();
	}
	public static inline function staticTock():Float {
		return Timer.stamp() - staticTickTime;
	}
}