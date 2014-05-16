package com.furusystems.flywheel.display.rendering.lime.materials;
import lime.utils.Assets;

/**
 * ...
 * @author Andreas Rønning
 */
class ShaderPreproc
{

	public static function processSource(src:String):String {
		var lines = src.split("\r\n");
		for (i in 0...lines.length) {
			var l = lines[i];
			if (l.indexOf("#pragma include") > -1) {
				var info = l.substring(l.indexOf('"') + 1, l.lastIndexOf('"'));
				lines[i] = Assets.getText(info);
			}
		}
		return lines.join("\r\n");
	}
	
}