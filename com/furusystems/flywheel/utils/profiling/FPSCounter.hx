package com.furusystems.flywheel.utils.profiling;
import flash.Lib;

/**
 * ...
 * @author Andreas Rønning
 */

class FPSCounter 
{
	private static var timer:Int = 0;
	private static var ms_prev:Int = 0;
	private static var _fps:Int = 0;
	public static var fps:Int = 0;
	public static var ms:Int = 0;
	public static var peak_ms:Int = 0;
	
	private static var _ms:Int = 0;
	public static function update():Int {
		timer = Lib.getTimer();
		//after a second has passed 
		if ( timer - 1000 > ms_prev ) {	
			fps = _fps;
			_fps = 0;
			ms_prev = timer;
			return fps;
		}
		//increment number of frames which have occurred in current second
		_fps++;

		ms = (timer - _ms);
		if (ms > peak_ms) peak_ms = ms;
		_ms = timer;
		return fps;
	}
	
	
}