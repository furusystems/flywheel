package com.furusystems.flywheel.input;
import com.furusystems.flywheel.Core;
import com.furusystems.flywheel.events.Signal1;
import flash.display.InteractiveObject;
import flash.events.KeyboardEvent;

/**
 * ...
 * @author Andreas Rønning
 */
class KeyboardManager implements IInputManager
{
	public var keyDict:Map<Int,Bool>;
	public var onKeyPress:Signal1<Int>;
	public var onKeyRelease:Signal1<Int>;
	public function new() 
	{
		onKeyPress = new Signal1<Int>();
		onKeyRelease = new Signal1<Int>();
	}
	
	private function onKeyUp(e:KeyboardEvent):Void 
	{
		keyDict.set(e.keyCode, false);
		onKeyRelease.dispatch(e.keyCode);
	}
	
	private function onKeyDown(e:KeyboardEvent):Void 
	{
		keyDict.set(e.keyCode, true);
		onKeyPress.dispatch(e.keyCode);
	}
	
	public inline function keyIsDown(code:Int):Bool {
		return keyDict.get(code);
	}
	
	public function reset():Void {
		var i:Int = 255;
		while (i-->= 0) {
			keyDict.set(i, false);
		}
		onKeyPress.removeAll();
		onKeyRelease.removeAll();
	}
	
	/* INTERFACE com.furusystems.flywheel.input.IInputManager */
	
	public function update(game:Core):Void 
	{
		
	}
	
	public function bind(source:InteractiveObject):Void {
		keyDict = new Map<Int,Bool>();
		reset();
		source.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		source.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	public function release(source:InteractiveObject):Void 
	{
		onKeyPress.removeAll();
		onKeyRelease.removeAll();
		source.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		source.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
}