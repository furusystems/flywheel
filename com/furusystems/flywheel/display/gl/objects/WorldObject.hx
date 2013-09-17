package com.furusystems.flywheel.display.gl.objects;
import com.furusystems.flywheel.display.gl.materials.Material;
import com.furusystems.flywheel.display.gl.mesh.Mesh;

/**
 * ...
 * @author Andreas Rønning
 */
typedef MaterialOverride = { location:Int, name:String, value:Dynamic };
class WorldObject extends Transform3D
{

	public var mesh:Mesh;
	public var material:Material;
	public var visible:Bool;
	public var materialOverrides:Map<String,MaterialOverride>;
	public function new() 
	{
		super();
		visible = true;
		mesh = null;
		material = null;
	}
	override public function prerender():Void {
		pushOverrides();
	}
	
	private inline function pushOverrides():Void 
	{
		
	}
	
	
}