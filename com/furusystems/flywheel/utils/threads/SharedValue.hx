package com.furusystems.flywheel.utils.threads;
import cpp.vm.Mutex;

/**
 * Thread safe genric value wrapper
 */
class SharedValue<T> {
	var mValue:T;
	var mMutex:Mutex;
	public function new(defaultValue:T) {
		mValue = defaultValue;
		mMutex = new Mutex();
	}
	function get_value():T 
	{
		mMutex.acquire();
		var retVal = mValue;
		mMutex.release();
		return retVal;
	}
	
	function set_value(value:T):T 
	{
		mMutex.acquire();
		var retVal = mValue = value;
		trace("Set value: " + retVal);
		mMutex.release();
		return retVal;
	}
	public var value(get_value, set_value):T;
}