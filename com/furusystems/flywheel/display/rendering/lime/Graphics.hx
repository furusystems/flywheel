package com.furusystems.flywheel.display.rendering.lime;
import com.furusystems.flywheel.display.rendering.lime.resources.TextureHandle;
import com.furusystems.flywheel.display.rendering.lime.tiles.LimeTileSheet;
import com.furusystems.flywheel.display.rendering.lime.tiles.TileFlags;
import com.furusystems.flywheel.geom.Vector2D;
import haxe.EnumFlags.EnumFlags;
import lime.gl.GL;
import lime.gl.GLBuffer;
import lime.utils.ByteArray;
import lime.utils.Float32Array;
import lime.utils.Matrix3D;
import lime.utils.Vector3D;
import shaderblox.ShaderBase;

/**
 * ...
 * @author Andreas Rønning
 */
private class GraphicsLineStyle {
	public var width:Float;
	public var color:Vector3D;
	public function new() {
		
	}
}
private class GraphicsFillStyle {
	public var color:Vector3D;
	public function new() {
		
	}
}

private class RenderState {
	
}

class Graphics
{
	
	static var vertexAttribute:Int;
	static var texCoordAttribute:Int;
	static var projectionMatrixUniform:Int;
	static var textureUniform:Int;
	static var fillColorUniform:Int;
	static var textureWeightUniform:Int;
	static var timeUniform:Int;
	static var screenSizeUniform:Int;
	
	static var vbo:GLBuffer;
	static var ibo:GLBuffer;
	static var initialized:Bool = false;
	static var currentTexture:TextureHandle;
	static var currentShader:ShaderBase;
	
	static var currentLineStyle:GraphicsLineStyle;
	static var currentFillStyle:GraphicsFillStyle;
	static var projectionMatrix:Matrix3D;
	
	static var prevTextureWeight:Float;
	
	static var utilVec:Vector2D = new Vector2D();
	static var utilMat:Matrix3D = new Matrix3D();
	
	static var vertices:Array<Float> = [];
	static var vertexF32Array:Float32Array;
	
	public static var time:Float = 0.0;
	
	static var prevDrawPosition:Vector3D = new Vector3D();
	public static var screenWidth:Float = 0;
	public static var screenHeight:Float = 0;
	
	static function initialize(force:Bool = false):Void {
		//GL.uniform1f(timeUniform, time);
		if (!initialized || force) {
			vbo = GL.createBuffer();
			GL.bindBuffer(GL.ARRAY_BUFFER, vbo);
			vertexF32Array = new Float32Array(512 * 1000);
			GL.bufferData(GL.ARRAY_BUFFER, vertexF32Array, GL.STREAM_DRAW);
			GL.bindBuffer(GL.ARRAY_BUFFER, null);
			ibo = GL.createBuffer();
			initialized = true;
		}
	}
	
	public static inline function setBlendFactors(from:Int, to:Int):Void {
		GL.enable(GL.BLEND);
		GL.blendFunc(from, to);
	}

	public static inline function drawMesh(m:Mesh, transform:Matrix3D) {
		m.predraw();
		m.draw();
		m.postdraw();
	}
	
	public static inline function clear(r:Float, g:Float, b:Float, a:Float):Void {
		GL.clearColor (r, g, b, a);
		GL.disable(GL.SCISSOR_TEST);
		GL.clear (GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT | GL.STENCIL_BUFFER_BIT);
		GL.enable(GL.SCISSOR_TEST);
		currentLineStyle = null;
		currentFillStyle = null;
		setTexture(null);
		setShader(null);
	}
	
