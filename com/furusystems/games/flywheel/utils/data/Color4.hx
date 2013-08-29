package com.furusystems.games.flywheel.utils;

/**
 * ...
 * @author Andreas Rønning
 */
class Color4 extends Color3
{
	public var a:Float = 0;
	public function new() 
	{
		super();
	}
	override public function fromHex(color:Int):Color4 {
		a = (color >> 24) / 255;
		r = (color >> 16 & 0xFF) / 255;
		g = (color >>  8 & 0xFF) / 255;
		b = (color & 0xFF) / 255;
		return this;
	}
	override public function toHex():Int {
		return Std.int(a * 255) << 24 | Std.int(r * 255) << 16 | Std.int(g * 255) << 8 | Std.int(b * 255);
	}
	
	public static function createFromHex(color:Int):Color4 {
		var c:Color4 = new Color4();
		c.a = (color >> 24) / 255;
		c.r = (color >> 16 & 0xFF) / 255;
		c.g = (color >>  8 & 0xFF) / 255;
		c.b = (color & 0xFF) / 255;
		return c;
	}
	public static function createFromColor3(color:Color3):Color4 {
		var out:Color4 = new Color4();
		out.a = 1;
		out.r = color.r;
		out.g = color.g;
		out.b = color.b;
		return out;
	}
	
}