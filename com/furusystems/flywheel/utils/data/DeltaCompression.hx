package com.furusystems.flywheel.utils.data;
import haxe.ds.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
class DeltaCompression
{
	static public function compressInt(a:Array<Int>):Array<Int> {
		var out:Array<Int> = new Array<Int>();
		var d:Int = 0;
		var prev:Int = 0;
		for (i in 0...a.length) {
			if (i != 0) {
				d = a[i] - prev;
				out[i] = d;
				prev = a[i];
			}else {
				out[i] = prev = a[i];
			}
		}
		return out;
	}
	static public function compressFloat(a:Array<Float>):Array<Float> {
		var out:Array<Float> = new Array<Float>();
		var d:Float = 0;
		var prev:Float = 0;
		for (i in 0...a.length) {
			if (i != 0) {
				d = a[i] - prev;
				out[i] = d;
				prev = a[i];
			}else {
				out[i] = prev = a[i];
			}
		}
		return out;
	}
	
}