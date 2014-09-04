package com.furusystems.flywheel.input;
import com.furusystems.flywheel.input.touch.TouchPoint;
#if flash
import flash.events.TouchEvent;
#elseif (lime&&!openfl)
import lime.InputHandler.TouchEvent;
#elseif openfl
import openfl.events.TouchEvent;
#end
import fsignal.Signal1;
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
		var x:Float = #if (flash||openfl) e.stageX; #elseif lime e.x;  #end
		var y:Float = #if (flash||openfl) e.stageY; #elseif lime e.y;  #end
		x = Math.max(boundsRect.x, Math.min(x, boundsRect.width+boundsRect.x));
		y = Math.max(boundsRect.y, Math.min(y, boundsRect.height+boundsRect.y));
		x -= inputMgr.xOffset;
		y -= inputMgr.yOffset;
		x *= inputMgr.xScale;
		y *= inputMgr.yScale;
		var p:TouchPoint = points[#if (flash||openfl) e.touchPointID #elseif lime e.ID #end];
		p.tempX = x;
		p.tempY = y;
		onTouchMove.dispatch(p);
	}
	
	public function touchEndHandler(e:TouchEvent):Void 
	{
		var boundsRect = inputMgr.bounds;
		var x:Float = #if (flash||openfl) e.stageX; #elseif lime e.x;  #end
		var y:Float = #if (flash||openfl) e.stageY; #elseif lime e.y;  #end
		x = Math.max(boundsRect.x, Math.min(x, boundsRect.width+boundsRect.x));
		y = Math.max(boundsRect.y, Math.min(y, boundsRect.height+boundsRect.y));
		x -= inputMgr.xOffset;
		y -= inputMgr.yOffset;
		x *= inputMgr.xScale;
		y *= inputMgr.yScale;
		var pt:TouchPoint = points[#if (flash||openfl) e.touchPointID #elseif lime e.ID #end];
		pt.x = pt.tempX = x;
		pt.y = pt.tempY = y;
		activePoints.remove(pt);
		points[pt.id] = null;
		onTouchEnd.dispatch(pt);
	}
	
	public function touchBeginHandler(e:TouchEvent):Void 
	{
		var boundsRect = inputMgr.bounds;
		var x:Float = #if (flash||openfl) e.stageX; #elseif lime e.x;  #end
		var y:Float = #if (flash||openfl) e.stageY; #elseif lime e.y;  #end
		x = Math.max(boundsRect.x, Math.min(x, boundsRect.width+boundsRect.x));
		y = Math.max(boundsRect.y, Math.min(y, boundsRect.height+boundsRect.y));
		x -= inputMgr.xOffset;
		y -= inputMgr.yOffset;
		x *= inputMgr.xScale;
		y *= inputMgr.yScale;
		var id = #if (flash||openfl) e.touchPointID #elseif lime e.ID #end;
		var pt:TouchPoint = new TouchPoint(id, x, y);
		points[id] = pt;
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
	
	public function update():Void 
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