package com.furusystems.flywheel.sound.lime;
import com.furusystems.flywheel.sound.IMusic;
#if (lime&&!openfl)
import lime.helpers.AudioHelper.Sound;
import lime.utils.Assets;
#end


/**
 * ...
 * @author Andreas Rønning
 */

class Music implements IMusic
{
	#if (!openfl&&lime)
	public var isPlaying(get_isPlaying, null):Bool;
	#else
	public var isPlaying:Bool;
	#end
	public var path(get_path, null):String;
	private var _path:String;
	private var _lastPlayTime:Float;
	private var _lastVolume:Float;
	private var _lastLoop:Bool;
	var owner:GameMusic;
	var musicName:String;
		
	public function new(owner:GameMusic) 
	{
		musicName = 'music';
		this.owner = owner;
	}
	
	#if (!openfl&&lime)
	inline function get_isPlaying():Bool
	{
		if (musicName == null) return false;
		return owner.audio.playing(musicName);
	}
	#end
	
	inline function get_path():String 
	{
		return _path;
	}
	
	public function play(path:String, volume:Float, loop:Bool = true, offset:Float = 0):Void 
	{
		if (isPlaying) {
			stop();
		}
		_lastLoop = loop;
		#if (!openfl&&lime)
		owner.audio.create(musicName, path, true);
		//if (_lastLoop) owner.audio.loop(musicName);
		owner.audio.play(musicName, _lastLoop?9999:1, offset);
		owner.audio.volume(musicName, volume);
		#end
		_path = path;
	}
	
	function play2(path:String, startTime:Float, volume:Float, loop:Bool = true):Void
	{
		if (isPlaying) {
			stop();
		}
		_lastLoop = loop;
		#if (!openfl&&lime)
		owner.audio.create(musicName, path, true);
		owner.audio.play(musicName, _lastLoop?9999:1, startTime);
		owner.audio.volume(musicName, volume);
		#end
		_path = path;
	}
	
	public function stop():Void 
	{
		if (isPlaying)
		{ 
			#if (!openfl&&lime)
			owner.audio.stop(musicName);
			#end
		}
	}
	
	public function setVolume(musicVolume:Float):Void 
	{
		if (isPlaying) {
			#if (!openfl&&lime)
			owner.audio.volume(musicName, musicVolume);
			#end
		}
	}
	
	
	public function setPaused(b:Bool):Void 
	{
		trace("pause music: " + b);
		if (b) {
			#if (!openfl&&lime)
			_lastPlayTime = owner.audio.position(musicName);
			_lastVolume = owner.audio.volume(musicName);
			owner.audio.stop(musicName);
			#end
		}else {
			trace("resuming music at: " + _lastPlayTime, _lastLoop);
			play2(_path, _lastPlayTime, _lastVolume, _lastLoop);
		}
	}
	
}