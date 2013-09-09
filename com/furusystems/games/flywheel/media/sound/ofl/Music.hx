package com.furusystems.games.flywheel.media.sound.ofl;
import com.furusystems.games.flywheel.media.sound.IMusic;
import openfl.Assets;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;


/**
 * ...
 * @author Andreas Rønning
 */

class Music implements IMusic
{
	public var channel:SoundChannel;
	public var isPlaying(get_isPlaying, null):Bool;
	public var path(get_path, null):String;
	private var _path:String;
	private var _lastPlayTime:Float;
	private var _lastVolume:Float;
	private var _lastLoop:Bool;
		
	public function new() 
	{
		channel = null;
	}
	
	private function get_isPlaying():Bool
	{
		return (channel != null);
	}
	
	private function get_path():String 
	{
		return _path;
	}
	
	/* INTERFACE com.furusystems.games.flywheel.media.sound.IMusic */
	
	public function play(path:String, volume:Float, loop:Bool = true):Void 
	{
		if (isPlaying) {
			stop();
		}
		_lastLoop = loop;
		
		#if debug
		trace("play music: " + path);
		#end
		var s:Sound = Assets.getSound(path);
		if (s == null) {
			#if debug
			trace("Couldnt load sound from path: " + path);
			#end
			return;
		}
		
		channel = s.play(0, loop ? -1 : 0, new SoundTransform(volume));
		isPlaying = true;
		_path = path;
	}
	
	function play2(path:String, startTime:Float, volume:Float, loop:Bool = true):Void {
		if (isPlaying) {
			stop();
		}
		_lastLoop = loop;
		#if debug
		trace("play music: " + path);
		#end
		var s:Sound = Assets.getSound(path);
		if (s == null) {
			#if debug
			trace("Couldnt load sound from path: " + path);
			#end
			return;
		}
		
		channel = s.play(startTime, loop ? -1 : 0, new SoundTransform(volume));
		isPlaying = true;
		_path = path;
	}
	
	public function stop():Void 
	{
		if (isPlaying) { 
			channel.stop();
			channel   = null;
			isPlaying = false;
		}
	}
	
	public function setVolume(musicVolume:Float):Void 
	{
		if (isPlaying) {
			var st:SoundTransform = new SoundTransform(musicVolume);
			channel.soundTransform = st;
		}
	}
	
	
	public function setPaused(b:Bool):Void 
	{
		if (channel == null) return;
		if (b) {
			_lastPlayTime = channel.position;
			_lastVolume = channel.soundTransform.volume;
			stop();
		}else {
			play2(_path, _lastPlayTime, _lastVolume, _lastLoop);
		}
	}
	
}