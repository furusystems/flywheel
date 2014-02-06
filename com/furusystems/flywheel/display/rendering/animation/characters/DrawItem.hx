package com.furusystems.flywheel.display.rendering.animation.characters;
import com.furusystems.flywheel.geom.Matrix33;
import com.furusystems.flywheel.geom.Vector2D;
import com.furusystems.flywheel.display.rendering.animation.gts.GTSSequence;
import com.furusystems.flywheel.display.rendering.animation.gts.GTSSheet;
import com.furusystems.flywheel.display.rendering.animation.gts.GTSTileMetrics;
import com.furusystems.flywheel.display.rendering.animation.ISpriteSequence;
import flash.display.BitmapData;
import flash.Vector;
/**
 * ...
 * @author Andreas Rønning
 */
class DrawItem
{
	public var joint:Joint;
	public var zPos:Float = 0;
	public var vertices:Vector<Float>;
	public var uvs:Vector<Float>;
	public var gts:GTSSheet;
	
	static var utilMatrix:Matrix33 = new Matrix33();
	
	var tl:Vector2D;
	var tr:Vector2D;
	var br:Vector2D;
	var bl:Vector2D;
	var pn:Vector2D;
	var pn2:Vector2D;
	public function new(joint:Joint, gts:GTSSheet) 
	{
		this.joint = joint;
		vertices = new Vector<Float>();
		uvs = new Vector<Float>();
		tl = new Vector2D();
		tr = new Vector2D();
		br = new Vector2D();
		bl = new Vector2D();
		pn = new Vector2D();
		pn2 = new Vector2D();
		zPos = joint.z;
		this.gts = gts;
	}
	public function update(cameraOffsetX:Float = 0, cameraOffsetY:Float = 0):Void {
		if (joint.sequence == "n/a") return;
		zPos = joint.z;
		var frame:Int = joint.owner.overrideFrame > -1 ? joint.owner.overrideFrame : joint.frame;
		var seq:GTSSequence = cast gts.getSequenceByName(joint.sequence);
		var tex:BitmapData = gts.texture;
		
		var twr = 1 / tex.width;
		var twh = 1 / tex.height;
		
		var frameMetrics:GTSTileMetrics = seq.getTileMetrics(frame);
		var w:Float = frameMetrics.bounds.width * .5;
		var h:Float = frameMetrics.bounds.height * .5;
		
		pn2.x = w - (frameMetrics.offset.x + joint.owner.localOffset.x);
		pn2.y = h - (frameMetrics.offset.y + joint.owner.localOffset.y);
		
		tl.setTo( -w, -h);
		tr.setTo( w, -h);
		br.setTo( w, h);
		bl.setTo( -w, h);
		
		utilMatrix.identity();
		utilMatrix.translate(pn2.x, pn2.y);
		utilMatrix *= joint.matrix;
		utilMatrix.translate(-cameraOffsetX, -cameraOffsetY);
		
		utilMatrix.transformVectorInPlace(tl);
		utilMatrix.transformVectorInPlace(tr);
		utilMatrix.transformVectorInPlace(bl);
		utilMatrix.transformVectorInPlace(br);
		
		vertices[0] = tl.x;
		vertices[1] = tl.y;
		vertices[2] = tr.x;
		vertices[3] = tr.y;
		vertices[4] = br.x;
		vertices[5] = br.y;
		vertices[6] = bl.x;
		vertices[7] = bl.y;
		
		uvs[0] = (frameMetrics.bounds.x * twr);
		uvs[1] = (frameMetrics.bounds.y * twh);
		uvs[2] = ((frameMetrics.bounds.x + frameMetrics.bounds.width) * twr);
		uvs[3] = (frameMetrics.bounds.y * twh);
		uvs[4] = ((frameMetrics.bounds.x + frameMetrics.bounds.width) * twr);
		uvs[5] = ((frameMetrics.bounds.y + frameMetrics.bounds.height) * twh);
		uvs[6] = (frameMetrics.bounds.x * twr);
		uvs[7] = ((frameMetrics.bounds.y + frameMetrics.bounds.height) * twh);
	}
	
}