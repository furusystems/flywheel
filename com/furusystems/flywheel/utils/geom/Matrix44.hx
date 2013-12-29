package com.furusystems.flywheel.utils.geom;
import haxe.ds.Vector;
/**
 * Affine 3D transform
 * @author Andreas Rønning
 */
abstract Matrix44(Vector<Float>) from Vector<Float> to Vector<Float>
{

	public inline function new() 
	{
		this = new Vector<Float>(16);
		identity();
	}
	
	public var m11(get, set):Float;
	inline function get_m11():Float {
		return this[0];
	}
	inline function set_m11(f:Float):Float {
		return this[0] = f;
	}
	
	public var m12(get, set):Float;
	inline function get_m12():Float {
		return this[1];
	}
	inline function set_m12(f:Float):Float {
		return this[1] = f;
	}
	
	public var m13(get, set):Float;
	inline function get_m13():Float {
		return this[2];
	}
	inline function set_m13(f:Float):Float {
		return this[2] = f;
	}
	
	public var m14(get, set):Float;
	inline function get_m14():Float {
		return this[3];
	}
	inline function set_m14(f:Float):Float {
		return this[3] = f;
	}
	
	public var m21(get, set):Float;
	inline function get_m21():Float {
		return this[4];
	}
	inline function set_m21(f:Float):Float {
		return this[4] = f;
	}
	
	public var m22(get, set):Float;
	inline function get_m22():Float {
		return this[5];
	}
	inline function set_m22(f:Float):Float {
		return this[5] = f;
	}
	
	public var m23(get, set):Float;
	inline function get_m23():Float {
		return this[6];
	}
	inline function set_m23(f:Float):Float {
		return this[6] = f;
	}
	
	public var m24(get, set):Float;
	inline function get_m24():Float {
		return this[7];
	}
	inline function set_m24(f:Float):Float {
		return this[7] = f;
	}
	
	public var m31(get, set):Float;
	inline function get_m31():Float {
		return this[8];
	}
	inline function set_m31(f:Float):Float {
		return this[8] = f;
	}
	
	public var m32(get, set):Float;
	inline function get_m32():Float {
		return this[9];
	}
	inline function set_m32(f:Float):Float {
		return this[9] = f;
	}
	
	public var m33(get, set):Float;
	inline function get_m33():Float {
		return this[10];
	}
	inline function set_m33(f:Float):Float {
		return this[10] = f;
	}
	
	public var m34(get, set):Float;
	inline function get_m34():Float {
		return this[11];
	}
	inline function set_m34(f:Float):Float {
		return this[11] = f;
	}
	
	public var m41(get, set):Float;
	inline function get_m41():Float {
		return this[12];
	}
	inline function set_m41(f:Float):Float {
		return this[12] = f;
	}
	
	public var m42(get, set):Float;
	inline function get_m42():Float {
		return this[13];
	}
	inline function set_m42(f:Float):Float {
		return this[13] = f;
	}
	
	public var m43(get, set):Float;
	inline function get_m43():Float {
		return this[14];
	}
	inline function set_m43(f:Float):Float {
		return this[14] = f;
	}
	
	public var m44(get, set):Float;
	inline function get_m44():Float {
		return this[15];
	}
	inline function set_m44(f:Float):Float {
		return this[15] = f;
	}
	
	public inline function identity():Void {
		m11 = 1; m12 = 0; m13 = 0; m14 = 0;
		m21 = 0; m22 = 1; m23 = 0; m24 = 0;
		m31 = 0; m32 = 0; m33 = 1; m34 = 0;
		m41 = 0; m42 = 0; m43 = 0; m44 = 1;
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
	
	public inline function clone():Matrix44 {
		var m:Matrix44 = new Matrix44();
		m.copyFrom(this);
		return m;
	}
	
	public inline function translate(x:Float = 0, y:Float = 0, z:Float = 0, w:Float = 0):Matrix44 {
		m14 += x;
		m24 += y;
		m34 += z;
		m44 += w;
		return this;
	}
	public inline function rotate(t:Float):Matrix44 {
		m11 *= Math.cos(t); m12 *= -Math.sin(t);
		m21 *= Math.sin(t); m22 *= Math.cos(t);
		return this;
	}
	public inline function scale(x:Float, y:Float, z:Float):Matrix44 {
		m11 *= x;
		m22 *= y;
		m33 *= z;
		return this;
	}
	
	public inline function copyFrom(m:Matrix44):Matrix44 {
		for (i in 0...m.length) {
			this[i] = m[i];
		}
		return this;
	}
	
	public inline function copyRowFrom(other:Matrix44, row:Int):Matrix44 {
		var start:Int = row * 4;
		var end:Int = start + 4;
		for (i in start...end) {
			this[i] = other[i];
		}
		return this;
	}
	public inline function copyColumnFrom(other:Matrix44, column:Int):Matrix44 {
		var idx:Int = column * 4-1;
		while(idx>0){
			this[idx] = other[idx];
			idx -= 4;
		}
		return this;
	}
	public inline function transpose():Matrix44 {
		var temp = clone();
		m11 = temp.m11;
		m21 = temp.m12;
		m31 = temp.m13;
		m41 = temp.m14;
		
		m12 = temp.m21;
		m22 = temp.m22;
		m32 = temp.m23;
		m42 = temp.m24;
		
		m13 = temp.m31;
		m23 = temp.m32;
		m33 = temp.m33;
		m43 = temp.m34;
		
		m14 = temp.m41;
		m24 = temp.m42;
		m34 = temp.m43;
		m44 = temp.m44;
		return this;
	}
	
	@:noCompletion @:op(A *= B) public static inline function compoundMult(a:Matrix44, b:Matrix44):Matrix44 {
		var m = a * b;
		return a.copyFrom(m);
	}
	@:noCompletion @:op(A * B) public static inline function mult(a:Matrix44, b:Matrix44):Matrix44 {
		var c = a.clone();
		c.m11 = a.m11 * b.m11 + a.m12 * b.m21 + a.m13 * a.m31;		c.m12 = a.m11 * b.m12 + a.m12 * b.m22 + a.m13 * a.m32;		c.m13 = a.m11 * b.m13 + a.m12 * b.m23 + a.m13 * a.m33;
		c.m21 = a.m21 * b.m11 + a.m22 * b.m21 + a.m23 * a.m31;		c.m22 = a.m21 * b.m12 + a.m22 * b.m22 + a.m23 * a.m32;		c.m23 = a.m21 * b.m13 + a.m22 * b.m23 + a.m23 * a.m33;
		c.m31 = a.m31 * b.m11 + a.m32 * b.m21 + a.m33 * a.m31;		c.m32 = a.m31 * b.m12 + a.m32 * b.m22 + a.m33 * a.m32;		c.m33 = a.m31 * b.m13 + a.m32 * b.m23 + a.m33 * a.m33;
		return c;
	}
	
	@:noCompletion @:op(A -= B) public static inline function compoundSub(a:Matrix44, b:Matrix44):Matrix44 {
		for (i in 0...16) {
			a[i] -= b[i];
		}
		return a;	
	}
	@:noCompletion @:op(A - B) public static inline function sub(a:Matrix44, b:Matrix44):Matrix44 {
		var out = a.clone();
		return out -= b;	
	}
	
	@:noCompletion @:op(A += B) public static inline function compoundAdd(a:Matrix44, b:Matrix44):Matrix44 {
		for (i in 0...16) {
			a[i] += b[i];
		}
		return a;	
	}
	@:noCompletion @:op(A + B) public static inline function add(a:Matrix44, b:Matrix44):Matrix44 {
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
		return "Matrix44(" + this + ")";
	}
	
	
}