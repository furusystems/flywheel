package com.furusystems.games.flywheel.utils.type;
/**
 * ...
 * @author Andreas Rønning
 */

class ClassFactory 
{

	public static function create(classType:String, ?args:Array<Dynamic>):Dynamic
	{
		if (args == null)
		{
			return Type.createInstance(Type.resolveClass(classType), []);
		} else {
			return Type.createInstance(Type.resolveClass(classType), args);
		}
	}
	
}