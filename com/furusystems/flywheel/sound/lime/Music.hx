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
	var currentMusicHandle:Sound;
		
	public function new(owner:GameMusic) 
	{
		this.owner = owner;
	}
	
	private function get_isPlaying():Bool
	{
		if (currentMusicHandle == null) return false;
		return currentMusicHandle.playing;
	}
	
	private function get_path():String 
	{
		return _path;
	}
	
	/* INTERFACE com.furusystems.flywheel.sound.IMusic */
	
	public function play(path:String, volume:Float, loop:Bool = true, offset:Float = 0):Void 
	{
		if (isPlaying) {
			stop();
		}
		_lastLoop = loop;
		currentMusicHandle = owner.audio.limeAudioHandler.create("music", path, true);
		if (currentMusicHandle == null) {
			trace("Couldnt load sound from path: " + path);
			return;
		}
		
		currentMusicHandle.play(loop?-1:1, offset);
		currentMusicHandle.volume = volume;
		_path = path;
	}
	
	function play2(path:String, startTime:Float, volume:Float, loop:Bool = true):Void
	{
		
		if (isPlaying) {
			stop();
		}
		_lastLoop = loop;
		
		currentMusicHandle = owner.audio.limeAudioHandler.create("music", path, true);
		
		if (currentMusicHandle == null) {
			#if debug
			trace("Couldnt load sound from path: " + path);
			#end
			return;
		}
		
		trace("play");
		currentMusicHandle.play(loop?-1:1, startTime);
		currentMusicHandle.volume = volume;
		_path = path;
	}
	
	public function stop():Void 
	{
		if (isPlaying)
		{ 
			trace("Stop");
			currentMusicHandle.stop();
			isPlaying = false;
		}
	}
	
	public function setVolume(musicVolume:Float):Void 
	{
		if (isPlaying) {
			currentMusicHandle.volume = musicVolume;
		}
	}
	
	
	public function setPaused(b:Bool):Void 
	{
		trace("pause music: " + b);
		if (currentMusicHandle == null)
		{
			trace("music channel is null");
			return;
		}
		if (b) {
			_lastPlayTime = currentMusicHandle.position;
			_lastVolume = currentMusicHandle.volume;
			currentMusicHandle.stop();
		}else {
			trace("resuming music at: " + _lastPlayTime, _lastLoop);
			play2(_path, _lastPlayTime, _lastVolume, _lastLoop);
		}
	}
	
}