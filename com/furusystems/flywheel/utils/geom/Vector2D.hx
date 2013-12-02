package com.furusystems.flywheel.utils.geom;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * ...
 * @author Andreas Rønning
 */
abstract Vector2D(Point) from Point to Point
{

	public inline function new(x:Float = 0, y:Float = 0) 
	{
		this = new Point(x, y);
	}
	
	//COMPARISONS
	
	@:noCompletion @:op(A > B) public static inline function moreThan(a:Vector2D, b:Vector2D):Bool {
		return a.x > b.x && a.y > b.y;
	}
	
	@:noCompletion @:op(A < B) public static inline function lessThan(a:Vector2D, b:Vector2D):Bool {
		return a.x < b.x && a.y < b.y;
	}
	
	@:noCompletion @:op(A >= B) public static inline function moreThanEq(a:Vector2D, b:Vector2D):Bool {
		return a.x >= b.x && a.y >= b.y;
	}
	
	@:noCompletion @:op(A <= B) public static inline function lessThanEq(a:Vector2D, b:Vector2D):Bool {
		return a.x <= b.x && a.y <= b.y;
	}
	
	//MATH
	@:noCompletion @:op(A + B) public static inline function add(a:Vector2D, b:Vector2D):Vector2D {
		var pt:Vector2D = a.clone();
		pt.x += b.x;
		pt.y += b.y;
		return pt;	
	}
	
	@:commutative @:noCompletion @:op(A + B) public static inline function addFloat(a:Vector2D, scalar:Float):Vector2D {
		var pt:Vector2D = a.clone();
		pt.x += scalar;
		pt.y += scalar;
		return pt;	
	}
	
	@:noCompletion @:op(A += B) public static inline function compoundAdd(a:Vector2D, b:Vector2D):Vector2D {
		a.x += b.x;
		a.y += b.y;
		return a;	
	}
	
	@:noCompletion @:op(A += B) public static inline function compoundAddFloat(a:Vector2D, scalar:Float):Vector2D {
		a.x += scalar;
		a.y += scalar;
		return a;	
	}
	
	@:noCompletion @:op(A - B) public static inline function sub(a:Vector2D, b:Vector2D):Vector2D {
		var pt:Vector2D = a.clone();
		pt.x -= b.x;
		pt.y -= b.y;
		return pt;	
	}
	
	@:commutative @:noCompletion @:op(A - B) public static inline function subFloat(a:Vector2D, scalar:Float):Vector2D {
		var pt:Vector2D = a.clone();
		pt.x -= scalar;
		pt.y -= scalar;
		return pt;	
	}
	
	@:noCompletion @:op(A -= B) public static inline function compoundSub(a:Vector2D, b:Vector2D):Vector2D {
		a.x -= b.x;
		a.y -= b.y;
		return a;
	}
	
	@:noCompletion @:op(A -= B) public static inline function compoundSubFloat(a:Vector2D, scalar:Float):Vector2D {
		a.x -= scalar;
		a.y -= scalar;
		return a;
	}
	
	@:noCompletion @:op(A *= B) public static inline function compoundMultFloat(a:Vector2D, scalar:Float):Vector2D {
		a.x *= scalar;
		a.y *= scalar;
		return a;
	}
	@:commutative @:noCompletion @:op(A * B) public static inline function multFloat(a:Vector2D, scalar:Float):Vector2D {
		var pt:Vector2D = a.clone();
		pt.x *= scalar;
		pt.y *= scalar;
		return pt;
	}
	
	@:noCompletion @:op(A * B) public static inline function multPt(a:Vector2D, b:Vector2D):Vector2D {
		var pt:Vector2D = a.clone();
		pt.x *= b.x;
		pt.y *= b.y;
		return pt;
	}
	@:noCompletion @:op(A *= B) public static inline function compoundMultPt(a:Vector2D, b:Vector2D):Vector2D {
		a.x *= b.x;
		a.y *= b.y;
		return a;
	}
	
	@:noCompletion @:op(A /= B) public static inline function compoundDivFloat(a:Vector2D, scalar:Float):Vector2D {
		a.x /= scalar;
		a.y /= scalar;
		return a;
	}
	@:commutative @:noCompletion @:op(A / B) public static inline function divFloat(a:Vector2D, scalar:Float):Vector2D {
		var pt:Vector2D = a.clone();
		pt.x /= scalar;
		pt.y /= scalar;
		return pt;
	}
	
	@:noCompletion @:op(A / B) public static inline function divPt(a:Vector2D, b:Vector2D):Vector2D {
		var pt:Vector2D = a.clone();
		pt.x /= b.x;
		pt.y /= b.y;
		return pt;
	}
	@:noCompletion @:op(A /= B) public static inline function compoundDivPt(a:Vector2D, b:Vector2D):Vector2D {
		a.x /= b.x;
		a.y /= b.y;
		return a;
	}
	
	public static inline function distance(a:Vector2D, b:Vector2D):Float {
		return Math.sqrt(distanceSqr(a, b));
	}
	
	public static inline function distanceSqr(a:Vector2D, b:Vector2D):Float {
		var dx:Float = b.x - a.x;
		var dy:Float = b.y - a.y;
		return dx * dx + dy * dy;
	}
	
	public inline function rotateAroundPt(pt:Vector2D, angle:Float):Vector2D {
		var ox:Float = x;
		var oy:Float = y;
		compoundSub(this, pt);
		rotate(angle);
		x += ox;
		y += oy;
		return this;
	}
	
	public inline function copyFrom(other:Vector2D):Vector2D {
		this.copyFrom(other);
		return this;
	}
	
	public inline function reflect(normal:Vector2D):Vector2D {
		return self() - (((self() * 2.0).dot(normal)) / Math.pow(normal.mag(), 2)) * normal;
	}
	public inline function reflectEq(normal:Vector2D):Vector2D {
		this.copyFrom(self() - (((self() * 2.0).dot(normal)) / Math.pow(normal.mag(), 2)) * normal);
		return this;
	}
	
	//Idiotic utility
	inline function self():Vector2D {
		return this;
	}
	
	public inline function rotate(angleRad:Float):Vector2D {
		var sin:Float = Math.sin(angleRad);
		var cos:Float = Math.cos(angleRad);
		var px:Float = x * cos - y * sin; 
		var py:Float = x * sin + y * cos;
		return set(px, py);
	}
	
	public inline function mag():Float {
		return this.length;
	}
	
	public inline function set(x:Float, y:Float):Vector2D {
		this.x = x;
		this.y = y;
		return this;
	}
	
	public inline function rectConstraint(rect:Rectangle):Vector2D {
		this.x = Math.max(rect.x, Math.min(rect.x + rect.width, this.x));
		this.y = Math.max(rect.y, Math.min(rect.y + rect.height, this.y));
		return this;
	}
	
	public inline function withinRect(rect:Rectangle):Bool {
		return rect.containsPoint(this);
	}
	
	public inline function equals(other:Vector2D):Bool {
		return other.x == this.x && other.y == this.y;
	}
	
	public inline function closeTo(other:Vector2D, epsilon:Float = 0.0001):Bool {
		return Math.abs(other.x - x + other.y - y) < epsilon;
	}
	
	public inline function truncate(length:Float):Vector2D {
		if (this.length > length) {
			return normalize(length);
		}else{
			return this;
		}
	}
	
	public inline function clone():Vector2D {
		return new Vector2D(this.x, this.y);
	}
	
	public inline function dot(b:Vector2D):Float {
		return this.x * b.x + this.y * b.y;
	}
	
	public inline function dotNormalized(b:Vector2D):Float {
		var a:Vector2D = clone().normalize();
		var b:Vector2D = b.clone().normalize();
		return a.dot(b);
	}
	
	public inline function normalize(length:Float = 1):Vector2D {
		this.normalize(length);
		return this;
	}
	
	public inline function normalLeft():Vector2D {
		return new Vector2D(this.y, -this.x);
	}
	public inline function normalRight():Vector2D {
		return new Vector2D(-this.y, this.x);
	}
	
	public inline function angleRad():Float {
		return Math.atan2(this.x, this.y);
	}
	
	public inline function angleTo(other:Vector2D):Float {
		var dx:Float = other.x - this.x;
		var dy:Float = other.y - this.y;
		return Math.atan2(dy, dx);
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