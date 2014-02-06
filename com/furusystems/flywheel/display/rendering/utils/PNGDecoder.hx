package com.furusystems.flywheel.display.rendering.utils;
import flash.display.BitmapData;
import flash.utils.ByteArray;

class PNGDecoder {
	private static inline var IHDR:Int = 0x49484452;
	private static inline var IDAT:Int = 0x49444154;
	private static inline var tEXt:Int = 0x74455874;
	private static inline var iTXt:Int = 0x69545874;
	private static inline var zTXt:Int = 0x7A545874;
	private static inline var IEND:Int = 0x49454E44;

	private static var infoWidth:Int;
	private static var infoHeight:Int;
	private static var infoBitDepth:Int;
	private static var infoColourType:Int;
	private static var infoCompressionMethod:Int;
	private static var infoFilterMethod:Int;
	private static var infoInterlaceMethod:Int;

	private static var fileIn:ByteArray;
	private static var buffer:ByteArray;
	private static var scanline:Int;
	private static var samples:Int;

	//**************************************************************************************************************

	/* Decodes a png image stream to a BitmapData. If the ByteArray is not a png, returns null. */
	public static function decodeImage(bytes:ByteArray):BitmapData {
		if (bytes == null) return null;

		fileIn = bytes;
		buffer = new ByteArray();
		samples = 4;

		fileIn.position = 0;

		// signature check
		if (Std.int(fileIn.readUnsignedInt()) != 0x89504e47) return invalidPNG();
		if (Std.int(fileIn.readUnsignedInt()) != 0x0D0A1A0A) return invalidPNG();

		var chunks:Array<Dynamic> = getChunks();

		var countIHDR:Int = 0;
		var validChunk:Bool;
		var i:Int;

		for (i in 0...chunks.length) {
			fileIn.position = chunks[i].position;
			validChunk = true;

			if (chunks[i].type == IHDR) {
				++countIHDR;

				if (i == 0) validChunk = processIHDR(chunks[i].length);
				else validChunk = false;
			}

			if (chunks[i].type == IDAT) {
				buffer.writeBytes(fileIn, fileIn.position, chunks[i].length);
			}

			if (!validChunk || countIHDR > 1) return invalidPNG();
		}

		var bd:BitmapData = processIDAT();

		fileIn = null;
		buffer = null;

		return bd;
	}


	//**************************************************************************************************************
	// Textual data decoding




	//**************************************************************************************************************
	// Misc functions

	private static inline function invalidPNG():BitmapData {
		fileIn = null;
		buffer = null;

		return null;
	}

	private static inline function getChunks():Array<Dynamic> {
		var chunks:Array<Dynamic> = new Array<Dynamic>();
		var length:Int;
		var type:Int;

		do {
			length = fileIn.readUnsignedInt();
			type = fileIn.readInt();

			chunks.push({type: type, position: fileIn.position, length: length});
			fileIn.position += length + 4; //data length + CRC (4 bytes)
		}
		while (type != IEND && fileIn.bytesAvailable > 0);

		return chunks;
	}

	//**************************************************************************************************************
	// Header & image chunks processing

	private static function processIHDR(cLength:Int):Bool {
		if (cLength != 13) return false;

		infoWidth 				= fileIn.readUnsignedInt();
		infoHeight 				= fileIn.readUnsignedInt();
		infoBitDepth 			= fileIn.readUnsignedByte();
		infoColourType 			= fileIn.readUnsignedByte();
		infoCompressionMethod 	= fileIn.readUnsignedByte();
		infoFilterMethod 		= fileIn.readUnsignedByte();
		infoInterlaceMethod 	= fileIn.readUnsignedByte();

		if (infoWidth <= 0 || infoHeight <= 0) return false;

		switch (infoBitDepth) {
			case 1:
			case 2:
			case 4:
			case 8:
			case 16:
			default: return false;
		}

		switch (infoColourType) {
			case 0:
				if (
					infoBitDepth != 1 &&
					infoBitDepth != 2 &&
					infoBitDepth != 4 &&
					infoBitDepth != 8 &&
					infoBitDepth != 16
				) return false;

			case 2:
			case 4:
			case 6:
				if (
					infoBitDepth != 8 &&
					infoBitDepth != 16
				) return false;

			case 3:
				if (
					infoBitDepth != 1 &&
					infoBitDepth != 2 &&
					infoBitDepth != 4 &&
					infoBitDepth != 8
				) return false;

			default: return false;
		}

		if (infoCompressionMethod != 0 || infoFilterMethod != 0) return false;
		if (infoInterlaceMethod != 0 && infoInterlaceMethod != 1) return false;

		return true;
	}

