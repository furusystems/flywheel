package com.furusystems.flywheel.sound.lime;
import com.furusystems.flywheel.sound.ISoundCue;
#if (lime&&!openfl)
import lime.utils.Assets;
#end

/**
 * ...
 * @author Andreas Rønning
 */

class Cue implements ISoundCue
{

	public var path:String;
	//public var sound:Sound;
	public var index:Int;
	public var duration:Float;
	public function new(path:String) 
	{
		this.path = path;
		#if sound
		sound = Assets.getSound(path);
		#end
	}
	
	public function release():Void 
	{
		
		//#if !openfl
		//sound.removeEventListener(Event.COMPLETE, onSoundLoaded);
		//#end
		//sound = null;
	}
	
}