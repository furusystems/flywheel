package com.furusystems.flywheel.utils.geom;
import haxe.ds.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
abstract Rectangle(Vector<Float>) from Vector<Float> to Vector<Float>
{

	public inline function new(x:Float = 0,y:Float = 0,w:Float = 0,h:Float = 0) 
	{
		var v = new Vector<Float>(4);
		v[0] = x;
		v[1] = y;
		v[2] = w;
		v[3] = h;
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
	
	public var width(get, set):Float;
	inline function get_width():Float {
		return this[2];
	}
	inline function set_width(f:Float):Float {
		return this[2] = f;
	}
	
	public var height(get, set):Float;
	inline function get_height():Float {
		return this[3];
	}
	inline function set_height(f:Float):Float {
		return this[3] = f;
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