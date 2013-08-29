package com.furusystems.games.flywheel.utils.time;
import flash.Lib;

/**
 * ...
 * @author Andreas Rønning
 */
class StopWatch
{
	public var tickTime:Int;
	public function new() 
	{
		tickTime = 0;
	}
	public function tick():Void {
		tickTime = Lib.getTimer();
	}
	public function tock():Int {
		return Lib.getTimer() - tickTime;
	}
	
	public static var staticTickTime:Int;
	public static function staticTick():Void {
		staticTickTime = Lib.getTimer();
	}
	public static function staticTock():Int {
		return Lib.getTimer() - staticTickTime;
	}
}