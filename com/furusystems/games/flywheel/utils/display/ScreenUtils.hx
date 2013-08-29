package com.furusystems.utils.deviceutils;
import nme.system.Capabilities;
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