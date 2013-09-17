package com.furusystems.flywheel.metrics;
import flash.Lib;
import haxe.Timer;

/**
 * ...
 * @author Andreas Rønning
 */
class Time
{
	public var timeScale:Float;
	
	public var clockMS:Int;
	public var clockS:Float;
	
	public var deltaMS:Int;
	public var deltaS:Float;
	public var scaledDeltaS:Float;
	public var scaledDeltaMS:Int;
	
	public var timeStep:Int = -1;
	
	var lastUpdateTimeMS:Int;
	public function new() 
	{
		reset();
	}
	public function reset() {
		clockMS = lastUpdateTimeMS = 0;
		timeScale = 1;
		deltaS = scaledDeltaS = 0;
		deltaMS = scaledDeltaMS = 0;
	}
	
	public function update():Void {
		if (timeStep == -1) {
			updateRunning();
		}else {
			updateFixed(timeStep);
		}
	}
	
	inline function updateRunning():Void {
		deltaMS = Lib.getTimer() - lastUpdateTimeMS;
		clockMS += deltaMS;
		clockS = clockMS * 0.001;
		deltaS = deltaMS * 0.001;
		scaledDeltaMS = Std.int(deltaMS * timeScale);
		scaledDeltaS = deltaS * timeScale;
		lastUpdateTimeMS = Lib.getTimer();
	}
	inline function updateFixed(stepMS:Int = 33):Void {
		deltaMS = stepMS;
		clockMS += deltaMS;
		clockS = clockMS * 0.001;
		deltaS = deltaMS * 0.001;
		scaledDeltaMS = Std.int(deltaMS * timeScale);
		scaledDeltaS = deltaS * timeScale;
	}
	
}