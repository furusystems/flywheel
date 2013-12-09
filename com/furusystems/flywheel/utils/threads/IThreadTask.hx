package com.furusystems.flywheel.utils.threads;

/**
 * Defines a task that can be accepted by the worker pool
 * @author Andreas Rønning
 */
interface IThreadTask
{
	/**
	 * Called by a worker thread when carrying out this task
	 */
	function execute():Void;
	/**
	 * Used by the worker thread to determine how to handle the task
	 * @return
	 */
	function getType():TaskType;
}