package com.furusystems.flywheel.display.rendering.lime.resources;
import com.furusystems.flywheel.display.rendering.animation.gts.GTSSheet;

/**
 * ...
 * @author Andreas Rønning
 */
class Resources
{
	static var textures = new Map<String, TextureHandle>();
	static var shaders = new Map<String, ShaderHandle>();
	static var gtsmap = new Map<String, GTSHandle>();
	
	public static function getGts(path:String):GTSHandle {
		if (gtsmap.exists(path)) return gtsmap.get(path);
		var h = new GTSHandle(path);
		gtsmap.set(path, h);
		h.acquire();
		return h;
	}
	
	public static function getTexture(path:String):TextureHandle {
		if (textures.exists(path)) return textures.get(path).acquire();
		var h = new TextureHandle(path);
		textures.set(path, h);
		h.acquire();
		return h;
	}
	
	public static function getShader(vertSrcPath:String, fragSrcPath:String):ShaderHandle {
		var name = vertSrcPath + fragSrcPath;
		if (shaders.exists(name)) return shaders.get(name);
		var h = new ShaderHandle(vertSrcPath, fragSrcPath);
		shaders.set(name, h);
		h.acquire();
		return h;
	}
	
	public static function reaquireAll():Void {
		for (t in textures) {
			t.acquire();
		}
		for (s in shaders) {
			s.acquire();
		}
		for (g in gtsmap) {
			g.acquire();
		}
	}
	
	public static function releaseAll():Void {
		for (t in textures) {
			t.release();
		}
		for (s in shaders) {
			s.release();
		}
		for (g in gtsmap) {
			g.release();
		}
	}
	
	public static function clear():Void {
		releaseAll();
		textures = new Map<String, TextureHandle>();
		shaders = new Map<String, ShaderHandle>();
		gtsmap = new Map<String, GTSHandle>();
	}

}