package com.zigurous 
{
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.utils.Dictionary;
	
	public class MouseHighlight 
	{
		static private var _highlights:Dictionary = new Dictionary();
		static private var _highlight:GlowFilter = new GlowFilter( 0xffff00, 1.0, 6.0, 6.0, 5 );
		
		static public function addHighlight( obj:InteractiveObject, hitbox:InteractiveObject = null ):void 
		{
			if ( hitbox == null ) hitbox = obj;
			
			hitbox.addEventListener( MouseEvent.ROLL_OVER, onMouseRollOver );
			hitbox.addEventListener( MouseEvent.ROLL_OUT, onMouseRollOut );
			
			_highlights[hitbox] = obj;
		}
		
		static public function removeHighlight( obj:InteractiveObject, hitbox:InteractiveObject = null ):void 
		{
			if ( hitbox == null ) hitbox = obj;
			
			obj.filters = [];
			
			hitbox.removeEventListener( MouseEvent.ROLL_OVER, onMouseRollOver );
			hitbox.removeEventListener( MouseEvent.ROLL_OUT, onMouseRollOut );
			
			delete _highlights[obj];
		}
		
		static public function highlight( obj:InteractiveObject ):void 
		{
			obj.filters = [_highlight];
		}
		
		static public function unhighlight( obj:InteractiveObject ):void 
		{
			obj.filters = [];
		}
		
		static private function onMouseRollOver( event:MouseEvent ):void 
		{
			highlight( _highlights[event.currentTarget] );
		}
		
		static private function onMouseRollOut( event:MouseEvent ):void 
		{
			unhighlight( _highlights[event.currentTarget] );
		}
		
	}
	
}