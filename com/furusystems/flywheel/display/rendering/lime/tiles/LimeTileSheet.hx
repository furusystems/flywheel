package com.furusystems.flywheel.display.rendering.lime.tiles;
import com.furusystems.flywheel.geom.AABB;

/**
 * ...
 * @author Andreas Rønning
 */
class LimeTileSheet
{
	public var tiles:Array<LimeTile>;
	public function new() 
	{
		tiles = [];
	}
	public inline function addTile(texBoundsX:Float, texBoundsY:Float, x:Float, y:Float, width:Float, height:Float, offsetX:Float, offsetY:Float, idx:Int = -1):LimeTile {
		var t = new LimeTile(tiles.length, x, y, width, height, offsetX, offsetY);
		x = x / texBoundsX;
		y = y / texBoundsY;
		t.umin = x;
		t.vmin = y;
		t.umax = x + width / texBoundsX;
		t.vmax = y + height / texBoundsY;
		if (idx != -1) tiles[idx] = t;
		else tiles.push(t);
		
		return t;
	}
	public inline function removeTile(t:LimeTile):LimeTile {
		tiles.remove(t);
		for (i in 0...tiles.length) {
			tiles[i].index = i;
		}
		return t;
	}
	public inline function dispose():Void {
		tiles = null;
	}
	
}
private class LimeTile {
	public var x:Float;
	public var y:Float;
	public var width:Float;
	public var height:Float;
	public var halfwidth:Float;
	public var halfheight:Float;
	public var offsetX:Float;
	public var offsetY:Float;
	
	public var umin:Float;
	public var vmin:Float;
	public var umax:Float;
	public var vmax:Float;
	
	public var index:Int;
	public inline function new(index:Int, x:Float, y:Float, width:Float, height:Float, ?offsetX:Float, ?offsetY:Float) {
		this.index = index;
		this.x = x;
		this.y = y;
		halfwidth = (this.width = width) * 0.5;
		halfheight = (this.height = height) * 0.5;
		if (offsetX == null ) offsetX = halfwidth;
		else this.offsetX = offsetX;
		if (offsetY == null ) offsetY = halfheight;
		else this.offsetY = offsetY;
	}
}