	public static function setShader(shader:ShaderBase):Void {
		if (currentShader == shader) return;
		if (currentShader != null) currentShader.deactivate();
		currentShader = shader;
		if (currentShader == null) return;
		currentShader.activate();
		/*
		clearShader();
		currentShader = shader;
		if (currentShader != null) {
			if (!currentShader.acquired) currentShader.acquire();
			var shader = currentShader.shader;
			GL.useProgram(shader.prog);
			vertexAttribute = GL.getAttribLocation (shader.prog, "aVertexPosition");
			texCoordAttribute = GL.getAttribLocation (shader.prog, "aTexCoord");
			projectionMatrixUniform = GL.getUniformLocation (shader.prog, "uProjectionMatrix");
			textureUniform = GL.getUniformLocation (shader.prog, "uTexture");
			fillColorUniform = GL.getUniformLocation (shader.prog, "uFillColor");
			textureWeightUniform = GL.getUniformLocation (shader.prog, "uTextureWeight");
			timeUniform = GL.getUniformLocation (shader.prog, "uTime");
			screenSizeUniform = GL.getUniformLocation (shader.prog, "uScreenSize");
			currentShader.shader.activate();
			updateUniforms();
			GL.enableVertexAttribArray(vertexAttribute);
			GL.enableVertexAttribArray(texCoordAttribute);
		}else {
			GL.disableVertexAttribArray(vertexAttribute);
			GL.disableVertexAttribArray(texCoordAttribute);
		}
		*/
	}
	static inline function clearShader():Void {
		GL.useProgram(null);
		GL.disableVertexAttribArray (vertexAttribute);
		GL.disableVertexAttribArray (texCoordAttribute);
	}
	
	public static function dispose():Void {
		if (initialized) {
			GL.deleteBuffer(vbo);
			GL.deleteBuffer(ibo);
			vbo = ibo = null;
			currentShader = null;
			currentTexture = null;
			initialized = false;
		}
	}
	
	static inline function updateUniforms() 
	{		
		if (projectionMatrix != null) {
			GL.uniformMatrix3D(projectionMatrixUniform, false, projectionMatrix);
		}	
		GL.uniform2f(screenSizeUniform, screenWidth, screenHeight);
		if (currentTexture != null) {
			GL.bindTexture(GL.TEXTURE0, currentTexture.tex.tex);
			GL.uniform1f(textureWeightUniform, 1);
			prevTextureWeight = 1;
		}else {
			GL.uniform1f(textureWeightUniform, 0);
			prevTextureWeight = 0;
		}
		if (currentFillStyle != null) {
			var c = currentFillStyle.color;
			GL.uniform4f(fillColorUniform, c.x, c.y, c.z, c.w);
		}else {
			GL.uniform4f(fillColorUniform, 1, 1, 1, 1);
		}
	}
	
	public static function setProjectionMatrix(mat:Matrix3D):Void {
		projectionMatrix = mat;
		updateUniforms();
	}
	public static inline function getProjectionMatrix():Matrix3D {
		return projectionMatrix;
	}
	
	public static function setLineStyle(width:Float, color:Vector3D):Void {
		currentLineStyle = new GraphicsLineStyle();
		currentLineStyle.width = width;
		currentLineStyle.color = color;
		updateUniforms();
	}
	public static function setFillStyle(color:Vector3D):Void {
		if (color == null) {
			currentFillStyle = null;
		}else {			
			currentFillStyle = new GraphicsFillStyle();
			currentFillStyle.color = color;
		}
		updateUniforms();
	}
	
	public static function setTexture(tex:TextureHandle, index:Int = GL.TEXTURE0):Void {
		currentTexture = tex;
		if (currentTexture == null) {
			GL.activeTexture (index);
			GL.bindTexture (GL.TEXTURE_2D, null);
			//GL.disable (GL.TEXTURE_2D); HMmmm track number of active textures somehow before disabling?
		}else {
			if (!tex.acquired) tex.acquire();
			GL.activeTexture (index);
			GL.bindTexture (GL.TEXTURE_2D, currentTexture.tex.tex);
			GL.enable (GL.TEXTURE_2D);
			GL.uniform1f(textureWeightUniform, 1);
		}
		updateUniforms();
	}
	
	public static function clearStyles():Void {
		currentFillStyle = null;
		currentLineStyle = null;
	}
	
