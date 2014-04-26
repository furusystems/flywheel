package com.furusystems.flywheel.input;
import com.furusystems.flywheel.Core;
import com.furusystems.flywheel.events.Signal1;
import com.furusystems.flywheel.input.touch.TouchPoint;
import lime.InputHandler.TouchEvent;
/**
 * ...
 * @author Andreas Rønning
 */
class TouchManager
{

	var points:Array<TouchPoint>;
	public var inputMgr:Input;
	public var activePoints:Array<TouchPoint>;
	
	public var onTouchBegin:Signal1<TouchPoint>;
	public var onTouchMove:Signal1<TouchPoint>;
	public var onTouchEnd:Signal1<TouchPoint>;
	
	public function new(inputMgr:Input) 
	{
		this.inputMgr = inputMgr;
		onTouchBegin = new Signal1<TouchPoint>();
		onTouchMove = new Signal1<TouchPoint>();
		onTouchEnd = new Signal1<TouchPoint>();
		reset();
	}
	
	public function touchMoveHandler(e:TouchEvent):Void 
	{
		var boundsRect = inputMgr.bounds;
		e.x = Math.max(boundsRect.x, Math.min(e.x, boundsRect.width+boundsRect.x));
		e.y = Math.max(boundsRect.y, Math.min(e.y, boundsRect.height+boundsRect.y));
		e.x -= inputMgr.xOffset;
		e.y -= inputMgr.yOffset;
		e.x *= inputMgr.xScale;
		e.y *= inputMgr.yScale;
		var p:TouchPoint = points[e.ID];
		p.tempX = e.x;
		p.tempY = e.y;
		onTouchMove.dispatch(p);
	}
	
	public function touchEndHandler(e:TouchEvent):Void 
	{
		var boundsRect = inputMgr.bounds;
		e.x = Math.max(boundsRect.x, Math.min(e.x, boundsRect.width+boundsRect.x));
		e.y = Math.max(boundsRect.y, Math.min(e.y, boundsRect.height+boundsRect.y));
		e.x -= inputMgr.xOffset;
		e.y -= inputMgr.yOffset;
		e.x *= inputMgr.xScale;
		e.y *= inputMgr.yScale;
		var pt:TouchPoint = points[e.ID];
		pt.x = pt.tempX = e.x;
		pt.y = pt.tempY = e.y;
		activePoints.remove(pt);
		points[pt.id] = null;
		onTouchEnd.dispatch(pt);
	}
	
	public function touchBeginHandler(e:TouchEvent):Void 
	{
		var boundsRect = inputMgr.bounds;
		e.x = Math.max(boundsRect.x, Math.min(e.x, boundsRect.width+boundsRect.x));
		e.y = Math.max(boundsRect.y, Math.min(e.y, boundsRect.height+boundsRect.y));
		e.x -= inputMgr.xOffset;
		e.y -= inputMgr.yOffset;
		e.x *= inputMgr.xScale;
		e.y *= inputMgr.yScale;
		var pt:TouchPoint = new TouchPoint(e.ID, e.x, e.y);
		points[e.ID] = pt;
		activePoints.push(pt);
		onTouchBegin.dispatch(pt);
	}
	
	inline function updatePoint(p:TouchPoint):Void 
	{
		p.deltaX = p.tempX - p.x;
		p.deltaY = p.tempY - p.y;
		p.x = p.tempX;
		p.y = p.tempY;
	}
	
	public function update(?game:Core):Void 
	{
		for (p in activePoints) 
		{
			updatePoint(p);
		}
	}
	
	public function reset():Void {
		points = new Array<TouchPoint>();
		activePoints = new Array<TouchPoint>();
		onTouchBegin.removeAll();
		onTouchMove.removeAll();
		onTouchEnd.removeAll();
	}
	
}