package com.furusystems.flywheel.media.video;

/**
 * ...
 * @author Andreas Rønning
 */
class VideoPlayer
{
	static public function playVideo(path:String, onComplete:Void->Void) {
		
	}
	
	static private var _volume:Float;
	static public var volume(get_volume, set_volume):Float;
	
	static function get_volume():Float 
	{
		return _volume;
	}
	
	static function set_volume(value:Float):Float 
	{
		return _volume = value;
	}
	
	
}