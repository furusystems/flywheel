package com.furusystems.flywheel.display.rendering.lime.resources;
import com.furusystems.flywheel.display.rendering.animation.gts.GTSSheet;
import com.furusystems.flywheel.display.rendering.lime.materials.PNGTexture;
import lime.utils.Assets;
import lime.utils.ByteArray;

/**
 * ...
 * @author Andreas Rønning
 */
class GTSHandle
{
	public var acquired:Bool;
	public var path:String;
	public var gts:GTSSheet;
	public function new(path:String) 
	{
		this.path = path;
	}
	public function acquire():GTSHandle 
	{
		if (acquired) return this;
		var gtsBytes = Assets.getBytes(path);
		acquired = true;
		gts = new GTSSheet(path);
		return this;
	}
	public function release():Void 
	{
		if (!acquired) return;
		if (gts != null) gts.dispose();
		gts = null;
		acquired = false;
	}	
}