package com.furusystems.flywheel.utils.data;
import flash.display.BitmapData;
import flash.utils.ByteArray;
import format.png.Reader;
import format.png.Tools;
import haxe.io.Bytes;
import haxe.io.BytesInput;

/**
 * ...
 * @author Andreas Rønning
 */
class PNGDecoder
{

	#if flash
	public static function decode(bytearray:ByteArray):BitmapData {
		var data = new Reader(new BytesInput(Bytes.ofData(bytearray))).read();
		var header = Tools.getHeader(data);
		var bmd:BitmapData = new BitmapData(header.width, header.height, true, 0);
		var bytes = Tools.extract32(data).getData();
		bytes.position = 0;
		bmd.setPixels(bmd.rect, bytes);
		return bmd;
	}
	#end
	
}