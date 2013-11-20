package com.furusystems.flywheel.utils.threads;
import cpp.vm.Mutex;

class SharedCounter {
	var mValue:Int;
	var mMutex:Mutex;
	public function new() {
		mValue = 0;
		mMutex = new Mutex();
	}
	function get_value():Int
	{
		mMutex.acquire();
		var retVal = mValue;
		mMutex.release();
		return retVal;
	}
	public function increment():Void {
		mMutex.acquire();
		mValue++;
		mMutex.release();
	}
	public function decrement():Void {
		mMutex.acquire();
		mValue--;
		mMutex.release();
	}
	
	public function reset(value:Int = 0) 
	{
		mMutex.acquire();
		mValue = value;
		mMutex.release();
	}
	public var value(get_value, null):Int;
}