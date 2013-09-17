package com.furusystems.utils.data;
import haxe.xml.Fast;

/**
 * ...
 * @author Andreas Rønning
 */

class XMLUtil 
{
	public inline static function getStringValue(f:Fast, nodename:String, defaultValue:String):String {
		if (f.hasNode.f) {
			return f.node.resolve(nodename).innerData;
		}else {
			return defaultValue;
		}
	}
	public inline static function getIntValue(f:Fast, nodename:String, defaultValue:Int):Int{
		if (f.hasNode.f) {
			return Std.parseInt(f.node.resolve(nodename).innerData);
		}else {
			return defaultValue;
		}
	}
	public inline static function getFloatValue(f:Fast, nodename:String, defaultValue:Float):Float{
		if (f.hasNode.f) {
			return Std.parseFloat(f.node.resolve(nodename).innerData);
		}else {
			return defaultValue;
		}
	}
}