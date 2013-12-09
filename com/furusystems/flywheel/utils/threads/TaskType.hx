package com.furusystems.flywheel.utils.threads;

/**
 * Task types expected by a worker
 * @author Andreas Rønning
 */
enum TaskType
{
	EXECUTE; //Run the task's execute() function
	SHUTDOWN; //Shut down the thread
}