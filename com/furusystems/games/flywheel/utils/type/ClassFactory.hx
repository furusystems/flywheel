package com.furusystems.utils;
/**
 * ...
 * @author Andreas Rønning
 */

class ClassFactory 
{

	public static inline function create(classType:String, ?args:Array<Dynamic> = null):Dynamic
	{
		if (args == null)
		{
			return Type.createInstance(Type.resolveClass(classType), []);
		} else {
			return Type.createInstance(Type.resolveClass(classType), args);
		}
	}
	
}