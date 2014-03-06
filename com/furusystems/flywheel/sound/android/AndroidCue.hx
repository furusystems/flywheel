package com.furusystems.flywheel.sound.android;
import com.furusystems.flywheel.sound.ISoundCue;

/**
 * ...
 * @author Andreas Rønning
 */

class AndroidCue implements ISoundCue
{

	public var path:String;
	public var index:Int;
	public var duration:Float;
	public function new(path:String) 
	{
		#if debug
		trace("New android cue");
		#end
		this.path = path;
		index = AndroidAudio.currentPool.load(path);
	}
	
	/* INTERFACE com.furusystems.flywheel.sound.ISoundCue */
	
	public function release():Void 
	{
		AndroidAudio.currentPool.unload(index);
	}
	
}