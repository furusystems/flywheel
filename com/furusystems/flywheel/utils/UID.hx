package com.furusystems.flywheel.utils;

/**
 * ...
 * @author Andreas Rønning
 */
class UID
{
	static var pool:Int = 0;
	public static inline function next():Int {
		return pool++;
	}
	
	static public function bracketPool(i:Int) 
	{
		pool = cast Math.max(i, pool);
	}
	
}