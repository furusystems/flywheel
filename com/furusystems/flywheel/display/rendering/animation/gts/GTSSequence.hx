package com.furusystems.flywheel.display.rendering.animation.gts;
import com.furusystems.flywheel.display.rendering.animation.ISpriteSequence;
import com.furusystems.flywheel.display.rendering.animation.ISpriteSheet;
import com.furusystems.flywheel.display.rendering.animation.LoopStyle;
import flash.geom.Point;
import flash.geom.Rectangle;


/**
 * ...
 * @author Andreas Rønning
 */
class GTSSequence implements ISpriteSequence
{
	public static inline var AREA_NONE:Int = -1;
	public static inline var AREA_CIRCLE:Int = 0;
	public static inline var AREA_RECT:Int = 1;
	
	public var frames:Array<GTSTile>;
	public var name:String;
	
	public var numframes:Int;
	public var startFrame:Int;
	public var endFrame:Int;
	
	public var looping:Bool;
	public var loopStyle:LoopStyle;
	public var framerate:Int;
	
	public var secondsPerFrame:Float;
	public var totalSequenceTime:Float;
	
	public var sheet:ISpriteSheet;
	
	public var hitAreaType:Int;
	public var hitboxWidth:Int;
	public var hitboxHeight:Int;
	public var hitCircleRadius:Float;
	
	public var pixelBoundsX:Int;
	public var pixelBoundsY:Int;
	
	public function new(name:String) 
	{
		this.name = name;
		hitAreaType = GTSSequence.AREA_NONE;
		hitboxHeight = hitboxWidth = 0;
		hitCircleRadius = 0;
		
		frames = new Array<GTSTile>();
		
		framerate = 30;
		
		loopStyle = LoopStyle.normal;
		looping = false;
	}
	
	public function addTile(rect:Rectangle):GTSTile {
		var t:GTSTile = new GTSTile(rect);
		frames.push(t);
		return t;
	}
	
	public function refreshInfo():Void 
	{
		startFrame = frames[0].tileSheetIndex;
		endFrame = frames[frames.length - 1].tileSheetIndex;
		numframes = (endFrame-startFrame + 1);
		totalSequenceTime = numframes * secondsPerFrame;
	}
	
	public function toString():String
	{
		return "Sequence: " + name + ", " + startFrame + ", " + endFrame + ", " + numframes;
	}
	public static function fromObject(ob:Dynamic, halfRes:Bool = false):ISpriteSequence { 
		var mult:Float = halfRes?0.5:1;
		var out:GTSSequence = new GTSSequence(ob.name);
		out.secondsPerFrame = 1 / ob.framerate;
		out.looping = ob.looping;
		out.hitAreaType = ob.hitareatype;
		if (ob.bounds != null) {
			out.pixelBoundsX = cast ob.bounds.width;
			out.pixelBoundsY = cast ob.bounds.height;
		}else {
			out.pixelBoundsX = 0;
			out.pixelBoundsY = 0;
		}
		switch(out.hitAreaType) {
			case GTSSequence.AREA_CIRCLE:
				out.hitCircleRadius = ob.radius;
			case GTSSequence.AREA_RECT:
				out.hitboxWidth = Std.int(ob.hitbox.width);
				out.hitboxHeight = Std.int(ob.hitbox.height);
		}
		for (i in 0...ob.tiles.length) {
			var o:Dynamic = ob.tiles[i];
			var t:GTSTile = out.addTile(new Rectangle(o.rect.x*mult, o.rect.y*mult, o.rect.width*mult, o.rect.height*mult));
			t.center.x = o.center.x * mult;
			t.center.y = o.center.y * mult;
		}
		return out;
	}
	private static var frameBounds:Rectangle = new Rectangle();
	public function getFrameBounds(idx:Int):Rectangle {
		var r:Rectangle = frames[idx];
		frameBounds.x = r.x;
		frameBounds.y = r.y;
		frameBounds.width = r.width;
		frameBounds.height = r.height;
		return frameBounds;
	}
	private static var tileMetrics:GTSTileMetrics = new GTSTileMetrics();
	private static var emptyMetrics:GTSTileMetrics = new GTSTileMetrics();
	public function getTileMetrics(idx:Int):GTSTileMetrics {
		if (frames.length < idx) {
			return emptyMetrics;
		}else{
			tileMetrics.offset = frames[idx].center;
			tileMetrics.bounds = getFrameBounds(idx);
			return tileMetrics;
		}
	}
	
}