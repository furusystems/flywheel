package com.furusystems.flywheel.utils.data;

/**
 * ...
 * @author Andreas Rønning
 */
class DFieldBufferIdx
{
	public static var frontBuffer:Int = 0;
	public static var backBuffer:Int = 1;
	public static inline function flipBuffers():Void {
		frontBuffer = (frontBuffer + 1) % 2;
		backBuffer = (backBuffer + 1) % 2;
	}
	
}