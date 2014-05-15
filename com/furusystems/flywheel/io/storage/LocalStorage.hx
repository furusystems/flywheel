package com.furusystems.flywheel.io.storage;
#if flash
import flash.net.SharedObject;
#end

/**
 * ...
 * @author Andreas Rønning
 */
class LocalStorage
{
	#if flash
	static var so:SharedObject;
	#end
	public static function init(key:String):Void {
		#if flash
		so = SharedObject.getLocal(key);
		#end
	}
	public static function getValue(key:String, defaultValue:Dynamic = null):Dynamic {
		#if flash
		if (Reflect.hasField(so.data, key)) {
			return Reflect.field(so.data, key);
		}else {
			return setValue(key, defaultValue);
		}
		#else
		return defaultValue;
		#end
	}
	public static inline function setValue(key:String, value:Dynamic):Dynamic {
		#if flash
		Reflect.setField(so.data, key, value);
		so.flush();
		return value;
		#else
		return null;
		#end
		
	}
	
}