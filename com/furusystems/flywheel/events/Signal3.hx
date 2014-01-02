package com.furusystems.flywheel.events;
import com.furusystems.flywheel.events.Signal.ListenerTypes;
/**
 * ...
 * @author Andreas Rønning
 */
@:generic @:remove class Signal3<T,T2,T3>
{
	var _listeners:Array<Listener3<T,T2,T3>> ;
	var _listenerCount:Int = 0;
	public var listenerCount(get_listenerCount, null):Int;
	public var oneshot:Bool;
	public function new(oneshot:Bool = false) 
	{
		this.oneshot = oneshot;
		_listeners = new Array<Listener3<T,T2,T3>>();
	}
	public inline function add(func:T->T2->T3->Void):Void {
		remove(func);
		_listeners.push( new Listener3<T,T2,T3>(ListenerTypes.NORMAL, func) );
		_listenerCount++;
	}
	public inline function remove(func:T->T2->T3->Void):Void {
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
	public inline function addOnce(func:T->T2->T3->Void):Void {
		remove(func);
		_listeners.push( new Listener3<T,T2,T3>(ListenerTypes.ONCE, func) );
		_listenerCount++;
	}
	public inline function removeAll():Void {
		_listeners = new Array<Listener3<T,T2,T3>>();
		_listenerCount = 0;
	}
	public inline function dispose():Void {
		_listeners = null;
		_listenerCount = 0;
	}
	public inline function dispatch(arg1:T, arg2:T2, arg3:T3):Void {
		for (i in _listeners) 
		{
			i.execute(arg1,arg2,arg3);
			if (i.type == ListenerTypes.ONCE) {
				_listeners.remove(i);
			}
		}
		if (oneshot) removeAll();
	}
}
@:generic @:remove private class Listener3<T,T2,T3> {
	public var func:T->T2->T3->Void;
	public var type:ListenerTypes;
	public inline function execute(arg1:T, arg2:T2, arg3:T3):Void {
		func(arg1,arg2,arg3);
	}
	public function new(type:ListenerTypes, func:T->T2->T3->Void) {
		this.type = type;
		this.func = func;
	}
}