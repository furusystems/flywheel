package com.furusystems.flywheel.fsm;
import com.furusystems.flywheel.Core;

/**
 * ...
 * @author Andreas Rønning
 */
interface IState
{
	var core:Core;
	function enter():Void;
	function update():Void;
	function render():Void;
	function exit():Void;
	
}