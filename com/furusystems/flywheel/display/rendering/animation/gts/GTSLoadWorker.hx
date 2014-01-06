package com.furusystems.flywheel.display.rendering.animation.gts;
import com.furusystems.flywheel.display.rendering.animation.gts.GTSManager;
import com.furusystems.flywheel.display.rendering.animation.gts.GTSSheet;
import cpp.vm.Mutex;
import flash.utils.ByteArray;
import openfl.Assets;
#if threading
import cpp.vm.Thread;
#end

/**
 * ...
 * @author Andreas Rønning
 */

class GTSLoadWorker 
{
	#if threading
	private var worker:Thread;
	private var mutex:Mutex;
	#end
	public var complete:Bool;
	public var sheet:GTSSheet;
	var manager:GTSManager;
	var path:String;
	public function new(manager:GTSManager, path:String) 
	{
		this.path = path;
		this.sheet = null;
		this.manager = manager;
		#if threading
		mutex = new Mutex();
		worker = Thread.create(doWork);
		trace("Worker starting threaded load from " + path);
		worker.sendMessage(Thread.current());
		worker.sendMessage(mutex);
		worker.sendMessage(path);
		worker.sendMessage(Assets.getBytes(path));
		#else
		sheet = new GTSSheet(path, Assets.getBytes(path), true);
		#end
	}
	public function checkProgress():Bool {
		#if threading
		if (sheet != null) return true;
		var m = Thread.readMessage(false);
		if (m == null) return false;
		complete = true;
		sheet = m;
		#end
		return true;
	}
	public function doWork():Void {
		#if threading
		var worker:Thread = Thread.readMessage(true);
		var mutex:Mutex = Thread.readMessage(true);
		var path:String = Thread.readMessage(true);
		var bytes:ByteArray = Thread.readMessage(true);
		var sheet:GTSSheet = new GTSSheet(path, bytes, false, false);
		trace("Worker completed threaded load from " + path);
		worker.sendMessage(sheet);
		#end
	}
	
}