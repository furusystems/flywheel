package com.furusystems.flywheel.display.gl.mesh.primitives;
import com.furusystems.flywheel.display.gl.mesh.Mesh;
import flash.geom.Point;
import flash.geom.Vector3D;
import openfl.gl.GL;
import nme.utils.Float32Array;

/**
 * ...
 * @author Andreas Rønning
 */
class Triangle extends Mesh
{

	public function new(?name) 
	{
		super(name==null?"Triangle":name);
		
		createVertexBuffer([
			Mesh.createVertex(new Vector3D(0, 1, 0), new Vector3D(0, 0, 1), new Vector3D(0, 0, 1), new Point(0, 0), new Vector3D(1, 0, 0, 1)),
			Mesh.createVertex(new Vector3D(1, -1, 0), new Vector3D(0, 0, 1), new Vector3D(0, 0, 1), new Point(0, 0),  new Vector3D(0, 1, 0, 1)),
			Mesh.createVertex(new Vector3D(-1, -1, 0), new Vector3D(0, 0, 1), new Vector3D(0, 0, 1), new Point(0, 0),  new Vector3D(0, 0, 1, 1))
			]);
			
		createIndexBuffer([0, 1, 2]);
	}
	
}