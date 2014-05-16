package com.furusystems.flywheel.display.rendering.animation;
import com.furusystems.flywheel.utils.data.SizedHash;
import com.furusystems.flywheel.display.rendering.lime.resources.TextureHandle;
import com.furusystems.flywheel.display.rendering.lime.tiles.LimeTileSheet;

/**
 * ...
 * @author Andreas Rønning
 */

interface ISpriteSheet 
{

	public var texture:TextureHandle;
	public var sequences:SizedHash<ISpriteSequence>; 
	public var tilesheet:LimeTileSheet;
	
	public function getSequenceByName(name:String):ISpriteSequence;
}