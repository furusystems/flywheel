package com.furusystems.flywheel;
import com.furusystems.flywheel.fsm.IState;
import com.furusystems.flywheel.input.Input;
import com.furusystems.games.rendering.lime.Graphics;
import lime.InputHandler.MouseEvent;
import lime.InputHandler.TouchEvent;
import lime.Lime;
import com.furusystems.flywheel.metrics.Time;

/**
 * A flywheel 
 * @author Andreas Rønning
 */
class Core
{
	var _currentState:IState;
	var _paused:Bool;
	public var input:Input;
	public var renderer:Dynamic;
	public var time:Time;
	var limeInstance:Lime;
	//public var stage:Stage;
	//public var audio:GameAudio;
	
	public var config(get, never):LimeConfig;
	inline function get_config():LimeConfig {
		return limeInstance.config;
	}
	public function new(timeStep:Int = -1) 
	{
		time = new Time();
		time.timeStep = timeStep;
		
		_currentState = null;
		_paused = true;
		//audio = new GameAudio();
		renderer = null;
		input = new Input();
	}
	
	function ready (lime:Lime):Void {
		this.limeInstance = lime;
		limeInstance.window.on_resize(onWindowResize);
		onWindowResize(lime);
		prepare();
	}
	
	public function setPaused(?newValue:Bool):Bool {
		if (newValue == null) _paused = !_paused;
		else _paused = newValue;
		//audio.setPaused(_paused);
		return _paused;
	}
	public function prepare():Void {
		
	}
	
	public function getPaused():Bool {
		return _paused;
	}
	
	function onWindowResize(lime:Lime) {
		Graphics.reinit();
		Graphics.setViewport2D(lime.config.width, lime.config.height);
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
		input.update(this);
		//audio.update(this.time.deltaS);
		if (_paused) return;
		time.update();
		Graphics.time = time.clockS;
		_currentState.update();
		_currentState.render();
	}
	
	public function getState():IState {
		return _currentState;
	}
	
	public function setState(value:IState):IState {
		if (value == _currentState) return _currentState;
		if (_currentState != null) {
			_currentState.exit();
			_currentState.core = null;
		}
		_currentState = value;
		if (_currentState != null) {
			time.stateCurrentTimeMS = 0;
			_currentState.core = this;
			_currentState.enter();
		}
		return _currentState;
	}
	
	public function dispose():Void {
		stop();
		setState(null);
	}
	
}