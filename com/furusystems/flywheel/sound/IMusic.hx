package com.furusystems.flywheel.sound;

/**
 * ...
 * @author Andreas Rønning
 */

interface IMusic {
	function play(path:String, volume:Float, loop:Bool = true, offset:Float = 0):Void;
	function stop():Void;
	function setVolume(musicVolume:Float):Void;
	function setPaused(b:Bool):Void;
}