package com.furusystems.flywheel.io.net;
import cpp.vm.Mutex;
import haxe.io.Bytes;
import haxe.io.Input;
import haxe.io.Output;
import sys.net.Socket;

/**
 * Rudimentary TCP socket server
 * @author Andreas Rønning
 */
class TCPClient
{
	var _socket:Socket;
	var _buffer:Bytes;
	var _mutex:Mutex;
	public function new(socket:Socket) {
		_socket = socket;
		_mutex = new Mutex();
		trace("New client: " + socket.peer().host + ":" + socket.peer().port);
	}
	
	function get_socket():Socket 
	{
		return _socket;
	}
	
	inline function lock():Void {
		_mutex.acquire();
	}
	inline function unlock():Void {
		_mutex.release();
	}
	
	public function writeString(str:String):Void {
		_socket.write(str);
	}
	public function readString():String {
		return _socket.read();
	}
	
	public function write():Output {
		return _socket.output;
	}
	public function read():Input {
		return _socket.input;
	}
	
	public var socket(get_socket, null):Socket;
}