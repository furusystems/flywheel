package com.furusystems.flywheel.media.sound.ofl;
import com.furusystems.flywheel.media.sound.ISoundCue;
import flash.net.URLRequest;
#if openfl
import openfl.Assets;
#end
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
		#if openfl
		sound = Assets.getSound(path);
		#else
		sound = new Sound(new URLRequest(path));
		#end
	}
	
	/* INTERFACE com.furusystems.flywheel.media.sound.ISoundCue */
	
	public function release():Void 
	{
		sound = null;
	}
	
}