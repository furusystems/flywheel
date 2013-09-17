package com.furusystems.flywheel.input;
import com.furusystems.flywheel.Core;
import com.furusystems.flywheel.events.Signal;
import flash.display.InteractiveObject;
import flash.events.MouseEvent;
import flash.geom.Point;

/**
 * ...
 * @author Andreas Rønning
 */
class MouseManager implements IInputManager
{
	var tempPosition:Point;
	public var position:Point;
	public var positionDelta:Point;
	public var leftMouse:Bool;
	public var rightMouse:Bool;
	public var middleMouse:Bool;
	
	public var onMouseDown:Signal<MouseEvent>;
	public var onMouseUp:Signal<MouseEvent>;
	public var onClick:Signal<MouseEvent>;
	
	var firstUpdate:Bool;
	
	public function new() 
	{
		position = new Point();
		tempPosition = new Point();
		positionDelta = new Point();
		onMouseDown = new Signal<MouseEvent>();
		onMouseUp = new Signal<MouseEvent>();
		onClick = new Signal<MouseEvent>();
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
			case MouseEvent.RIGHT_MOUSE_UP:
				rightMouse = false;
			case MouseEvent.MIDDLE_MOUSE_UP:
				middleMouse = false;
		}
		onMouseUp.dispatch(e);
	}
	
	function mouseDownHandler(e:MouseEvent):Void 
	{
		updateTempMousePos(e);
		switch(e.type) {
			case MouseEvent.MOUSE_DOWN:
				leftMouse = true;
			case MouseEvent.RIGHT_MOUSE_DOWN:
				rightMouse = true;
			case MouseEvent.MIDDLE_MOUSE_DOWN:
				middleMouse = true;
		}
		onMouseDown.dispatch(e);
	}
	
	
	/* INTERFACE com.furusystems.flywheel.input.IInputManager */
	
	public function update(game:Core):Void 
	{
		if (firstUpdate) {
			firstUpdate = false;
			positionDelta.setTo(0, 0);
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
		source.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, mouseDownHandler);
		source.addEventListener(MouseEvent.RIGHT_MOUSE_UP, mouseUpHandler);
		source.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, mouseDownHandler);
		source.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, mouseUpHandler);
		source.addEventListener(MouseEvent.CLICK, clickHandler);
		source.addEventListener(MouseEvent.RIGHT_CLICK, clickHandler);
		source.addEventListener(MouseEvent.MIDDLE_CLICK, clickHandler);
		source.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}
	public function release(source:InteractiveObject):Void {
		reset();
		source.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		source.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		source.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, mouseDownHandler);
		source.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, mouseUpHandler);
		source.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, mouseDownHandler);
		source.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, mouseUpHandler);
		source.removeEventListener(MouseEvent.CLICK, clickHandler);
		source.removeEventListener(MouseEvent.RIGHT_CLICK, clickHandler);
		source.removeEventListener(MouseEvent.MIDDLE_CLICK, clickHandler);
		source.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
	}
	
	public function reset():Void {
		firstUpdate = true;
		positionDelta.setTo(0, 0);
		onMouseDown.removeAll();
		onMouseUp.removeAll();
		onClick.removeAll();
	}
	
}