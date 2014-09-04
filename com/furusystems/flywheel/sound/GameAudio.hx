package com.furusystems.flywheel.sound;
import com.furusystems.flywheel.Core;
#if native
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
	#if lime
	var limeAudioHandler:AudioHandler;
	#end
	public var fx:GameFX;
	public var music:GameMusic;
	
	public function new(#if lime limeInstance:Lime #end) 
	{
		limeAudioHandler = limeInstance.audio;
		fx = new GameFX(this);
		music = new GameMusic(this);
	}
	
	public inline function create(name:String, path:String, isMusic:Bool = false):Sound {
		return limeAudioHandler.create(name, path, isMusic);
	}
	public inline function stop(name:String) {
		limeAudioHandler.stop(name);
	}
	public inline function volume(name:String, ?vol:Float):Float {
		return limeAudioHandler.volume(name, vol);
	}
	public inline function playing(name:String):Bool {
		return limeAudioHandler.playing(name);
	}
	public inline function play(name:String, count:Int, offset:Float = 0.0):Void {
		return limeAudioHandler.play(name, count, offset);
	}
	public inline function position(name:String, ?offset:Float):Float {
		return limeAudioHandler.position(name, offset);
	}
	public inline function loop(name:String){
		return limeAudioHandler.loop(name);
	}
	public inline function sound(name:String):Sound {
		return limeAudioHandler.sound(name);
	}
	
	public function update(deltaS:Float):Void
	{
		fx.update(deltaS);
		music.update(deltaS);
	}
	public function reset():Void {
		fx.reset();
		music.reset();
	}
	
	public function dispose() 
	{
		fx.reset();
		music.reset();
	}
	
	public function setPaused(paused:Bool):Void 
	{
		music.setPaused(paused);
		fx.setPaused(paused);
	}
	
}