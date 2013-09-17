package com.furusystems.flywheel.input;
import com.furusystems.flywheel.Core;
import flash.display.InteractiveObject;
import flash.display.Stage;

/**
 * ...
 * @author Andreas Rønning
 */
class Input
{
	public var keyboard:KeyboardManager;
	public var touch:TouchManager;
	public var mouse:MouseManager;
	var _eventSource:InteractiveObject;
	public function new() 
	{
		keyboard = new KeyboardManager();
		touch = new TouchManager();
		mouse = new MouseManager();
	}
	public inline function update(game:Core):Void {
		keyboard.update(game);
		touch.update(game);
		mouse.update(game);
	}
	public function bind(eventSource:InteractiveObject):Void {
		_eventSource = eventSource;
		keyboard.bind(_eventSource);
		touch.bind(_eventSource);
		mouse.bind(_eventSource);
	}
	public function release():Void {
		keyboard.release(_eventSource);
		touch.release(_eventSource);
		mouse.release(_eventSource);
		_eventSource = null;
	}
	
}