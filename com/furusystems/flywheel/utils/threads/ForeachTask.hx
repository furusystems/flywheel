package com.furusystems.flywheel.utils.threads;
import com.furusystems.flywheel.utils.threads.TaskType;

/**
 * IThreadTask implementation that iterates over a list of items and calls a function on each
 * @author Andreas Rønning
 */
class ForeachTask<T> implements IThreadTask
{
	var list:Array<T>;
	var start:Int;
	var end:Int;
	var handler:T -> Void;

	public function new(list:Array<T>, start:Int, end:Int, handler:T -> Void) 
	{
		this.handler = handler;
		this.end = end;
		this.start = start;
		this.list = list;
		
	}
	
	/* INTERFACE com.furusystems.flywheel.utils.threads.IThreadTask */
	
	inline public function execute():Void 
	{
		for (i in start...end) 
		{
			handler(list[i]);
		}
	}
	
	
	public inline function getType():TaskType 
	{
		return TaskType.EXECUTE;
	}
	
}