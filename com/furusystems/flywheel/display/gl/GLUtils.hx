package com.furusystems.flywheel.display.gl;
import com.furusystems.flywheel.math.MathUtils;
import flash.geom.Matrix3D;
import flash.geom.Vector3D;
import flash.Vector;
import openfl.gl.GL;
import openfl.gl.GLProgram;
import openfl.gl.GLShader;

class GLUtils
{
	
	public static function createShader(source:String, type:Int):GLShader
	{
		var shader = GL.createShader(type);
		GL.shaderSource(shader, source);
		GL.compileShader(shader);
		if (GL.getShaderParameter(shader, GL.COMPILE_STATUS)==0)
		{
		 trace("\tERROR\n" + source);
		 var err = GL.getShaderInfoLog(shader);
		 if (err!="")
			throw err;
		}
		return shader;
	}
	public static function createProgram(inVertexSource:String, inFragmentSource:String):GLProgram
	{
		var program = GL.createProgram();
		var vshader = createShader(inVertexSource, GL.VERTEX_SHADER);
		var fshader = createShader(inFragmentSource, GL.FRAGMENT_SHADER);
		GL.attachShader(program, vshader);
		GL.attachShader(program, fshader);
		GL.linkProgram(program);
		if (GL.getProgramParameter(program, GL.LINK_STATUS)==0)
		{
		 var result = GL.getProgramInfoLog(program);
		 if (result!="")
			throw result;
		}
		return program;
	}
	
	public static function projection2D(w:Float, h:Float):Matrix3D 
	{
		var mvp = new Matrix3D();
		mvp.appendScale(1 / w * 2, -(1 / h) * 2, 1);
		mvp.appendTranslation( -1, 1, 0);
		return mvp;
	}
	
	public static function projectionPerspective(fov:Float, imageAspectRatio:Float, n:Float, f:Float, transpose:Bool = true):Matrix3D {
		var scale = Math.tan(MathUtils.degToRad(fov * 0.5)) * n;
		var r = imageAspectRatio * scale;
		var l = -r;
		var t = scale;
		var b = -t;
		if (transpose) {
			return frustumTransposed(l, r, b, t, n, f);
		}else {
			return frustum(l, r, b, t, n, f);
		}
	}
	
	private static function frustum(l:Float, r:Float, b:Float, t:Float, n:Float, f:Float):Matrix3D
	{
		var mat = new Vector<Float>();
		mat[0] = (2 * n) / (r - l);
		mat[1] = 0;
		mat[2] = (r + l) / (r - l);
		mat[3] = 0;
		
		mat[4] = 0;
		mat[5] = (2 * n) / (t - b);
		mat[6] = (t + b) / (t - b);
		mat[7] = 0;
		
		mat[8] = 0;
		mat[9] = 0;
		mat[10] = -((f + n) / (f - n));
		mat[11] = -((2 * f * n) / (f - n));
		
		mat[12] = 0;
		mat[13] = 0;
		mat[14] = -1;
		mat[15] = 0;
		
		return new Matrix3D(mat);
	}	
	
	public static function lookAt(from:Vector3D, to:Vector3D, asAngles:Bool = true):Vector3D {
		var out:Vector3D = new Vector3D();
		var diff:Vector3D = to.subtract(from);
		var xzdistance:Float = Math.sqrt(diff.x * diff.x + diff.z * diff.z);
		if(asAngles){
			out.y = MathUtils.radToDeg(Math.atan2(diff.x, diff.z));
			out.x = MathUtils.radToDeg( -Math.atan2(diff.y, xzdistance));
		}else {
			out.y = Math.atan2(diff.x, diff.z);
			out.x = -Math.atan2(diff.y, xzdistance);
		}
		out.z = 0;
		return out;
	}
	
	private static function frustumTransposed(l:Float, r:Float, b:Float, t:Float, n:Float, f:Float):Matrix3D {
		var mat = new Vector<Float>();
		mat[0] = (2 * n) / (r - l);
		mat[4] = 0;
		mat[8] = (r + l) / (r - l);
		mat[12] = 0;
		
		mat[1] = 0;
		mat[5] = (2 * n) / (t - b);
		mat[9] = (t + b) / (t - b);
		mat[13] = 0;
		
		mat[2] = 0;
		mat[6] = 0;
		mat[10] = -((f + n) / (f - n));
		mat[14] = -((2 * f * n) / (f - n));
		
		mat[3] = 0;
		mat[7] = 0;
		mat[11] = -1;
		mat[15] = 0;
		
		return new Matrix3D(mat);
	}
}