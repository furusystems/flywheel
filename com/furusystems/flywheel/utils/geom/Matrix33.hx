package com.furusystems.flywheel.utils.geom;
import haxe.ds.Vector;
/**
 * Affine 2D transform
 * @author Andreas Rønning
 */
abstract Matrix33(Vector<Float>) from Vector<Float> to Vector<Float>
{

	public inline function new() 
	{
		this = new Vector<Float>(9);
		identity();
	}
	
	public var m11(get, set):Float;
	@:noCompletion inline function get_m11():Float {
		return this[0];
	}
	@:noCompletion inline function set_m11(f:Float):Float {
		return this[0] = f;
	}
	
	public var m12(get, set):Float;
	@:noCompletion inline function get_m12():Float {
		return this[1];
	}
	@:noCompletion inline function set_m12(f:Float):Float {
		return this[1] = f;
	}
	
	public var m13(get, set):Float;
	@:noCompletion inline function get_m13():Float {
		return this[2];
	}
	@:noCompletion inline function set_m13(f:Float):Float {
		return this[2] = f;
	}
	
	public var m21(get, set):Float;
	@:noCompletion inline function get_m21():Float {
		return this[3];
	}
	@:noCompletion inline function set_m21(f:Float):Float {
		return this[3] = f;
	}
	
	public var m22(get, set):Float;
	@:noCompletion inline function get_m22():Float {
		return this[4];
	}
	@:noCompletion inline function set_m22(f:Float):Float {
		return this[4] = f;
	}
	
	public var m23(get, set):Float;
	@:noCompletion inline function get_m23():Float {
		return this[5];
	}
	@:noCompletion inline function set_m23(f:Float):Float {
		return this[5] = f;
	}
	
	public var m31(get, set):Float;
	@:noCompletion inline function get_m31():Float {
		return this[6];
	}
	@:noCompletion inline function set_m31(f:Float):Float {
		return this[6] = f;
	}
	
	public var m32(get, set):Float;
	@:noCompletion inline function get_m32():Float {
		return this[7];
	}
	@:noCompletion inline function set_m32(f:Float):Float {
		return this[7] = f;
	}
	
	public var m33(get, set):Float;
	@:noCompletion inline function get_m33():Float {
		return this[8];
	}
	@:noCompletion inline function set_m33(f:Float):Float {
		return this[8] = f;
	}
	
	public inline function identity():Matrix33 {
		m11 = 1; m12 = 0; m13 = 0; 
		m21 = 0; m22 = 1; m23 = 0; 
		m31 = 0; m32 = 0; m33 = 1; 
		return this;
	}
	
	public var length(get, never):Int;
	@:noCompletion inline function get_length():Int {
		return this.length;
	}
	
	public inline function transformVectorInPlace(inPos:Vector2D):Vector2D {
		var x:Float = inPos.x * m11 + inPos.y * m12 + m13;
		var y:Float = inPos.x * m21 + inPos.y * m22 + m23;
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
		m13 += x;
		m23 += y;
		return this;
	}
	public inline function rotate(t:Float):Matrix33 {
		m11 *= Math.cos(t); m12 *= -Math.sin(t);
		m21 *= Math.sin(t); m22 *= Math.cos(t);
		return this;
	}
	public inline function scale(x:Float, y:Float):Matrix33 {
		m11 *= x;
		m22 *= y;
		return this;
	}
	public inline function skew(x:Float, y:Float):Matrix33 {
		m12 *= Math.tan(x);
		m21 *= Math.tan(y);
		return this;
	}
	
	public inline function copyFrom(m:Matrix33):Matrix33 {
		for (i in 0...m.length) {
			this[i] = m[i];
		}
		return this;
	}
	
	public inline function copyRowFrom(other:Matrix33, row:Int):Matrix33 {
		var start:Int = row * 3;
		var end:Int = start + 3;
		for (i in start...end) {
			this[i] = other[i];
		}
		return this;
	}
	public inline function copyColumnFrom(other:Matrix33, column:Int):Matrix33 {
		var idx:Int = column * 3-1;
		while(idx>0){
			this[idx] = other[idx];
			idx -= 3;
		}
		return this;
	}
	public inline function transpose():Matrix33 {
		var temp = clone();
		m11 = temp.m11;
		m21 = temp.m12;
		m31 = temp.m13;
		
		m12 = temp.m21;
		m22 = temp.m22;
		m32 = temp.m23;
		
		m13 = temp.m31;
		m23 = temp.m32;
		m33 = temp.m33;
		return this;
	}
	
	@:noCompletion @:op(A *= B) public static inline function compoundMult(a:Matrix33, b:Matrix33):Matrix33 {
		var m = a * b;
		return a.copyFrom(m);
	}
	@:noCompletion @:op(A * B) public static inline function mult(a:Matrix33, b:Matrix33):Matrix33 {
		var c = a.clone();
		c.m11 = a.m11 * b.m11 + a.m12 * b.m21 + a.m13 * a.m31;		c.m12 = a.m11 * b.m12 + a.m12 * b.m22 + a.m13 * a.m32;		c.m13 = a.m11 * b.m13 + a.m12 * b.m23 + a.m13 * a.m33;
		c.m21 = a.m21 * b.m11 + a.m22 * b.m21 + a.m23 * a.m31;		c.m22 = a.m21 * b.m12 + a.m22 * b.m22 + a.m23 * a.m32;		c.m23 = a.m21 * b.m13 + a.m22 * b.m23 + a.m23 * a.m33;
		c.m31 = a.m31 * b.m11 + a.m32 * b.m21 + a.m33 * a.m31;		c.m32 = a.m31 * b.m12 + a.m32 * b.m22 + a.m33 * a.m32;		c.m33 = a.m31 * b.m13 + a.m32 * b.m23 + a.m33 * a.m33;
		return c;
	}
	
	@:noCompletion @:op(A -= B) public static inline function compoundSub(a:Matrix33, b:Matrix33):Matrix33 {
		for (i in 0...9) {
			a[i] -= b[i];
		}
		return a;	
	}
	@:noCompletion @:op(A - B) public static inline function sub(a:Matrix33, b:Matrix33):Matrix33 {
		var out = a.clone();
		return out -= b;	
	}
	
	@:noCompletion @:op(A += B) public static inline function compoundAdd(a:Matrix33, b:Matrix33):Matrix33 {
		for (i in 0...9) {
			a[i] += b[i];
		}
		return a;	
	}
	@:noCompletion @:op(A + B) public static inline function add(a:Matrix33, b:Matrix33):Matrix33 {
		var out = a.clone();
		return out += b;	
	}
	
	@:noCompletion @:arrayAccess public inline function arrayAccess(key:Int):Float{
        return this[key];
    }
    
    @:noCompletion @:arrayAccess public inline function arrayWrite(key:Int, value:Float):Float {
        this[key] = value;
        return value;
    }
	
	public inline function toString():String {
		return "Matrix33(" + this + ")";
	}
	
}