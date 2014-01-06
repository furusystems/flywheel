package com.furusystems.flywheel.display.rendering.animation.gts;
import com.furusystems.flywheel.utils.data.SizedHash;
import com.furusystems.flywheel.display.rendering.animation.ISpriteSequence;
import com.furusystems.flywheel.display.rendering.animation.ISpriteSheet;
import com.furusystems.flywheel.display.rendering.utils.PNGDecoder;
import com.furusystems.system.BitmapManager;
import flash.geom.Point;
import format.png.Reader;
import format.png.Tools;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.Json;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import openfl.Assets;
import openfl.display.Tilesheet;
import flash.errors.Error;
import flash.utils.ByteArray;
#if threading
import cpp.vm.Mutex;
#end


/**
 * ...
 * @author Andreas Rønning
 */

class GTSSheet implements ISpriteSheet
{
	public var texture:BitmapData;
	public var textureset:SizedHash<BitmapData>;
	
	public var sequences:SizedHash<ISpriteSequence>; //I keep a stack of sequences used with this spritesheet for possible future convenience
	
	public var tilesheet:Tilesheet;
	
	private var frameIndexBase:Int;
	
	public var _nativeResolutionX:Int;
	public var _nativeResolutionY:Int;
	public var parsedDescriptor:Dynamic;
	public var protected:Bool;
	public var path:String;
	
	public  var halfRes:Bool;
	public function new(assetPath:String, bytes:ByteArray, protected:Bool = false, halfRes:Bool = false):Void {
		this.halfRes = halfRes;
		this.protected = protected;
		this.path = assetPath;
		#if threading
		var m:Mutex = new Mutex();
		m.acquire();
		#end
		
		sequences = new SizedHash<ISpriteSequence>();
		textureset = new SizedHash<BitmapData>();
		
		
		
		trace("Reading GTS: " + assetPath);
		
		bytes.uncompress();
		bytes.position = 0;
		var version:String = bytes.readUTF();
		trace("\tGTS version: " + version);
		if (version != "2.0") {
			throw new Error("Outdated GTS format");
		}
		var json:String = bytes.readUTF();
		parsedDescriptor = Json.parse(json);
		
		var imgCount:Int = bytes.readShort();
		
		//find the texture with the resolution we want
		_nativeResolutionX = _nativeResolutionY = halfRes?Std.int(parsedDescriptor.resolution * 0.5):Std.int(parsedDescriptor.resolution);
		var txFound:Bool = false;
		
		for (i in 0...imgCount) {
			var dims:Int = bytes.readShort();
			var filesize:Int = bytes.readUnsignedInt();
			if(dims==_nativeResolutionX){
				var imgBytes:ByteArray = new ByteArray();
				bytes.readBytes(imgBytes, 0, filesize);
				imgBytes.position = 0;
				texture = addTexture(imgBytes);
				imgBytes.clear();
				txFound = true;
				break;
			}else {
				bytes.position += filesize;
			}
		}
		if (!txFound) {
			throw new Error("No texture of resolution " + _nativeResolutionX + " found for GTS: " + assetPath);
		}

		
		
		for (i in 0...parsedDescriptor.sequences.length) {
			addSequence(GTSSequence.fromObject(parsedDescriptor.sequences[i], halfRes));
		}
		var bmd:BitmapData = getNativeRes();
		tilesheet = createTileSheet(bmd);
		
		#if (dumpbits && !flash)
		for (t in textureset) {
			t.dumpBits();
		}
		#end
		
		bytes.clear();
		
		#if threading
		m.release();
		#end
	}
	
	public function dispose():Void {
		parsedDescriptor = null;
		sequences = null;
		texture.dispose();
		for (t in textureset) {
			t.dispose();
		}
	}
	
	public function createTileSheet(tex:BitmapData):Tilesheet 
	{
		var out:Tilesheet = new Tilesheet(tex);
		frameIndexBase = 0;
		for (s in sequences) {
			applySequenceToSheet(out, s);
		}
		#if dumpbits
		tex.dumpBits();
		#end
		return out;
	}
	
	public function getNativeRes():BitmapData 
	{
		if (textureset.size == 1) {
			for (t in textureset) {
				return t;
			}
		}else{
			var name:String = "texture_" + _nativeResolutionX;
			return textureset.get(name);
		}
		return null;
	}
	
	private function addTexture(bytearray:ByteArray):BitmapData 
	{
		#if cpp
		var loader:Loader = new Loader();
		loader.loadBytes(bytearray);
		var bmd:BitmapData = cast(loader.content, Bitmap).bitmapData;
		#else
		var bmd:BitmapData = PNGDecoder.decodeImage(bytearray);
		#end
		
		textureset.set("texture_" + bmd.width, bmd);
		return BitmapManager.register("texture_" + bmd.width, bmd);
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
	
	private function applySequenceToSheet(tilesheet:Tilesheet, s:ISpriteSequence):Void {
		var ss:GTSSequence = cast s;
		for (f in ss.frames) {
			tilesheet.addTileRect(f, f.center);
			f.tileSheetIndex = frameIndexBase;
			frameIndexBase++;
		}
		ss.refreshInfo();
	}
	
	
	public function getSequenceByName(name:String):ISpriteSequence {
		if (sequences.exists(name)) {
			return sequences.get(name);
		}
		throw new Error("No sequence by name: " + name);
	}
	
}