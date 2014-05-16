package com.furusystems.flywheel.display.rendering.lime.materials;
import format.png.Reader;
import format.png.Tools;
import haxe.io.BytesInput;
import lime.gl.GL;
import lime.gl.GLTexture;
import lime.utils.Assets;
import lime.utils.ByteArray;
import lime.utils.UInt8Array;

/**
 * ...
 * @author Andreas Rønning
 */
class PNGTexture
{
	public var width:Int;
	public var height:Int;
	public var tex:GLTexture;
	function new() 
	{
		
	}
	
	/* INTERFACE com.furusystems.games.IDisposable */
	
	public function dispose():Void 
	{
		GL.deleteTexture(tex);
	}
	
	public static function fromFile(assetPath:String):PNGTexture {
		return fromBytes(Assets.getBytes (assetPath));
	}
	
	static public function fromBytes(bytes:ByteArray):PNGTexture { 
		var out = new PNGTexture();
		var byteInput = new BytesInput (bytes, 0, bytes.length);
		var png = new Reader (byteInput).read ();
		var data = Tools.extract32 (png);
		var header = Tools.getHeader (png);
		
		out.width = header.width;
		out.height = header.height;
		out.tex = createGLTexture(out.width, out.height, new UInt8Array (data.getData()));
		return out;
	}
	
	static function createGLTexture (width:Int, height:Int, data:UInt8Array):GLTexture {
		
		var texture = GL.createTexture ();
		GL.bindTexture (GL.TEXTURE_2D, texture);
		GL.texImage2D (GL.TEXTURE_2D, 0, GL.RGBA, width, height, 0, GL.RGBA, GL.UNSIGNED_BYTE, data);
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
		GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
		GL.bindTexture (GL.TEXTURE_2D, null);
		return texture;
		
	}
}