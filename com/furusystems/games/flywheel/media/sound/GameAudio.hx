package com.furusystems.games.flywheel.media.sound;
import com.furusystems.games.flywheel.Core;
#if android
import com.furusystems.games.flywheel.media.sound.android.AndroidAudio;
#end


/**
 * ...
 * @author Andreas Rønning
 */

class GameAudio 
{
	public var fx:GameFX;
	public var music:GameMusic;
	
	public function new() 
	{
		#if android
			if (AndroidAudio.initialize()) {
				#if debug
				trace("Android audio initialized");
				#end
			}else {
				#if debug
				trace("Android audio could not initialize");
				#end
			}
		#end
		
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