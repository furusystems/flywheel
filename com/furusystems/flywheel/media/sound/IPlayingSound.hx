package com.furusystems.flywheel.media.sound;
import com.furusystems.flywheel.Core;
import com.furusystems.flywheel.utils.data.Property;

/**
 * ...
 * @author Andreas Rønning
 */

interface IPlayingSound 
{
	function update(deltaS:Float):Void;
	function dispose():Void;
	var length:Float;
	var complete:Bool;
	var pan:Property<Float>;
	var volume:Property<Float>;
	var loopcount:Property<Int>;
	var playbackRate:Property<Float>;
	var priority:Int;
	var playStartTime:Int;
	
}