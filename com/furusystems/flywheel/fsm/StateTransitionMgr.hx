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
	public var onStateEnter:STATE-> TRIGGER -> Void;
	public var onStateExit:STATE-> TRIGGER -> Void;
	public function new() {
		map = new Map < STATE, Map < TRIGGER, STATE >> ();
	}
	
	public function setState(state:STATE):STATE {
		switchState(state);
		return currentState;
	}
	inline function switchState(newState:STATE, ?trigger:TRIGGER):Void {
		if (currentState != null) exit(currentState, trigger);
		currentState = newState;
		enter(currentState, trigger);
	}
	
	inline function enter(state:STATE, trigger:TRIGGER):Void {
		if (onStateEnter != null) onStateEnter(state, trigger);
	}
	inline function exit(state:STATE, trigger:TRIGGER):Void {
		if (onStateExit != null) onStateExit(state, trigger);
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
	
	public function trigger(trigger:TRIGGER):Void {
		var triggerMap:Map<TRIGGER,STATE> = map.get(currentState);
		if (triggerMap == null) return;
		var newState:STATE = triggerMap.get(trigger);
		if (newState == null) return;
		switchState(newState, trigger);
	}
	
}