package com.furusystems.flywheel.display.rendering.animation.gts;
import com.furusystems.flywheel.geom.Vector2D;
import flash.geom.Point;
import flash.geom.Rectangle;

/**
 * ...
 * @author Andreas Rønning
 */
class GTSTileMetrics
{
	public var offset:Vector2D;
	public var bounds:Rectangle;
	public function new() 
	{
		offset = new Vector2D();
		bounds = new Rectangle();
	}
	public function toString():String {
		return "Tile metrics: " + bounds + ", " + offset;
	}
	
}