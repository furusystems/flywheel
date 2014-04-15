package com.furusystems.flywheel.display.rendering.animation.gts;
import com.furusystems.flywheel.geom.Rectangle;
import com.furusystems.flywheel.geom.Vector2D;

/**
 * ...
 * @author Andreas Rønning
 */

class GTSTile extends Rectangle
{

	public var center:Vector2D;
	public var tileSheetIndex:Int;
	public function new(rect:Rectangle) 
	{
		super();
		copyFrom(rect);
		makeCenter();
	}
	public function makeCenter():Vector2D {
		center = new Vector2D();
		center.x = width * .5;
		center.y = height * .5;
		return center;
	}
	
}