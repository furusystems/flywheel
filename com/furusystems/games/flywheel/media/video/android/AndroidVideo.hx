package com.furusystems.games.flywheel.media.video.android;
#if android
import openfl.utils.JNI;
#end

/**
 * ...
 * @author Andreas Rønning
 */
class AndroidVideo
{
	public static function playVideo(asset:String):Void {
		#if android
		var method = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelVideo", "playVideo", "(Ljava/lang/String;)V");
		method(asset);
		#end
	}
	
	static public function initialize() 
	{
		#if android
		var method = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelVideo", "initialize", "()V");
		method();
		#end
	}
}