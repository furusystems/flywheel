package com.furusystems.flywheel;
import com.furusystems.flywheel.fsm.IState;
import com.furusystems.flywheel.input.Input;
import com.furusystems.flywheel.sound.GameAudio;
import com.furusystems.flywheel.metrics.Time;
import flash.display.Stage;
import flash.errors.Error;
import flash.events.Event;
import flash.Lib;

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
	public var stage:Stage;
	public var audio:GameAudio;
	public function new(stage:Stage, timeStep:Int = -1) 
	{
		this.stage = stage;
		time = new Time();
		time.timeStep = timeStep;
		
		_currentState = null;
		_paused = true;
		audio = new GameAudio();
		renderer = null;
		input = new Input();
		input.bind(stage);
		stage.addEventListener(Event.DEACTIVATE, onDeactivated);
	}
	
	private function onDeactivated(e:Event):Void 
	{
		setPaused(true);
		stage.removeEventListener(Event.DEACTIVATE, onDeactivated);
		stage.addEventListener(Event.ACTIVATE, onActivated);
	}
	
	private function onActivated(e:Event):Void 
	{
		setPaused(false);
		stage.addEventListener(Event.DEACTIVATE, onDeactivated);
		stage.removeEventListener(Event.ACTIVATE, onActivated);
	}
	
	
	public function setPaused(?newValue:Bool):Bool {
		if (newValue == null) _paused = !_paused;
		else _paused = newValue;
		audio.setPaused(_paused);
		return _paused;
	}
	
	public function getPaused():Bool {
		return _paused;
	}
	
	public function start():Void {
		_paused = false;
		if (_currentState == null) throw new Error("Cannot start without valid state");
		stage.addEventListener(Event.ENTER_FRAME, update);
	}
	public function stop():Void {
		_paused = true;
		stage.removeEventListener(Event.ENTER_FRAME, update);
	}
	
	
	public function update(e:Event):Void {
		input.update(this);
		time.update();
		audio.update(this.time.deltaS);
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
		input.release();
	}
	
	public var state(get_state, set_state):IState;
	
}