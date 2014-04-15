package com.furusystems.flywheel.sound;
import com.furusystems.flywheel.Core;
import lime.AudioHandler;
import lime.Lime;


/**
 * ...
 * @author Andreas Rønning
 */

class GameAudio 
{
	public var limeAudioHandler:AudioHandler;
	public var fx:GameFX;
	public var music:GameMusic;
	
	public function new(limeInstance:Lime) 
	{
		limeAudioHandler = limeInstance.audio;
		fx = new GameFX(this);
		music = new GameMusic(this);
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