package com.furusystems.flywheel.display.rendering.animation.characters;
import com.furusystems.flywheel.display.rendering.animation.characters.vo.Bone;
import haxe.Json;

/**
 * ...
 * @author Andreas Rønning
 */
class Skeleton extends Bone
{
	public function new(json:String) 
	{
		super(Json.parse(json));
	}	
	
}