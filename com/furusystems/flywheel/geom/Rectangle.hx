package com.furusystems.flywheel.geom;
import haxe.ds.Vector;

/**
 * ...
 * @author Andreas Rønning
 */

private class RectangleFields {
	public var x:Float;
	public var y:Float;
	public var w:Float;
	public var h:Float;
	public inline function new() {
		
	}
}
 
abstract Rectangle(RectangleFields) from RectangleFields to RectangleFields
{

	public inline function new(x:Float = 0,y:Float = 0,w:Float = 0,h:Float = 0) 
	{
		var v = new RectangleFields();
		v.x = x;
		v.y = y;
		v.w = w;
		v.h = h;
		this = v;
	}
	public var x(get, set):Float;
	@:noCompletion inline function get_x():Float {
		return this.x;
	}
	@:noCompletion inline function set_x(f:Float):Float {
		return this.x = f;
	}
	
	public var y(get, set):Float;
	@:noCompletion inline function get_y():Float {
		return this.y;
	}
	@:noCompletion inline function set_y(f:Float):Float {
		return this.y = f;
	}
	
	public var width(get, set):Float;
	@:noCompletion inline function get_width():Float {
		return this.w;
	}
	@:noCompletion inline function set_width(f:Float):Float {
		return this.w = f;
	}
	
	public var height(get, set):Float;
	@:noCompletion inline function get_height():Float {
		return this.h;
	}
	@:noCompletion inline function set_height(f:Float):Float {
		return this.h = f;
	}
	
	public inline function contains(other:Rectangle):Bool {
		return false;
	}
	
	public inline function containedBy(other:Rectangle):Bool {
		return false;
	}
	
	public inline function intersects(other:Rectangle):Bool {
		return false;
	}
	
	public inline function intersection(other:Rectangle):Rectangle {
		return new Rectangle();
	}
	
	public inline function containsPoint(pt:Vector2D):Bool {
		return !(pt.x < x || pt.y < y || pt.x > x + width || pt.y > y + height);
	}
	
	public inline function toString():String {
		return 'Rectangle($x,$y,$width,$height)';
	}
	
}