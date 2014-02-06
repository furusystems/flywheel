package com.furusystems.flywheel.display.rendering.animation;

/**
 * Enumerates possible loop behaviors
 * @author Andreas Rønning
 */

enum LoopStyle 
{
	normal; // loop forever
	pingpong; // ping pong forever
	once; // return to 1st frame, then stop
}