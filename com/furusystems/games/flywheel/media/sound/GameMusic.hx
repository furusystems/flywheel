package com.furusystems.games.flywheel.media.sound;
import com.furusystems.games.flywheel.Core;
import com.furusystems.games.flywheel.media.sound.GameAudio;
import com.furusystems.games.flywheel.media.sound.IMusic;

#if android
import com.furusystems.games.flywheel.media.sound.android.AndroidMusic;
#else
import com.furusystems.games.flywheel.media.sound.ofl.Music;
#end

/**
 * ...
 * @author Andreas Rønning
 */

@:build( com.furusystems.games.flywheel.build.AssetProcessing.buildMusicPaths("./assets/audio/music") ) class GameMusic 
{
	public var currentMusic:String;
	public var nextMusic:String;
	public var prevMusic:String;
	
	public var masterVolume:Float;
	public var masterMasterVolume:Float;
	
	var currentTransition:MusicTransition;
	var transitionDuration:Float;
	var transitionTime:Float;
	var transitionGrace:Float;
	var transitionStartVolume:Float;
	var transitionTargetVolume:Float;
	var transitionResultVolume:Float;
	
	var audio:GameAudio;
	var targetMusicVolume:Float;
	var musicVolume:Float;
	var paused:Bool;
	
	var muted:Bool;
	
	var m:IMusic;
	
	public function new(audio:GameAudio) 
	{
		#if android
		m = new AndroidMusic();
		#else
		m = new Music();
		#end
		this.audio = audio;
		targetMusicVolume = musicVolume = masterVolume = masterMasterVolume = 1;
		currentMusic = null;
		prevMusic = null;
		muted = false;
		paused = false;
	}
	public function setMuted(m:Bool):Void
	{
		muted = m;
		if (muted) stop(true);
	}
	
	public function setPaused(p:Bool):Void
	{
		// doesn't actually pause the music, just stops the mp3 and stores its name to be restarted on 'resume'
		#if android
			m.setPaused(p);
		#else
		if (p)
		{
			prevMusic = currentMusic;
			stop(true);
		} else {
			if (prevMusic != null)
			{
				playMusic(prevMusic, 1, MusicTransition.cut);
			}
		}
		#end
	}
	
	public function playMusic(streamPath:String, volume:Float = 1, ?transition:MusicTransition, duration:Float = 2, grace:Float = 0.5):Void
	{
		if (!isEnabled()) return;
		if (transition == null) transition = MusicTransition.cut;
		if (streamPath == "") streamPath = null;
		
		currentTransition = null;
		transitionStartVolume = musicVolume;
		trace("streampath: " + streamPath + ", Transition: " + transition);
		
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
			m.play(streamPath, volume);
			musicVolume = volume;
			currentMusic = streamPath;
		}else {
			m.stop();
		}
	}
	
	function updateTransition(deltaS:Float) 
	{
		transitionTime += deltaS;
		var s:Float = transitionTime / transitionDuration;
		//trace("Updating transition: " + currentTransition+", "+transitionTime+", "+transitionDuration);
		switch(currentTransition) {
			case MusicTransition.cut_to_fade, MusicTransition.simplefade:
				musicVolume = transitionStartVolume + s * (transitionTargetVolume-transitionStartVolume);
			case MusicTransition.fade:
				s = transitionTime / (transitionDuration * 0.5);
				musicVolume = transitionStartVolume + s * (transitionTargetVolume-transitionStartVolume);
				if (s > 1) {
					playMusic(nextMusic, transitionResultVolume, MusicTransition.cut_to_fade, transitionDuration / 2, transitionGrace);
				}
			case MusicTransition.fade_to_cut:
				musicVolume = transitionStartVolume + s * (transitionTargetVolume-transitionStartVolume);
				if (s >= 1) {
					playMusic(nextMusic, transitionResultVolume, MusicTransition.cut);
				}
			default:
		}
		
		if (transitionTime>=transitionDuration) {
			endTransition();
		}
	}
	
	function endTransition() 
	{
		musicVolume = transitionResultVolume;
		currentTransition = null;
		if (nextMusic==null) {
			m.stop();
		}
		currentMusic = nextMusic;
	}
	public function isEnabled():Bool {
		return masterVolume > 0 && masterMasterVolume > 0 && !muted;
	}
	
	private var prevVolume:Float;
	public function update(deltaS:Float):Void {
		if (currentTransition != null) {
			updateTransition(deltaS);
		}
		if (currentMusic == null && nextMusic == null) return;
		
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
		trace("Stop music");
		if (currentMusic == null) return;
		if(sharp){
			currentMusic = nextMusic = null;
			m.stop();
		}else {
			playMusic("", 0, MusicTransition.fade_to_cut);
		}
	}
	
	public function fadeCurrent(targetVolume:Float, duration:Float = 1):Void
	{
		trace("Fade current to " + targetVolume);
		if (targetVolume == musicVolume) return;
		playMusic(currentMusic, targetVolume, MusicTransition.simplefade, duration);
	}
	
}