package com.furusystems.flywheel.utils.geom;
import haxe.ds.Vector;
/**
 * ...
 * @author Andreas Rønning
 */
abstract Matrix22(Vector<Float>) from Vector<Float> to Vector<Float>
{

	public inline function new() 
	{
		this = new Vector<Float>(4);
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
	
	public var m21(get, set):Float;
	inline function get_m21():Float {
		return this[2];
	}
	inline function set_m21(f:Float):Float {
		return this[2] = f;
	}
	
	public var m22(get, set):Float;
	inline function get_m22():Float {
		return this[3];
	}
	inline function set_m22(f:Float):Float {
		return this[3] = f;
	}
	
	public var length(get, never):Int;
	inline function get_length():Int {
		return this.length;
	}
	
	public inline function copyFrom(m:Vector<Float>):Matrix44 {
		for (i in 0...m.length) {
			this[i] = m[i];
		}
		return this;
	}
	
	public inline function clone():Matrix44 {
		var m:Matrix44 = new Matrix44();
		m.copyFrom(this);
		return m;
	}
	
	@:arrayAccess public inline function arrayAccess(key:Int):Float{
        return this[key];
    }
    
    @:arrayAccess public inline function arrayWrite(key:Int, value:Float):Float {
        this[key] = value;
        return value;
    }
	
	public inline function identity():Void {
		m11 = 1; m12 = 0;
		m21 = 0; m22 = 1;
	}
	
	public inline function toString():String {
		return "Matrix22(" + this + ")";
	}
	
}