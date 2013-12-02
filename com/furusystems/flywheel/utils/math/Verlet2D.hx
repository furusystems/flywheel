package com.furusystems.flywheel.utils.math;

/**
 * ...
 * @author Andreas Rønning
 */
class Verlet2D
{
	public var x:Verlet;
	public var y:Verlet;
	public function new() 
	{
		x = new Verlet();
		y = new Verlet();
	}
	public inline function set(x:Float, y:Float):Verlet2D {
		this.x.set(x);
		this.y.set(y);
		return this;
	}
	public inline function update():Void {
		x.update();
		y.update();
	}
	
}