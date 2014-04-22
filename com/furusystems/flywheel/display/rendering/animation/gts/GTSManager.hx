package com.furusystems.flywheel.display.rendering.animation.gts;
import com.furusystems.games.GameBase2D;
import com.furusystems.flywheel.display.rendering.animation.characters.AnimPackage;
import com.furusystems.flywheel.display.rendering.animation.characters.Character;
import lime.utils.Assets;

/**
 * ...
 * @author Andreas Rønning
 */

class GTSManager 
{
	public var gtsSheets:Map<String, GTSSheet>;
	public var animationPackages:Map<String, AnimPackage>;
	public var ready:Bool = false;
	private var processes:Array<GTSLoadWorker>;
	private var sheetsToLoad:Int = 0;
	public function new() {
		gtsSheets = new Map<String, GTSSheet>();
		animationPackages = new Map<String, AnimPackage>();
		processes = new Array<GTSLoadWorker>();
	}
	public function get(path:String,protect:Bool = false):GTSSheet {
		if (!gtsSheets.exists(path)) {
			trace("Creating new GTS: " + path);
			#if runtimerescale
			var sheet:GTSSheet = new GTSSheet(path, Assets.getBytes(path), protect, GameBase2D.halfRes);
			#else
			var sheet:GTSSheet = new GTSSheet(path, Assets.getBytes(path), protect, false);
			#end
			gtsSheets.set(path, sheet);
			trace("GTS created");
			return sheet;
		}
		var s:GTSSheet = gtsSheets.get(path);
		s.protected = protect;
		return s;
	}
	
	public function load(path:String):Void {
		processes.push(new GTSLoadWorker(this, path));
	}
	
	public function remove(path:String):Void {
		gtsSheets.remove(path);
	}
	public function clear(includeProtected:Bool = false):Void {
		trace("Clearing GTS manager");
		if (includeProtected) {
			gtsSheets = new Map<String, GTSSheet>();
		}else {
			for (i in gtsSheets.keys()) {
				if (gtsSheets.get(i).protected) continue;
				gtsSheets.remove(i);
			}
		}
		for (a in animationPackages) {
			a.dispose();
		}
		animationPackages = new Map<String, AnimPackage>();
	}
	public function isReady():Bool {
		for (p in processes) {
			if (p.checkProgress()) {
				gtsSheets.set(p.sheet.path, p.sheet);
				processes.remove(p);
			}
		}
		return processes.length == 0;
	}	
	public function loadCharacter(gtsPath:String, animPath:String) 
	{
		#if characters
		trace("Loading character: " + gtsPath + ", " + animPath);
		var p:AnimPackage = null;
		if (animationPackages.exists(animPath)) {
			p = animationPackages.get(animPath);
		}else {
			p = new AnimPackage(Assets.getBytes(animPath));
			animationPackages.set(animPath, p);
		}	
		return new Character(get(gtsPath, false), p);
		#else
		return null;
		#end
		
	}
	
}