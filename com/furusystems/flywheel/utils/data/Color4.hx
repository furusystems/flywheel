package com.furusystems.flywheel.utils.data;
#if flash
import flash.geom.Vector3D;
#elseif falconer
import falconer.utils.Vector3D;
#elseif lime
import lime.utils.Vector3D;
#end

/**
 * ...
 * @author Andreas Rønning
 */
abstract Color4(Vector3D) from Vector3D to Vector3D
{
	public var r(get, set):Float;
	public var g(get, set):Float;
	public var b(get, set):Float;
	public var a(get, set):Float;
	
	inline function get_r():Float { return this.x; };
	inline function get_g():Float { return this.y; };
	inline function get_b():Float { return this.z; };
	inline function get_a():Float { return this.w; };
	
	inline function set_r(v:Float):Float { return this.x=v; };
	inline function set_g(v:Float):Float { return this.y=v; };
	inline function set_b(v:Float):Float { return this.z=v; };
	inline function set_a(v:Float):Float { return this.w=v; };
	
	public inline function new(r:Float = 0,g:Float = 0,b:Float = 0,a:Float = 0) 
	{
		this = new Vector3D(r, g, b, a);
	}
	public inline function setFromHex(color:Int):Color4 {
		a = (color >> 24) / 255;
		r = (color >> 16 & 0xFF) / 255;
		g = (color >>  8 & 0xFF) / 255;
		b = (color & 0xFF) / 255;
		return this;
	}
	public inline function toHex():Int {
		return Std.int(a * 255) << 24 | Std.int(r * 255) << 16 | Std.int(g * 255) << 8 | Std.int(b * 255);
	}
	public inline function copyFrom(other:Color3):Void {
		r = other.r;
		g = other.g;
		b = other.b;
		a = 1;
	}
	public inline function clone():Color4 {
		return new Color4(r, g, b, a);
	}
	
	public static function fromHex(color:Int):Color4 {
		var c:Color4 = new Color4();
		c.a = (color >> 24) / 255;
		c.r = (color >> 16 & 0xFF) / 255;
		c.g = (color >>  8 & 0xFF) / 255;
		c.b = (color & 0xFF) / 255;
		return c;
	}
	public static function fromColor3(color:Color3):Color4 {
		var out:Color4 = new Color4();
		out.a = 1;
		out.r = color.r;
		out.g = color.g;
		out.b = color.b;
		return out;
	}
	
}