	public static function drawTiles(sheet:LimeTileSheet, data:Array<Float>, ?flags:EnumFlags<TileFlags>):Void {
		initialize();
		if (flags == null) flags = new EnumFlags<TileFlags>();
		var useScale:Bool = false;
		var useRotation:Bool = false;
		if (flags.has(TileFlags.ROTATION)) {
			useRotation = true;
		}
		if (flags.has(TileFlags.SCALE)) {
			useScale = true;
		}
		var dataindex = 0;
		var vertexIndex = 0;
		var vertexPosIndex:Int = -4;
		var indices:Int = 0;
		var sin:Float = 0;
		var cos:Float = 0;
		while (dataindex < data.length) {
			var idx = Std.int(data[dataindex++]);
			if (idx < 0) {
				break;
			}
			#if debug
			if (idx == 1) {
				trace("Tile index " + idx);
				trace(data);
			}
			#end
			var tile = sheet.tiles[idx];
			var centerx = data[dataindex ++];
			var centery = data[dataindex ++];
			if (tile == null) throw 'Null tile at $idx';
			
			var w:Float = tile.width - tile.offsetX;
			var h:Float = tile.height - tile.offsetY;
			utilVec.setTo(w, h);
			
			if (useScale) {
				w *= data[dataindex ++];
				h *= data[dataindex ++];
			}
			if (useRotation) {
				var rotation = data[dataindex ++];	
				sin = Math.sin(rotation);
				cos = Math.cos(rotation);
			}
			
			//Vertex values in pixels
			var tl = utilVec;
			if (useRotation) {
				tl.setTo( -w, -h);
				tl.rotateSinCos(sin,cos);
				tl.x += centerx;
				tl.y += centery;
			}else {
				tl.setTo(centerx - w, centery - h);
			}
			
			vertexF32Array.setFloat32(vertexIndex, tl.x);
			vertexF32Array.setFloat32(vertexIndex + 4, tl.y);
			vertexF32Array.setFloat32(vertexIndex + 8, tile.umin);
			vertexF32Array.setFloat32(vertexIndex + 12, tile.vmin);
			vertexF32Array.setFloat32(vertexIndex + 48, tl.x);
			vertexF32Array.setFloat32(vertexIndex + 52, tl.y);
			vertexF32Array.setFloat32(vertexIndex + 56, tile.umin);
			vertexF32Array.setFloat32(vertexIndex + 60, tile.vmin);
			
			var tr = utilVec;
			if (useRotation) {
				tr.setTo(w, -h);
				tr.rotateSinCos(sin,cos);
				tr.x += centerx;
				tr.y += centery;
			}else {
				tr.setTo(centerx + w, centery - h);
			}
			
			vertexF32Array.setFloat32(vertexIndex + 16, tr.x);
			vertexF32Array.setFloat32(vertexIndex + 20, tr.y);
			vertexF32Array.setFloat32(vertexIndex + 24, tile.umax);
			vertexF32Array.setFloat32(vertexIndex + 28, tile.vmin);
			
			var br = utilVec;
			if (useRotation) {
				br.setTo(w, h);
				br.rotateSinCos(sin,cos);
				br.x += centerx;
				br.y += centery;
			}else {
				br.setTo(centerx + w, centery + h);
			}
			vertexF32Array.setFloat32(vertexIndex + 32 , br.x);
			vertexF32Array.setFloat32(vertexIndex + 36 , br.y);
			vertexF32Array.setFloat32(vertexIndex + 40, tile.umax);
			vertexF32Array.setFloat32(vertexIndex + 44, tile.vmax);
			vertexF32Array.setFloat32(vertexIndex + 64, br.x);
			vertexF32Array.setFloat32(vertexIndex + 68, br.y);
			vertexF32Array.setFloat32(vertexIndex + 72, tile.umax);
			vertexF32Array.setFloat32(vertexIndex + 76, tile.vmax);
			
			var bl = utilVec;
			if (useRotation) {
				bl.setTo( -w, h);
				bl.rotateSinCos(sin,cos);
				bl.x += centerx;
				bl.y += centery;
			}else {
				bl.setTo(centerx - w, centery + h);
			}
			vertexF32Array.setFloat32(vertexIndex + 80, bl.x);
			vertexF32Array.setFloat32(vertexIndex + 84, bl.y);
			vertexF32Array.setFloat32(vertexIndex + 88, tile.umin);
			vertexF32Array.setFloat32(vertexIndex + 92, tile.vmax);
			
			indices += 6;
			vertexIndex += 96;
		}
		
		//var numElements = indices * 4;
		GL.bindBuffer (GL.ARRAY_BUFFER, vbo);
		GL.bufferSubData(GL.ARRAY_BUFFER, 0, new Float32Array (vertexF32Array.buffer, 0, vertexIndex));
		GL.vertexAttribPointer (vertexAttribute, 2, GL.FLOAT, false, 16, 0);
		GL.vertexAttribPointer (texCoordAttribute, 2, GL.FLOAT, false, 16, 8);
		
		GL.drawArrays(GL.TRIANGLES, 0, indices);
		
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
	}
	
	
	static inline function buildRect(x:Float,y:Float,width:Float,height:Float, uvBoundsX:Float = 1, uvBoundsY:Float = 1, uvOffsetX:Float = 0, uvOffsetY:Float = 0) 
	{
		var idx:Int = 0;
		vertexF32Array.setFloat32(idx, x);
		vertexF32Array.setFloat32(idx += 4, y);
		vertexF32Array.setFloat32(idx += 4, uvOffsetX);
		vertexF32Array.setFloat32(idx += 4, uvOffsetY);
		
		vertexF32Array.setFloat32(idx += 4, x + width);
		vertexF32Array.setFloat32(idx += 4, y);
		vertexF32Array.setFloat32(idx += 4, uvOffsetX+uvBoundsX);
		vertexF32Array.setFloat32(idx += 4, uvOffsetY);
		
		vertexF32Array.setFloat32(idx += 4, x + width);
		vertexF32Array.setFloat32(idx += 4, y + height);
		vertexF32Array.setFloat32(idx += 4, uvOffsetX+uvBoundsX);
		vertexF32Array.setFloat32(idx += 4, uvOffsetY+uvBoundsY);
		
		vertexF32Array.setFloat32(idx += 4, x);
		vertexF32Array.setFloat32(idx += 4, y + height);
		vertexF32Array.setFloat32(idx += 4, uvOffsetX);
		vertexF32Array.setFloat32(idx += 4, uvOffsetY+uvBoundsY);
	}
	
