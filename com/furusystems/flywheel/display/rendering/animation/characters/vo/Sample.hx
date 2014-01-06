package com.furusystems.flywheel.display.rendering.animation.characters.vo;
import flash.utils.ByteArray;

/**
 * ...
 * @author Andreas Rønning
 */
class Sample
{

	public var x:Float;
	public var y:Float;
	public var z:Float;
	public var rotation:Float;
	public var scaleX:Float;
	public var scaleY:Float;
	
	public var boneID:Int;
	public var sequenceName:String;
	public var sequenceFrame:Int;
	public function new(bytes:ByteArray) 
	{
		boneID = bytes.readShort();
		z = bytes.readFloat();
		sequenceName = bytes.readUTF();
		sequenceFrame = bytes.readShort();
		x = bytes.readFloat();
		y = bytes.readFloat();
		rotation = bytes.readFloat();
		scaleX = bytes.readFloat();
		scaleY = bytes.readFloat();
	}
	
}