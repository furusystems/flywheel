package com.furusystems.flywheel.io.net;

import com.furusystems.flywheel.events.Signal;
import com.furusystems.flywheel.io.net.TCPClient;
import cpp.vm.Deque.Deque;
import cpp.vm.Thread;
import sys.net.Host;
import sys.net.Socket;
/**
 * ...
 * @author Andreas Rønning
 */
class TCP
{
public static var onConnection:Signal<TCPClient> = new Signal<TCPClient>();
	public static var onDisconnection:Signal<TCPClient> = new Signal<TCPClient>();
	public static var onData:Signal<TCPClient> = new Signal<TCPClient>();
	static inline var SHUTDOWN:Int = 0;
	static var serverThread:Thread;
	static var _running:Bool = false;
	public static function setup(hostname:String = "localhost", port:Int = 1984, pendingConnections:Int = 1):Void {
		if (_running) shutdown();
		serverThread = Thread.create(serve);
		serverThread.sendMessage(Thread.current());
		serverThread.sendMessage(hostname);
		serverThread.sendMessage(port);
		serverThread.sendMessage(pendingConnections);
		_running = true;
	}
	
	public static function shutdown():Void {
		if (!_running) return;
		serverThread.sendMessage(ServerMessage.SHUTDOWN);
		serverThread = null;
		clients = null;
		_running = false;
	}
	
	static function serve() 
	{
		var mainThread:Thread = Thread.readMessage(true);
		var hostName:String = Thread.readMessage(true);
		var port:Int = Thread.readMessage(true);
		var pendingConnections:Int = Thread.readMessage(true);
		var clients:Array<TCPClient> = [];
		
		var serverSocket:Socket = new Socket();
		serverSocket.setBlocking(false);
		serverSocket.bind(new Host(hostName), port);
		serverSocket.listen(pendingConnections);
		trace("Serving at " + hostName + ":" + port);
		while (true) {
			var msg:ServerMessage = Thread.readMessage(false);
			if (msg != null) {
				switch(msg.type) {
					case ServerMessageType.SHUTDOWN:
						break;
					default:
						//Ignore other
				}
			}
			var newConnection:Socket = serverSocket.accept();
			if (newConnection != null) {
				clients.push(acceptConnection(mainThread, newConnection));
			}
			var selection = Socket.select(clients, clients, clients);
			Sys.sleep(0.016);
		}
	}
	static function acceptConnection(mainThread:Thread, client:Socket):TCPClient {
		var tcpClient:TCPClient = new TCPClient(client);
		mainThread.sendMessage(new ServerMessage(ServerMessageType.CONNECT, tcpClient));
		return tcpClient;
	}
	
	function get_running():Bool 
	{
		return _running;
	}
	
	static public var running(get_running, null):Bool;
}
private class ServerMessage {
	public var type:ServerMessageType;
	public var data:Dynamic;
	public function new(type:ServerMessageType, ?data:Dynamic) {
		this.type = type;
		this.data = data;
	}
}
private enum ServerMessageType {
	SHUTDOWN;
	DATA;
	CONNECT;
	DISCONNECT;
}