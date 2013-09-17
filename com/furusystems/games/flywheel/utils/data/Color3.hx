package com.furusystems.games.flywheel.utils.data;

/**
 * ...
 * @author Andreas Rønning
 */
class Color3
{
	public var r:Float = 0;
	public var g:Float = 0;
	public var b:Float = 0;
	public function new(r:Float = 0, g:Float = 0, b:Float = 0) 
	{
		this.r = r;
		this.g = g;
		this.b = b;
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
	
	public static function fromHex(color:Int):Color3 {
		var c:Color3 = new Color3();
		c.r = (color >> 16) / 255;
		c.g = (color >> 8 & 0xFF) / 255;
		c.b = (color & 0xFF) / 255;
		return c;
	}
	public static function fromColor4(color:Color4):Color3 {
		var out:Color3 = new Color3();
		out.r = color.r;
		out.g = color.g;
		out.b = color.b;
		return out;
	}
	
}