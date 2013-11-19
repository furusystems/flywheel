package com.furusystems.flywheel.utils.threads;
import haxe.ds.Vector.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
class ThreadTask
{
	public var handler:Array<Dynamic> -> Void;
	public var onComplete:Array<Dynamic> -> Void;
	public var data:Array<Dynamic>;
	public function new(handler:Array<Dynamic>->Void, data:Array<Dynamic>, ?onComplete:Array<Dynamic>->Void) 
	{
		this.data = data;
		this.handler = handler;
		this.onComplete = onComplete;
	}
	
}