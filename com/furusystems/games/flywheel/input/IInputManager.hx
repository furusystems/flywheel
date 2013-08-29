package com.furusystems.games.flywheel.input;
import com.furusystems.games.flywheel.Core;
import flash.display.InteractiveObject;

/**
 * @author Andreas Rønning
 */

interface IInputManager 
{
	function update(game:Core):Void;
	function release(source:InteractiveObject):Void;
	function bind(source:InteractiveObject):Void;
	function reset():Void;
}