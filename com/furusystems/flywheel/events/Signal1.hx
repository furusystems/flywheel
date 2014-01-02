package com.furusystems.flywheel.events;
import com.furusystems.flywheel.events.Signal.ListenerTypes;

/**
 * ...
 * @author Andreas Rønning
 */
@:generic @:remove class Signal1<T>
{
	var _listeners:Array<Listener1<T>> ;
	var _listenerCount:Int = 0;
	public var listenerCount(get_listenerCount, null):Int;
	public var oneshot:Bool;
	public function new(oneshot:Bool = false) 
	{
		this.oneshot = oneshot;
		_listeners = new Array<Listener1<T>>();
	}
	public inline function add(func:T->Void):Void {
		remove(func);
		_listeners.push( new Listener1<T>(ListenerTypes.NORMAL, func) );
		_listenerCount++;
	}
	public inline function remove(func:T->Void):Void {
		for (l in _listeners) 
		{
			if (l.func == func) {
				_listeners.remove(l);
				_listenerCount--;
				break;
			}
		}
	}
	function get_listenerCount():Int 
	{
		return _listenerCount;
	}
	public inline function addOnce(func:T->Void):Void {
		remove(func);
		_listeners.push( new Listener1<T>(ListenerTypes.ONCE, func) );
		_listenerCount++;
	}
	public inline function removeAll():Void {
		_listeners = new Array<Listener1<T>>();
		_listenerCount = 0;
	}
	public inline function dispose():Void {
		_listeners = null;
		_listenerCount = 0;
	}
	public inline function dispatch(value:T):Void {
		for (i in _listeners) 
		{
			i.execute(value);
			if (i.type == ListenerTypes.ONCE) {
				_listeners.remove(i);
			}
		}
		if (oneshot) removeAll();
	}
}
@:generic @:remove private class Listener1<T> {
	public var func:T->Void;
	public var type:ListenerTypes;
	public inline function execute(arg:T):Void {
		func(arg);
	}
	public function new(type:ListenerTypes, func:T->Void) {
		this.type = type;
		this.func = func;
	}
}