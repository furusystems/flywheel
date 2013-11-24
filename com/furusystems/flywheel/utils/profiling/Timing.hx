package com.furusystems.flywheel.utils.profiling;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.Lib;
import flash.text.TextField;
import haxe.Timer;

/**
 * ...
 * @author Andreas Rønning
 */
class Timing 
{
	static public var debugDraw:Sprite = new Sprite();
	
	static private var t:Float;
	static private var peakUpdateTime:Float = 0;
	static private var peakRenderTime:Float = 0;
	static private var peakFrameTime:Float = 0;

	public static var liveMap:Map<String, Float> = new Map<String,Float>();
	public static var methodMap:Map<String, Float> = new Map<String,Float>();
	public static var peakMap:Map<String, Float> = new Map<String,Float>();
	public static var renderMap:Map<String, Float> = new Map<String,Float>();
	
	public static var renderTime:Float = 0;
	public static var updateTime:Float = 0;
	public static var frameTime:Float = 0;
	
	private static var lowpassedUpdateTime:Float = 0;
	private static var lowpassedRenderTime:Float = 0;
	private static var lowpassedFrameTime:Float = 0;
	static private var fields:Array<DebugField>;
	
	public static inline function tick():Void {
		#if timings
		t = Timing.stamp();
		#end
	}
	public static inline function tock(name:String):Float {
		#if timings
		var delta:Float = Timing.stamp() - t;
		methodMap.set(name, methodMap.get(name) + delta);
		return delta;
		#else
		return 0;
		#end
	}
	public static inline function set(name:String, value:Float):Void {
		methodMap.set(name, value);
	}
	public static function reset():Void {
		 peakUpdateTime  = 0;
		 peakRenderTime  = 0;
		 peakFrameTime  = 0;
			 
		 liveMap = new Map<String, Float>();
		 peakMap = new Map<String, Float>();
		 renderMap = new Map<String, Float>();
		 methodMap = new Map<String, Float>();
	}
	public static function draw(totalTime:Float):Sprite {
		if (totalTime > peakFrameTime) {
			peakFrameTime = totalTime;
		}
		lowpassedFrameTime += (totalTime - lowpassedFrameTime) * 0.02;
		
		if (renderTime > peakRenderTime) {
			peakRenderTime = renderTime;
		}
		lowpassedRenderTime += (renderTime - lowpassedRenderTime) * 0.02;
		
		if (updateTime > peakUpdateTime) {
			peakUpdateTime = updateTime;
		}
		lowpassedUpdateTime += (updateTime - lowpassedUpdateTime) * 0.02;
		
		debugDraw.graphics.clear();
		while (debugDraw.numChildren > 0) {
			debugDraw.removeChildAt(0);
		}
		var f = new DebugField("Frame time: " + "FPS: "+FPSCounter.fps+"/"+Lib.current.stage.frameRate+"\t"+lowpassedFrameTime, 1, 1);
		f.draw();
		f = new DebugField("Update time: " + lowpassedUpdateTime, lowpassedUpdateTime / lowpassedFrameTime, 0);
		f.y = 20;
		f.draw();
		f = new DebugField("Render time: " + lowpassedRenderTime, 0, lowpassedRenderTime / lowpassedFrameTime);
		f.y = 40;
		f.draw();
		fields = [];
		var yp:Int = 3;
		for (k in methodMap.keys()) {
			var live:Float = methodMap.get(k) / lowpassedFrameTime;
			f = new DebugField(k, live, 0);
			f.y = yp * 20;
			f.draw();
			yp++;
		}
		var max:Int = 10;
		for (k in peakMap.keys()) {
			if (max-- <= 0) break;
			var live:Float = liveMap.get(k) / lowpassedFrameTime;
			var peak:Float = peakMap.get(k) / lowpassedFrameTime;
			var render:Float = renderMap.get(k) / lowpassedFrameTime;
			field(k, live, render);
		}
		fields.sort(sortFields);
		var prevField:DebugField = null;
		var offsetA:Float = 0;
		var offsetB:Float = 0;
		for (i in 0...fields.length) {
			fields[i].y = yp++ * 20;
			fields[i].draw(offsetA,offsetB);
			prevField = fields[i];
			//offsetA += prevField.ratioA;
			//offsetB += prevField.ratioB;
		}
		return debugDraw;
	}
	
	static private function sortFields(a:DebugField, b:DebugField):Int
	{
		if (!a.sorted) return -1;
		var sumA:Float = a.ratioA + a.ratioB;
		var sumB:Float = b.ratioA + b.ratioB;
		if (sumA < sumB) return 1;
		else if (sumA > sumB) return -1;
		else return 0;
	}
	private static inline function field(name:String, ratioA:Float, ratioB:Float,sorted:Bool = true):Void {
		fields.push(new DebugField(name, ratioA, ratioB,sorted));
	}
	
	public static inline function stamp():Float {
		return Timer.stamp();
	}
	
	static public function clearMaps() 
	{
		liveMap = new Map<String, Float>();
		peakMap = new Map<String, Float>();
		renderMap = new Map<String, Float>();
		methodMap = new Map<String, Float>();
	}
	
}
private class DebugField extends TextField {
	public var ratioA:Float;
	public var ratioB:Float;
	public var sorted:Bool;
	public function new(name:String, ratioA:Float, ratioB:Float, sorted:Bool = true) {
		super();
		this.sorted = sorted;
		this.ratioA = ratioA;
		this.ratioB = ratioB;
		textColor = 0xFFFF00;
		text = name + "\t" +ratioA * 100 + "%\t" + ratioB * 100 + "%";
		width = 700;
		mouseEnabled = false;
	}
	public function draw(offsetA:Float = 0, offsetB:Float = 0):DebugField {
		Timing.debugDraw.addChild(this);
		var g:Graphics = Timing.debugDraw.graphics;
		if (offsetA != 0) {
			g.beginFill(0, 0.4);
			g.drawRect(0, y, offsetA*width, 9);
			g.endFill();
		}
		if (offsetB != 0) {
			g.beginFill(0, 0.4);
			g.drawRect(0, y+10, offsetB*width, 9);
			g.endFill();
		}
		g.beginFill(0xFF0000, 0.4);
		g.drawRect(offsetA*width, y, ratioA*width, 9);
		g.endFill();
		g.beginFill(0x00FF00, 0.4);
		g.drawRect(offsetB*width, y+10, ratioB*width, 9);
		g.endFill();
		return this;
	}
}
