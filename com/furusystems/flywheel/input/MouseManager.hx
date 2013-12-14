package com.furusystems.flywheel.input;
import com.furusystems.flywheel.Core;
import com.furusystems.flywheel.events.Signal1;
import com.furusystems.flywheel.utils.geom.Vector2D;
import flash.display.InteractiveObject;
import flash.events.MouseEvent;
import flash.geom.Point;

/**
 * ...
 * @author Andreas Rønning
 */
class MouseManager implements IInputManager
{
	var tempPosition:Vector2D;
	public var position:Vector2D;
	public var positionDelta:Vector2D;
	public var leftMouse:Bool;
	public var rightMouse:Bool;
	public var middleMouse:Bool;
	
	public var onMouseDown:Signal1<MouseEvent>;
	public var onMouseUp:Signal1<MouseEvent>;
	public var onClick:Signal1<MouseEvent>;
	
	var firstUpdate:Bool;
	
	public function new() 
	{
		position = new Point();
		tempPosition = new Point();
		positionDelta = new Point();
		onMouseDown = new Signal1<MouseEvent>();
		onMouseUp = new Signal1<MouseEvent>();
		onClick = new Signal1<MouseEvent>();
	}
	
	function mouseMoveHandler(e:MouseEvent):Void 
	{
		updateTempMousePos(e);
	}
	
	inline function updateTempMousePos(e:MouseEvent):Void {
		tempPosition.x = e.stageX;
		tempPosition.y = e.stageY;
	}
	
	function clickHandler(e:MouseEvent):Void 
	{
		updateTempMousePos(e);
		onClick.dispatch(e);
	}
	
	function mouseUpHandler(e:MouseEvent):Void 
	{
		updateTempMousePos(e);
		switch(e.type) {
			case MouseEvent.MOUSE_UP:
				leftMouse = false;
			#if desktop
			case MouseEvent.RIGHT_MOUSE_UP:
				rightMouse = false;
			case MouseEvent.MIDDLE_MOUSE_UP:
				middleMouse = false;
			#end
		}
		onMouseUp.dispatch(e);
	}
	
	function mouseDownHandler(e:MouseEvent):Void 
	{
		updateTempMousePos(e);
		switch(e.type) {
			case MouseEvent.MOUSE_DOWN:
				leftMouse = true;
			#if desktop
			case MouseEvent.RIGHT_MOUSE_DOWN:
				rightMouse = true;
			case MouseEvent.MIDDLE_MOUSE_DOWN:
				middleMouse = true;
			#end
		}
		onMouseDown.dispatch(e);
	}
	
	
	/* INTERFACE com.furusystems.flywheel.input.IInputManager */
	
	public function update(game:Core):Void 
	{
		if (firstUpdate) {
			firstUpdate = false;
			positionDelta.set(0, 0);
		}else{
			positionDelta.x = tempPosition.x - position.x;
			positionDelta.y = tempPosition.y - position.y;
		}
		position.x = tempPosition.x;
		position.y = tempPosition.y;
	}
	
	public function bind(source:InteractiveObject):Void {
		reset();
		source.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		source.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		source.addEventListener(MouseEvent.CLICK, clickHandler);
		source.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		#if desktop
		source.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, mouseDownHandler);
		source.addEventListener(MouseEvent.RIGHT_MOUSE_UP, mouseUpHandler);
		source.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, mouseDownHandler);
		source.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, mouseUpHandler);
		source.addEventListener(MouseEvent.RIGHT_CLICK, clickHandler);
		source.addEventListener(MouseEvent.MIDDLE_CLICK, clickHandler);
		#end
	}
	public function release(source:InteractiveObject):Void {
		reset();
		source.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		source.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		source.removeEventListener(MouseEvent.CLICK, clickHandler);
		source.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		#if desktop
		source.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, mouseDownHandler);
		source.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, mouseUpHandler);
		source.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, mouseDownHandler);
		source.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, mouseUpHandler);
		source.removeEventListener(MouseEvent.RIGHT_CLICK, clickHandler);
		source.removeEventListener(MouseEvent.MIDDLE_CLICK, clickHandler);
		#end
	}
	
	public function reset():Void {
		firstUpdate = true;
		positionDelta.set(0, 0);
		onMouseDown.removeAll();
		onMouseUp.removeAll();
		onClick.removeAll();
	}
	
}