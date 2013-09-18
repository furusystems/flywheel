package com.furusystems.flywheel.preprocessing;
import haxe.io.Bytes;
import haxe.macro.Context;
import haxe.macro.Expr.Field;
import haxe.macro.Expr;
import sys.FileSystem;
import sys.io.File;

/**
 * ...
 * @author Andreas Rønning
 */
class Audio
{
	macro public static function buildMusicPaths(basePath:String):Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var pos:Position = Context.currentPos();
		if (FileSystem.exists(basePath)) {
			var tstring = TPath({ pack : [], name : "String", params : [], sub : null });
			var paths:Array<String> = FileSystem.readDirectory(basePath);
			var trimmed:String = basePath.substring(basePath.indexOf("/")+1, basePath.length);
			for (p in paths) {
				if (!Util.isMusic(p)) continue;
				var name:String = Util.cleanName(p.substring(0, p.lastIndexOf(".")));
				var path:String = trimmed + "/" + p;
				name = "MUSIC_" + name.toUpperCase();
				trace("Adding music path: " + name + " : " + path);
				var e = macro $v{path};
				fields.push( { name : name, doc : null, meta : [], access : [APublic, AStatic, AInline], kind : FVar(tstring, e), pos : pos } );
			}
		}else {
			trace("No music files in base path: " + basePath);
		}
		return fields;
	}
	//TODO: Recursive search for fx without the need of a deeper base path
	macro public static function buildSoundPaths(basePath:String):Array<Field> {
		var fields:Array<Field> = Context.getBuildFields();
		var pos:Position = Context.currentPos();
		if (FileSystem.exists(basePath)) {
			var tstring = TPath({ pack : [], name : "String", params : [], sub : null });
			var paths:Array<String> = FileSystem.readDirectory(basePath);
			var trimmed:String = basePath.substring(basePath.indexOf("/")+1, basePath.length);
			for (p in paths) {
				if (!Util.isWav(p)) continue;
				var name:String = Util.cleanName(p.substring(0, p.lastIndexOf(".")));
				name = "FX_" + name.toUpperCase();
				var path:String = trimmed + "/" + p;
				trace("Adding FX path: " + name + " : " + path);
				var e = macro $v{path};
				fields.push( { name : name, doc : null, meta : [], access : [APublic, AStatic, AInline], kind : FVar(tstring, e), pos : pos } );
			}	
		}else {
			trace("No fx files in base path: " + basePath);
		}
		return fields;
	}
	
	macro public static function buildSoundDurations(basePath:String):Array<Field> {
		var fields = Context.getBuildFields();
		var pos = Context.currentPos();
		if (FileSystem.exists(basePath)) {
			
			var tfloat = TPath({ pack : [], name : "Float", params : [], sub : null });
			var paths = FileSystem.readDirectory(basePath);
			var trimmed:String = basePath.substring(basePath.indexOf("/")+1, basePath.length);
			for (p in paths) {
				if (!Util.isWav(p)) continue;
				var path:String = trimmed +"/" + p;
				var duration = Util.readWavDuration(path);
				var name:String = Util.cleanName(p.substring(0, p.lastIndexOf(".")));
				name = name.toUpperCase();
				trace("Adding FX duration: " + name + " : " + duration);
				var e = macro $v{duration};
				fields.push( { name : name, doc : null, meta : [], access : [APublic, AStatic], kind : FVar(tfloat, e), pos : pos } );
			}
		}else {
			trace("No fx files in base path: " + basePath);
		}
		return fields;
	}
	
}