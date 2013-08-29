package com.furusystems.games.flywheel.media.sound.android;
import openfl.utils.JNI;

/**
 * JNI wrapper for a soundpool instance
 * @author Andreas Rønning
 */

class SoundPool 
{
	private var source:Dynamic;
	
	private var jAutoPause:Dynamic;
	private var jAutoresume:Dynamic;
	private var jLoad:Dynamic;
	private var jPause:Dynamic;
	private var jPlay:Dynamic;
	private var jRelease:Dynamic;
	private var jUnload:Dynamic;
	private var jResume:Dynamic;
	private var jSetLoop:Dynamic;
	private var jSetRate:Dynamic;
	private var jSetVolume:Dynamic;
	private var jStop:Dynamic;
	
	public function new(source:Dynamic) 
	{
		setSource(source);
	}
	public function setSource(source:Dynamic):Void {
		trace("Initializing local soundpool: " + source);
		this.source = source;
		trace("jPlaySound");
		jPlay = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "playSound", "(IDDIID)I");
		trace("jLoad");
		jLoad = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "getSoundHandle", "(Ljava/lang/String;)I");
		trace("jStop");
		jStop = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "stopSound", "(I)V");
		trace("jUnload");
		jUnload = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "unloadSound", "(I)V");
		trace("jPause");
		jPause = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "pauseSound", "(I)V");
		trace("jResume");
		jResume = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "resumeSound", "(I)V");
		trace("jAutoPause");
		jAutoPause = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "autoPause", "()V");
		trace("jAutoresume");
		jAutoresume = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "autoResume", "()V");
		trace("jRelease");
		jRelease = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "releasePool", "()V");
		trace("jSetVolume");
		jSetVolume = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "setVolume", "(IDD)V");
		trace("jSetLoop");
		jSetLoop = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "setLoop", "(II)V");
		trace("jSetRate");
		jSetRate = JNI.createStaticMethod("com.furusystems.flywheel.FlywheelSound", "setRate", "(ID)V");
		
	}
	public function autoPause():Void {
		jAutoPause();
		//Pause all active streams.
	}
	public function autoResume():Void {
		jAutoresume();
		//Resume all previously active streams.
	}
	public function load(path:String):Int {
		trace("Soundpool loading from path: " + path);
		return jLoad(path);
		//Load the sound from the specified path.
	}
	public function pause(id:Int):Void {
		//Pause a playback stream.	
		jPause(id);
	}
	public function play(id:Int, leftvol:Float = 1, rightvol:Float = 1, priority:Int = 0, loopCount:Int = 0, playbackrate:Float = 1):Int {
		//Play a sound from a sound ID.
		return jPlay(id, leftvol, rightvol, priority, loopCount, playbackrate);
	}
	public function release():Void {
		jRelease();
		//Release the SoundPool resources	
	}
	public function resume(id:Int):Void {
		jResume(id);
		//Resume a playback stream.	
	}
	public function setLoop(id:Int, loopCount:Int):Void {
		jSetLoop(id, loopCount);	
		//Set loop mode.	
	}
	public function setRate(id:Int, rate:Float = 1):Void {
		jSetRate(id, rate);
		//Change playback rate.
	}
	public function setVolume(id:Int, leftVol:Float = 1, rightVol:Float = 1):Void {
		jSetVolume(id, leftVol, rightVol);
		//Set stream volume.
	}
	public function stop(id:Int):Void {
		jStop(id);
		//Stop a playback stream.
	}
	public function unload(id:Int):Bool {
		return jUnload(id);
	}
	
}