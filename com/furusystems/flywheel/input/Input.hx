package com.furusystems.flywheel.input;
import com.furusystems.flywheel.geom.Rectangle;
import flash.display.InteractiveObject;

/**
 * ...
 * @author Andreas Rønning
 */
class Input
{
	public var keyboard:KeyboardManager;
	public var touch:TouchManager;
	public var mouse:MouseManager;
	public var xOffset:Float = 0;
	public var yOffset:Float = 0;
	public var xScale:Float = 1.0;
	public var yScale:Float = 1.0;
	public var bounds:Null<Rectangle>;
	public function new() 
	{
		keyboard = new KeyboardManager();
		touch = new TouchManager(this);
		mouse = new MouseManager(this);
	}
	#if flash
	public function bind(i:InteractiveObject) {
		keyboard.bind(i);
		mouse.bind(i);
	}
	public function release(i:InteractiveObject) {
		keyboard.release(i);
		mouse.release(i);
	}
	#end
	public inline function update() {
		#if mobile
		touch.update();
		#else
		mouse.update();
		#end
	}
}