	public static function drawRect(x:Float, y:Float, width:Float, height:Float, uvBoundsX:Float = 1, uvBoundsY:Float = 1, uvOffsetX:Float = 0, uvOffsetY:Float = 0) {
		initialize();
		buildRect(x, y, width, height, uvBoundsX, uvBoundsY, uvOffsetX, uvOffsetY);
		
		GL.bindBuffer (GL.ARRAY_BUFFER, vbo);
		GL.bufferSubData(GL.ARRAY_BUFFER, 0, new Float32Array(vertexF32Array.buffer, 0, 16));
		//GL.vertexAttribPointer (vertexAttribute, 2, GL.FLOAT, false, 16, 0);
		//GL.vertexAttribPointer (texCoordAttribute, 2, GL.FLOAT, false, 16, 8);
		
		GL.drawArrays (GL.TRIANGLE_FAN, 0, 4) ;
		
		//if (currentLineStyle != null) {
			//GL.lineWidth(currentLineStyle.width);
			//var c = currentLineStyle.color;
			//GL.uniform4f(fillColorUniform, c.x, c.y, c.z, c.w);
			//GL.uniform1f(textureWeightUniform, 0);
			//GL.drawArrays(GL.LINE_LOOP, 0, 4);
			//GL.uniform1f(textureWeightUniform, prevTextureWeight);
			//if (currentFillStyle != null) {
				//var c = currentFillStyle.color;
				//GL.uniform4f(fillColorUniform, c.x, c.y, c.z, c.w);
			//}
		//}
		
		//return;
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
	}
	
