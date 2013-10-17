package com.furusystems.flywheel.preprocessing;
import haxe.io.Bytes;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileSeek;
//using Lambda;
/**
 * ...
 * @author Andreas Rønning
 */
class Util
{
	public static inline function cleanName(s:String):String {
		//return s;
		//TODO: Wtf?
		var idx:Int = s.indexOf("-");
		while (idx != -1) {
			s = s.substring(0, idx) + "_" + s.substring(idx+1, s.length);
			idx = s.indexOf("-");
		}
		return s;
	}
	
	public static inline function isWav(s:String):Bool {
		return s.indexOf("wav") > -1;
	}
	
	public static inline function isMusic(s:String):Bool {
		return s.indexOf("mp3") > -1 || s.indexOf("ogg") > -1;
	}
	
	public static function readWavDuration(path:String):Float {
		var c = 20;
		#if (ios || mac)
		var f:FileInput = File.read(path, true);
		#else
		var f:FileInput = File.read(path, true);
		#end
		f.bigEndian = false;
		f.seek(24,FileSeek.SeekBegin);
		var sampleRate:Int = f.readUInt24();
		f.bigEndian = true;
		var bytes:Bytes = f.readAll();
		f.seek(32,FileSeek.SeekBegin);
		var blockAlign:Int = f.readByte();
		f.seek(44,FileSeek.SeekBegin);
		var dataLength:Int = bytes.length;
		var bytesPerSec:Int = sampleRate * blockAlign;
		var sec:Float = dataLength / bytesPerSec;
		f.close();
		return sec;
	}
	
}