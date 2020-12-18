package com.zigurous 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	
	public class MainMenu extends MovieClip 
	{
		private var _shown:Boolean;
		private var _animating:Boolean;
		
		public function show():void 
		{
			if ( !_shown ) 
			{
				_shown = true;
				
				alpha = 1.0;
				visible = true;
				addEventListener( MouseEvent.CLICK, onClick );
				
				Main.instance.addChild( this );
			}
		}
		
		public function hide():void 
		{
			if ( _shown && !_animating ) 
			{
				removeEventListener( MouseEvent.CLICK, onClick );
				
				Main.instance.fadeToBlack( 1.0, onHideComplete );
				_animating = true;
			}
		}
		
		private function onClick( event:MouseEvent ):void 
		{
			hide();
		}
		
		private function onHideComplete():void 
		{
			visible = false;
			Main.instance.removeChild( this );
			
			_shown = false;
			_animating = false;
			
			Main.instance.startGame();
		}
		
	}
	
}