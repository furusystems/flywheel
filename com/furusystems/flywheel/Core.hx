package com.furusystems.flywheel;
import com.furusystems.flywheel.fsm.IState;
import com.furusystems.games.rendering.lime.Graphics;
import lime.Lime;
//import com.furusystems.flywheel.input.Input;
//import com.furusystems.flywheel.sound.GameAudio;
import com.furusystems.flywheel.metrics.Time;

/**
 * A flywheel 
 * @author Andreas Rønning
 */
class Core
{

	var _currentState:IState;
	var _paused:Bool;
	//public var input:Input;
	public var renderer:Dynamic;
	public var time:Time;
	public var limeInstance:Lime;
	//public var stage:Stage;
	//public var audio:GameAudio;
	public function new(timeStep:Int = -1) 
	{
		time = new Time();
		time.timeStep = timeStep;
		
		_currentState = null;
		_paused = true;
		//audio = new GameAudio();
		renderer = null;
		//input = new Input();
		//input.bind(stage);
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
		//stage.addEventListener(Event.ENTER_FRAME, update);
	}
	public function stop():Void {
		_paused = true;
		//stage.removeEventListener(Event.ENTER_FRAME, update);
	}
	
	
	public function render():Void {
		//input.update(this);
		time.update();
		Graphics.time = time.clockS;
		//audio.update(this.time.deltaS);
		if (_paused) return;
		
		_currentState.update();
		_currentState.render();
	}
	
	@:noCompletionprivate function get_state():IState {
		return _currentState;
	}
	
	@:noCompletion private function set_state(value:IState):IState {
		if (value == _currentState) return _currentState;
		if (_currentState != null) {
			_currentState.exit();
			_currentState.game = null;
		}
		_currentState = value;
		if (_currentState != null) {
			time.stateCurrentTimeMS = 0;
			_currentState.game = this;
			_currentState.enter();
		}
		return _currentState;
	}
	
	public function dispose():Void {
		stop();
		state = null;
		//input.release();
	}
	
	public var state(get_state, set_state):IState;
	
}