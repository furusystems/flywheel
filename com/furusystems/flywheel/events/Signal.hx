package com.furusystems.flywheel.events;

/**
 * ...
 * @author Andreas Rønning
 */
enum ListenerTypes {
	ONCE;
	NORMAL;
}
class Signal<T>
{
	var _listeners:Array<Listener<T>> ;
	var _listenerCount:Int = 0;
	public var listenerCount(get_listenerCount, null):Int;
	public var oneshot:Bool;
	public function new(oneshot:Bool = false) 
	{
		this.oneshot = oneshot;
		_listeners = new Array<Listener<T>>();
	}
	public inline function add(func:T->Void):Void {
		remove(func);
		_listeners.push( new Listener<T>(ListenerTypes.NORMAL, func) );
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
		_listeners.push( new Listener<T>(ListenerTypes.ONCE, func) );
		_listenerCount++;
	}
	public inline function removeAll():Void {
		_listeners = new Array<Listener<T>>();
		_listenerCount = 0;
	}
	public inline function dispose():Void {
		_listeners = null;
		_listenerCount = 0;
	}
	public inline function dispatch(value:T):Void {
		if (_listenerCount != 0){
			for (i in _listeners) 
			{
				i.execute(value);
				if (i.type == ListenerTypes.ONCE) {
					_listeners.remove(i);
				}
			}
		}
		if (oneshot) removeAll();
	}
}
private class Listener<T> {
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