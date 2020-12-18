package com.zigurous 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	final public class PhysicsUtils 
	{
		static private const ORIGIN:Point = new Point();
		
		static public function distanceBetween( a:DisplayObject, b:DisplayObject ):Number 
		{
			var aPoint:Point = a.localToGlobal( ORIGIN );
			var bPoint:Point = b.localToGlobal( ORIGIN );
			
			var x1:Number = aPoint.x;
			var x2:Number = bPoint.x;
			
			var y1:Number = aPoint.y;
			var y2:Number = bPoint.y;
			
			var dx:Number = Math.abs( x2 - x1 );
			var dy:Number = Math.abs( y2 - y1 );
			
			return Math.sqrt( (dx * dx) + (dy * dy) );
		}
		
		static public function isCollidingAABB( a:DisplayObject, b:DisplayObject ):Boolean 
		{
			var aPoint:Point = a.localToGlobal( ORIGIN );
			var bPoint:Point = b.localToGlobal( ORIGIN );
			
			var x1:Number = aPoint.x;
			var x2:Number = bPoint.x;
			
			var y1:Number = aPoint.y;
			var y2:Number = bPoint.y;
			
			var dx:Number = Math.abs( x2 - x1 );
			var dy:Number = Math.abs( y2 - y1 );
			
			return (dx < (a.width * 0.5) + (b.width * 0.5)) ? ((dy < (a.height * 0.5) + (b.height * 0.5)) ? true : false) : false;
		}
		
		static public function isTargetLeftOf( target:DisplayObject, source:DisplayObject ):Boolean 
		{
			var sourcePoint:Point = source.localToGlobal( ORIGIN );
			var targetPoint:Point = target.localToGlobal( ORIGIN );
			
			return target.x <= sourcePoint.x;
		}
		
		static public function isTargetRightOf( target:DisplayObject, source:DisplayObject ):Boolean 
		{
			var sourcePoint:Point = source.localToGlobal( ORIGIN );
			var targetPoint:Point = target.localToGlobal( ORIGIN );
			
			return target.x >= sourcePoint.x;
		}
		
	}
	
}