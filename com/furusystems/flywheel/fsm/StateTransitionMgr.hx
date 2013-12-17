package com.furusystems.flywheel.fsm;
import com.furusystems.flywheel.events.Signal1;
import com.furusystems.flywheel.events.Signal2.Signal2;
using Lambda;
/**
 * ...
 * @author Andreas Rønning
 */
class StateTransitionMgr<TRIGGER:EnumValue, STATE:EnumValue>{

	private var map:Map<STATE,Map<TRIGGER,STATE>>;
	private var currentState:Null<STATE>;
	public var onStateEnter:Signal1<STATE>;
	public var onStateExit:Signal1<STATE>;
	public function new() {
		map = new Map < STATE, Map < TRIGGER, STATE >> ();
		onStateEnter = new Signal1<STATE>();
		onStateExit = new Signal1<STATE>();
	}
	
	public function setState(state:STATE):STATE {
		if (currentState != null) exit(currentState);
		currentState = state;
		enter(currentState);
		return currentState;
	}
	
	inline function enter(state:STATE):Void {
		onStateEnter.dispatch(state);
	}
	inline function exit(state:STATE):Void {
		onStateExit.dispatch(state);
	}
	public function mapTransition(from:STATE, to:STATE, trigger:TRIGGER, commutative:Bool = false):Void {
		if (!map.exists(from)) map.set(from, new Map<TRIGGER,STATE>());
		if (!map.exists(to)) map.set(to, new Map<TRIGGER,STATE>());
		var triggermap:Map<TRIGGER,STATE> = map.get(from);
		if (triggermap != null) triggermap.set(trigger, to);
		if (commutative) {
			triggermap = map.get(to);
			if (triggermap != null) triggermap.set(trigger, from);
		}
	}
	
	public function trigger(id:TRIGGER):Void {
		var triggerMap:Map<TRIGGER,STATE> = map.get(currentState);
		if (triggerMap == null) return;
		var trans:STATE = triggerMap.get(id);
		if (trans == null) return;
		setState(trans);
	}
	
}