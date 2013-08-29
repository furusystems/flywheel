package com.furusystems.games.flywheel.media.sound.android;

import openfl.utils.JNI;

/**
 * ...
 * @author Andreas Rønning
 */

class AndroidAudio 
{
	private static var _currentPool:SoundPool;
	
	private static inline var POOL_NOT_READY:Int = 0;
	private static inline var POOL_READY:Int = 1;
	private static inline var POOL_ERROR:Int = -1;
	
	public static function clearPool():Void {
		#if android
		trace("Android: Clear SoundPool");
		var method:Dynamic = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "clearPool", "()V");
		method();
		#end
	}
	public static function initialize():Bool {
		trace("Android: Initializing");
		var method = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "initialize", "()V");
		method();
		
		method = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "getPool", "()Landroid/media/SoundPool;");
		_currentPool = new SoundPool(method());
		return true;
	}
	private static function get_currentPool():SoundPool 
	{
		return _currentPool;
	}
	
	static public var currentPool(get_currentPool, null):SoundPool;
	
	static public function isPoolReady():Bool {
		//trace("Is the pool ready?");
		var method:Dynamic = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "isPoolReady", "()I");
		var val:Int = method();
		//trace("Pool ready state: " + val);
		return val==POOL_READY;
	}
	
}