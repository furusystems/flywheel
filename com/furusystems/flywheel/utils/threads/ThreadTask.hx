package com.furusystems.flywheel.utils.threads;
import haxe.ds.Vector.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
class ThreadTask
{
	public var type:TaskType;
	public var handler:Array<Dynamic> -> Void;
	public var data:Array<Dynamic>;
	public function new(type:TaskType, handler:Array<Dynamic>->Void, ?data:Array<Dynamic>) 
	{
		this.type = type;
		this.data = data;
		this.handler = handler;
	}
	
}