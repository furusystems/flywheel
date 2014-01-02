package com.furusystems.flywheel.scripting.sequencer;

/**
 * ...
 * @author Andreas Rønning
 */

@:generic @:remove class SequencerEvent<T>
{
	public var dispatched:Bool;
	public var triggerTime:Float;
	public var eventData:T;
	public var index:Int;
	public function new() {
		
	}
}