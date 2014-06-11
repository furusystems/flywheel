package com.furusystems.flywheel.display.rendering.lime.font;
import com.furusystems.bmfont.CharacterDef;
import com.furusystems.bmfont.FontDef;
import com.furusystems.bmfont.Reader;
import com.furusystems.flywheel.display.rendering.lime.materials.PNGTexture;
import com.furusystems.flywheel.display.rendering.lime.tiles.LimeTileSheet;
import haxe.io.BytesInput;
import lime.utils.Assets;

/**
 * ...
 * @author Andreas Rønning
 */
class LimeBitmapFont
{
	var def:FontDef;
	public var tilesheet:LimeTileSheet;
	public var texture:PNGTexture;
	public function new(basePath:String, fontFile:String) 
	{
		def = Reader.read(Assets.getBytes(basePath + fontFile));
		texture = PNGTexture.fromFile(basePath + def.pageFileNames[0]);
		tilesheet = new LimeTileSheet();
		for (i in 0...def.charMap.length) {
			var char = def.charMap[i];
			if (char != null) {
				var t = tilesheet.addTile(def.texWidth, def.texHeight, char.x, char.y, char.width, char.height, char.halfWidth, char.halfHeight, char.id);
			}
		}
	}
	public function dispose() {
		texture.dispose();
		def = null;
	}
	public inline function draw(str:String, x:Int, y:Int, center:Bool = false):Array<Float> {
		var out = new Array<Float>();
		drawTo(out, 0, str, x, y, center);
		return out;
	}
	public function drawTo(target:Array<Float>, idx:Int, str:String, x:Int = 0, y:Int= 0, center:Bool = false):Int
	{
		x += def.paddingLeft;
		y += def.paddingUp;
		var out:Array<Float> = target;
		var offsetX:Int = 0;
		var offsetY:Int = 0;
		var startX:Int = x;
		var h:Int = 0;
		var w:Int = 0;
		var initIndex:Int = idx;
		var items:Int = 0;
		var prevChar:Int = -1;
		for (i in 0...str.length)
		{
			var code = str.charCodeAt(i);
			var char = StringTools.fastCodeAt(str, i);
			if (char == 10)
			{
				// backslash linebreak
				offsetX = startX;
				offsetY += def.lineHeight;
			}
			
			var c = def.charMap[char];
			if (c == null) {
				#if debug
				trace(String.fromCharCode(char) + "(" + char + ") does not exist");
				#end
				continue;
			}
			
			out[idx] = c.id;
			//var k= c.kerningPairs[prevChar];
			//if (k != 0) {
				//offsetX -= k;
			//}
			out[idx + 1] = (x + offsetX + c.halfWidth + c.xOffset);
			out[idx + 2] = (y + offsetY + c.halfHeight + c.yOffset);
			items++;
			idx += 3;
			w += c.xAdvance;
			h = Std.int(Math.max(h, c.height));
			offsetX += c.xAdvance;
			prevChar = c.id;
		}
		if (center) {
			var i:Int = initIndex;
			while (i < initIndex+(items*3)) {
				out[i+1] -= w >> 1;
				out[i+2] -= h >> 1;
				i += 3;
			}
		}
		return idx;
	}
	
}