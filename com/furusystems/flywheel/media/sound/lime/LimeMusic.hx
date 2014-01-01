package com.furusystems.flywheel.media.sound.lime;
import com.furusystems.flywheel.media.sound.IMusic;
import flash.net.URLRequest;
#if openfl
import openfl.Assets;
#elseif lime
import lime.utils.Assets;
#end
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;


/**
 * ...
 * @author Andreas Rønning
 */

class LimeMusic implements IMusic
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
	
	/* INTERFACE com.furusystems.flywheel.media.sound.IMusic */
	
	public function play(path:String, volume:Float, loop:Bool = true, offset:Float = 0):Void 
	{
		#if !music return #end
		if (isPlaying) {
			stop();
		}
		_lastLoop = loop;
		#if openfl
		var s:Sound = Assets.getSound(path, false);
		#else
		var s:Sound = new Sound(new URLRequest(path));
		#end
		if (s == null) {
			trace("Couldnt load sound from path: " + path);
			return;
		}
		trace("Play music of length: "+s.length);
		
		channel = s.play(offset, loop ? 9999 : 0, new SoundTransform(volume));
		isPlaying = true;
		_path = path;
	}
	
	function play2(path:String, startTime:Float, volume:Float, loop:Bool = true):Void
	{
		#if !music return #end
		if (isPlaying) {
			stop();
		}
		_lastLoop = loop;
		
		#if debug
		trace("play music: " + path);
		#end
		#if openfl
		var s:Sound = Assets.getSound(path, false);
		#else
		var s:Sound = new Sound(new URLRequest(path));
		#end
		if (s == null) {
			#if debug
			trace("Couldnt load sound from path: " + path);
			#end
			return;
		}
		
		channel = s.play(startTime, loop ? 9999 : 0, new SoundTransform(volume));
		isPlaying = true;
		_path = path;
	}
	
	public function stop():Void 
	{
		if (isPlaying)
		{ 
			trace("Stop");
			channel.stop();
			channel = null;
			isPlaying = false;
		}
	}
	
	public function setVolume(musicVolume:Float):Void 
	{
		if (isPlaying) {
			var st:SoundTransform = channel.soundTransform;
			st.volume = musicVolume;
			channel.soundTransform = st;
		}
	}
	
	
	public function setPaused(b:Bool):Void 
	{
		trace("pause music: " + b);
		if (channel == null)
		{
			trace("music channel is null");
			return;
		}
		if (b) {
			_lastPlayTime = channel.position;
			_lastVolume = channel.soundTransform.volume;
			channel.stop();
			isPlaying = false;
		}else {
			trace("resuming music at: " + _lastPlayTime, _lastLoop);
			play2(_path, _lastPlayTime, _lastVolume, _lastLoop);
		}
	}
	
}