package com.furusystems.flywheel.media.sound;

/**
 * ...
 * @author Andreas Rønning
 */
#if (ios || mac)
@:build( com.furusystems.flywheel.preprocessing.AssetProcessing.buildSoundDurations("/assets/audio/fx") ) class CueDurations
#else
@:build( com.furusystems.flywheel.preprocessing.AssetProcessing.buildSoundDurations("./assets/audio/fx") ) class CueDurations
#end
{
	
}