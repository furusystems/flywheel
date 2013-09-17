package com.furusystems.flywheel.display.gl.mesh.primitives;
import com.furusystems.flywheel.display.gl.mesh.Mesh;
import com.furusystems.flywheel.utils.data.Color4;
import flash.geom.Point;
import flash.geom.Vector3D;
import openfl.gl.GL;

/**
 * ...
 * @author Andreas Rønning
 */
class Quad extends Mesh
{

	public function new(?name) 
	{
		super(name==null?"Quad":name);
		
		createVertexBuffer([
			Mesh.createVertex(new Vector3D(-1, -1, 0), new Vector3D(0, 0, 1), new Vector3D(0, 0, 1), new Point(0, 0), new Color4(1, 0, 0, 1)),
			Mesh.createVertex(new Vector3D(1, -1, 0), new Vector3D(0, 0, 1), new Vector3D(0, 0, 1), new Point(1, 0), new Color4(0, 1, 0, 1)),
			Mesh.createVertex(new Vector3D(1, 1, 0), new Vector3D(0, 0, 1), new Vector3D(0, 0, 1), new Point(1, 1), new Color4(0, 0, 1, 1)),
			Mesh.createVertex(new Vector3D(-1, 1, 0), new Vector3D(0, 0, 1), new Vector3D(0, 0, 1), new Point(0, 1), new Color4(1, 1, 0, 1))
		]);
		
		createIndexBuffer([
			0, 1, 2, 0, 2, 3
		]);
	}
	
}