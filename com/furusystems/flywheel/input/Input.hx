package com.furusystems.flywheel.input;
import com.furusystems.flywheel.Core;

/**
 * ...
 * @author Andreas Rønning
 */
class Input
{
	//public var keyboard:KeyboardManager;
	public var touch:TouchManager;
	public var mouse:MouseManager;
	public function new() 
	{
		//keyboard = new KeyboardManager();
		touch = new TouchManager();
		mouse = new MouseManager();
	}
	public inline function update(core:Core) {
		#if mobile
		touch.update(core);
		#else
		mouse.update(core);
		#end
	}
}