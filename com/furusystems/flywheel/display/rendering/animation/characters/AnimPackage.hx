package com.furusystems.flywheel.display.rendering.animation.characters;
import haxe.Json;
import flash.utils.ByteArray;

/**
 * ...
 * @author Andreas Rønning
 */
class AnimPackage
{
	var data:ByteArray;
	public var skeleton:Skeleton;
	public var basePose:Animation;
	public var animations:Array<Animation>;
	public function new(data:ByteArray) 
	{
		this.data = data;
		trace("New anim package");
		data.position = 0;
		var version:Int = data.readShort();
		trace("Loading animation data version: " + version);
		var jsn:String = data.readUTF();
		trace("Bone json: " + jsn);
		skeleton = new Skeleton(jsn);
		
		var boneCount:Int = data.readShort();
		var animationCount:Int = data.readShort();
		
		trace("counts: " + boneCount + ", " + animationCount);
		
		animations = [];
		for (i in 0...animationCount) 
		{
			if (i == 0) {
				basePose = Animation.fromBytes(boneCount, data);
			}else {
				animations.push(Animation.fromBytes(boneCount, data));
			}
		}
		data.clear();
		trace("Anim package created");
		
	}
	public function dispose():Void {
		animations = null;
		skeleton = null;
	}
	
}