package com.furusystems.flywheel.geom.bvh;
import com.furusystems.flywheel.geom.Vector2D;
import com.furusystems.flywheel.geom.AABB;
import de.polygonal.ds.DLL;
import de.polygonal.ds.SLL;

/**
 * ...
 * @author Andreas Rønning
 */
 
class Volume<T:AABB> {
	public var children:DLL<Volume<T>>;
	public var holder:T;
	public var parent:Volume<T>;
	public var bounds:AABB;
	public var hasChildren:Bool;
	var depth:Int;
	var threshold:Float;
	public function new(?holder:T, ?parent:Volume<T>, threshold:Float = 256) {
		this.threshold = threshold;
		this.holder = holder;
		this.parent = parent;
		children = new DLL<Volume<T>>();
		bounds = new AABB();
		if (parent != null) depth = parent.depth + 1;
	}
	
	static var testVec:Vector2D = new Vector2D();
	public function queryPt(x:Float, y:Float, scale:Float = 1, ?out:SLL<Volume<T>>):SLL<Volume<T>> 
	{
		if (out == null) out = new SLL<Volume<T>>();
		testVec.setTo(x, y);
		if (bounds.containsVector2D(testVec)) {
			if (holder != null) out.append(this);
			for (c in children) {
				c.queryPt(x, y, scale, out);
			}
		}
		return out;
	}
	public function queryBox(box:AABB, scale:Float = 1, ?out:SLL<Volume<T>>):SLL<Volume<T>> {
		if (out == null) out = new SLL<Volume<T>>();
		if (bounds.intersects(box)) {
			if (holder != null) out.append(this);
			for (c in children) {
				c.queryBox(box, scale, out);
			}
		}
		return out;
	}
	
	public function destroy():Void {
		if (parent != null) parent.remove(this);
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
			bounds.copyFrom(children.head.val.bounds);
		}else {
			bounds.zero();
		}
		for (c in children) {
			bounds.union(c.bounds, bounds);
		}
		if (bounds.sizeSq!=boundSize && parent != null) {
			parent.calcBounds();
		}
	}
	
	public function add(n:T):Volume<T> {
		for (c in children) {
			if (c.bounds.position.distanceManhattan(n.position) < threshold) {
				var v = c.add(n);
				return v;
			}
		}
		hasChildren = true;
		if (holder != null) {
			var v = new Volume<T>(holder, this);
			children.append(v);
			v.calcBounds();
			holder = null;
		}
		var v = new Volume<T>(n, this);
		children.append(v);
		v.calcBounds();
		return v;
	}
	function remove(n:Volume<T>):Void {
		children.remove(n);
		if (children.size() == 0) {
			hasChildren = false;
			if (parent != null) parent.remove(this);
			return;
		}
		calcBounds();
	}
}
 
class BVH<T:AABB> extends Volume<T>
{

	public function new() 
	{
		super();
	}
	
}