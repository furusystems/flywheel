package com.furusystems.flywheel.display.rendering.lime.resources;
import com.furusystems.flywheel.display.rendering.lime.materials.Shader;
import lime.utils.Assets;
import lime.utils.ByteArray;

/**
 * ...
 * @author Andreas Rønning
 */
class ShaderHandle
{
	
	public var acquired:Bool;
	public var vertSrc:String;
	public var fragSrc:String;
	public var shader:Shader;
	public function new(vertSrcPath:String, fragSrcPath:String)
	{
		this.vertSrc = Assets.getText(vertSrcPath);
		this.fragSrc = Assets.getText(fragSrcPath);
	}
	
	public function acquire():ShaderHandle 
	{
		if (acquired) return this;
		acquired = true;
		shader = Shader.createFromSrc(vertSrc, fragSrc);
		return this;
	}
	
	public function release():Void 
	{
		if (!acquired) return;
		if (shader != null) shader.dispose();
		shader = null;
		acquired = false;
	}
	
}