package com.furusystems.flywheel.geom;
import com.furusystems.flywheel.geom.Vector2D;
#if flash
import flash.display.Graphics;
#end

/**
 * ...
 * @author Andreas Rønning
 */
class Ray2D
{
	public var start:Null<Vector2D>;
	public var vec:Null<Vector2D>;
	public function new(start:Vector2D, vec:Vector2D) 
	{
		this.start = start;
		this.vec = vec;
	}
	public inline function getPt(t:Float):Vector2D {
		return start + vec * t;
	}
	#if flash
	public inline function draw(graphics:Graphics, color:Int, scale:Float = 1):Void {
		graphics.moveTo(start.x * scale, start.y * scale);
		graphics.lineStyle(0, color);
		graphics.lineTo(start.x * scale + vec.x * scale, start.y * scale + vec.y * scale);
		graphics.lineStyle();
	}
	#end
	
	static public function intersection(a:Ray2D, b:Ray2D):Vector2D {
			var qp:Vector2D = b.start - a.start;
			var rxs:Float = a.vec.cross(b.vec);
			var t = qp.cross(b.vec) / rxs;
			var u = qp.cross(a.vec) / rxs;
			var isParallel = rxs == 0;
			var intersects = t >= 0 && t <= 1 && u >= 0 && u <= 1;
			if (intersects) {
				return a.getPt(t);
			}
			return null;
		}
	
}