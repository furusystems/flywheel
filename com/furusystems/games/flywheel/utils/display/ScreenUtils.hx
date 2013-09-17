package com.furusystems.utils.display;
import flash.system.Capabilities;
/**
 * ...
 * @author Andreas Rønning
 */
class ScreenUtils 
{
	public static inline function inchesToPixels(inches:Float):Int {
		return Std.int(Capabilities.screenDPI * inches);
	}
	
}