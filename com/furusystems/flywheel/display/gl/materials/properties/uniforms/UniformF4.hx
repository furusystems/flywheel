package com.furusystems.flywheel.display.gl.materials.properties.uniforms;
import flash.geom.Vector3D;
import openfl.gl.GL;
import openfl.gl.GLUniformLocation;

/**
 * ...
 * @author Andreas Rønning
 */
class UniformF4 extends UniformF3
{

	public function new(name:String, size:Int, index:GLUniformLocation, ?defaultValue:Vector3D) 
	{
		super(name, size, index, defaultValue);
	}
	override public function update():Void 
	{
		GL.uniform4f(position, value.x, value.y, value.z, value.w);
	}
	
}