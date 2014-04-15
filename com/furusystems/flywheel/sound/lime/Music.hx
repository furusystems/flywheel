package com.furusystems.flywheel.sound.lime;
import com.furusystems.flywheel.sound.IMusic;
import lime.helpers.AudioHelper.Sound;
import lime.utils.Assets;


/**
 * ...
 * @author Andreas Rønning
 */

class Music implements IMusic
{
	public var isPlaying(get_isPlaying, null):Bool;
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
	
	inline function get_isPlaying():Bool
	{
		if (musicName == null) return false;
		return owner.audio.playing(musicName);
	}
	
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
		owner.audio.create(musicName, path, true);
		//if (_lastLoop) owner.audio.loop(musicName);
		owner.audio.play(musicName, _lastLoop?9999:1, offset);
		owner.audio.volume(musicName, volume);
		_path = path;
	}
	
	function play2(path:String, startTime:Float, volume:Float, loop:Bool = true):Void
	{
		if (isPlaying) {
			stop();
		}
		_lastLoop = loop;
		owner.audio.create(musicName, path, true);
		owner.audio.play(musicName, _lastLoop?9999:1, startTime);
		owner.audio.volume(musicName, volume);
		_path = path;
	}
	
	public function stop():Void 
	{
		if (isPlaying)
		{ 
			owner.audio.stop(musicName);
		}
	}
	
	public function setVolume(musicVolume:Float):Void 
	{
		if (isPlaying) {
			owner.audio.volume(musicName, musicVolume);
		}
	}
	
	
	public function setPaused(b:Bool):Void 
	{
		trace("pause music: " + b);
		if (b) {
			_lastPlayTime = owner.audio.position(musicName);
			_lastVolume = owner.audio.volume(musicName);
			owner.audio.stop(musicName);
		}else {
			trace("resuming music at: " + _lastPlayTime, _lastLoop);
			play2(_path, _lastPlayTime, _lastVolume, _lastLoop);
		}
	}
	
}