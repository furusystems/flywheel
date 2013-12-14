package com.furusystems.flywheel.media.sound;
import com.furusystems.flywheel.Core;
import com.furusystems.flywheel.media.sound.FXChannel;
import com.furusystems.flywheel.media.sound.GameAudio;
import com.furusystems.flywheel.media.sound.ISoundCue;
import flash.errors.Error;
#if openfl
import openfl.Assets;
#end

#if (android && soundmanager)
import com.furusystems.flywheel.media.sound.android.AndroidAudio;
import com.furusystems.flywheel.media.sound.android.AndroidCue;
#else
import com.furusystems.flywheel.media.sound.ofl.Cue;
#end

/**
 * ...
 * @author Andreas Rønning
 */
#if ios
@:build( com.furusystems.flywheel.preprocessing.Audio.buildSoundPaths("//Users/johndavies/Documents/PaperPals/branches/openfl/assets/audio/fx") ) class GameFX
#elseif openfl
@:build( com.furusystems.flywheel.preprocessing.Audio.buildSoundPaths("./assets/audio/fx") ) class GameFX 
#else
class GameFX
#end
{
	public var audio:GameAudio;
	public var muted:Bool;
	public var masterVolume:Float;
	public var masterMasterVolume:Float;

	public var soundPool:Map<String, ISoundCue>;
	
	private var channelCount:Int = 0;
	public var channels:Map<String, FXChannel>;
	
	public static inline var MAX_POLYPHONY:Int = 8;
	private var availablePolyphony:Int = MAX_POLYPHONY;
	
	public function new(audio:GameAudio) 
	{
		this.audio = audio;
		//cuePaths = new CuePaths();
		channels = new Map<String, FXChannel>();
		soundPool = new Map<String, ISoundCue>();
		masterVolume = 1.0;
		masterMasterVolume = 1.0;
	}
	public function createChannel(name:String, polyphony:Int, priority:Int = 0):FXChannel {
		polyphony = Std.int(Math.min(availablePolyphony, polyphony));
		if (polyphony < 1) {
			throw new Error("Ran out of available polyphony");
		}
		var chan:FXChannel = new FXChannel(name, this, polyphony, priority);
		channels.set(name, chan);
		availablePolyphony -= polyphony;
		channelCount++;
		trace("Created channel '"+name+"', current count: " + channelCount);
		return chan;
	}
	
	public function removeChannel(channel:FXChannel):FXChannel 
	{
		if (channels.exists(channel.name)) {
			channel.stopAllSounds();
			channels.remove(channel.name);
			channelCount--;
			availablePolyphony += channel.polyphony;
		}
		return channel;
	}
	
	public function dispose():Void {
		unloadAll();
		stopAllSounds();
		channels = null;
		channelCount = 0;
		soundPool = null;
	}
	
	public function getChannel(name:String):FXChannel {
		return channels.get(name);
	}
	public function update(deltaS:Float):Void {
		for (c in channels) {
			c.update(deltaS);
		}
	}
	public function load(path:String):Void {
		if (soundPool.exists(path) || !isEnabled()) return;
		var newCue:ISoundCue;
		#if (android && soundmanager)
			newCue = new AndroidCue(path);
		#else
			newCue = new Cue(path);
		#end
		var p:String = { var s = path.split("/"); s.pop().split(".").shift(); };
		trace("sfxname: " + p.toUpperCase());
		newCue.duration = Reflect.field(CueDurations, p.toUpperCase());
		soundPool.set(path, newCue);
		#if debug
		trace("SFX ADDED: '" + path + "' - " + soundPool.exists(path) + " : " + newCue.duration);
		#end
	}
	
	public function isEnabled():Bool
	{
		return masterVolume > 0 && masterMasterVolume > 0 && !muted;
	}
	public function setMuted(m:Bool):Void
	{
		muted = m;
		if(muted) stopAllSounds();
	}
	public function stopAllSounds():Void {
		for (c in channels) {
			c.stopAllSounds();
		}		
	}
	
	public function unloadAll():Void {
		for (c in soundPool) {
			c.release();
		}
		soundPool = new Map<String, ISoundCue>();
	}
	
	public function reset():Void {
		for (c in channels) {
			c.reset();
		}
	}
	public inline function isReady():Bool {
		#if (android && soundmanager)
			return AndroidAudio.isPoolReady();
		#else
			return true; //Dunno how sound loading on iphone works
		#end
	}
	public function setVolumeForAll(target:Float):Void {
		for (c in channels) {
			c.setVolumeForAll(target);
		}
	}
	public function setPanForAll(target:Float):Void {
		for (c in channels) {
			c.setPanForAll(target);
		}
	}
	
	public function stopLoops():Void 
	{
		for (c in channels) {
			c.stopLoops();
		}
	}
	
	public function setPaused(paused:Bool) 
	{
		#if (android && soundmanager)
		if (paused) {
			AndroidAudio.currentPool.autoPause();
		}else {
			AndroidAudio.currentPool.autoResume();
		}
		#else
			if(paused) stopAllSounds(); //TODO: Actually pause cues?
		#end
	}
	
}