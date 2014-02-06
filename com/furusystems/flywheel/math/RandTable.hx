package com.furusystems.flywheel.math;
import haxe.ds.Vector.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
class RandTable
{
	static var numbers:Vector<Float>;
	static var index:Int;
	static var size:Int;
	public static inline function setup(num:Int):Void {
		size = num;
		numbers = new Vector<Float>(size);
		index = 0;
		for (i in 0...size) {
			numbers[i] = Math.random();
		}
	}
	public static inline function next():Float {
		index = (index + 1) % size;
		return numbers[index];
	}
	
}