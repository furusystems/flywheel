package com.furusystems.flywheel.utils.threads;
import cpp.vm.Deque;
import cpp.vm.Mutex;
import cpp.vm.Thread;
import flash.system.System;
import haxe.ds.Vector;
import haxe.Timer;

/**
 * Simple worker thread pool implementation
 * @author Andreas Rønning
 */
class ThreadPool
{
	var _numThreads:Int;
	var _pool:Vector<Thread>;
	var _tasks:Deque<IThreadTask>;
	var _numJobs:SharedCounter;
	var _main:Thread;
	
	/**
	 * Create a new worker pool
	 * @param	numThreads
	 */
	public function new(numThreads:Int):Void {
		if (_pool != null) shutDown();
		_numThreads = numThreads;
		if (numThreads <= 0) {
			return;
		}
		_tasks = new Deque<IThreadTask>();
		_pool = new Vector<Thread>(numThreads);
		_numJobs = new SharedCounter();
		for (i in 0...numThreads) {
			_pool[i] = Thread.create(work);
			_pool[i].sendMessage(i);
			_pool[i].sendMessage(_numJobs);
			_pool[i].sendMessage(_tasks);
		}
	}
	
	/**
	 * Add a task to the list of jobs to be carried out
	 * @param	threadTask
	 */
	public inline function submitTask(threadTask:IThreadTask):Void {
		_numJobs.increment();
		_tasks.push(threadTask);
	}
	/**
	 * Block until all jobs are complete
	 */
	public function finish():Void {
		if (_numThreads <= 0) return;
		while (_numJobs.value > 0) {}
	}
	/**
	 * Tell threads to shut down and block until they do
	 */
	public function shutDown():Void {
		trace("Shutdown");
		var t:IThreadTask = new ShutdownTask();
		for (i in 0..._pool.length) 
		{
			submitTask(t);
		}
		finish(); //ensure all threads finish shutting down
		_numThreads = 0;
		_pool = null;
	}
	
	/**
	 * Worker entry point
	 */
	static function work():Void {
		var id:Int = Thread.readMessage(true);
		var numJobs:SharedCounter = Thread.readMessage(true);
		var tasks:Deque<IThreadTask> = Thread.readMessage(true);
		while (true) {
			var task:IThreadTask = tasks.pop(true);
			if (task.getType() == TaskType.SHUTDOWN) {
				numJobs.decrement();
				return;
			}else{
				task.execute();
				numJobs.decrement();
			}
		}
	}
	
	/**
	 * Get the number of jobs left on the queue
	 * @return
	 */
	public function getNumJobsInQueue():Int 
	{
		return _numJobs.value;
	}
	
	/**
	 * Get the number of threads in the pool
	 */
	public var numThreads(get_numThreads, null):Int;
	function get_numThreads():Int 
	{
		return _numThreads;
	}
	
	
	
	
	
	/**
	 * Divide the processing of a list of items across the worker pool.
	 */
	public function decompose<T>(list:Array<T>, itemHandler:T->Void):Void {
		var idx:Int = 0;
		var chunkLength:Int = Math.floor(list.length / _numThreads);
		for (i in 0..._numThreads) 
		{
			var t:IThreadTask = new ForeachTask<T>(list, idx, idx+chunkLength, itemHandler);
			submitTask(t);
			idx += chunkLength;
		}
	}
	
}
