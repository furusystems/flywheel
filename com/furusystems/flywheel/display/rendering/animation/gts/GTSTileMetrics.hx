package com.furusystems.flywheel.display.rendering.animation.gts;
import com.furusystems.flywheel.geom.Rectangle;
import com.furusystems.flywheel.geom.Vector2D;

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