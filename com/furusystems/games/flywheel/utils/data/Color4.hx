package com.furusystems.games.flywheel.utils.data;

/**
 * ...
 * @author Andreas Rønning
 */
class Color4
{
	public var r:Float = 0;
	public var g:Float = 0;
	public var b:Float = 0;
	public var a:Float = 0;
	public function new(r:Float = 0,g:Float = 0,b:Float = 0,a:Float = 0) 
	{
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
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