package com.furusystems.flywheel.media.sound;

/**
 * ...
 * @author Andreas Rønning
 */
#if ios
@:build( com.furusystems.flywheel.preprocessing.Audio.buildSoundDurations("//Users/johndavies/Documents/PaperPals/branches/openfl/assets/audio/fx") ) class CueDurations
#elseif openfl
@:build( com.furusystems.flywheel.preprocessing.Audio.buildSoundDurations("./assets/audio/fx") ) class CueDurations
#else
class CueDurations
#end
{
	
}