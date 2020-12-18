package com.zigurous 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.greensock.TweenLite;

	public class CreditsMenu extends MovieClip 
	{
		private var _background:Sprite;
		private var _character:Sprite;
		
		private var _shown:Boolean;
		private var _animating:Boolean;
		
		public function CreditsMenu()
		{
			_background = this["mBackground"];
			_character = this["mCharacter"];
		}
		
		public function show():void 
		{
			if ( !_shown ) 
			{
				_shown = true;
				_background.x = 0.0;
				
				visible = true;
				addEventListener( Event.ENTER_FRAME, update );
				
				Main.instance.addChild( this );
			}
		}
		
		public function hide():void 
		{
			if ( _shown && !_animating ) 
			{
				removeEventListener( Event.ENTER_FRAME, update );
				visible = false;
			}
		}
		
		private function update( event:Event ):void 
		{
			if ( _background.x > -7350.0 ) 
			{
				_background.x -= 250.0 * FrameRate.deltaTime;
			} 
			else 
			{
				_character.x += 250.0 * FrameRate.deltaTime
				
				if ( _character.x > Main.instance.stageRef.stageWidth + 50.0 ) 
				{
					removeEventListener( Event.ENTER_FRAME, update );
					
					Main.instance.mainMenu.show();
					Main.instance.mainMenu.alpha = 0.0;
					
					TweenLite.to( Main.instance.mainMenu, 1.5, { alpha:1.0, onComplete:onShowMainMenuComplete } );
				}
			}
		}
		
		private function onShowMainMenuComplete():void 
		{
			hide();
		}
		
	}
	
}