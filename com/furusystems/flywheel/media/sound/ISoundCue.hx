package com.furusystems.flywheel.media.sound;

/**
 * ...
 * @author Andreas Rønning
 */

interface ISoundCue 
{
	var path:String;
	var index:Int;
	var duration:Float;
	function release():Void;

}