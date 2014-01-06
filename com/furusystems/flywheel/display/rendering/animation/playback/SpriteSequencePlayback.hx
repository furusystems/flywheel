package com.furusystems.flywheel.display.rendering.animation.playback;
import com.furusystems.flywheel.display.rendering.animation.ISpriteSequence;
import com.furusystems.flywheel.display.rendering.animation.LoopStyle;


/**
 * ...
 * @author Andreas Rønning
 */

class SpriteSequencePlayback 
{
	public var sequence:ISpriteSequence;
	
	public var currentSequenceFrame:Int;
	public var currentTilesheetFrame:Int;
	
	public var playing:Bool;
	
	public var onPlayComplete:SpriteSequencePlayback->Void;
	public var onEnterFrame:SpriteSequencePlayback-> Void;
	public var onSequenceChanged:SpriteSequencePlayback->Void;
	
	public var playDirection:Int;
	public var playtime:Float;
	public var looping:Bool;
	
	public function new() 
	{
		currentSequenceFrame = 0;
		currentTilesheetFrame = -1;
		playing = false;
		playDirection = 1;
		playtime = 0;
	}

	/**
	 * Called by the SpriteSheet. Advances internal time and sets the current frame on the parent sheet.
	 * @param	delta
	 */
	public function step(delta:Float):Void {
		if (!playing) return;
		playtime += delta * playDirection;
		if (playtime < 0 && sequence.loopStyle != LoopStyle.pingpong) return;
		if (playtime > sequence.totalSequenceTime || playtime < 0)
		{ 
			if (sequence.looping || looping || sequence.loopStyle==LoopStyle.once)
			{
				switch(sequence.loopStyle)
				{
					case LoopStyle.normal:
						var diff:Float = playtime-sequence.totalSequenceTime;
						playtime = diff;
						
					case LoopStyle.pingpong:
						playDirection = -playDirection;
						playtime += delta * playDirection;
						
					case LoopStyle.once:
						playtime = 0;
						if (onPlayComplete != null)
						{
							onPlayComplete(this);
						}
						stop();
				}
			} else {
				if (onPlayComplete != null)
				{
					onPlayComplete(this);
				}
				stop();
			}
		}
		gotoFrame(Std.int(playtime / sequence.secondsPerFrame));
	}
	private inline function gotoFrame(f:Int):Int {
		var prev:Int = currentSequenceFrame;
		currentSequenceFrame = Std.int(Math.max(0, Math.min(f, sequence.numframes)));
		currentTilesheetFrame = sequence.startFrame+currentSequenceFrame;
		if (prev != currentSequenceFrame && onEnterFrame != null) { 
			onEnterFrame(this);
		}
		return currentSequenceFrame;
	}
	public function setSequence(s:ISpriteSequence):Void {
		sequence = s;
		reset();
		if (onSequenceChanged != null) onSequenceChanged(this);
	}
	public function switchSequenceByName(n:String):Void {
		sequence = sequence.sheet.getSequenceByName(n);
		if (onSequenceChanged != null) onSequenceChanged(this);
	}
	
	/**
	 * Calculates the new playtime for the requested frame and steps to it
	 * Does NOT stop playback
	 * @param	f
	 * @return
	 */
	public inline function goto(f:Int):Int {
		playtime = f * sequence.secondsPerFrame;
		return gotoFrame(Math.round(playtime / sequence.secondsPerFrame)); // changed to Math.round because Std.Int displays the wrong frame!
	}
	/**
	 * Begins or resumes playback
	 * @param	?playFromStart
	 */
	public function play(?playFromStart:Bool = true ):Void {
		if (playFromStart) reset();
		playing = true;
	}
	
	/**
	 * Stops the sequence and goes to the first frame
	 */
	public inline function reset():Void
	{
		goto(0);
		playing = false;
	}
	
	/**
	 * Stops the sequence
	 */
	public function stop() 
	{
		gotoFrame(Math.floor(playtime / sequence.secondsPerFrame));
		playing = false;
	}
	
	public inline function getTilesheetFrame(sequenceFrame:Int):Int
	{
		return sequence.startFrame+sequenceFrame;
	}
	
	/**
	 * generally useless, just here for the lulz
	 * @param	f
	 */
	public inline function setRawTileSheetFrame(f:Int):Void
	{
		currentTilesheetFrame = f;
	}
	
}