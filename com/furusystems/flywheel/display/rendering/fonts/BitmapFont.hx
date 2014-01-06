package com.furusystems.flywheel.display.rendering.fonts;
import com.furusystems.system.BitmapManager;
import haxe.ds.Vector;
import openfl.Assets;
import flash.display.BitmapData;
import flash.geom.Rectangle;
import openfl.display.Tilesheet;


/**
 * ...
 * @author Andreas Rønning
 */

class BitmapFont
{
	public var sheet:Tilesheet;
	public var charMap:Vector<Character>;
	public var cache:Map<String, Array<Float>>;
	
	public var face:String;
	public var size:Int;
	public var bold:Bool;
	public var italic:Bool;
	public var charset:String;
	public var unicode:Bool;
	public var stretchH:Int;
	public var smooth:Bool;
	public var aa:Bool;
	public var padding:String;
	public var spacing:String; 
	public var kerning:Int;
	public var outline:Bool;
	
	public var lineHeight:Int;
	public var base:Int;
	public var scaleW:Int;
	public var scaleH:Int;
	public var pages:Int;
	public var packed:Bool;
	public var alphaChnl:Int;
	public var redChnl:Int;
	public var greenChnl:Int;
	public var blueChnl:Int;
	public var chars:Int;
	public var count:Int;
	
	//TODO: Support multiple pages
	public var id:Int;
	public var file:String;
	public var texture:BitmapData;
	public var tilesheet:Tilesheet;
	
	public function new(texturePath:String, descriptorPath:String) 
	{
		
		//trace("Processing descriptor");
		cache = new Map<String, Array<Float>>();
		
		var descriptor:String = Assets.getText(descriptorPath);
		
		var lines:Array<String> = descriptor.split("\n");
		charMap = new Vector<Character>(255);
		
		while (lines.length > 0) {
			processLine(lines.shift());
			//lines.shift();
		}
		configure(texturePath);
	}
	
	private function configure(texturePath:String) 
	{
		var bmd:BitmapData = BitmapManager.getBitmapData(texturePath);
		tilesheet = new Tilesheet(bmd);
		var idx:Int = 0;
		for (c in charMap) {
			if (c == null) continue;
			var r:Rectangle = new Rectangle();
			r.x = c.x;
			r.y = c.y;
			r.width = c.width;
			r.height = c.height;
			tilesheet.addTileRect(r);
			c.sheetIndex = idx;
			idx++;
		}
		#if (dumpbits && !flash)
		bmd.dumpBits();
		#end
	}
	private function processLine(line:String):Void {
		var s:Array<String> = line.split(" ");
		var lineType:String = s.shift();
		switch(lineType) {
			case "info":
				getProperties(this, s.join(" "));
			case "common":
				getProperties(this, s.join(" "));
			case "page":
				getProperties(this, s.join(" "));
			case "chars":
				getProperties(this, s.join(" "));
			case "char":
				processChar(s.join(" "));
		}
	}
	private function getProperties(targetObject:Dynamic, s:String):Void {
		var idx:Int = 0;
		var max:Int = s.length;
		var buffer:String = "";
		var key:String = "";
		var value:String = "";
		var string:Bool = false;
		while (idx < max) {
			switch(s.charAt(idx)) {
				case "=": //mark end of key
					key = buffer;
					buffer = "";
				case '"': //begin or end string
					string = !string;
					if (!string) {
						//a string has been ended, we assume it's a value
						value = buffer;
						setProperty(targetObject, key, value);
						key = value = buffer = "";
					}
				case " ":
					if(key!=""){
						if (!string) {
							value = buffer;
							setProperty(targetObject, key, value);
							key = value = buffer = "";
						}else {
							buffer += s.charAt(idx);
						}
					}
				default:
					buffer += s.charAt(idx);
			}
			idx++;
		}
		if (buffer.length>0&&key.length>0) { //manage the tail
			value = buffer;
			setProperty(targetObject, key, value);
		}
	}
	private inline function setProperty(ob:Dynamic, key:String, value:String):Void	{
		if (Type.typeof(Reflect.field(ob, key)) == Type.ValueType.TBool) { //holy whatshit
			Reflect.setField(ob, key, value == "1");
		}else {
			Reflect.setField(ob, key, value);
		}
	}
	
