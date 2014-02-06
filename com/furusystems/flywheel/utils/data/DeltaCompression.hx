package com.furusystems.flywheel.utils.data;
import haxe.ds.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
class DeltaCompression
{
	static public function compressInt(a:Array<Int>):Array<Int> {
		var out = new Array<Int>();
		var d = 0;
		var prev = 0;
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
		var out = new Array<Float>();
		var d = 0.0;
		var prev = 0.0;
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