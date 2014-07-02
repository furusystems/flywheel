package com.furusystems.flywheel.fsm;

/**
 * ...
 * @author Andreas Rønning
 */
interface IState<T>
{
	var game:T;
	function enter():Void;
	function update():Void;
	function render():Void;
	function exit():Void;
	
}