package com.furusystems.flywheel.fsm;

/**
 * ...
 * @author Andreas Rønning
 */
interface IState<T>
{
	var core:T;
	function enter(?info:Dynamic):Void;
	function preUpdate():Void;
	function update():Void;
	function postUpdate():Void;
	function exit():Void;
	
}