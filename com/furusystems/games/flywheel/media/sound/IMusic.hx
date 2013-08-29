package com.furusystems.games.flywheel.media.sound;

/**
 * ...
 * @author Andreas Rønning
 */

interface IMusic {
	function play(path:String, volume:Float, loop:Bool = true):Void;
	function stop():Void;
	function setVolume(musicVolume:Float):Void;
	function setPaused(b:Bool):Void;
}