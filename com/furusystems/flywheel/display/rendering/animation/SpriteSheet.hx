package com.furusystems.flywheel.display.rendering.animation;
import com.furusystems.flywheel.display.rendering.animation.SpriteSheet;
import com.furusystems.system.BitmapManager;
import com.furusystems.utils.SizedHash;
import openfl.Assets;
import flash.display.BitmapData;
import openfl.display.Tilesheet;
import flash.geom.Point;
import flash.geom.Rectangle;


/**
 * General purpose sprite sheet that supports multiple sequences per sheet and also a couple of callbacks (enterframe, complete)
 * Wraps and manipulates a public TileDrawInstruction ready to be passed to the renderer
 * @author Andreas Rønning
 */

class SpriteSheet implements ISpriteSheet
{
	public var texture:BitmapData;
	
	public var sequences:SizedHash<ISpriteSequence>; //I keep a stack of sequences used with this spritesheet for possible future convenience
	public var currentSequence:ISpriteSequence; //The current sequence dictates what frame this SpriteSheet is currently outputting
	
	public var tilesheet:Tilesheet;
	public var currentTilesheetFrame:Int;
	/**
	 * Create a new Spritesheet with a default sequence
	 * @param	source The source texture
	 * @param	framewidth The width of a frame
	 * @param	frameheight The height of a frame
	 * @param	numFrames The number of frames contained in the sheet. x/y rows are counted left to right
	 * @param	frameRate The desired framerate for this spritesheet
	 */
	public function new(source:BitmapData, framewidth:Int, frameheight:Int, numFrames:Int,frameRate:Int,?createDefault:Bool = true,?buildTileSheet:Bool = true) 
	{
		sequences = new SizedHash<ISpriteSequence>();
		this.texture = source;
	}
	

	public function addSequence(s:ISpriteSequence):ISpriteSequence {
		sequences.set(s.name, s);
		return s;
	}
	
	public inline function getSequenceByName(name:String):ISpriteSequence {
		if (sequences.exists(name)) {
			return sequences.get(name);
		}else{
			return null;
		}
	}
	
	static public function createFromFilename(path:String, ?frameRate:Int = 30, ?createDefaultSequence:Bool = true ):ISpriteSheet 
	{
		var s:Array<String> = path.split("_");
		if(s.length>1){
			var end:String = s.pop();
			var numFrames:Int = Std.parseInt(end.split(".").shift());
			var height:Int = Std.parseInt(s.pop());
			var width:Int = Std.parseInt(s.pop());
			return new SpriteSheet(BitmapManager.getBitmapData(path,false), width, height, numFrames, frameRate, createDefaultSequence);
		}else {
			var bmd:BitmapData = BitmapManager.getBitmapData(path,false);
			return new SpriteSheet(bmd, bmd.width, bmd.height, 1, 1, true);
		}
		
	}
	public static function createTilesheetFromFilename(path:String):Tilesheet {
		var s:Array<String> = path.split("_");
		if(s.length>1){
			var end:String = s.pop();
			var numFrames:Int = Std.parseInt(end.split(".").shift());
			var height:Int = Std.parseInt(s.pop());
			var width:Int = Std.parseInt(s.pop());
			return makeTilesheet(BitmapManager.getBitmapData(path,false), width, height, numFrames);
		}else {
			var bmd:BitmapData = BitmapManager.getBitmapData(path,false);
			return makeTilesheet(bmd, bmd.width, bmd.height, 1);
		}
	}
	public static function parseInfoFromFilename(path:String):Array<Int> {
		var out:Array<Int> = new Array<Int>();
		var s:Array<String> = path.split("_");
		if(s.length>1){
			var end:String = s.pop();
			var numFrames:Int = Std.parseInt(end.split(".").shift());
			var height:Int = Std.parseInt(s.pop());
			var width:Int = Std.parseInt(s.pop());
			out.push(width);
			out.push(height);
			out.push(numFrames);
		}else {
			var bmd:BitmapData = BitmapManager.getBitmapData(path);
			out.push(bmd.width);
			out.push(bmd.height);
			out.push(1);
		}
		return out;
	}
	
	public static function makeTilesheet(source:BitmapData,framewidth:Float,frameheight:Float,numframes:Int):Tilesheet 
	{		
		var rect:Rectangle = new Rectangle(0, 0, framewidth, frameheight);	
		var tilesheet:Tilesheet = new Tilesheet(source);
		var pt:Point = new Point(framewidth * 0.5, frameheight * 0.5);
		var xOffset:Int = 0;
		var yOffset:Int = 0;
		for (i in 0...numframes) {
			if (xOffset * framewidth >= source.width) {
				xOffset = 0;
				yOffset++;
			}
			rect.x = xOffset * framewidth;
			rect.y = yOffset * frameheight;
			tilesheet.addTileRect(rect, pt);
			xOffset++;
		}
		
		#if dumpbits
		source.dumpBits();
		#end
		return tilesheet;
	}
	
}