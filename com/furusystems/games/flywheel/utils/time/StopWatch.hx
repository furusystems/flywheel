package com.furusystems.games.flywheel.utils.time;
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
	public function tock():Int {
		return Timer.stamp() - tickTime;
	}
	
	public static var staticTickTime:Int;
	public static function staticTick():Void {
		staticTickTime = Timer.stamp();
	}
	public static function staticTock():Int {
		return  Timer.stamp() - staticTickTime;
	}
}