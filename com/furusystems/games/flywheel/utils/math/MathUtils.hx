package com.furusystems.utils;
import com.furusystems.games.gameobject.GameTransform;
import com.furusystems.utils.FastSine;
import de.polygonal.core.math.Mathematics;
import nme.geom.Point;

/**
 * ...
 * @author Andreas Rønning
 */

class MathUtils
{
	public static inline var degreesToRadians:Float = 0.01745329251994329576923690768489;
	public static inline var halfPi:Float = 1.5707963267948966192313216916398;
	public static inline var quarterPi:Float = 0.78539816339744830961566084581988;
	
	public static inline function randomRange(a:Float, b:Float):Float
	{
		return a + (Math.random() * (b - a));
	}
	
	public static inline function randomSpread(base:Float, plusOrMinus:Float):Float
	{
		return base - plusOrMinus + (Math.random() * (plusOrMinus * 2));
	}
	
	public static inline function randomInt(min:Int, max:Int):Int
	{
		return min + Math.round(Math.random() * (max - min));
	}
	
	public static inline function clamp(a:Float, min:Float, max:Float):Float
	{
		if (a < min){
			return min;
		}else if (a > max) {
			return max;
		}else {
			return a;
		}
	}
	
	public static inline function manhattanDistance(x1:Float,x2:Float,y1:Float,y2:Float):Float {
		var diffX:Float = x2 - x1;
		var diffY:Float = y2 - y1;
		return diffX * diffX + diffY * diffY;
	}
	
	public static inline function getVelocitiesTowardTarget(startX:Float, startY:Float, targetX:Float, targetY:Float, shotPower:Float):Point
	{
		var v:Point = new Point();
		var dx:Float = targetX - startX;
		var dy:Float = targetY - startY;
		
		#if (cpp || flash)
		var angle:Float = Math.atan2(dy, dx);
		#else
		var angle:Float = Math.atan2(dx, dy);
		#end
		var angles:Point = FastSine.low(angle);
		
		v.x = angles.x * shotPower;
		v.y = angles.y * shotPower;
		return v;
	}
	
	public static inline function getVelocitiesFromAngle(angle:Float, shotPower:Float):Point
	{
		var v:Point = new Point();
		var angles:Point = FastSine.low(angle);
		v.x = angles.x * shotPower;
		v.y = angles.y * shotPower;
		return v;
	}
	
	public static inline function getDistanceBetweenPoints(startX:Float, startY:Float, endX:Float, endY:Float):Float
	{
		var dx:Float = endX - startX;
		var dy:Float = endY - startY;
		return Math.sqrt((dx * dx) + (dy * dy));
	}
	
	static public inline function getAngleTowardsTarget(x1:Float,y1:Float,x2:Float,y2:Float):Float 
	{
		#if (cpp || flash)
		return Math.atan2(y2-y1, x2-x1);
		#else
		return Math.atan2(y2-y1, x2-x1);
		#end
	}
	public static inline function rotatePoint(pt:Point, center:Point, angle:Float):Void {
		var oldx:Float = pt.x;
		var oldy:Float = pt.y;
		var sin:Float = Math.sin(angle);
		var cos:Float = Math.cos(angle);
		pt.y = cos * (oldy - center.y) + sin * (oldx - center.x) + center.y;
		pt.x = cos * (oldx - center.x) - sin * (oldy - center.y) + center.x;
	}
	public static inline function projectVector(a:Point, b:Point, normalized:Bool = false, inPlace:Bool = false):Point {
		var proj:Point;
		
		if (inPlace) proj = a;
		else proj = new Point();
		
		var dp:Float = dotProduct(a, b);
		if(!normalized){
			proj.x = ( dp / (b.x * b.x + b.y * b.y) ) * b.x;
			proj.y = ( dp / (b.x * b.x + b.y * b.y) ) * b.y;
		}else {
			proj.x = dp * b.x;
			proj.y = dp * b.y;
		}
		return proj;
	}
	
	public static inline function vectorSubtractInPlace(a:Point, b:Point):Point {
		a.x -= b.x;
		a.y -= b.y;
		return a;
	}
	public static inline function vectorAddInPlace(a:Point, b:Point):Point {
		a.x += b.x;
		a.y += b.y;
		return a;
	}
	
	public static inline function vectorSubtract(a:Point, b:Point):Point {
		return new Point(b.x - a.x, b.y - a.y);
	}
	public static inline function vectorAdd(a:Point, b:Point):Point {
		return new Point(a.x + b.x, a.y + b.y);
	}
	
	public static inline function rangesOverlap(amin:Float, amax:Float, bmin:Float, bmax:Float):Bool {
		return !(amin > bmax || bmin > amax);
	}
	
	public static inline function mag(a:Point):Float {
		return Math.sqrt(a.x * a.x + a.y * a.y);
	}
	public static inline function normalize(a:Point, inPlace:Bool = false):Point {
		var len:Float = mag(a);
		if (inPlace) {
			a.x /= len;
			a.y /= len;
			return a;
		}else {
			return new Point(a.x / len, a.y / len);
		}
	}
	public static inline function toLeftNormal(a:Point):Point {
		var temp:Float = a.x;
		a.x = a.y;
		a.y = -temp;
		return a;
	}
	public static inline function toRightNormal(a:Point):Point {
		
		var temp:Float = a.x;
		a.x = -a.y;
		a.y = temp;
		return a;
	}
	public static inline function leftNormal(a:Point):Point {
		return new Point( a.y, -a.x);
	}
	public static inline function rightNormal(a:Point):Point {
		return new Point( -a.y, a.x);
	}
	public static inline function dotProduct(a:Point, b:Point):Float {
		return a.x*b.x + a.y*b.y;
	}
	
}