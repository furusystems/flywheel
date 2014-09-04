package com.furusystems.flywheel.input;
import com.furusystems.flywheel.geom.Vector2D;
#if flash
import flash.display.InteractiveObject;
import flash.events.MouseEvent;
#elseif openfl
import openfl.events.MouseEvent;
#end
import fsignal.Signal1;

/**
 * ...
 * @author Andreas Rønning
 */
class MouseManager
{
	var tempPosition:Vector2D;
	public var inputMgr:Input;
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
	
	public function new(inputMgr:Input) 
	{
		this.inputMgr = inputMgr;
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
	
	public function mouseMoveHandler(e:MouseEvent):Void 
	{
		updateMousePos(e);
		onMouseMove.dispatch(e);
	}
	
	function updateMousePos(e:MouseEvent):Void {
		var boundsRect = inputMgr.bounds;
		var x:Float = #if (flash||openfl) e.stageX; #elseif lime e.x;  #end
		var y:Float = #if (flash||openfl) e.stageY; #elseif lime e.y;  #end
		if(boundsRect!=null){
			x = Math.max(boundsRect.x, Math.min(x, boundsRect.width+boundsRect.x));
			y = Math.max(boundsRect.y, Math.min(y, boundsRect.height + boundsRect.y));
		}
		x -= inputMgr.xOffset;
		y -= inputMgr.yOffset;
		x *= inputMgr.xScale;
		y *= inputMgr.yScale;
		positionDelta.x = x - position.x;
		positionDelta.y = y - position.y;
		position.x = x;
		position.y = y;
	}
	
	public function clickHandler(e:MouseEvent):Void 
	{
		updateMousePos(e);
		#if flash
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
		#end
	}
	
	public function mouseUpHandler(e:MouseEvent):Void 
	{
		updateMousePos(e);
		#if flash
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
		#end
	}
	
	public function mouseDownHandler(e:MouseEvent):Void 
	{
		updateMousePos(e);
		#if flash
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
		#end
	}
	
	public function update():Void 
	{
	}
	
	public function mouseWheelHandler(e:MouseEvent):Void 
	{
		onMouseWheel.dispatch(e);
	}
	
	#if flash
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
	#end
	
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