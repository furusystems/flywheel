package com.furusystems.flywheel.display.rendering.lime;

import lime.gl.GL;
import lime.gl.GLBuffer;
import lime.utils.Matrix3D;
/**
 * ...
 * @author Andreas Rønning
 */
class Mesh
{
	public var vbo:GLBuffer;
	public var ibo:GLBuffer;
	public var transform:Matrix3D;
	public function new() 
	{
		vbo = GL.createBuffer();
		ibo = GL.createBuffer();
		transform = new Matrix3D();
	}
	public inline function predraw() {
		
	}
	public inline function draw() {
		
	}
	public inline function postdraw() {
		
	}
	public function dispose() {
		GL.deleteBuffer(vbo);
		GL.deleteBuffer(ibo);
		transform = null;
	}
	
}