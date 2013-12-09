package com.furusystems.flywheel.utils.threads;
import com.furusystems.flywheel.utils.threads.IThreadTask;
import com.furusystems.flywheel.utils.threads.TaskType;

/**
 * Task that does nothing but tell a thread to break out of its execution loop and close
 * @author Andreas Rønning
 */
class ShutdownTask implements IThreadTask
{

	public function new() 
	{
		
	}
	
	/* INTERFACE com.furusystems.flywheel.utils.threads.IThreadTask */
	
	public function execute():Void 
	{
		
	}
	
	inline public function getType():TaskType 
	{
		return TaskType.SHUTDOWN;
	}
	
}