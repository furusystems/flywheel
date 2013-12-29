package com.furusystems.flywheel.utils.geom;
import haxe.ds.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
abstract Quaternion(Vector<Float>) from Vector<Float> to Vector<Float>
{
	public inline function new(x:Float = 0.0,y:Float = 0.0,z:Float = 0.0,w:Float = 1.0) 
	{
		var v = new Vector<Float>(4);
		v[0] = x;
		v[1] = y;
		v[2] = z;
		v[3] = w;
		this = v;
	}
	
	public var x(get, set):Float;
	inline function get_x():Float {
		return this[0];
	}
	inline function set_x(f:Float):Float {
		return this[0] = f;
	}
	
	public var y(get, set):Float;
	inline function get_y():Float {
		return this[1];
	}
	inline function set_y(f:Float):Float {
		return this[1] = f;
	}
	
	public var z(get, set):Float;
	inline function get_z():Float {
		return this[2];
	}
	inline function set_z(f:Float):Float {
		return this[2] = f;
	}
	
	public var w(get, set):Float;
	inline function get_w():Float {
		return this[3];
	}
	inline function set_w(f:Float):Float {
		return this[3] = f;
	}
	
	
	public static function fromAxisAngle(x:Float, y:Float, z:Float, angle:Float):Quaternion{
		var out:Quaternion = new Quaternion();
		var result = Math.sin(angle * 0.5);
		out.w = Math.cos(angle * 0.5);
		out.x = x * result;
		out.y = y * result;
		out.z = z * result;
		return out;
	}
	public inline function toMatrix(out:Matrix44):Matrix44 {
		// First row
	    out[0] = 1.0f - 2.0f * ( y * y + z * z );  
	    out[1] = 2.0f * ( x * y - w * z );  
	    out[2] = 2.0f * ( x * z + w * y );  
	    out[3] = 0.0f;  
	
	    // Second row
	    out[4] = 2.0f * ( x * y + w * z );  
	    out[5] = 1.0f - 2.0f * ( x * x + z * z );  
	    out[6] = 2.0f * ( y * z - w * x );  
	    out[7] = 0.0f;  
	
	    // Third row
	    out[8] = 2.0f * ( x * z - w * y );  
	    out[9] = 2.0f * ( y * z + w * x );  
	    out[10] = 1.0f - 2.0f * ( x * x + y * y );  
	    out[11] = 0.0f;  
	
	    // Fourth row
	    out[12] = 0;  
	    out[13] = 0;  
	    out[14] = 0;  
	    out[15] = 1.0f;
		
		return out;
	}
	public inline function mult(other:Quaternion):Quaternion {
		var q:Quaternion = clone();
		return q.multInPlace(other);
	}
	public inline function multInPlace(other:Quaternion):Quaternion {
		w = w*other.w - x*other.x - y*other.y - z*other.z;
		x = w*other.x + x*other.w + y*other.z - z*other.y;
		y = w*other.y + y*other.w + z*other.x - x*other.z;
		z = w*other.z + z*other.w + x*other.y - y*other.x;
		return this;
	}
	public inline function clone():Quaternion {
		return new Quaternion(x, y, z, w);
	}

}