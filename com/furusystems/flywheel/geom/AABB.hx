package com.furusystems.flywheel.geom;

/**
 * ...
 * @author Andreas Rønning
 */
class AABB
{
	public var position:Vector2D;
	public var size:Vector2D;
	public var halfWidth:Float;
	public var halfHeight:Float;
	
	public var sizeSq(get, never):Float;
	inline function get_sizeSq():Float {
		return width + height;
	}
	
	public var x(get, set):Float;
	inline function get_x():Float {
		return position.x;
	}
	inline function set_x(f:Float):Float {
		return position.x = f;
	}
	
	public var y(get, set):Float;
	inline function get_y():Float {
		return position.y;
	}
	inline function set_y(f:Float):Float {
		return position.y = f;
	}
	
	public var width(get, set):Float;
	inline function get_width():Float {
		return size.x;
	}
	inline function set_width(f:Float):Float {
		size.x = f;
		halfWidth = size.x * 0.5;
		return size.x;
	}
	
	public var height(get, set):Float;
	inline function get_height():Float {
		return size.y;
	}
	inline function set_height(f:Float):Float {
		size.y = f;
		halfHeight = size.y * 0.5;
		return size.y;
	}
	
	public function new(x:Float = 0,y:Float = 0, width:Float = 0,height:Float = 0) 
	{
		position = new Vector2D(x, y);
		size = new Vector2D(width, height);
		halfWidth = width * 0.5;
		halfHeight = height * 0.5;
	}
	public inline function redefine(x:Float, y:Float, width:Float, height:Float):AABB {
		position.setTo(x, y);
		size.setTo(width, height);
		halfWidth = width * 0.5;
		halfHeight = height * 0.5;
		return this;
	}
	
	public inline function copyFrom(other:AABB):AABB {
		return redefine(other.x, other.y, other.width, other.height);
	}
	
	public inline function containsVector2D(v:Vector2D):Bool {
		return !(v.x<position.x-halfWidth || v.x > position.x+halfWidth || v.y < position.y-halfHeight || v.y > position.y+halfHeight);
	}
	public inline function intersects(other:AABB):Bool {
		var t = other.position - position;
		return Math.abs(t.x) <= (halfWidth + other.halfWidth) && Math.abs(t.y) <= (halfHeight + other.halfHeight);
	}
	public inline function clone():AABB {
		return new AABB(position.x, position.y, size.x, size.y);
	}
	public function toString():String {
		return '[x=$x y=$y w=$width h=$height]';
	}
	public function zero():AABB {
		return redefine(0, 0, 0, 0);
	}
	#if flash
	public static function fromRect(r:flash.geom.Rectangle):AABB {
		return new AABB(r.x + r.width * 0.5, r.y + r.height * 0.5, r.width, r.height);
	}
	#end
	
	public inline function union(other:AABB, ?out:AABB):AABB {
		if (out == null) out = clone();
		var minX = Math.min(position.x - halfWidth, other.position.x - other.halfWidth);
		var minY = Math.min(position.y - halfHeight, other.position.y - other.halfHeight);
		var maxX = Math.max(position.x + halfWidth, other.position.x + other.halfWidth);
		var maxY = Math.max(position.y + halfHeight, other.position.y + other.halfHeight);
		var w = maxX - minX;
		var h = maxY - minY;
		var x = minX + w * 0.5;
		var y = minY + h * 0.5;
		return out.redefine(x, y, w, h);
	}
	
}