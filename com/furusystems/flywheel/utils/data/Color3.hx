package com.furusystems.flywheel.utils.data;
import lime.utils.Vector3D;

/**
 * ...
 * @author Andreas Rønning
 */
abstract Color3(Vector3D) from Vector3D to Vector3D
{
	public var r(get, set):Float;
	public var g(get, set):Float;
	public var b(get, set):Float;
	
	inline function get_r():Float { return this.x; };
	inline function get_g():Float { return this.y; };
	inline function get_b():Float { return this.z; };
	
	inline function set_r(v:Float):Float { return this.x = v; };
	inline function set_g(v:Float):Float { return this.y = v; };
	inline function set_b(v:Float):Float { return this.z = v; };
	
	public inline function new(r:Float = 0, g:Float = 0, b:Float = 0) 
	{
		this = new Vector3D(r, g, b, 1);
	}
	public inline function setFromHex(color:Int):Color3 {
		r = (color >> 16) / 255;
		g = (color >> 8 & 0xFF) / 255;
		b = (color & 0xFF) / 255;
		return this;
	}
	public inline function toHex():Int {
		return Std.int(r * 255) << 16 | Std.int(g * 255) << 8 | Std.int(b * 255);
	}
	public inline function copyFrom(other:Color3):Void {
		r = other.r;
		g = other.g;
		b = other.b;
	}
	public inline function clone():Color3 {
		return new Color3(r, g, b);
	}
	
	public static inline function fromHex(color:Int):Color3 {
		var c:Color3 = new Color3();
		c.r = (color >> 16) / 255;
		c.g = (color >> 8 & 0xFF) / 255;
		c.b = (color & 0xFF) / 255;
		return c;
	}
	public static inline function fromColor4(color:Color4):Color3 {
		var out:Color3 = new Color3();
		out.r = color.r;
		out.g = color.g;
		out.b = color.b;
		return out;
	}
	
}