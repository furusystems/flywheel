package com.furusystems.flywheel.sound;
import com.furusystems.flywheel.Core;
import com.furusystems.flywheel.events.Signal1;
import com.furusystems.flywheel.sound.GameAudio;
import com.furusystems.flywheel.sound.IMusic;
import com.furusystems.flywheel.sound.lime.Music;

/**
 * ...
 * @author Andreas Rønning
 */
@:build( com.furusystems.flywheel.preprocessing.Audio.buildMusicPaths("./assets/audio/music") ) class GameMusic 
{
	public var currentMusic:String;
	public var nextMusic:String;
	public var prevMusic:String;
	public var loopNext:Bool;
	
	public var masterVolume:Float;
	public var masterMasterVolume:Float;
	
	public var onTransitionComplete:Signal1<GameMusic>;
	
	var currentTransition:MusicTransition;
	var transitionDuration:Float;
	var transitionTime:Float;
	var transitionGrace:Float;
	var transitionStartVolume:Float;
	var transitionTargetVolume:Float;
	var transitionResultVolume:Float;
	
	public var audio:GameAudio;
	var targetMusicVolume:Float;
	var musicVolume:Float;
	var paused:Bool;
	
	var nextPlayOffset:Float;
	
	var muted:Bool;
	
	var m:IMusic;
	
	
	public function new(audio:GameAudio) 
	{
		this.audio = audio;
		m = new Music(this);
		onTransitionComplete = new Signal1<GameMusic>();
		targetMusicVolume = musicVolume = masterVolume = masterMasterVolume = 1;
		currentMusic = "";
		prevMusic = "";
		loopNext = false;
		muted = false;
		paused = false;
	}
	public function setMuted(m:Bool):Void
	{
		muted = m;
		trace("Muted: " + muted);
		masterMasterVolume = (muted) ? 0.0 : 1.0;
	}
	
	public function setPaused(p:Bool):Void
	{
		m.setPaused(p);
	}
	
	public function playMusic(streamPath:String, volume:Float = -1, offset:Float = 0, looping:Bool = false, ?transition:MusicTransition, duration:Float = 2, grace:Float = 0.5):Void
	{
		if (streamPath == currentMusic || streamPath == nextMusic) return;
		if (!isEnabled()) return;
		if (transition == null) transition = MusicTransition.cut;
		if (streamPath == "") streamPath = null;
		if (volume == -1) volume = musicVolume;
		
		nextPlayOffset = offset;
		
		loopNext = looping;
		
		#if debug
		trace("streampath: " + streamPath + ", Transition: " + transition);
		#end
		
		if (streamPath == null) {
			switch(transition) {
				case MusicTransition.fade, MusicTransition.fade_to_cut:
					transition = MusicTransition.fade_to_cut;
				default:
					transition = MusicTransition.cut;
			}
		}
		switch(transition) {
			case MusicTransition.cut:
				transitionTargetVolume = transitionResultVolume = volume;
				cutTo(streamPath, volume);
				return;
			case MusicTransition.cut_to_fade:
				cutTo(streamPath, 0);
				transitionTargetVolume = transitionResultVolume = volume;
			case MusicTransition.fade, MusicTransition.fade_to_cut:
				transitionResultVolume = volume;
				transitionTargetVolume = 0;
			case MusicTransition.simplefade:
				transitionTargetVolume = transitionResultVolume = volume;
		}
		
		transitionStartVolume = musicVolume;
		
		transitionDuration = duration;
		transitionTime = 0;
		transitionGrace = grace;
		nextMusic = streamPath;
		
		currentTransition = transition;
	}
	
	function cutTo(streamPath:String, volume:Float) 
	{
		//trace("Cut to: " + streamPath+", "+volume);
		currentTransition = null;
		if(streamPath!=null){
			musicVolume = volume;
			currentMusic = streamPath;
			//trace("Cut to "+nextPlayOffset);
			m.play(streamPath, volume, loopNext, nextPlayOffset);
		}else {
			m.stop();
		}
	}
	
	function updateTransition(deltaS:Float) 
	{
		transitionTime += deltaS;
		var s:Float = transitionTime / transitionDuration;
		switch(currentTransition) {
			case MusicTransition.cut_to_fade, MusicTransition.simplefade:
				musicVolume = transitionStartVolume + s * (transitionTargetVolume-transitionStartVolume);
			case MusicTransition.fade:
				s = transitionTime / (transitionDuration * 0.5);
				musicVolume = transitionStartVolume + s * (transitionTargetVolume-transitionStartVolume);
				if (s > 1) {
					playMusic(nextMusic, transitionResultVolume, nextPlayOffset, loopNext, MusicTransition.cut_to_fade, transitionDuration / 2, transitionGrace);
				}
			case MusicTransition.fade_to_cut:
				musicVolume = transitionStartVolume + s * (transitionTargetVolume-transitionStartVolume);
				if (s >= 1) {
					playMusic(nextMusic, transitionResultVolume, nextPlayOffset, loopNext, MusicTransition.cut);
				}
			default:
		}
		trace("Updating transition: " + currentTransition + ", " + transitionTime + ", " + transitionDuration + ", " + s+", "+musicVolume);
		
		if (transitionTime >= transitionDuration) {
			endTransition();
		}
	}
	
	function endTransition() 
	{
		trace("End transition");
		musicVolume = transitionResultVolume;
		currentTransition = null;
		if (nextMusic==null) {
			m.stop();
		}
		currentMusic = nextMusic;
		onTransitionComplete.dispatch(this);
	}
	public function isEnabled():Bool {
		return masterVolume > 0 && masterMasterVolume > 0 && !muted;
	}
	
	private var prevVolume:Float;
	public function update(deltaS:Float):Void {
		if (currentMusic == "" && nextMusic == "") return;
		if (currentTransition != null) {
			updateTransition(deltaS);
		}
		var v:Float = musicVolume * masterVolume * masterMasterVolume;
		if(prevVolume!=v){
			prevVolume = v;
			m.setVolume(prevVolume);
		}
	}
	public function reset():Void {
		stop();
	}
	

	public function stop(sharp:Bool = false) 
	{
		if (currentMusic == null) return;
		#if debug
		trace("Stop music");
		#end
		if(sharp){
			currentMusic = nextMusic = null;
			currentTransition = null;
			trace("Sharp stop");
			m.stop();
		}else {
			trace("Fade stop");
			playMusic("", 0, 0, false, MusicTransition.fade_to_cut, 0.4, 0);
		}
	}
	
	public function fadeCurrent(targetVolume:Float, duration:Float = 1):Void
	{
		#if debug
		trace("Fade current to " + targetVolume);
		#end
		if (targetVolume == musicVolume) return;
		playMusic(currentMusic, targetVolume, 0, false, MusicTransition.simplefade, duration);
	}
	
}