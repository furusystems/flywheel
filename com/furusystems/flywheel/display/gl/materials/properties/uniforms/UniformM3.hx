package com.furusystems.flywheel.display.gl.materials.properties.uniforms;
import openfl.gl.GL;
import openfl.gl.GLUniformLocation;
import openfl.utils.Float32Array;

/**
 * ...
 * @author Andreas Rønning
 */
class UniformM3 extends Uniform
{
	public function new(name:String, size:Int, index:GLUniformLocation, ?defaultValue:Array<Float>) 
	{
		super(name, size, index);
		if (defaultValue == null) defaultValue = [0, 0, 0, 0, 0, 0];
		value = defaultValue;
	}
	override public function update():Void 
	{
		GL.uniformMatrix3fv(position, false, new Float32Array(value));
	}
	
}