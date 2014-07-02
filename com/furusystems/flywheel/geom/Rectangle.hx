package com.furusystems.flywheel.geom;
import haxe.ds.Vector;

/**
 * ...
 * @author Andreas Rønning
 */

class Rectangle
{

	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;
	public inline function new(x:Float = 0,y:Float = 0,w:Float = 0,h:Float = 0) 
	{
		this.x = x;
		this.y = y;
		this.width = w;
		this.height = h;
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
	
	public inline function setTo(x:Float, y:Float, width:Float, height:Float):Rectangle {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
		return this;
	}
	
	public inline function copyFrom(other:Rectangle):Rectangle {
		return setTo(other.x, other.y, other.width, other.height);
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