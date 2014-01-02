package com.furusystems.flywheel.geom;
import haxe.ds.Vector;
/**
 * Affine 2D transform
 * @author Andreas Rønning
 */

private class M33Fields {
	public var a:Float;
	public var b:Float;
	public var c:Float;
	public var d:Float;
	public var tx:Float;
	public var ty:Float;
	public inline function new() {
		
	}
}
 
abstract Matrix33(M33Fields) from M33Fields to M33Fields
{

	public inline function new() 
	{
		this = new M33Fields();
		identity();
	}
	
	public var a(get, set):Float;
	@:noCompletion inline function get_a():Float {
		return this.a;
	}
	@:noCompletion inline function set_a(f:Float):Float {
		return this.a = f;
	}
	
	public var b(get, set):Float;
	@:noCompletion inline function get_b():Float {
		return this.b;
	}
	@:noCompletion inline function set_b(f:Float):Float {
		return this.b = f;
	}
	
	public var c(get, set):Float;
	@:noCompletion inline function get_c():Float {
		return this.c;
	}
	@:noCompletion inline function set_c(f:Float):Float {
		return this.c = f;
	}
	
	public var d(get, set):Float;
	@:noCompletion inline function get_d():Float {
		return this.d;
	}
	@:noCompletion inline function set_d(f:Float):Float {
		return this.d = f;
	}
	
	public var tx(get, set):Float;
	@:noCompletion inline function get_tx():Float {
		return this.tx;
	}
	@:noCompletion inline function set_tx(f:Float):Float {
		return this.tx = f;
	}
	
	public var ty(get, set):Float;
	@:noCompletion inline function get_ty():Float {
		return this.ty;
	}
	@:noCompletion inline function set_ty(f:Float):Float {
		return this.ty = f;
	}
	
	
	public inline function identity():Matrix33 {
		a = 1; b = 0; tx = 0; 
		c = 0; d = 1; ty = 0; 
		return this;
	}
	
	public inline function transformVectorInPlace(inPos:Vector2D):Vector2D {
		var x:Float = inPos.x * a + inPos.y * b + tx;
		var y:Float = inPos.x * c + inPos.y * d + ty;
		inPos.x = x;
		inPos.y = y;
		return inPos;
	}
	public inline function transformVector(inPos:Vector2D):Vector2D {
		return transformVectorInPlace(inPos.clone());
	}
	
	public inline function clone():Matrix33 {
		var m:Matrix33 = new Matrix33();
		m.copyFrom(this);
		return m;
	}
	
	public inline function translate(x:Float, y:Float):Matrix33 {
		tx += x;
		ty += y;
		return this;
	}
	public inline function rotate(t:Float):Matrix33 {
		a *= Math.cos(t); b *= -Math.sin(t);
		c *= Math.sin(t); d *= Math.cos(t);
		return this;
	}
	public inline function scale(x:Float, y:Float):Matrix33 {
		a *= x;
		d *= y;
		return this;
	}
	public inline function skew(x:Float, y:Float):Matrix33 {
		b *= Math.tan(x);
		c *= Math.tan(y);
		return this;
	}
	
	public inline function copyFrom(m:Matrix33):Matrix33 {
		a = m.a;
		b = m.b;
		c = m.c;
		d = m.d;
		tx = m.tx;
		ty = m.ty;
		
		return this;
	}
	
	@:noCompletion @:op(A *= B) public static inline function compoundMult(m1:Matrix33, m2:Matrix33):Matrix33 {
		var a1 = m1.a * m2.a + m1.b * m2.c;
		m1.b = m1.a * m2.b + m1.b * m2.d;
		m1.a = a1;
		
		var c1 = m1.c * m2.a + m1.d * m2.c;
		m1.d = m1.c * m2.b + m1.d * m2.d;
		
		m1.c = c1;
		
		var tx1 = m1.tx * m2.a + m1.ty * m2.c + m2.tx;
		m1.ty = m1.tx * m2.b + m1.ty * m2.d + m2.ty;
		m1.tx = tx1;
		
		return m1;
	}
	@:op(A * B) public static inline function mult(a:Matrix33, b:Matrix33):Matrix33 {
		var c = a.clone();
		return c *= b;
	}
	
	@:noCompletion @:op(A -= B) public static inline function compoundSub(a:Matrix33, b:Matrix33):Matrix33 {
		a.a -= b.a;
		a.b -= b.b;
		a.c -= b.c;
		a.d -= b.d;
		a.tx -= b.tx;
		a.ty -= b.ty;
		return a;	
	}
	@:op(A - B) public static inline function sub(a:Matrix33, b:Matrix33):Matrix33 {
		var out = a.clone();
		return out -= b;	
	}
	
	@:noCompletion @:op(A += B) public static inline function compoundAdd(a:Matrix33, b:Matrix33):Matrix33 {
		a.a += b.a;
		a.b += b.b;
		a.c += b.c;
		a.d += b.d;
		a.tx += b.tx;
		a.ty += b.ty;
		return a;	
	}
	@:op(A + B) public static inline function add(a:Matrix33, b:Matrix33):Matrix33 {
		var out = a.clone();
		return out += b;	
	}
	
	public inline function toString():String {
		return "Matrix33(" + this + ")";
	}
	
}