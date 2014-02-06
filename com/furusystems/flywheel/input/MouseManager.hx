package com.furusystems.flywheel.input;
import com.furusystems.flywheel.Core;
import com.furusystems.flywheel.events.Signal1;
import com.furusystems.flywheel.geom.Vector2D;
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
	public var clickStartPosition:Vector2D;
	public var position:Vector2D;
	public var positionDelta:Vector2D;
	public var leftMouse:Bool;
	public var rightMouse:Bool;
	public var middleMouse:Bool;
	
	public var onMouseDown:Signal1<MouseEvent>;
	public var onRightMouseDown:Signal1<MouseEvent>;
	public var onMiddleMouseDown:Signal1<MouseEvent>;
	public var onMouseMove:Signal1<MouseEvent>;
	public var onMouseUp:Signal1<MouseEvent>;
	public var onRightMouseUp:Signal1<MouseEvent>;
	public var onMiddleMouseUp:Signal1<MouseEvent>;
	public var onMouseWheel:Signal1<MouseEvent>;
	public var onClick:Signal1<MouseEvent>;
	public var onRightClick:Signal1<MouseEvent>;
	public var onMiddleClick:Signal1<MouseEvent>;
	public var onDoubleClick:Signal1<MouseEvent>;
	
	public function new() 
	{
		clickStartPosition = new Vector2D();
		position = new Vector2D();
		tempPosition = new Vector2D();
		positionDelta = new Vector2D();
		onMouseDown = new Signal1<MouseEvent>();
		onRightMouseDown = new Signal1<MouseEvent>();
		onMiddleMouseDown = new Signal1<MouseEvent>();
		onMouseMove = new Signal1<MouseEvent>();
		onMouseUp = new Signal1<MouseEvent>();
		onRightMouseUp = new Signal1<MouseEvent>();
		onMiddleMouseUp = new Signal1<MouseEvent>();
		onMouseWheel = new Signal1<MouseEvent>();
		onClick = new Signal1<MouseEvent>();
		onRightClick = new Signal1<MouseEvent>();
		onMiddleClick = new Signal1<MouseEvent>();
		onDoubleClick = new Signal1<MouseEvent>();
	}
	
	function mouseMoveHandler(e:MouseEvent):Void 
	{
		updateMousePos(e);
		onMouseMove.dispatch(e);
	}
	
	inline function updateMousePos(e:MouseEvent):Void {
		positionDelta.x = e.stageX - position.x;
		positionDelta.y = e.stageY - position.y;
		position.x = e.stageX;
		position.y = e.stageY;
	}
	
	function clickHandler(e:MouseEvent):Void 
	{
		updateMousePos(e);
		switch(e.type) {
			case MouseEvent.CLICK:
				leftMouse = false;
				onClick.dispatch(e);
			#if (desktop || air3)
			case MouseEvent.RIGHT_CLICK:
				rightMouse = false;
				onRightClick.dispatch(e);
			case MouseEvent.MIDDLE_CLICK:
				middleMouse = false;
				onMiddleClick.dispatch(e);
			#end
		}
	}
	
	function mouseUpHandler(e:MouseEvent):Void 
	{
		updateMousePos(e);
		switch(e.type) {
			case MouseEvent.MOUSE_UP:
				leftMouse = false;
				onMouseUp.dispatch(e);
			#if (desktop || air3)
			case MouseEvent.RIGHT_MOUSE_UP:
				rightMouse = false;
				onRightMouseUp.dispatch(e);
			case MouseEvent.MIDDLE_MOUSE_UP:
				middleMouse = false;
				onMiddleMouseUp.dispatch(e);
			#end
		}
	}
	
	function mouseDownHandler(e:MouseEvent):Void 
	{
		updateMousePos(e);
		clickStartPosition.copyFrom(position);
		switch(e.type) {
			case MouseEvent.MOUSE_DOWN:
				leftMouse = true;
				onMouseDown.dispatch(e);
			#if (desktop || air3)
			case MouseEvent.RIGHT_MOUSE_DOWN:
				rightMouse = true;
				onRightMouseDown.dispatch(e);
			case MouseEvent.MIDDLE_MOUSE_DOWN:
				middleMouse = true;
				onMiddleMouseDown.dispatch(e);
			#end
		}
	}
	
	/* INTERFACE com.furusystems.flywheel.input.IInputManager */
	public function update(?game:Core):Void 
	{
	}
	
	public function bind(source:InteractiveObject):Void {
		reset();
		source.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		source.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		source.addEventListener(MouseEvent.CLICK, clickHandler);
		source.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		source.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		source.addEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);
		#if (desktop || air3)
		source.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, mouseDownHandler);
		source.addEventListener(MouseEvent.RIGHT_MOUSE_UP, mouseUpHandler);
		source.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, mouseDownHandler);
		source.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, mouseUpHandler);
		source.addEventListener(MouseEvent.RIGHT_CLICK, clickHandler);
		source.addEventListener(MouseEvent.MIDDLE_CLICK, clickHandler);
		#end
	}
	
	private function doubleClickHandler(e:MouseEvent):Void 
	{
		updateMousePos(e);
		onDoubleClick.dispatch(e);
	}
	public function release(source:InteractiveObject):Void {
		reset();
		source.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
		source.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		source.removeEventListener(MouseEvent.CLICK, clickHandler);
		source.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		source.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		source.removeEventListener(MouseEvent.DOUBLE_CLICK, doubleClickHandler);

		#if (desktop || air3)
		source.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, mouseDownHandler);
		source.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, mouseUpHandler);
		source.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, mouseDownHandler);
		source.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, mouseUpHandler);
		source.removeEventListener(MouseEvent.RIGHT_CLICK, clickHandler);
		source.removeEventListener(MouseEvent.MIDDLE_CLICK, clickHandler);
		#end
	}
	
	private function mouseWheelHandler(e:MouseEvent):Void 
	{
		onMouseWheel.dispatch(e);
	}
	
	public function reset():Void {
		positionDelta.setTo(0, 0);
	    onMouseDown.removeAll();
	    onRightMouseDown.removeAll();
	    onMiddleMouseDown.removeAll();
	    onMouseMove.removeAll();
	    onMouseUp.removeAll();
	    onRightMouseUp.removeAll();
	    onMiddleMouseUp.removeAll();
	    onMouseWheel.removeAll();
	    onClick.removeAll();
	    onRightClick.removeAll();
	    onMiddleClick.removeAll();
	    onDoubleClick.removeAll();
	}
	
}