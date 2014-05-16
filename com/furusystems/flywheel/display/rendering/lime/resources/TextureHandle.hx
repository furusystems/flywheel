package com.furusystems.flywheel.display.rendering.lime.resources;
import com.furusystems.flywheel.display.rendering.lime.materials.PNGTexture;
import lime.utils.Assets;
import lime.utils.ByteArray;

/**
 * ...
 * @author Andreas Rønning
 */
class TextureHandle
{
	public var pathOrBytes:Dynamic;
	public var tex:PNGTexture;
	public var acquired:Bool;
	public function new(pathOrBytes:Dynamic) 
	{
		this.pathOrBytes = pathOrBytes;
	}
	public function acquire():TextureHandle 
	{
		if (acquired) return this;
		var texBytes:ByteArray;
		if (Std.is(pathOrBytes, ByteArray)) {
			texBytes = pathOrBytes;
		}else {	
			texBytes = Assets.getBytes(pathOrBytes);
		}
		acquired = true;
		tex = PNGTexture.fromBytes(texBytes);
		return this;
	}
	public function release():Void 
	{
		if (!acquired) return;
		if (tex != null) tex.dispose();
		tex = null;
		acquired = false;
	}
	
}