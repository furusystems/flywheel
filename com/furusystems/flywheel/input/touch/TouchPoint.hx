package com.furusystems.flywheel.input.touch;
import flash.geom.Point;

/**
 * ...
 * @author Andreas Rønning
 */

class TouchPoint extends Point
{
	public var id:Int;
	public var tempX:Float;
	public var tempY:Float;
	public var deltaX:Float;
	public var deltaY:Float;
	public var startX:Float;
	public var startY:Float;
	public function new(id:Int,startX:Float,startY:Float) 
	{
		this.id = id;
		super(startX, startY);
		this.startX = startX;
		this.startY = startY;
		tempX = startX;
		tempY = startY;
		deltaX = deltaY = 0;
	}
	
}