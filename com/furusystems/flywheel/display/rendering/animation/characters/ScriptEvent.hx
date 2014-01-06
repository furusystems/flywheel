package com.furusystems.flywheel.display.rendering.animation.characters;
import hscript.Expr;
import hscript.Parser;
import flash.utils.ByteArray;

/**
 * ...
 * @author Andreas Rønning
 */
class ScriptEvent
{
	public var rawText:String = "";
	public var script:Expr;
	public var time:Float = 0;
	public var hasTriggered:Bool;
	private static var parser:Parser = new Parser();
	public function new(source:ByteArray) 
	{
		time = source.readFloat();
		rawText = source.readUTF();
		trace("new character script event");
		try {
			script = parser.parseString(rawText);
		}catch (error:Error) {
			trace("Invalid haxe script: " + rawText);
			script = null;
		}
	}
	
}