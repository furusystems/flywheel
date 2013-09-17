package com.furusystems.flywheel.media.sound.ofl;
import com.furusystems.flywheel.media.sound.ISoundCue;
import openfl.Assets;
import flash.media.Sound;

/**
 * ...
 * @author Andreas Rønning
 */

class Cue implements ISoundCue
{

	public var path:String;
	public var sound:Sound;
	public var index:Int;
	public var duration:Float;
	public function new(path:String) 
	{
		this.path = path;
		sound = Assets.getSound(path);
	}
	
	/* INTERFACE com.furusystems.flywheel.media.sound.ISoundCue */
	
	public function release():Void 
	{
		sound = null;
	}
	
}