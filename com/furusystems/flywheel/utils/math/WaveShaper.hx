package com.furusystems.flywheel.utils.math;
class WaveShaper {
	public static inline function shape(input:Float, drive:Float):Float{
		var k:Float = 2.0 * drive / (1.0 - drive);
		return (1.0 + k) * input / (1.0 + k * Math.abs(input));
	}
}