package com.furusystems.flywheel.input.touch;

/**
 * ...
 * @author Andreas Rønning
 */

class TouchPoint
{
	public var id:Int;
	public var x:Float;
	public var y:Float;
	public var tempX:Float;
	public var tempY:Float;
	public var deltaX:Float;
	public var deltaY:Float;
	public var startX:Float;
	public var startY:Float;
	public function new(id:Int,startX:Float,startY:Float) 
	{
		this.id = id;
		this.x = startX;
		this.y = startY;
		this.startX = startX;
		this.startY = startY;
		tempX = startX;
		tempY = startY;
		deltaX = deltaY = 0;
	}
	public function clone():TouchPoint {
		return new TouchPoint(id, x, y);
	}
	
}