	public static function drawCircle(x:Float, y:Float, radius:Float, resolution:Int = 8, rotation:Float = 0):Void {
		initialize();
		
		var tr = 1 / resolution;
		var idx:Int = -4;
		var uvpt = new Vector2D();
		var sinU:Float = 0;
		var cosU:Float = 0;
		if (rotation != 0) {
			sinU = Math.sin(rotation);
			cosU = Math.cos(rotation);
		}
		for (i in 0...resolution) {
			var t = i * tr * 6.28;
			var sin:Float = Math.sin(t);
			var cos:Float = Math.cos(t);
			vertexF32Array.setFloat32(idx += 4, x + cos * radius);
			vertexF32Array.setFloat32(idx += 4, y + sin * radius);
			uvpt.setTo(cos, sin);
			if(rotation!=0){
				uvpt.rotateSinCos(sinU, cosU);
			}
			uvpt += 1;
			uvpt *= 0.5;
			vertexF32Array.setFloat32(idx += 4, uvpt.x);
			vertexF32Array.setFloat32(idx += 4, uvpt.y);
		}
		GL.bindBuffer (GL.ARRAY_BUFFER, vbo);
		GL.bufferSubData(GL.ARRAY_BUFFER, 0, new Float32Array(vertexF32Array.buffer, 0, resolution * 4));
		GL.vertexAttribPointer (vertexAttribute, 2, GL.FLOAT, false, 16, 0);
		GL.vertexAttribPointer (texCoordAttribute, 2, GL.FLOAT, false, 16, 8);
		
		GL.drawArrays(GL.TRIANGLE_FAN, 0, resolution);
			
		if (currentLineStyle != null) {
			GL.lineWidth(currentLineStyle.width);
			var c = currentLineStyle.color;
			GL.uniform4f(fillColorUniform, c.x, c.y, c.z, c.w);
			GL.uniform1f(textureWeightUniform, 0);
			GL.drawArrays(GL.LINE_LOOP, 0, resolution);
			GL.uniform1f(textureWeightUniform, prevTextureWeight);
			if (currentFillStyle != null) {
				var c = currentFillStyle.color;
				GL.uniform4f(fillColorUniform, c.x, c.y, c.z, c.w);
			}
		}
		
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
	}
	
	public static function drawTriangles(vertices:Array<Float>, indices:Array<Int>, uvs:Array<Float>, dimensionality:Int = 2):Void {
		/*initialize();
		
		GL.bindBuffer (GL.ARRAY_BUFFER, vbo);
		GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (cast vertices), GL.STREAM_DRAW);
		GL.vertexAttribPointer (vertexAttribute, dimensionality, GL.FLOAT, false, 0, 0);
		
		GL.bindBuffer (GL.ARRAY_BUFFER, uvbo);	
		GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (cast uvs), GL.STREAM_DRAW);
		GL.vertexAttribPointer (texCoordAttribute, 2, GL.FLOAT, false, 0, 0);
		
		var indexData = createIndexBytes(indices);
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, ibo);
		GL.bufferData(GL.ELEMENT_ARRAY_BUFFER, indexData, GL.STREAM_DRAW);
		
		GL.drawElements(GL.TRIANGLES, indices.length, GL.UNSIGNED_BYTE, 0);
		
		GL.bindBuffer(GL.ARRAY_BUFFER, null);
		GL.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, null);*/
	}
	
	static public function reinit() 
	{
		initialized = false;
		initialize();
	}
	
	static inline function createIndexBytes(indices:Array<Int>):ByteArray 
	{
		var out = new ByteArray();
		for (i in 0...indices.length) {
			out.writeByte(indices[i]);
		}
		return out;
	}
	
	
	public static var quadVBO(get, never):GLBuffer;
	static var _quadVBO:GLBuffer = null;
	inline static function get_quadVBO():GLBuffer 
	{
		if (_quadVBO == null) {
			_quadVBO = GL.createBuffer();
			GL.bindBuffer(GL.ARRAY_BUFFER, _quadVBO);
			var vertices:Array<Float> = [
				-1, -1, 0, 0,
				1, -1, 1, 0,
				1, 1, 1, 1,
				-1, 1, 0, 1];
			GL.bufferData(GL.ARRAY_BUFFER, new Float32Array(vertices), GL.STATIC_DRAW);
			GL.bindBuffer(GL.ARRAY_BUFFER, null);
		}
		return _quadVBO;
	}
	
}