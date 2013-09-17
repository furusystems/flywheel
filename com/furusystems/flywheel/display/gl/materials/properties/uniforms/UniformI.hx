package com.furusystems.flywheel.display.gl.materials.properties.uniforms;
import openfl.gl.GL;
import openfl.gl.GLUniformLocation;

/**
 * ...
 * @author Andreas Rønning
 */
class UniformI extends Uniform
{
	public function new(name:String, size:Int, index:GLUniformLocation, defaultValue:Int = 0) 
	{
		super(name, size, index);
		value = defaultValue;
	}
	override public function update():Void 
	{
		GL.uniform1i(position, value);
	}
	
}