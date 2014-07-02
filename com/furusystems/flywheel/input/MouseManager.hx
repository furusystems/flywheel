package com.furusystems.flywheel.input;
import com.furusystems.flywheel.Core;
import com.furusystems.flywheel.events.Signal1;
import com.furusystems.flywheel.geom.Vector2D;
import lime.InputHandler.MouseEvent;

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
	
	inline function updateMousePos(e:MouseEvent):Void {
		var boundsRect = inputMgr.bounds;
		e.x = Math.max(boundsRect.x, Math.min(e.x, boundsRect.width+boundsRect.x));
		e.y = Math.max(boundsRect.y, Math.min(e.y, boundsRect.height+boundsRect.y));
		e.x -= inputMgr.xOffset;
		e.y -= inputMgr.yOffset;
		e.x *= inputMgr.xScale;
		e.y *= inputMgr.yScale;
		positionDelta.x = e.x - position.x;
		positionDelta.y = e.y - position.y;
		position.x = e.x;
		position.y = e.y;
	}
	
	public function clickHandler(e:MouseEvent):Void 
	{
		updateMousePos(e);
	}
	
	public function mouseUpHandler(e:MouseEvent):Void 
	{
		updateMousePos(e);
	}
	
	public function mouseDownHandler(e:MouseEvent):Void 
	{
		updateMousePos(e);
	}
	
	public function update(?game:Core):Void 
	{
	}
	
	public function mouseWheelHandler(e:MouseEvent):Void 
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