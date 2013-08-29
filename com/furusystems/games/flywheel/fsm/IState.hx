package com.furusystems.games.flywheel.fsm;
import com.furusystems.games.flywheel.Core;

/**
 * ...
 * @author Andreas Rønning
 */
interface IState
{
	var game:Core;
	function enter():Void;
	function update():Void;
	function render():Void;
	function exit():Void;
	
}