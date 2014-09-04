package com.furusystems.flywheel.fsm;
import com.furusystems.flywheel.Core;
import nape.shape.Circle;

/**
 * ...
 * @author Andreas Rønning
 */
interface IState
{
	var core:Core;
	function enter(?info:Dynamic):Void;
	function preUpdate():Void;
	function update():Void;
	function postUpdate():Void;
	function exit():Void;
	
}