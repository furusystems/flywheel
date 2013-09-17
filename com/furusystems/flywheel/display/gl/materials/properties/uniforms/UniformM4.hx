package com.furusystems.flywheel.display.gl.materials.properties.uniforms;
import flash.geom.Matrix3D;
import openfl.gl.GL;
import openfl.gl.GLUniformLocation;

/**
 * ...
 * @author Andreas Rønning
 */
class UniformM4 extends Uniform
{
	public function new(name:String, size:Int, index:GLUniformLocation, ?defaultValue:Matrix3D) 
	{
		super(name, size, index);
		if (defaultValue == null) defaultValue = new Matrix3D();
		value = defaultValue;
	}
	override public function update():Void 
	{
		GL.uniformMatrix3D(position, false, value);
	}
	
}