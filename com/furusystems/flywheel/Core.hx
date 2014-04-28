package com.furusystems.flywheel;
import com.furusystems.flywheel.fsm.IState;
import com.furusystems.flywheel.geom.Rectangle;
import com.furusystems.flywheel.input.Input;
import com.furusystems.flywheel.sound.GameAudio;
import com.furusystems.games.rendering.lime.Graphics;
import lime.gl.GL;
import lime.InputHandler.MouseEvent;
import lime.InputHandler.TouchEvent;
import lime.Lime;
import com.furusystems.flywheel.metrics.Time;
import lime.utils.Matrix3D;

/**
 * A flywheel 
 * @author Andreas Rønning
 */
class Core
{
	var _currentState:IState;
	var _paused:Bool;
	var limeInstance:Lime;
	
	public var viewportRect:Rectangle;
	public var input:Input;
	public var time:Time;
	public var audio:GameAudio;
	
	public var targetAspectRatio:Float;
	public var gameWidth:Int;
	public var gameHeight:Int;
	
	public var config(get, never):LimeConfig;
	inline function get_config():LimeConfig {
		return limeInstance.config;
	}
	public function new(timeStep:Int = -1, width:Int, height:Int) 
	{
		viewportRect = new Rectangle();
		time = new Time();
		time.timeStep = timeStep;
		gameWidth = width;
		gameHeight = height;
		input = new Input();
		
		_currentState = null;
		_paused = true;
	}
	
	public function setSize(width:Int, height:Int) 
	{
		this.gameWidth = width;
		this.gameHeight = height;
		onWindowResize(limeInstance);
	}
	
	function ready (lime:Lime):Void {
		this.limeInstance = lime;
		GL.enable(GL.SCISSOR_TEST);
		audio = new GameAudio(limeInstance);
		limeInstance.window.on_resize(onWindowResize);
		
		setSize(gameWidth, gameHeight);
		
		prepare();
	}
	
	public function setPaused(?newValue:Bool):Bool {
		if (newValue == null) _paused = !_paused;
		else _paused = newValue;
		audio.setPaused(_paused);
		return _paused;
	}
	public function prepare():Void {
		
	}
	
	public function getPaused():Bool {
		return _paused;
	}
	
	function onWindowResize(lime:Lime) {
		Graphics.reinit();
		
		targetAspectRatio = gameWidth / gameHeight;
		
		viewportRect.width = lime.config.width;
		viewportRect.height = Std.int(viewportRect.width / targetAspectRatio + 0.5);
		
		if (viewportRect.height > lime.config.height )
		{
			viewportRect.height = lime.config.height;
			viewportRect.width = Std.int(viewportRect.height * targetAspectRatio + 0.5);
		}
		
		viewportRect.x = Std.int( (lime.config.width  / 2) - (viewportRect.width / 2) );
		viewportRect.y = Std.int( (lime.config.height / 2) - (viewportRect.height / 2) );
		
		
		GL.enable(GL.SCISSOR_TEST);
		GL.scissor(Std.int(viewportRect.x),Std.int(viewportRect.y),Std.int(viewportRect.width),Std.int(viewportRect.height));
		
		updateViewport();
		var mat = Matrix3D.createOrtho (0, gameWidth, gameHeight, 0, -1, 1);
		Graphics.setProjectionMatrix(mat);
		
		input.xScale = gameWidth/viewportRect.width;
		input.yScale = gameHeight/viewportRect.height;
		input.bounds = new Rectangle(viewportRect.x,viewportRect.y,viewportRect.width,viewportRect.height);
		input.xOffset = viewportRect.x;
		input.yOffset = viewportRect.y;
	}
	
	public inline function updateViewport(offsetX:Float = 0, offsetY:Float = 0) 
	{
		GL.viewport(Std.int(viewportRect.x+offsetX),Std.int(viewportRect.y+offsetY),Std.int(viewportRect.width),Std.int(viewportRect.height));
		GL.scissor(Std.int(viewportRect.x+offsetX),Std.int(viewportRect.y+offsetY),Std.int(viewportRect.width),Std.int(viewportRect.height));
	}
	
	public function start():Void {
		_paused = false;
		if (_currentState == null) throw "Cannot start without valid state";
	}
	public function stop():Void {
		_paused = true;
	}
	
	function ontouchbegin( e:TouchEvent ) { 
		
		input.touch.touchBeginHandler(e);
	}
	function ontouchmove( e:TouchEvent ) {
		input.touch.touchMoveHandler(e);
	}
	function ontouchend( e:TouchEvent ) {
		input.touch.touchEndHandler(e);
	}
	
	function onmousedown(e:MouseEvent) {
		input.mouse.mouseDownHandler(e);
	}
	function onmouseup(e:MouseEvent) {
		input.mouse.mouseUpHandler(e);
	}
	function onmousemove(e:MouseEvent) {
		input.mouse.mouseMoveHandler(e);
	}
	
	
	public function render():Void {
		time.update();
		Graphics.time = time.clockS;
		input.update(this);
		audio.update(time.deltaS);
		if (_paused) return;
		_currentState.preUpdate();
		_currentState.update();
		_currentState.postUpdate();
	}
	
	public function getState():IState {
		return _currentState;
	}
	
	public function setState(value:IState, ?info:Dynamic):IState {
		if (value == _currentState) return _currentState;
		if (_currentState != null) {
			_currentState.exit();
			_currentState.core = null;
		}
		_currentState = value;
		if (_currentState != null) {
			time.stateCurrentTimeMS = 0;
			_currentState.core = this;
			_currentState.enter(info);
		}
		return _currentState;
	}
	
	public function dispose():Void {
		stop();
		setState(null);
	}
	
}