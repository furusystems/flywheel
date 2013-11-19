package com.furusystems.flywheel.utils.threads;
import cpp.vm.Deque;
import cpp.vm.Mutex;
import cpp.vm.Thread;
import haxe.ds.Vector;

/**
 * ...
 * @author Andreas Rønning
 */
class ThreadPool
{
	static private var numThreads:Int;
	static private var pool:Vector<Thread>;
	static private var tasks:Deque<ThreadTask> = new Deque<ThreadTask>();
	static private var lock:Mutex = new Mutex();
	static private var main:Thread;
	public static inline var MSG_SHUTDOWN:Int = 0;
	public static inline var MSG_COMPLETE:Int = 1;
	
	static private var numJobs:Int = 0;
	
	public static inline function submitTask(threadTask:ThreadTask):Void {
		numJobs++;
		tasks.push(threadTask);
	}
	public static function setup(numThreads:Int):Void {
		if (pool != null) shutDown();
		trace("Startup");
		ThreadPool.numThreads = numThreads;
		pool = new Vector<Thread>(numThreads);
		for (i in 0...numThreads) {
			pool[i] = Thread.create(work);
			pool[i].sendMessage(i);
			pool[i].sendMessage(Thread.current);
		}
	}
	public static inline function finish():Void {
		//while (numJobs > 0) {
			//Sys.sleep(0);
		//}
	}
	
	public static function test():Void {
		var c:Vector<Int> = new Vector<Int>(200000);
		var numTasks:Int = numThreads;
		var idx:Int = 0;
		var chunkLength:Int = Math.floor(c.length / numTasks);
		for (i in 0...numTasks) 
		{
			var t:ThreadTask = new ThreadTask(zeroValue, [c, idx, idx+chunkLength]);
			ThreadPool.submitTask(t);
			idx += chunkLength;
		}
	}
	private static function zeroValue(td:Array<Dynamic>):Void {
		var collection:Vector<Int> = td[0];
		var start:Int = td[1];
		var end:Int = td[2];
		for (i in start...end) {
			collection[i] = 0;
		}
	}
	public static function shutDown():Void {
		trace("Shutdown");
		for (t in pool) {
			t.sendMessage(MSG_SHUTDOWN); //stupid but whatevs
		}
		pool = null;
	}
	private static function work():Void {
		var id:Int = Thread.readMessage(true);
		var main:Thread = Thread.readMessage(true);
		while (true) {
			var msg:Dynamic = Thread.readMessage(false);
			if (msg != null) {
				if (msg == MSG_SHUTDOWN) return;
			}
			var task:ThreadTask = tasks.pop(false);
			if(task!=null){
				task.handler(task.data);
				numJobs--;
				if (task.onComplete != null) task.onComplete(task.data);
			}
			Sys.sleep(0.001);
		}
		trace(id+": Thread closed");
	}
}