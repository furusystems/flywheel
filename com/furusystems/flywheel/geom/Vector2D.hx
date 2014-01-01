package com.furusystems.flywheel.geom;
import haxe.ds.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
abstract Vector2D(Vector<Float>) from Vector<Float> to Vector<Float>
{

	public inline function new(x:Float = 0, y:Float = 0) 
	{
		var v = new Vector<Float>(2);
		v[0] = x;
		v[1] = y;
		this = v;
	}
	
	public var x(get, set):Float;
	@:noCompletion inline function get_x():Float {
		return this[0];
	}
	@:noCompletion inline function set_x(f:Float):Float {
		return this[0] = f;
	}
	
	public var y(get, set):Float;
	inline function get_y():Float {
		return this[1];
	}
	inline function set_y(f:Float):Float {
		return this[1] = f;
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
		x = other.x;
		y = other.y;
		return this;
	}
	
	public inline function reflect(normal:Vector2D):Vector2D {
		var f:Vector2D = this;
		return f - (((f * 2.0).dot(normal)) / Math.pow(normal.mag(), 2)) * normal;
	}
	public inline function reflectEq(normal:Vector2D):Vector2D {
		var f:Vector2D = this;
		copyFrom(f - (((f * 2.0).dot(normal)) / Math.pow(normal.mag(), 2)) * normal);
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
		return Math.sqrt(x * x + y * y);
	}
	
	public inline function set(x:Float, y:Float):Vector2D {
		this[0] = x;
		this[1] = y;
		return this;
	}
	
	public inline function rectConstraint(rect:Rectangle):Vector2D {
		x = Math.max(rect.x, Math.min(rect.x + rect.width, x));
		y = Math.max(rect.y, Math.min(rect.y + rect.height, y));
		return this;
	}
	
	public inline function withinRect(rect:Rectangle):Bool {
		return rect.containsPoint(this);
	}
	
	public inline function equals(other:Vector2D):Bool {
		return other.x == x && other.y == y;
	}
	
	public inline function closeTo(other:Vector2D, epsilon:Float = 0.0001):Bool {
		return Math.abs(other.x - x + other.y - y) < epsilon;
	}
	
	public inline function truncate(length:Float):Vector2D {
		if (mag() > length) {
			return normalize(length);
		}else{
			return this;
		}
	}
	
	public inline function cross(other:Vector2D):Float {
		return x * other.y - y * other.x;
	}
	
	public inline function clone():Vector2D {
		return new Vector2D(x, y);
	}
	
	public inline function dot(b:Vector2D):Float {
		return x * b.x + y * b.y;
	}
	
	public inline function dotNormalized(b:Vector2D):Float {
		var a:Vector2D = clone().normalize();
		var b:Vector2D = b.clone().normalize();
		return a.dot(b);
	}
	
	public inline function unit():Vector2D {
		return clone().unitize();
	}
	public inline function unitize():Vector2D {
		return normalize();
	}
	
	public inline function normalize(length:Float = 1):Vector2D {
		var m = 1/mag();
		x *= m * length; 
		y *= m * length;
		return this;
	}
	
	public inline function normalRight():Vector2D {
		return new Vector2D(y, -x);
	}
	public inline function normalLeft():Vector2D {
		return new Vector2D(-y, x);
	}
	
	public inline function angleRad():Float {
		return Math.atan2(x, y);
	}
	
	public inline function angleTo(other:Vector2D):Float {
		var dx:Float = other.x - x;
		var dy:Float = other.y - y;
		return Math.atan2(dy, dx);
	}
	
	public inline function toString():String {
		return 'Vector2D($x,$y)';
	}
}