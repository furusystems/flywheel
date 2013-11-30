package com.furusystems.flywheel.utils.geom;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * ...
 * @author Andreas Rønning
 */
abstract FWPoint(Point) from Point to Point
{

	public inline function new(x:Float = 0, y:Float = 0) 
	{
		this = new Point(x, y);
	}
	
	//COMPARISONS
	
	@:noCompletion @:op(A > B) public static inline function moreThan(a:FWPoint, b:FWPoint):Bool {
		return a.x > b.x && a.y > b.y;
	}
	
	@:noCompletion @:op(A < B) public static inline function lessThan(a:FWPoint, b:FWPoint):Bool {
		return a.x < b.x && a.y < b.y;
	}
	
	@:noCompletion @:op(A >= B) public static inline function moreThanEq(a:FWPoint, b:FWPoint):Bool {
		return a.x >= b.x && a.y >= b.y;
	}
	
	@:noCompletion @:op(A <= B) public static inline function lessThanEq(a:FWPoint, b:FWPoint):Bool {
		return a.x <= b.x && a.y <= b.y;
	}
	
	//MATH
	@:noCompletion @:op(A + B) public static inline function add(a:FWPoint, b:FWPoint):FWPoint {
		var pt:FWPoint = a.clone();
		a.x += b.x;
		a.y += b.y;
		return a;	
	}
	
	@:commutative @:noCompletion @:op(A + B) public static inline function addFloat(a:FWPoint, scalar:Float):FWPoint {
		var pt:FWPoint = a.clone();
		a.x += scalar;
		a.y += scalar;
		return a;	
	}
	
	@:noCompletion @:op(A += B) public static inline function compoundAdd(a:FWPoint, b:FWPoint):FWPoint {
		a.x += b.x;
		a.y += b.y;
		return a;	
	}
	
	@:noCompletion @:op(A += B) public static inline function compoundAddFloat(a:FWPoint, scalar:Float):FWPoint {
		a.x += scalar;
		a.y += scalar;
		return a;	
	}
	
	@:noCompletion @:op(A - B) public static inline function sub(a:FWPoint, b:FWPoint):FWPoint {
		var pt:FWPoint = a.clone();
		a.x -= b.x;
		a.y -= b.y;
		return a;	
	}
	
	@:commutative @:noCompletion @:op(A - B) public static inline function subFloat(a:FWPoint, scalar:Float):FWPoint {
		var pt:FWPoint = a.clone();
		a.x -= scalar;
		a.y -= scalar;
		return a;	
	}
	
	@:noCompletion @:op(A -= B) public static inline function compoundSub(a:FWPoint, b:FWPoint):FWPoint {
		a.x -= b.x;
		a.y -= b.y;
		return a;
	}
	
	@:noCompletion @:op(A -= B) public static inline function compoundSubFloat(a:FWPoint, scalar:Float):FWPoint {
		a.x -= scalar;
		a.y -= scalar;
		return a;
	}
	
	@:noCompletion @:op(A *= B) public static inline function compoundMultFloat(a:FWPoint, scalar:Float):FWPoint {
		a.x *= scalar;
		a.y *= scalar;
		return a;
	}
	@:commutative @:noCompletion @:op(A * B) public static inline function multFloat(a:FWPoint, scalar:Float):FWPoint {
		var pt:FWPoint = a.clone();
		pt.x *= scalar;
		pt.y *= scalar;
		return pt;
	}
	
	@:noCompletion @:op(A * B) public static inline function multPt(a:FWPoint, b:FWPoint):FWPoint {
		var pt:FWPoint = a.clone();
		pt.x *= b.x;
		pt.y *= b.y;
		return pt;
	}
	@:noCompletion @:op(A *= B) public static inline function compoundMultPt(a:FWPoint, b:FWPoint):FWPoint {
		a.x *= b.x;
		a.y *= b.y;
		return a;
	}
	
	@:noCompletion @:op(A /= B) public static inline function compoundDivFloat(a:FWPoint, scalar:Float):FWPoint {
		a.x /= scalar;
		a.y /= scalar;
		return a;
	}
	@:commutative @:noCompletion @:op(A / B) public static inline function divFloat(a:FWPoint, scalar:Float):FWPoint {
		var pt:FWPoint = a.clone();
		pt.x /= scalar;
		pt.y /= scalar;
		return pt;
	}
	
	@:noCompletion @:op(A / B) public static inline function divPt(a:FWPoint, b:FWPoint):FWPoint {
		var pt:FWPoint = a.clone();
		pt.x /= b.x;
		pt.y /= b.y;
		return pt;
	}
	@:noCompletion @:op(A /= B) public static inline function compoundDivPt(a:FWPoint, b:FWPoint):FWPoint {
		a.x /= b.x;
		a.y /= b.y;
		return a;
	}
	
	public inline function rotateAroundPt(pt:FWPoint, angle:Float):FWPoint {
		var ox:Float = x;
		var oy:Float = y;
		compoundSub(this, pt);
		rotate(angle);
		x += ox;
		y += oy;
		return this;
	}
	
	public inline function reflect(normal:FWPoint):FWPoint {
		return self() - (((self() * 2.0).dot(normal)) / Math.pow(normal.mag(), 2)) * normal;
	}
	public inline function reflectEq(normal:FWPoint):FWPoint {
		this.copyFrom(self() - (((self() * 2.0).dot(normal)) / Math.pow(normal.mag(), 2)) * normal);
		return this;
	}
	
	//Idiotic utility
	inline function self():FWPoint {
		return this;
	}
	
	public inline function rotate(angleRad:Float):FWPoint {
		var sin:Float = Math.sin(angleRad);
		var cos:Float = Math.cos(angleRad);
		var px:Float = x * cos - y * sin; 
		var py:Float = x * sin + y * cos;
		return set(px, py);
	}
	
	public inline function mag():Float {
		return this.length;
	}
	
	public inline function set(x:Float, y:Float):FWPoint {
		this.x = x;
		this.y = y;
		return this;
	}
	
	public inline function rectConstraint(rect:Rectangle):FWPoint {
		this.x = Math.max(rect.x, Math.min(rect.x + rect.width, this.x));
		this.y = Math.max(rect.y, Math.min(rect.y + rect.height, this.y));
		return this;
	}
	
	public inline function withinRect(rect:Rectangle):Bool {
		return rect.containsPoint(this);
	}
	
	public inline function equals(other:FWPoint):Bool {
		return other.x == this.x && other.y == this.y;
	}
	
	public inline function closeTo(other:FWPoint, epsilon:Float = 0.0001):Bool {
		return Math.abs(other.x - x + other.y - y) < epsilon;
	}
	
	public inline function truncate(length:Float):FWPoint {
		if (this.length > length) {
			return normalize(length);
		}else{
			return this;
		}
	}
	
	public inline function clone():FWPoint {
		return new FWPoint(this.x, this.y);
	}
	
	public inline function dot(b:FWPoint):Float {
		return this.x * b.x + this.y * b.y;
	}
	
	public inline function dotNormalized(b:FWPoint):Float {
		var a:FWPoint = clone().normalize();
		var b:FWPoint = b.clone().normalize();
		return a.dot(b);
	}
	
	public inline function normalize(length:Float = 1):FWPoint {
		this.normalize(length);
		return this;
	}
	
	public inline function normalLeft():FWPoint {
		return new FWPoint(this.y, -this.x);
	}
	public inline function normalRight():FWPoint {
		return new FWPoint(-this.y, this.x);
	}
	
	public inline function angleRad():Float {
		return Math.atan2(this.x, this.y);
	}
	
	public var x(get, set):Float;
	public var y(get, set):Float;
	
	inline function get_x():Float {
		return this.x;
	}
	
	inline function set_x(value:Float):Float {
		return this.x = value;
	}
	
	inline function get_y():Float {
		return this.y;
	}
	
	inline function set_y(value:Float):Float {
		return this.y = value;
	}
	
}