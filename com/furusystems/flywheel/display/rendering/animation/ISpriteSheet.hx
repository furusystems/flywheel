package com.furusystems.flywheel.display.rendering.animation;
import com.furusystems.flywheel.utils.data.SizedHash;
import croissant.renderer.lime.materials.PNGTexture;
import croissant.renderer.lime.tiles.LimeTileSheet;

/**
 * ...
 * @author Andreas Rønning
 */

interface ISpriteSheet 
{

	public var texture:PNGTexture;
	public var sequences:SizedHash<ISpriteSequence>; 
	public var tilesheet:LimeTileSheet;
	
	public function getSequenceByName(name:String):ISpriteSequence;
}