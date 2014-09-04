package com.furusystems.flywheel.sound;
import com.furusystems.flywheel.Core;
import com.furusystems.flywheel.sound.FXChannel;
import com.furusystems.flywheel.sound.GameAudio;
import com.furusystems.flywheel.sound.ISoundCue;
import com.furusystems.flywheel.sound.lime.Cue;

/**
 * ...
 * @author Andreas Rønning
 */
@:build( com.furusystems.flywheel.preprocessing.Audio.buildSoundPaths("./assets/audio/fx") ) class GameFX 
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
		#if sound
		//cuePaths = new CuePaths();
		channels = new Map<String, FXChannel>();
		soundPool = new Map<String, ISoundCue>();
		masterVolume = 1.0;
		masterMasterVolume = 1.0;
		#end
	}
	public function createChannel(name:String, polyphony:Int, priority:Int = 0):FXChannel {
		#if sound
		polyphony = Std.int(Math.min(availablePolyphony, polyphony));
		if (polyphony < 1) {
			throw ("Ran out of available polyphony");
		}
		var chan:FXChannel = new FXChannel(name, this, polyphony, priority);
		channels.set(name, chan);
		availablePolyphony -= polyphony;
		channelCount++;
		trace("Created channel '"+name+"', current count: " + channelCount);
		return chan;
		#end
		return null;
	}
	
	public function removeChannel(channel:FXChannel):FXChannel 
	{
		#if sound
		if (channels.exists(channel.name)) {
			channel.stopAllSounds();
			channels.remove(channel.name);
			channelCount--;
			availablePolyphony += channel.polyphony;
		}
		return channel;
		#end
		return null;
	}
	
	public function dispose():Void {
		#if sound
		unloadAll();
		stopAllSounds();
		channels = null;
		channelCount = 0;
		soundPool = null;
		#end
	}
	
	public function getChannel(name:String):FXChannel {
		return channels.get(name);
	}
	public function update(deltaS:Float):Void {
		#if sound
		for (c in channels) {
			c.update(deltaS);
		}
		#end
	}
	public function load(path:String):Void {
		#if sound
		if (soundPool.exists(path) || !isEnabled()) return;
		var newCue:ISoundCue = new Cue(path);
		var p:String = { var s = path.split("/"); s.pop().split(".").shift(); };
		trace("sfxname: " + p.toUpperCase());
		newCue.duration = Reflect.field(CueDurations, p.toUpperCase());
		soundPool.set(path, newCue);
		#if debug
		trace("SFX ADDED: '" + path + "' - " + soundPool.exists(path) + " : " + newCue.duration);
		#end
		#end
	}
	
	public function isEnabled():Bool
	{
		return masterVolume > 0 && masterMasterVolume > 0 && !muted;
	}
	public function setMuted(m:Bool):Void
	{
		#if sound
		muted = m;
		if (muted) stopAllSounds();
		#end
	}
	public function stopAllSounds():Void {
		#if sound
		for (c in channels) {
			c.stopAllSounds();
		}		
		#end
	}
	
	public function unloadAll():Void {
		#if sound
		for (c in soundPool) {
			c.release();
		}
		soundPool = new Map<String, ISoundCue>();
		#end
	}
	
	public function reset():Void {
		#if sound
		for (c in channels) {
			c.reset();
		}
		#end
	}
	public inline function isReady():Bool {
		return true; //Dunno how sound loading on iphone works
	}
	
	public function setVolumeForAll(target:Float):Void {
		#if sound
		for (c in channels) {
			c.setVolumeForAll(target);
		}
		#end
	}
	public function setPanForAll(target:Float):Void {
		#if sound
		for (c in channels) {
			c.setPanForAll(target);
		}
		#end
	}
	
	public function stopLoops():Void 
	{
		#if sound
		for (c in channels) {
			c.stopLoops();
		}
		#end
	}
	
	public function setPaused(paused:Bool) 
	{
		#if sound
		#if (android && soundmanager)
		if (paused) {
			AndroidAudio.currentPool.autoPause();
		}else {
			AndroidAudio.currentPool.autoResume();
		}
		#else
			if(paused) stopAllSounds(); //TODO: Actually pause cues?
		#end
		#end
	}
	
}