package com.furusystems.flywheel.scripting.sequencer;
import com.furusystems.flywheel.events.Signal1.Signal1;


/**
 * ...
 * @author Andreas Rønning
 */

@:generic @:remove class Sequencer<T>
{
	public var events:Array<SequencerEvent<T>>;
	public var _cache:Array<SequencerEvent<T>>;
	public var time:Float;
	public var onEvent:Signal1<SequencerEvent<T>>;
	public var onComplete:Signal1<Sequencer<T>>;
	private var _completed:Bool;
	public var completed(default, null):Bool;
	public var remainingEvents(get_remainingEvents, never):Int;
	private var indices:Int;
	public function new() 
	{
		_cache = null;
		indices = -1;
		onEvent = new Signal1<SequencerEvent<T>>();
		onComplete = new Signal1<Sequencer<T>>();
		events = new Array<SequencerEvent<T>>();
	}
	
	public function dispose():Void {
		onComplete.dispose();
		onEvent.dispose();
	}
	
	private function get_remainingEvents():Int {
		return events.length;
	}
	public function clear():Void {
		events = new Array<SequencerEvent<T>>();
		_cache = null;
		time = 0;
	}
	public function addEvent(time:Float, data:T, ?targetEventArray:Array<SequencerEvent<T>> = null):Void
	{
		if (targetEventArray == null) { targetEventArray = this.events; } // default to internal events array, an alternative can be supplied to use any sequencer as a sequence factory
		indices++;
		var evt:SequencerEvent<T> = new SequencerEvent<T>();
		evt.dispatched = false;
		evt.eventData = data;
		evt.triggerTime = time;
		evt.index = indices;
		targetEventArray.push(evt);
	}
	public function sortEvents(?targetEventArray:Array<SequencerEvent<T>> = null):Void
	{
		if (targetEventArray == null) { targetEventArray = this.events; } // default to internal events array, an alternative can be supplied
		targetEventArray.sort(sortFunc2);
		targetEventArray.sort(sortFunc);
	}
	private function sortFunc(a:SequencerEvent<T>, b:SequencerEvent<T>):Int {
		if (a.triggerTime > b.triggerTime) return -1;
		if (a.triggerTime < b.triggerTime) return 1;
		return 0;
	}
	private function sortFunc2(a:SequencerEvent<T>, b:SequencerEvent<T>):Int {
		if (a.index > b.index) return -1;
		if (a.index < b.index) return 1;
		return 0;
	}
	public function reset():Void {
		if (_cache != null)
		{
			retrieveCache();
		} else {
			for (e in events)
			{
				e.dispatched = false;
			}
		}
		time = 0;
		_completed = false;
	}
	public function cacheEvents():Void {
		_cache = events.copy();
	}
	public function retrieveCache():Void {
		events = _cache.copy();
		for (e in events) {
			e.dispatched = false;
		}
	}
	public function printEvents():String {
		var out:String = "";
		for (e in events) {
			out += e.triggerTime + "\n";
		}
		return out;
	}
	public function offsetToZero(offset:Float = 0, ?targetEventArray:Array<SequencerEvent<T>> = null):Void
	{
		if (targetEventArray == null) { targetEventArray = this.events; } // default to internal events array, an alternative can be supplied
		var minTriggerTime:Float = Math.POSITIVE_INFINITY;
		for (e in targetEventArray) {
			if (e.triggerTime < minTriggerTime) { 
				minTriggerTime = e.triggerTime;
			}
		}
		minTriggerTime += offset;
		for (e in targetEventArray) {
			e.triggerTime -= minTriggerTime;
		}
	}
	public function update(delta:Float):Void {
		time += delta;
		if (events.length == 0 && !_completed) {
			_completed = true;
			if (onComplete != null) onComplete.dispatch(this);
			return;
		}
		if (events.length == 0) return;
		
		var nextEvent:SequencerEvent<T> = events[events.length - 1];
		
		while (time > nextEvent.triggerTime)
		{
			dispatch(events.pop());
			if (events.length == 0) break;
			nextEvent = events[events.length - 1];
		}
	}
	public function skipToNextEvent():Void
	{
		var nextEvent:SequencerEvent<T> = events[events.length - 1];
		time = nextEvent.triggerTime;
	}
	
	private inline function dispatch(nextEvent:SequencerEvent<T>):Void 
	{
		nextEvent.dispatched = true;
		onEvent.dispatch(nextEvent);
	}
	
}