package com.furusystems.flywheel.display.rendering.animation.gts;
import com.furusystems.flywheel.display.rendering.lime.materials.PNGTexture;
import com.furusystems.flywheel.display.rendering.lime.resources.TextureHandle;
import com.furusystems.flywheel.display.rendering.lime.tiles.LimeTileSheet;
import com.furusystems.flywheel.utils.data.SizedHash;
import com.furusystems.flywheel.display.rendering.animation.ISpriteSequence;
import com.furusystems.flywheel.display.rendering.animation.ISpriteSheet;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.Json;
import lime.utils.Assets;
import lime.utils.ByteArray;
#if threading
import cpp.vm.Mutex;
#end


/**
 * ...
 * @author Andreas Rønning
 */

class GTSSheet implements ISpriteSheet
{
	public var texture:TextureHandle;
	public var sequences:SizedHash<ISpriteSequence>; //I keep a stack of sequences used with this spritesheet for possible future convenience
	public var tilesheet:LimeTileSheet;
	private var frameIndexBase:Int;
	
	public var _nativeResolutionX:Int;
	public var _nativeResolutionY:Int;
	public var parsedDescriptor:Dynamic;
	public var path:String;
	
	public var halfRes:Bool;
	public function new(assetPath:String):Void {
		this.path = assetPath;
		
		sequences = new SizedHash<ISpriteSequence>();
		
		trace("Reading GTS: " + assetPath);
		var bytes:ByteArray = Assets.getBytes(assetPath);
		
		bytes.uncompress();
		bytes.position = 0;
		var version:String = bytes.readUTF();
		trace("\tGTS version: " + version);
		if (version != "2.0") {
			throw "Outdated GTS format";
		}
		var json:String = bytes.readUTF();
		parsedDescriptor = Json.parse(json);
		
		var imgCount:Int = bytes.readShort();
		trace("imagecount: " + imgCount);
		
		//find the texture with the resolution we want
		_nativeResolutionX = _nativeResolutionY = halfRes?Std.int(parsedDescriptor.resolution * 0.5):Std.int(parsedDescriptor.resolution);
		var txFound:Bool = false;
		
		for (i in 0...imgCount) {
			var dims:Int = bytes.readShort();
			var filesize:Int = bytes.readUnsignedInt();
			if(dims==_nativeResolutionX){
				var imgBytes = new ByteArray();
				bytes.readBytes(imgBytes, 0, filesize);
				imgBytes.position = 0;
				texture = new TextureHandle(imgBytes);
				texture.acquire();
				imgBytes.clear();
				txFound = true;
				break;
			}else {
				bytes.position += filesize;
			}
		}
		
		for (i in 0...parsedDescriptor.sequences.length) {
			addSequence(GTSSequence.fromObject(parsedDescriptor.sequences[i], halfRes));
		}
		
		tilesheet = createTileSheet(texture.tex);
		
		bytes.clear();
		
		#if threading
		m.release();
		#end
	}
	
	public function dispose():Void {
		parsedDescriptor = null;
		sequences = null;
		texture.release();
	}
	
	public function createTileSheet(tex:PNGTexture):LimeTileSheet
	{
		var out = new LimeTileSheet();
		frameIndexBase = 0;
		for (s in sequences) {
			applySequenceToSheet(tex, out, s);
		}
		return out;
	}
	
	/**
	 * Add a sprite sequence to this sprite sheet
	 * @param	s
	 * @return
	 */
	public function addSequence(s:ISpriteSequence):ISpriteSequence 
	{
		sequences.set(s.name, s);
		s.sheet = this;
		return s;
	}
	
	private function applySequenceToSheet(tex:PNGTexture, tilesheet:LimeTileSheet, s:ISpriteSequence):Void {
		var ss:GTSSequence = cast s;
		trace("Adding sequence: " + ss.name);
		for (f in ss.frames) {
			var t = tilesheet.addTile(tex.width, tex.height, f.x, f.y, f.width, f.height, f.center.x, f.center.y);
			//trace("Added tile: " + t.index);
			f.tileSheetIndex = t.index;
			//frameIndexBase++;
		}
		ss.refreshInfo();
	}
	
	
	public function getSequenceByName(name:String):ISpriteSequence {
		if (sequences.exists(name)) {
			return sequences.get(name);
		}
		throw "No sequence by name: " + name;
	}
	
}