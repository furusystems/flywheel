package com.furusystems.flywheel.sound.android;
import com.furusystems.flywheel.sound.IMusic;
import openfl.utils.JNI;

/**
 * ...
 * @author Andreas Rønning
 */

class AndroidMusic implements IMusic
{
	private var jPlay:Dynamic;
	private var jStop:Dynamic;
	private var jTransform:Dynamic;
	private var jPause:Dynamic;
	private var jResume:Dynamic;

	public function new() 
	{
		#if debug
		trace("setting up android music");
		#end
		jPlay = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "playMusic", "(Ljava/lang/String;DDID)I");
		jStop = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "stopMusic", "()V");
		jPause = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "pauseMusic", "()V");
		jResume = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "resumeMusic", "()V");
		jTransform = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "setMusicTransform", "(Ljava/lang/String;DD)V");
	}
	
	
	
	/* INTERFACE com.furusystems.flywheel.sound.IMusic */
	
	public function play(path:String, volume:Float, loop:Bool = true, offset:Float = 0):Void 
	{
		jPlay(path, volume, volume, loop?9999:0, 0);
	}
	
	public function stop():Void 
	{
		jStop();
	}
	
	
	public function setVolume(musicVolume:Float):Void 
	{
		jTransform("", musicVolume, musicVolume);
	}
	
	public function setPaused(b:Bool):Void 
	{
		if (b) jPause();
		else jResume();
	}
	
}