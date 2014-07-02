package com.furusystems.flywheel.input;
import com.furusystems.flywheel.Core;
import com.furusystems.flywheel.geom.Rectangle;

/**
 * ...
 * @author Andreas Rønning
 */
class Input
{
	//public var keyboard:KeyboardManager;
	public var touch:TouchManager;
	public var mouse:MouseManager;
	public var xOffset:Float = 0;
	public var yOffset:Float = 0;
	public var xScale:Float = 1.0;
	public var yScale:Float = 1.0;
	public var bounds:Null<Rectangle>;
	public function new() 
	{
		//keyboard = new KeyboardManager();
		touch = new TouchManager(this);
		mouse = new MouseManager(this);
	}
	public inline function update(core:Core) {
		#if mobile
		touch.update(core);
		#else
		mouse.update(core);
		#end
	}
}