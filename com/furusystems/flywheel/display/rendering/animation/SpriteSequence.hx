package com.furusystems.flywheel.display.rendering.animation;

import flash.geom.Rectangle;

/**
 * In short, responsible for setting the current frame output from a SpriteSheet.
 * Receives updates from the spritesheet it is currently owned by, and tracks time internally.
 * @author Andreas Rønning
 */

class SpriteSequence implements ISpriteSequence
{
	public var sheet:ISpriteSheet; //set from the SpriteSheet upon registering with it
	
	public var numframes:Int;
	public var startFrame:Int;
	public var endFrame:Int;
	public var currentSequenceFrame:Int;
	public var currentTilesheetFrame:Int;
	public var onPlayComplete:ISpriteSequence->Void;
	public var onEnterFrame:ISpriteSequence-> Void;
	public var playing:Bool;
	public var playtime:Float;
	public var looping:Bool;
	public var loopStyle:LoopStyle;
	public var playDirection:Int;
	public var framerate:Int;
	public var name:String;
	public var secondsPerFrame:Float;
	public var totalSequenceTime:Float;
	/**
	 * Create a new sequence
	 * @param	startFrame The starting frame in the sprite sheet (for this sequence)
	 * @param	endFrame The ending frame in the sprite sheet (for this sequence)
	 * @param	?loopStyle Defines the loop behavior when reaching the final frame
	 */
	public function new(name:String, startFrame:Int,endFrame:Int,?framerate:Int = 30, ?loopStyle:LoopStyle) 
	{
		this.framerate = framerate;
		this.name = name;
		if (loopStyle == null) loopStyle = LoopStyle.normal;
		this.startFrame = startFrame;
		this.endFrame = endFrame;
		numframes = endFrame-startFrame;
		playtime = 0;
		playing = false;
		this.loopStyle = loopStyle;
		looping = false;
		playDirection = 1;
		currentSequenceFrame = 0;
		secondsPerFrame = 1 / framerate;
		totalSequenceTime = numframes * secondsPerFrame;
	}
	
	public function toString():String
	{
		return "Sequence: " + name + ", " + startFrame + ", " + endFrame + ", " + numframes;
	}
	public function getFrameBounds(idx:Int):Rectangle {
		return new Rectangle();
	}
	
}