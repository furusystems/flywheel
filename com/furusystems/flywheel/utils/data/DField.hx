package com.furusystems.flywheel.utils.data;

@:generic class DField<T>
{
	private var values:Array<T>;
	public function new(defaultValue:T) 
	{
		values = new Array<T>();
		values[0] = values[1] = defaultValue;
	}
	
	inline public function flatten():Void {
		back = front;
	}
	
	public function set(value:T):T 
	{
		return values[0] = values[1] = value;
	}
	
	public var front(get_front, set_front):T;
	
	inline function set_front(newValue:T):T
	{
		return values[DFieldBufferIdx.frontBuffer] = newValue;
	}
	
	inline function get_front():T 
	{
		return values[DFieldBufferIdx.frontBuffer];
	}
	
	public var back(get_back, set_back):T;
	
	inline function set_back(newValue:T):T
	{
		return values[DFieldBufferIdx.backBuffer] = newValue;
	}
	
	inline function get_back():T 
	{
		return values[DFieldBufferIdx.backBuffer];
	}
	
}