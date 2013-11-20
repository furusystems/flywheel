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
	static var numThreads:Int;
	static var pool:Vector<Thread>;
	static var tasks:Deque<ThreadTask> = new Deque<ThreadTask>();
	static var lock:Mutex = new Mutex();
	static var main:Thread;
	static var numJobs:SharedCounter = new SharedCounter();
	
	public static inline function submitTask(threadTask:ThreadTask):Void {
		numJobs.increment();
		tasks.push(threadTask);
	}
	public static function setup(numThreads:Int):Void {
		if (pool != null) shutDown();
		trace("Setup "+numThreads);
		ThreadPool.numThreads = numThreads;
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
		trace("Finishing...");
		while (numJobs.value > 0) {}
		trace("Finished");
	}
	
	public static function shutDown():Void {
		trace("Shutdown");
		var t:ThreadTask = new ThreadTask(TaskType.SHUTDOWN, null);
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
				task.handler(task.data);
				trace(id, "Finished a job in " + (Timer.stamp() - startTime));
				numJobs.decrement();
			}
		}
	}
	
	public function getNumJobsInQueue():Int 
	{
		return numJobs.value;
	}
	
	
	
	
	
	
	/**
	 * TESTS
	 */
	public static function test():Void {
		var c:Vector<Float> = new Vector<Float>(8000000);
		var numTasks:Int = numThreads;
		var idx:Int = 0;
		var chunkLength:Int = Math.floor(c.length / numTasks);
		for (i in 0...numTasks) 
		{
			var t:ThreadTask = new ThreadTask(TaskType.RUN, fudgeValue, [c, idx, idx+chunkLength]);
			ThreadPool.submitTask(t);
			idx += chunkLength;
		}
	}
	static function fudgeValue(td:Array<Dynamic>):Void {
		var collection:Vector<Float> = td[0];
		var start:Int = td[1];
		var end:Int = td[2];
		for (i in start...end) {
			collection[i] = Math.cos(Math.sin(Math.pow(Math.random(), Math.random())));
		}
	}
}
