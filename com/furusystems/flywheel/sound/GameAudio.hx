package com.furusystems.flywheel.sound;
#if (lime&&!openfl)
import lime.AudioHandler;
import lime.helpers.AudioHelper.Sound;
import lime.Lime;
#end


/**
 * ...
 * @author Andreas Rønning
 */

class GameAudio 
{
	#if (lime&&!openfl)
	var limeAudioHandler:AudioHandler;
	#end
	public var fx:GameFX;
	public var music:GameMusic;
	
	public function new(#if (lime&&!openfl) limeInstance:Lime #end) 
	{
		#if (lime&&!openfl) limeAudioHandler = limeInstance.audio; #end
		fx = new GameFX(this);
		music = new GameMusic(this);
	}
	public inline function create(name:String, path:String, isMusic:Bool = false) {
		#if sound
		return limeAudioHandler.create(name, path, isMusic);
		#else
		return null;
		#end
	}
	public inline function stop(name:String) {
		#if sound
		limeAudioHandler.stop(name);
		#end
	}
	public inline function volume(name:String, ?vol:Float) {
		#if sound
		return limeAudioHandler.volume(name, vol);
		#end
		return null;
	}
	public inline function playing(name:String) {
		#if sound
		return limeAudioHandler.playing(name);
		#end
		return null;
	}
	public inline function play(name:String, count:Int, offset:Float = 0.0) {
		#if sound
		return limeAudioHandler.play(name, count, offset);
		#end
		return null;
	}
	public inline function position(name:String, ?offset:Float) {
		#if sound
		return limeAudioHandler.position(name, offset);
		#end
		return null;
	}
	public inline function loop(name:String) {
		#if sound
		return limeAudioHandler.loop(name);
		#end
		return null;
	}
	public inline function sound(name:String) {
		#if sound
		return limeAudioHandler.sound(name);
		#end
		return null;
	}
	//#end
	public function update(deltaS:Float)
	{
		#if sound
		fx.update(deltaS);
		music.update(deltaS);
		#end
	}
	public function reset() {
		#if sound
		fx.reset();
		music.reset();
		#end
	}
	
	public function dispose() 
	{
		#if sound
		fx.reset();
		music.reset();
		#end
	}
	
	public function setPaused(paused:Bool):Void 
	{
		#if sound
		music.setPaused(paused);
		fx.setPaused(paused);
		#end
	}
	
}