	private static function processIDAT():BitmapData {
		var bd:BitmapData = new BitmapData(infoWidth, infoHeight);

		var bufferLen:Int;
		var filter:Int;
		var i:Int;

		var r:Int;
		var g:Int;
		var b:Int;
		var a:Int;

		try { buffer.uncompress(); }
		catch (err:Dynamic) { return null; }

		scanline = 0;
		bufferLen = buffer.length;

		while (Std.int(buffer.position) < bufferLen) {
			filter = buffer.readUnsignedByte();

			// check each scanline filter
			if (filter == 0) {
				for (i in 0...infoWidth ) {
					r = noSample() << 16;
					g = noSample() << 8;
					b = noSample();
					a = noSample() << 24;

					bd.setPixel32(i, scanline, a + r + g + b);
				}
			}
			else
			if (filter == 1) {
				for (i in 0...infoWidth) {
					r = subSample() << 16;
					g = subSample() << 8;
					b = subSample();
					a = subSample() << 24;

					bd.setPixel32(i, scanline, a + r + g + b);
				}
			}
			else
			if (filter == 2) {
				for (i in 0...infoWidth) {
					r = upSample() << 16;
					g = upSample() << 8;
					b = upSample();
					a = upSample() << 24;

					bd.setPixel32(i, scanline, a + r + g + b);
				}
			}
			else
			if (filter == 3) {
				for (i in 0...infoWidth) {
					r = averageSample() << 16;
					g = averageSample() << 8;
					b = averageSample();
					a = averageSample() << 24;

					bd.setPixel32(i, scanline, a + r + g + b);
				}
			}
			else
			if (filter == 4) {
				for (i in 0...infoWidth) {
					r = paethSample() << 16;
					g = paethSample() << 8;
					b = paethSample();
					a = paethSample() << 24;

					bd.setPixel32(i, scanline, a + r + g + b);
				}
			}
			else {
				buffer.position += samples * infoWidth;
			}

			++scanline;
		}

		return bd;
	}

	//**************************************************************************************************************
	// Scanline filters

	private static function noSample():Int {
		return buffer[buffer.position++];
	}

	private static function subSample():Int {
		var ret:Int = buffer[buffer.position] + byteA();

		ret &= 0xff;
		buffer[buffer.position++] = ret;

		return ret;
	}

	private static function upSample():Int {
		var ret:Int = buffer[buffer.position] + byteB();

		ret &= 0xff;
		buffer[buffer.position++] = ret;

		return ret;
	}

	private static function averageSample():Int {
		var ret:Int = buffer[buffer.position] + Math.floor((byteA() + byteB())/2);

		ret &= 0xff;
		buffer[buffer.position++] = ret;

		return ret;
	}

	private static function paethSample():Int {
		var ret:Int = buffer[buffer.position] + paethPredictor();

		ret &= 0xff;
		buffer[buffer.position++] = ret;

		return ret;
	}

	//**************************************************************************************************************
	// Misc functions

	private static function paethPredictor():Int {
		var a:Int = byteA();
		var b:Int = byteB();
		var c:Int = byteC();

		var p:Int = 0;
		var pa:Int = 0;
		var pb:Int = 0;
		var pc:Int = 0;
		var Pr:Int = 0;

		p = a + b - c;

		pa = cast Math.abs(p - a);
		pb = cast Math.abs(p - b);
		pc = cast Math.abs(p - c);

		if (pa <= pb && pa <= pc) Pr = a;
		else
		if (pb <= pc) Pr = b;
		else
		Pr = c;

		return Pr;
	}

	/* The byte corresponding to the one being filtered from the pixel to the left. */
	private static function byteA():Int {
		var init:Int = scanline * (infoWidth * samples + 1);
		var priorIndex:Int = buffer.position - samples;

		if (priorIndex <= init) return 0;

		return buffer[priorIndex];
	}

	/* The byte corresponding to the one being filtered from the pixel at the top. */
	private static function byteB():Int {
		var priorIndex:Int = buffer.position - (infoWidth * samples + 1);

		if (priorIndex < 0) return 0;

		return buffer[priorIndex];
	}

	/* The byte corresponding to the one being filtered from the pixel to the left from the pixel at the top. */
	private static function byteC():Int {
		var priorIndex:Int = buffer.position - (infoWidth * samples + 1);

		if (priorIndex < 0) return 0;

		var init:Int = (scanline - 1) * (infoWidth * samples + 1);
		priorIndex = priorIndex - samples;

		if (priorIndex <= init) return 0;

		return buffer[priorIndex];
	}
}