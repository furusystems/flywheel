package com.furusystems.flywheel.display.gl.materials.properties;
import com.furusystems.flywheel.display.gl.materials.GLSLShader;
import openfl.gl.GLUniformLocation;

/**
 * ...
 * @author Andreas Rønning
 */
class VertAttribute
{
	public var name:String;
	public var type:ParamType;
	public var position:Int;
	public var size:Int;
	public function new(name:String, type:ParamType, position:Int, size:Int) 
	{
		this.name = name;
		this.type = type;
		this.position = position;
		this.size = size;
	}
	
}