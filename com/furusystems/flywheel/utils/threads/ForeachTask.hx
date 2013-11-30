package com.furusystems.flywheel.utils.threads;
import com.furusystems.flywheel.utils.threads.TaskType;
import com.furusystems.flywheel.utils.threads.ThreadTask;

/**
 * ...
 * @author Andreas Rønning
 */
class ForeachTask<T> extends ThreadTask
{
	var list:Array<T>;
	var start:Int;
	var end:Int;
	var handler:T -> Void;

	public function new(list:Array<T>, start:Int, end:Int, handler:T -> Void) 
	{
		super(TaskType.FOREACH);
		this.handler = handler;
		this.end = end;
		this.start = start;
		this.list = list;
		
	}
	override public function execute():Void 
	{
		for (i in start...end) 
		{
			handler(list[i]);
		}
	}
	
}