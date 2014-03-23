package com.furusystems.flywheel.geom.bvh;
import com.furusystems.flywheel.geom.Vector2D;
import com.furusystems.flywheel.geom.AABB;
import de.polygonal.ds.DLL;
import de.polygonal.ds.SLL;

/**
 * ...
 * @author Andreas Rønning
 */
 
class BVH<T:AABB> {
	public var children:Array<BVH<T>>;
	public var holder:T;
	public var parent:BVH<T>;
	public var bounds:AABB;
	public var hasChildren(get,never):Bool;
	var depth:Int;
	var threshold:Float;
	var uid:Int = 0;
	static var uidPool:Int = 0;
	public function new(?holder:T, ?parent:BVH<T>, threshold:Float = 256) {
		uid = uidPool++;
		this.threshold = threshold;
		this.parent = parent;
		this.holder = holder;
		if(holder!=null) holder.aabbUserData = this;
		children = new Array<BVH<T>>();
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
	
	static var testVec:Vector2D = new Vector2D();
	public function queryPt(x:Float, y:Float, scale:Float = 1, ?out:SLL<BVH<T>>):SLL<BVH<T>> 
	{
		if (out == null) out = new SLL<BVH<T>>();
		testVec.setTo(x, y);
		if (bounds.containsVector2D(testVec)) {
			if (holder != null) out.append(this);
			for (c in children) {
				c.queryPt(x, y, scale, out);
			}
		}
		return out;
	}
	public function queryBox(box:AABB, scale:Float = 1, ?out:SLL<BVH<T>>):SLL<BVH<T>> {
		if (out == null) out = new SLL<BVH<T>>();
		if (bounds.intersects(box)) {
			if (holder != null) {
				out.append(this);
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
			bounds.copyFrom(children[0].bounds);
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
			trace("Already exists");
			return null;
		}
		for (c in children) {
			if (c.bounds.position.distanceManhattan(n.position) < threshold) {
				return c.add(n);
			}
		}
		if (holder != null) {
			var v = new BVH<T>(holder, this);
			children.push(v);
			v.calcBounds();
			holder = null;
		}
		var v = new BVH<T>(n, this);
		children.push(v);
		v.calcBounds();
		
		return v;
	}
	
	public function clear():Void {
		children = new Array<BVH<T>>();
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
		calcBounds();
	}
}