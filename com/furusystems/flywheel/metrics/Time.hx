package com.furusystems.flywheel.metrics;
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
	
	public var stateCurrentTimeMS:Int;
	
	var lastUpdateTimeMS:Int;
	public function new() 
	{
		reset();
	}
	public function reset() {
		stateCurrentTimeMS = 0;
		clockMS = lastUpdateTimeMS = 0;
		timeScale = 1;
		deltaS = scaledDeltaS = 0;
		deltaMS = scaledDeltaMS = 0;
	}
	
	public function step(advance:Float = 0):Void {
		update(Std.int(advance * 1000));
	}
	
	inline function update(stepMS:Int = 33):Void {
		deltaMS = stepMS;
		clockMS += deltaMS;
		stateCurrentTimeMS += deltaMS;
		clockS = clockMS * 0.001;
		deltaS = deltaMS * 0.001;
		scaledDeltaMS = Std.int(deltaMS * timeScale);
		scaledDeltaS = deltaS * timeScale;
	}
	
}