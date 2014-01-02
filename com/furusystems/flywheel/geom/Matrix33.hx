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
	
	public inline function setTo (a1:Float, b1:Float, c1:Float, d1:Float, tx1:Float, ty1:Float):Matrix33 {
		a = a1;
		b = b1;
		c = c1;
		d = d1;
		tx = tx1;
		ty = ty1;
		return this;
	}
	
	
	public inline function identity():Matrix33 {
		a = 1; b = 0; tx = 0; 
		c = 0; d = 1; ty = 0; 
		return this;
	}
	
	public inline function transformVectorInPlace(inPos:Vector2D):Vector2D {
		var tempX = inPos.x * a + inPos.y * c + tx;
		var tempY = inPos.x * b + inPos.y * d + ty;
		return inPos.setTo(tempX,tempY);
	}
	public inline function transformVector(inPos:Vector2D):Vector2D {
		return transformVectorInPlace(inPos.clone());
	}
	
	public inline function deltaTransformVectorInPlace(inPos:Vector2D):Vector2D {
		return inPos.setTo(inPos.x * a + inPos.y * c, inPos.x * b + inPos.y * d);
	}
	
	public inline function deltaTransformVector(inPos:Vector2D):Vector2D {
		return deltaTransformVectorInPlace(inPos.clone());
	}
	
	public inline function clone():Matrix33 {
		var m:Matrix33 = new Matrix33();
		m.copyFrom(this);
		return m;
	}
	
	public inline function invert ():Matrix33 {
		
		var norm = a * d - b * c;
		
		if (norm == 0) {
			
			a = b = c = d = 0;
			tx = -tx;
			ty = -ty;
			
		} else {
			
			norm = 1.0 / norm;
			var a1 = d * norm;
			d = a * norm;
			a = a1;
			b *= -norm;
			c *= -norm;
			
			var tx1 = - a * tx - c * ty;
			ty = - b * tx - d * ty;
			tx = tx1;
			
		}
		
		return this;
		
	}
	
	public inline function translate(x:Float, y:Float):Matrix33 {
		tx += x;
		ty += y;
		return this;
	}
	public inline function rotate(angle:Float):Matrix33 {
		var cos = Math.cos(angle);
		var sin = Math.sin(angle);
		
		var a1 = a * cos - b * sin;
		b = a * sin + b * cos;
		a = a1;
		
		var c1 = c * cos - d * sin;
		d = c * sin + d * cos;
		c = c1;
		
		var tx1 = tx * cos - ty * sin;
		ty = tx * sin + ty * cos;
		tx = tx1;
		
		return this;
	}
	public inline function setRotation(angle:Float, scale:Float = 1):Matrix33 {
		a = Math.cos (angle) * scale;
		c = Math.sin (angle) * scale;
		b = -c;
		d = a;
		return this;
	}
	
	public inline function scale(x:Float, y:Float):Matrix33 {
		a *= x;
		b *= y;
		c *= x;
		d *= y;
		tx *= x;
		ty *= y;
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
	
	@:noCompletion inline function concat(m:Matrix33):Matrix33 {
		var a1 = a * m.a + b * m.c;
		b = a * m.b + b * m.d;
		a = a1;
		
		var c1 = c * m.a + d * m.c;
		d = c * m.b + d * m.d;
		
		c = c1;
		
		var tx1 = tx * m.a + ty * m.c + m.tx;
		ty = tx * m.b + ty * m.d + m.ty;
		tx = tx1;
		return this;
	}
	
	@:noCompletion @:op(A *= B) public static inline function compoundMult(m1:Matrix33, m2:Matrix33):Matrix33 {
		return m1.concat(m2);
	}
	@:op(A * B) public static inline function mult(a:Matrix33, b:Matrix33):Matrix33 {
		var c = a.clone();
		return c *= b;
	}
	
	public inline function toString():String {
		return "Matrix33(" + this + ")";
	}
	
}