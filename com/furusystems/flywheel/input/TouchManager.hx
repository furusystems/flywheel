package com.furusystems.flywheel.input;
import com.furusystems.flywheel.Core;
import com.furusystems.flywheel.events.Signal;
import com.furusystems.flywheel.input.touch.TouchPoint;
import flash.display.InteractiveObject;
import flash.events.TouchEvent;
import flash.ui.Multitouch;

/**
 * ...
 * @author Andreas Rønning
 */
class TouchManager implements IInputManager
{

	var points:Map<Int, TouchPoint>;
	public var activePoints:List<TouchPoint>;
	
	public var onTouchBegin:Signal<TouchPoint>;
	public var onTouchMove:Signal<TouchPoint>;
	public var onTouchEnd:Signal<TouchPoint>;
	
	public function new() 
	{
		onTouchBegin = new Signal<TouchPoint>();
		onTouchMove = new Signal<TouchPoint>();
		onTouchEnd = new Signal<TouchPoint>();
	}
	
	private function touchMoveHandler(e:TouchEvent):Void 
	{
		var p:TouchPoint = points.get(e.touchPointID);
		p.tempX = e.stageX;
		p.tempY = e.stageY;
		onTouchMove.dispatch(p);
	}
	
	private function touchEndHandler(e:TouchEvent):Void 
	{
		var pt:TouchPoint = points.get(e.touchPointID);
		pt.x = pt.tempX = e.stageX;
		pt.y = pt.tempY = e.stageY;
		activePoints.remove(pt);
		points.remove(pt.id);
		onTouchEnd.dispatch(pt);
	}
	
	private function touchBeginHandler(e:TouchEvent):Void 
	{
		var pt:TouchPoint = new TouchPoint(e.touchPointID, e.stageX, e.stageY);
		points.set(e.touchPointID, pt);
		activePoints.add(pt);
		onTouchBegin.dispatch(pt);
	}
	
	inline function updatePoint(p:TouchPoint):Void 
	{
		p.deltaX = p.tempX - p.x;
		p.deltaY = p.tempY - p.y;
		p.x = p.tempX;
		p.y = p.tempY;
	}
	
	/* INTERFACE com.furusystems.flywheel.input.IInputManager */
	
	public function update(game:Core):Void 
	{
		for (p in activePoints) 
		{
			updatePoint(p);
		}
	}
	
	
	public function bind(source:InteractiveObject):Void {
		reset();
		if (Multitouch.supportsTouchEvents) {
			source.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
			source.addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
			source.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
		}else {
			trace("Multitouch not supported, TODO: map to mouse manager");
		}
	}
	
	public function release(source:InteractiveObject):Void {
		reset();
		source.removeEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
		source.removeEventListener(TouchEvent.TOUCH_END, touchEndHandler);
		source.removeEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
	}
	
	public function reset():Void {
		points = new Map<Int, TouchPoint>();
		activePoints = new List<TouchPoint>();
		onTouchBegin.removeAll();
		onTouchMove.removeAll();
		onTouchEnd.removeAll();
	}
	
}