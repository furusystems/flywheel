package com.furusystems.flywheel.display.rendering.lime.materials;
import com.furusystems.flywheel.geom.Vector2D;
import lime.gl.GL;
import lime.gl.GLProgram;
import lime.gl.GLShader;
import lime.utils.Matrix3D;
import lime.utils.Vector3D;

/**
 * ...
 * @author Andreas Rønning
 */
class Shader
{
	public var name:String;
	
	var vertSource:String;
	var fragSource:String;
	
	public var vert:GLShader;
	public var frag:GLShader;
	public var prog:GLProgram;
	public var uniforms:Map<String, Int>;
	public var uniformTypes:Map<String, Int>;
	public var uniformValues:Map<String, Dynamic>;
	public var isActive:Bool;
	var dirtyUniforms:Map<String, Bool>;
	
	function new() 
	{
		name = "Shader";
	}
	
	
	function initFromSource(vertSrc:String, fragSrc:String) {
		this.vertSource = vertSrc;
		this.fragSource = fragSrc;
		var vertexShader = GL.createShader (GL.VERTEX_SHADER);
		GL.shaderSource (vertexShader, vertSource);
		GL.compileShader (vertexShader);
		
		if (GL.getShaderParameter (vertexShader, GL.COMPILE_STATUS) == 0) {
			trace("Error compiling vertex shader: "+GL.getShaderInfoLog(vertexShader));
			throw "Error compiling vertex shader";
			
		}
		
		var fragmentShader = GL.createShader (GL.FRAGMENT_SHADER);
		GL.shaderSource (fragmentShader, fragSource);
		GL.compileShader (fragmentShader);
		
		if (GL.getShaderParameter (fragmentShader, GL.COMPILE_STATUS) == 0) {
			trace("Error compiling fragment shader: "+GL.getShaderInfoLog(fragmentShader));
			throw "Error compiling fragment shader";
			
		}
		
		var shaderProgram = GL.createProgram ();
		GL.attachShader (shaderProgram, vertexShader);
		GL.attachShader (shaderProgram, fragmentShader);
		GL.linkProgram (shaderProgram);
		
		if (GL.getProgramParameter (shaderProgram, GL.LINK_STATUS) == 0) {
			throw "Unable to initialize the shader program.";
		}
		
		var u = uniforms = new Map<String,Int>();
		var utypes = uniformTypes = new Map<String,Int>();
		var uvalues = uniformValues = new Map<String,Dynamic>();
		var dirties = dirtyUniforms = new Map<String,Bool>();
		var numUniforms = GL.getProgramParameter(shaderProgram, GL.ACTIVE_UNIFORMS);
		while (numUniforms-->0) {
			var uInfo = GL.getActiveUniform(shaderProgram, numUniforms);
			switch(uInfo.type) {
				case GL.FLOAT:
					trace(uInfo.name+ " float");
					uvalues.set(uInfo.name, 1.0);
				case GL.FLOAT_VEC2:
					trace(uInfo.name+ " vector2");
					uvalues.set(uInfo.name, new Vector2D());
				case GL.FLOAT_VEC3|GL.FLOAT_VEC4:
					trace(uInfo.name+ " vector3");
					uvalues.set(uInfo.name, new Vector3D());
				case GL.INT:
					uvalues.set(uInfo.name, 0);
					trace(uInfo.name+ " Int");
				case GL.FLOAT_MAT4:
					uvalues.set(uInfo.name, new Matrix3D());
					trace(uInfo.name+ " matrix");
			}
			u.set(uInfo.name, numUniforms);
			utypes.set(uInfo.name, uInfo.type);
			dirties.set(uInfo.name, true);
		}
		
		vert = vertexShader;
		frag = fragmentShader;
		prog = shaderProgram;
	}
	
	public static function createFromSrc(vertSrc:String, fragSrc:String):Shader {
		vertSrc = ShaderPreproc.processSource(vertSrc);
		fragSrc = ShaderPreproc.processSource(fragSrc);
		var out = new Shader();
		out.initFromSource(vertSrc, fragSrc);
		return out;
	}
	public function reload():Void {
		initFromSource(vertSource, fragSource);
	}
	public function activate():Void {
		if (!isActive) {
			isActive = true;
			GL.useProgram(prog);
			applyUniforms(true);
		}
	}
	public function deactivate():Void {
		isActive = false;
		GL.useProgram(null);
	}
	public function setUniform(name:String, value:Dynamic):Void {
		if (!uniformValues.exists(name)) throw "No uniform called '" + name+"'";
		uniformValues.set(name, value);
		dirtyUniforms.set(name, true);
		if (isActive) applyUniforms(false);
	}
	
	public function applyUniforms(all:Bool = true) 
	{
		if (!isActive) return;
		for (i in dirtyUniforms.keys()) {
			if (all || dirtyUniforms.get(i) == true) {
				dirtyUniforms.set(i, false);
				applyUniform(i);
			}
		}
	}
	inline function applyUniform(name:String) {
		switch(uniformTypes.get(name)) {
			case GL.FLOAT:
				GL.uniform1f(uniforms.get(name), uniformValues.get(name));
			case GL.FLOAT_VEC2:
				var vec:Vector2D = uniformValues.get(name);
				GL.uniform2f(uniforms.get(name), vec.x, vec.y);
			case GL.FLOAT_VEC3:
				var vec:Vector3D = uniformValues.get(name);
				GL.uniform3f(uniforms.get(name), vec.x, vec.y, vec.z);
			case GL.FLOAT_VEC4:
				var vec:Vector3D = uniformValues.get(name);
				GL.uniform4f(uniforms.get(name), vec.x, vec.y, vec.z, vec.w);
			case GL.INT:
				GL.uniform1i(uniforms.get(name), Std.int(uniformValues.get(name)));
			case GL.FLOAT_MAT4:
				GL.uniformMatrix3D(uniforms.get(name), false, uniformValues.get(name));
		}
	}
	
	public function toString():String {
		return "Shader ["+name+"]";
	}
	
	/* INTERFACE com.furusystems.games.IDisposable */
	
	public function dispose():Void 
	{
		GL.deleteProgram(prog);
		GL.deleteShader(vert);
		GL.deleteShader(frag);
	}
	
}