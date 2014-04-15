package com.furusystems.flywheel.display.rendering.animation;
import com.furusystems.games.rendering.lime.materials.PNGTexture;
import com.furusystems.games.rendering.lime.tiles.LimeTileSheet;
import com.furusystems.flywheel.utils.data.SizedHash;

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