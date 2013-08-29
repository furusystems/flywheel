package com.furusystems.utils;
import nme.geom.Point;

/**
 * ...
 * @author Andreas Rønning
 */

class FastSine 
{
	public static inline var HALFPI:Float = 1.57079632;
	public static inline var PI:Float = 3.14159265;
	public static inline var PI2:Float = 6.28318531;
	
	private static var result:Point = new Point();
	
	public static inline function wrapAngle(x:Float):Float {
		while(x<-PI){
			x += PI2;
		}
		while(x>PI){
			x -= PI2;
		}
		return x;
	}
	public static inline function high(x:Float):Point {
		x = wrapAngle(x);
		
		//compute sine
		result.y = sin(x);
		//compute cosine: sin(x + PI/2) = cos(x)
		result.x = cos(x);
		return result;
	}
	public static inline function sin(x:Float):Float {
		if (x < 0)
		{
			var sin:Float = 1.27323954 * x + .405284735 * x * x;
			
			if (sin < 0)
				return .225 * (sin *-sin - sin) + sin;
			else
				return .225 * (sin * sin - sin) + sin;
		}
		else
		{
			var sin:Float = 1.27323954 * x - 0.405284735 * x * x;
			
			if (sin < 0)
				return .225 * (sin *-sin - sin) + sin;
			else
				return .225 * (sin * sin - sin) + sin;
		}
	}
	
	public static inline function cos(x:Float):Float {
		x += HALFPI;
		if (x >  PI)
			x -= PI2;

		if (x < 0)
		{
			var cos:Float = 1.27323954 * x + 0.405284735 * x * x;
			
			if (cos < 0)
				return .225 * (cos *-cos - cos) + cos;
			else
				return .225 * (cos * cos - cos) + cos;
		}
		else
		{
			var cos:Float = 1.27323954 * x - 0.405284735 * x * x;

			if (cos < 0)
				return .225 * (cos *-cos - cos) + cos;
			else
				return .225 * (cos * cos - cos) + cos;
		}
	}
	
	
	public static inline function low(x:Float):Point {
		x = wrapAngle(x);
		
		//compute sine
		result.y = low_sin(x);
		//compute cosine: sin(x + PI/2) = cos(x)
		result.x = low_cos(x);
		return result;
	}
	public static inline function low_sin(x:Float):Float {
		if (x < 0)
			return 1.27323954 * x + .405284735 * x * x;
		else
			return 1.27323954 * x - 0.405284735 * x * x;
	}
	public static inline function low_cos(x:Float):Float {
		x += HALFPI;
		if (x >  PI)
			x -= PI2;

		if (x < 0)
			return 1.27323954 * x + 0.405284735 * x * x
		else
			return 1.27323954 * x - 0.405284735 * x * x;
	}
	
}