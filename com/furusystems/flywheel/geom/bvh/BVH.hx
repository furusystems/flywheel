package com.furusystems.flywheel.geom.bvh;
import com.furusystems.flywheel.geom.Vector2D;
using com.furusystems.flywheel.geom.Vector2D;
import com.furusystems.flywheel.geom.AABB;
import com.furusystems.flywheel.utils.UID;

/**
 * ...
 * @author Andreas Rønning
 */
#if fwgenerics
@:generic
#end
class BVH<T:AABB> {
	public var children:List<BVH<T>>;
	public var holder:T;
	public var parent:BVH<T>;
	public var bounds:AABB;
	public var hasChildren(get, never):Bool;
	public var calcAuto:Bool = true;
	var depth:Int;
	var threshold:Float;
	var uid:Int = 0;
	var testVec:Vector2D;
	public function new(?holder:T, ?parent:BVH<T>, threshold:Float = 256) {
		uid = UID.next();
	
		testVec = new Vector2D();
		this.threshold = threshold;
		this.parent = parent;
		this.holder = holder;
		if(holder!=null) holder.aabbUserData = this;
		children = new List<BVH<T>>();
		bounds = new AABB();
		if (parent != null) depth = parent.depth + 1;
	}
	
	inline function get_hasChildren():Bool {
		return children.length > 0;
	}
	
	public function size():Int {
		var out:Int = 0;
		if (holder != null) out = 1;
		for (c in children) {
			out += c.size();
		}
		return out;
	}
	
	public function toString():String {
		return "{BVH " + hasChildren + " : " + holder + " : " + uid+"}";
	}
	public function queryPt(x:Float, y:Float, scale:Float = 1, ?out:List<BVH<T>>):List<BVH<T>> 
	{
		if (out == null) out = new List<BVH<T>>();
		testVec.setTo(x, y);
		if (bounds.containsVector2D(testVec)) {
			if (holder != null) out.add(this);
			for (c in children) {
				c.queryPt(x, y, scale, out);
			}
		}
		return out;
	}
	public function queryBox(box:AABB, scale:Float = 1, ?out:List<BVH<T>>):List<BVH<T>> {
		if (out == null) out = new List<BVH<T>>();
		if (bounds.intersects(box)) {
			if (holder != null) {
				out.add(this);
			}else{
				for (c in children) {
					c.queryBox(box, scale, out);
				}
			}
		}
		return out;
	}
	
	public function contains(n:T):Bool {
		if (holder == n) return true;
		for (v in children) {
			if (v.contains(n)) return true;
		}
		return false;
	}
	
	public function calcBounds():Void {
		var boundSize = bounds.sizeSq;
		if (holder != null) { 
			bounds.redefine(holder.position.x, holder.position.y, holder.size.x, holder.size.y);
		}else if(hasChildren){
			bounds.copyFrom(children.first().bounds);
		}else {
			bounds.zero();
		}
		for (c in children) {
			bounds.union(c.bounds, bounds);
		}
		if (bounds.sizeSq != boundSize && parent != null) {
			parent.calcBounds();
		}
	}
	
	public function add(n:T):BVH<T> {
		if (contains(n)) {
			return null;
		}
		for (c in children) {
			if (c.bounds.position.distanceManhattan(n.position) < threshold) {
				return c.add(n);
			}
		}
		if (holder != null) {
			var v = new BVH<T>(holder, this);
			children.add(v);
			if(v.calcAuto) v.calcBounds();
			holder = null;
		}
		var v = new BVH<T>(n, this);
		children.add(v);
		if(v.calcAuto) v.calcBounds();
		
		return v;
	}
	
	public inline function clear():Void {
		children = new List<BVH<T>>();
		holder = null;
	}
	
	public function destroy():Void {
		if (holder != null) {
			holder.aabbUserData = null;
			holder = null;
		}
		if (parent != null) {
			parent.remove(this);
		}
	}
	
	
	function remove(n:BVH<T>):Void {
		children.remove(n);
		if (!hasChildren) {
			if (parent != null) {
				parent.remove(this);
				return;
			}
		}
		if(calcAuto) calcBounds();
	}
}