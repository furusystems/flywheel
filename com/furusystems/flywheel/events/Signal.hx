package com.furusystems.flywheel.events;

/**
 * ...
 * @author Andreas Rønning
 */
enum ListenerTypes {
	ONCE;
	NORMAL;
}
class Signal
{
	var _listeners:Array<Listener0>;
	var _listenerCount:Int = 0;
	public var listenerCount(get_listenerCount, null):Int;
	public var oneshot:Bool;
	public function new(oneshot:Bool = false) 
	{
		this.oneshot = oneshot;
		_listeners = new Array<Listener0>();
	}
	public inline function add(func:Void->Void):Void {
		remove(func);
		_listeners.push( new Listener0(ListenerTypes.NORMAL, func) );
		_listenerCount++;
	}
	public inline function remove(func:Void->Void):Void {
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
	public inline function addOnce(func:Void->Void):Void {
		remove(func);
		_listeners.push( new Listener0(ListenerTypes.ONCE, func) );
		_listenerCount++;
	}
	public inline function removeAll():Void {
		_listeners = new Array<Listener0>();
		_listenerCount = 0;
	}
	public inline function dispose():Void {
		_listeners = null;
		_listenerCount = 0;
	}
	public inline function dispatch():Void {
		for (i in _listeners) 
		{
			i.execute();
			if (i.type == ListenerTypes.ONCE) {
				_listeners.remove(i);
			}
		}
		if (oneshot) removeAll();
	}
}
private class Listener0 {
	public var func:Void->Void;
	public var type:ListenerTypes;
	public inline function execute():Void {
		func();
	}
	public function new(type:ListenerTypes, func:Void->Void) {
		this.type = type;
		this.func = func;
	}
}