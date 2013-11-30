package com.furusystems.flywheel.utils.threads;
import cpp.vm.Deque;
import cpp.vm.Mutex;
import cpp.vm.Thread;
import flash.system.System;
import haxe.ds.Vector;
import haxe.Timer;

/**
 * ...
 * @author Andreas Rønning
 */
class ThreadPool
{
	static var _numThreads:Int;
	static var pool:Vector<Thread>;
	static var tasks:Deque<ThreadTask> = new Deque<ThreadTask>();
	static var lock:Mutex = new Mutex();
	static var main:Thread;
	static var numJobs:SharedCounter = new SharedCounter();
	static var enabled:Bool = false;
	static var includeMain:Bool;
	public static inline function submitTask(threadTask:ThreadTask):Void {
		numJobs.increment();
		tasks.push(threadTask);
	}
	public static function setup(numThreads:Int, includeMain:Bool = false):Void {
		if (pool != null) shutDown();
		trace("Setup "+numThreads);
		_numThreads = numThreads;
		if (numThreads <= 0) {
			enabled = false;
			return;
		}
		ThreadPool.includeMain = true;
		enabled = true;
		pool = new Vector<Thread>(numThreads);
		numJobs.reset();
		for (i in 0...numThreads) {
			pool[i] = Thread.create(work);
			pool[i].sendMessage(i);
			pool[i].sendMessage(numJobs);
		}
	}
	/**
	 * Block until all jobs are complete
	 */
	public static function finish():Void {
		if (_numThreads <= 0) return;
		//trace("Finishing...");
		while (numJobs.value > 0) {}
		//trace("Finished");
	}
	
	public static function shutDown():Void {
		trace("Shutdown");
		var t:ThreadTask = new ThreadTask(TaskType.SHUTDOWN);
		for (i in 0...pool.length) 
		{
			submitTask(t);
		}
		finish(); //ensure all threads finish shutting down
		pool = null;
	}
	
	static function work():Void {
		var id:Int = Thread.readMessage(true);
		var numJobs:SharedCounter = Thread.readMessage(true);
		while (true) {
			var task:ThreadTask = tasks.pop(true);
			if (task.type == TaskType.SHUTDOWN) {
				trace(id+": Thread closed");
				numJobs.decrement();
				return;
			}else{
				var startTime = Timer.stamp();
				task.execute();
				//trace(id, "Finished a job in " + (Timer.stamp() - startTime));
				numJobs.decrement();
			}
		}
	}
	
	public function getNumJobsInQueue():Int 
	{
		return numJobs.value;
	}
	
	
	
	
	/**
	 * UTIL
	 */
	
	public static function decompose<T>(list:Array<T>, handler:T->Void):Void {
		var idx:Int = 0;
		var chunkLength:Int = Math.floor(list.length / _numThreads);
		for (i in 0..._numThreads) 
		{
			var t:ThreadTask = new ForeachTask<T>(list, idx, idx+chunkLength, handler);
			ThreadPool.submitTask(t);
			idx += chunkLength;
		}
	}
	
	static public var numThreads(get_numThreads, null):Int;
	static function get_numThreads():Int 
	{
		return _numThreads;
	}
	
}
