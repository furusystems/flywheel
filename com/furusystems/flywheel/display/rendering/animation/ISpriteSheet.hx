package com.furusystems.flywheel.display.rendering.animation;
import flash.display.BitmapData;
import com.furusystems.flywheel.utils.data.SizedHash;
import openfl.display.Tilesheet;

/**
 * ...
 * @author Andreas Rønning
 */

interface ISpriteSheet 
{

	public var texture:BitmapData;
	
	public var sequences:SizedHash<ISpriteSequence>; 
	
	public var tilesheet:Tilesheet;
	
	public function getSequenceByName(name:String):ISpriteSequence;
}