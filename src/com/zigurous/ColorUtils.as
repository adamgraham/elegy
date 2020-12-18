package com.zigurous 
{
	import flash.display.DisplayObject;
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.ColorMatrixFilterPlugin;
	
	final public class ColorUtils 
	{
		static public function desaturate( obj:DisplayObject, percent:Number = 0.0 ):void 
		{
			TweenPlugin.activate( [ColorMatrixFilterPlugin] );
			TweenLite.to( obj, 0.0, { colorMatrixFilter:{ "saturation":percent } } );
		}
		
	}
	
}