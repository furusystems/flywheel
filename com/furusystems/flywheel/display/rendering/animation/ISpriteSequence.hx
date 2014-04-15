package com.furusystems.flywheel.display.rendering.animation;
import com.furusystems.flywheel.geom.Rectangle;

/**
 * ...
 * @author Andreas Rønning
 */

interface ISpriteSequence 
{
	
	public var sheet:ISpriteSheet;
	public var startFrame:Int;
	public var endFrame:Int;
	public var numframes:Int;
	
	public var looping:Bool;
	public var loopStyle:LoopStyle;
	public var framerate:Int;
	
	public var secondsPerFrame:Float;
	public var totalSequenceTime:Float;
	public var name:String;
	
	public function getFrameBounds(idx:Int):Rectangle;

}