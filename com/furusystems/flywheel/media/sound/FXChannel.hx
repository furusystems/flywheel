package com.furusystems.flywheel.media.sound;
#if (android && soundmanager)
import com.furusystems.flywheel.Core;
import com.furusystems.flywheel.media.sound.android.AndroidPlayingSound;
#else
import com.furusystems.flywheel.media.sound.ofl.PlayingSound;
#end
import com.furusystems.flywheel.media.sound.IPlayingSound;
import com.furusystems.flywheel.media.sound.ISoundCue;

/**
 * ...
 * @author Andreas Rønning
 */

class FXChannel 
{
	public var name:String;
	public var defaultPriority:Int;
	public var playingSounds:List<IPlayingSound>;
	public var muted:Bool;
	public var mgr:GameFX;
	public var polyphony:Int;
	public function new(name:String, mgr:GameFX, polyphony:Int = 1, defaultPriority:Int = 0) 
	{
		this.name = name;
		this.polyphony = polyphony;
		this.mgr = mgr;
		this.defaultPriority = defaultPriority;
		playingSounds = new List<IPlayingSound>();
		muted = false;
	}
	public function update(deltaS:Float):Void {
		for (s in playingSounds) {
			s.update(deltaS);
			if (s.complete)
			{
				playingSounds.remove(s);
			}
		}
	}
	public function reset():Void {
		stopAllSounds();
	}
	#if (android && soundmanager)
	public function play(path:String, vol:Float = 1, pan:Float = 0, loop:Int = 0, priority:Int = -1, rate:Float = 1):AndroidPlayingSound
	#else
	public function play(path:String, vol:Float = 1, pan:Float = 0, loop:Int = 0, priority:Int = -1, rate:Float = 1):IPlayingSound
	#end
	{
		if (mgr.muted) return null;
		if (priority == -1) priority = defaultPriority;
		var sp:Map<String, ISoundCue> = mgr.soundPool;
		if (!(muted&&mgr.muted))
		{
			if (!sp.exists(path))
			{
				#if debug
				trace("No cue loaded from path: " + path);
				#end
				return null;
			} else {
				if (consolidatePolyphony(priority)) {
					var cue:ISoundCue = sp.get(path);
					#if (android && soundmanager)
					var s = new AndroidPlayingSound(cue, vol * mgr.masterVolume * mgr.masterMasterVolume, pan, loop, priority, rate);
					#else
					var s = new PlayingSound(cue, vol * mgr.masterVolume * mgr.masterMasterVolume, pan, loop);
					#end
					playingSounds.add(s);
					return s;
				}else {
					#if debug
					trace("Sound could not be played due to unavailable polyphony");
					#end
					return null;
				}
			}
		} else {
			return null;
		}
	}
	private function consolidatePolyphony(priority:Int):Bool {
		//is there available polyphony?
		if (playingSounds.length < polyphony) {
			return true;
		}
		//Are there lower or same priority sounds playing? if so, kill one
		for (s in playingSounds) {
			if (s.priority <= priority) {
				s.dispose();
				return true;
			}
		}
		//there is no available polyphony, and all other currently playing sounds are higher priority. FAIL
		return false;
	}
	public function stopAllSounds():Void {
		while(playingSounds.length>0){
			playingSounds.pop().dispose();
		}
	}
	public function setVolumeForAll(target:Float):Void {
		for (s in playingSounds) {
			s.volume.value = target;
		}
	}
	public function setPanForAll(target:Float):Void {
		for (s in playingSounds) {
			s.pan.value = target;
		}
	}
	public function stopLoops():Void 
	{
		for (s in playingSounds) {
			if (s.loopcount.value != 0) {
				s.dispose();
			}
		}
	}
	
}