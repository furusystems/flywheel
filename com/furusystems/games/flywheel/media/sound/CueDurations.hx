package com.furusystems.games.flywheel.media.sound;

/**
 * ...
 * @author Andreas Rønning
 */
#if (ios || mac)
@:build( com.furusystems.games.flywheel.preprocessing.AssetProcessing.buildSoundDurations("/assets/audio/fx") ) class CueDurations
#else
@:build( com.furusystems.games.flywheel.preprocessing.AssetProcessing.buildSoundDurations("./assets/audio/fx") ) class CueDurations
#end
{
	
}