	private inline function processChar(s:String):Void
	{
		var c:Character = new Character();
		getProperties(c, s);
		charMap[c.id] = c;
	}
	public function draw(str:String, x:Float = 0, y:Float = 0, center:Bool = false):Array<Float>
	{
		var out:Array<Float> = new Array<Float>();
		drawTo(out, 0, str, x, y, center);
		return out;
	}
	public function drawTo(target:Array<Float>, idx:Int, str:String, x:Float = 0, y:Float = 0, center:Bool = false):Int
	{
		var out:Array<Float> = target;
		var offsetX:Int = kerning;
		var offsetY:Int = 0;
		var startX:Int = kerning;
		var characters:Array<String> = str.split("");
		var h:Int = 0;
		var w:Int = 0;
		var initIndex:Int = idx;
		var items:Int = 0;
		for (char in characters)
		{
			if (char == "\\")
			{
				// backslash linebreak
				offsetX = startX;
				offsetY += lineHeight;
			}
			
			var c:Character = charMap[char.charCodeAt(0)];
			if (c==null) {
				//trace(char+" does not exist");
				continue;
			}
			out[idx] = (x + offsetX + c.xoffset);
			out[idx + 1] = (y + offsetY + c.yoffset);
			out[idx + 2] = (c.sheetIndex);
			items++;
			idx += 3;
			w += c.xadvance;
			h = Std.int(Math.max(h, c.height));
			offsetX += c.xadvance;
		}
		if (center) {
			var i:Int = initIndex;
			while (i < initIndex+(items*3)) {
				out[i] -= w >> 1;
				out[i+1] -= h >> 1;
				i += 3;
			}
		}
		return idx;
	}
	public function drawCharCodesTo(target:Array<Float>, codes:Array<Int>, x:Float, y:Float, offset:Int = 0, center:Bool = false):Array<Float>
	{
		var out:Array<Float> = target;	
		var offsetX:Int = kerning;
		var offsetY:Int = 0;
		var startX:Int = kerning;
		var idx:Int = offset;
		var initIndex:Int = idx;
		var items:Int = 0;
		var lineWidths:Array<Int> = new Array<Int>(); // individual widths found per line (to allow centering to work over line breaks)
		var breakIndicies:Array<Int> = new Array<Int>(); // positions in the output at which linebreaks occur
		var w:Int = 0;
		var h:Int = 0;
		
		breakIndicies.push(0);
		
		for (char in codes)
		{
			if (char == 92)
			{
				// backslash linebreak
				offsetX = startX;
				offsetY += lineHeight;
				h = offsetY;
				lineWidths.push(w);
				breakIndicies.push(items);
				w = 0;
				continue;
			}
			
			var c:Character = charMap[char];
			if (c == null)
			{
				//trace(char+" does not exist");
				continue;
			}
			
			out[idx] = x + offsetX + c.xoffset;
			out[idx+1] = y + offsetY + c.yoffset;
			out[idx + 2] = c.sheetIndex;
			
			offsetX += c.xadvance;
			items++;
			w += c.xadvance;
			h = Std.int(Math.max(h, c.height));
			idx += 3;
		}
		
		// add final line width
		lineWidths.push(w);
		
		// center everything
		if (center)
		{
			var bi:Int = 0;
			while (bi < breakIndicies.length)
			{
				var istart:Int = breakIndicies[bi];
				var iend:Int = (bi == breakIndicies.length - 1) ? items : breakIndicies[bi + 1];
				for (i in istart...iend)
				{
					var ii:Int = initIndex + (i * 3);
					out[ii] -= lineWidths[bi] >> 1;
					out[ii + 1] -= h; // >> 1;
				}
				bi++;
			}
		}
		
		return out;
	}
	
	public function drawCharCodes(codes:Array<Int>, x:Float, y:Float):Array<Float> {
		var out:Array<Float> = new Array<Float>();
		var offsetX:Int = kerning;
		var offsetY:Int = 0;
		var startX:Int = kerning;
		for (char in codes)
		{
			if (char == 92)
			{
				// backslash linebreak
				offsetX = startX;
				offsetY += lineHeight;
				continue;
			}
			
			var c:Character = charMap[char];
			if (c==null) {
				//trace(char+" does not exist");
				continue;
			}
			
			out.push(x + offsetX + c.xoffset);
			out.push(y + offsetY + c.yoffset);
			out.push(c.sheetIndex);
			
			offsetX += c.xadvance;
		}
		return out;
	}
	
}