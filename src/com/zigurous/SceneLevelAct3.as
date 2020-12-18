package com.zigurous 
{	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import com.greensock.TweenLite;
	
	final public class SceneLevelAct3 extends SceneLevel 
	{
		private var _teddyBearHitbox:Sprite;
		private var _casketHitbox:Sprite;
		private var _doorHitbox:Sprite;
		private var _retryButton:Sprite;
		
		private var _previousX:Number;
		
		static public var allowEnding:Boolean;
		
		override internal function update( deltaTime:Number ):void 
		{
			if ( _player.hasTeddyBear() ) 
			{
				if ( PhysicsUtils.distanceBetween( _player.hitbox, _casketHitbox ) < 250.0 ) 
				{
					if ( _retryButton.alpha < 1.0 ) 
					{
						_retryButton.visible = true;
						
						TweenLite.killTweensOf( _retryButton );
						TweenLite.to( _retryButton, 0.5, { alpha:1.0 } );
					}
				} 
				else 
				{
					if ( _retryButton.alpha == 1.0 ) 
					{
						TweenLite.killTweensOf( _retryButton );
						TweenLite.to( _retryButton, 0.5, { alpha:0.0 } );
					}
				}
			}
		}
		
		override protected function onInit():void 
		{
			_bounds = new Rectangle( 0.0, 0.0, 0.0, 720.0 );
			
			_teddyBearHitbox = _scene["mTeddyBearHitbox"];
			_casketHitbox = _scene["mCasketHitbox"];
			_doorHitbox = _scene["mDoorHitbox"];
			_retryButton = _scene["mRetry"];
			
			_previousX = 100.0;
		}
		
		override protected function onDispose():void 
		{
			_teddyBearHitbox = null;
			_casketHitbox = null;
			_doorHitbox = null;
			_retryButton = null;
		}
		
		override protected function onBegin():void 
		{
			_playbackControls.hide();
			_player.disableJumping();
			_player.x = allowEnding ? _previousX : 100.0;
			_player.y = 700.0;
			
			_teddyBearHitbox.addEventListener( MouseEvent.CLICK, onInteractTeddyBear );
			_casketHitbox.addEventListener( MouseEvent.CLICK, onInteractCasket );
			_doorHitbox.addEventListener( MouseEvent.CLICK, onInteractDoor );
			_retryButton.addEventListener( MouseEvent.CLICK, onPromptClick );
			_scene["mPicture"].addEventListener( MouseEvent.CLICK, onPromptClick );
			_retryButton.alpha = 0.0;
			
			closeDoor();
			
			_doorHitbox.visible = allowEnding;
			_casketHitbox.visible = allowEnding;
			
			AudioManager.playMusic( "MusicAct3" );
			ColorUtils.desaturate( _player, 0.25 );
			MouseHighlight.addHighlight( _scene["mTeddyBear"], _teddyBearHitbox );
			if ( allowEnding ) MouseHighlight.addHighlight( _scene["mCasket"], _casketHitbox );
		}
		
		override protected function onEnd():void 
		{
			_teddyBearHitbox.removeEventListener( MouseEvent.CLICK, onInteractTeddyBear );
			_casketHitbox.removeEventListener( MouseEvent.CLICK, onInteractCasket );
			_doorHitbox.removeEventListener( MouseEvent.CLICK, onInteractDoor );
			_retryButton.removeEventListener( MouseEvent.CLICK, onPromptClick );
			_scene["mPicture"].removeEventListener( MouseEvent.CLICK, onPromptClick );
			
			AudioManager.stopMusic();
			MouseHighlight.removeHighlight( _scene["mTeddyBear"], _teddyBearHitbox );
			MouseHighlight.removeHighlight( _scene["mDoorClosed"], _doorHitbox );
			MouseHighlight.removeHighlight( _scene["mCasket"], _casketHitbox );
			//ColorUtils.desaturate( _player, 1.0 );
		}
		
		private function openDoor():void 
		{
			_scene["mDoorOpen"].visible = true;
			_scene["mDoorClosed"].visible = false;
		}
		
		private function closeDoor():void 
		{
			_scene["mDoorOpen"].visible = false;
			_scene["mDoorClosed"].visible = true;
		}
		
		private function onInteractTeddyBear( event:MouseEvent ):void 
		{
			if ( PhysicsUtils.distanceBetween( _player.hitbox, _teddyBearHitbox ) < 200.0 ) 
			{
				_scene["mTeddyBear"].visible = false;
				_teddyBearHitbox.visible = false;
				_player.showTeddyBear();
				
				closeDoor();
				
				MouseHighlight.removeHighlight( _scene["mDoorClosed"], _doorHitbox );
				MouseHighlight.addHighlight( _scene["mCasket"], _casketHitbox );
				
				if ( !allowEnding ) 
				{
					_previousX = _player.x;
					
					SceneLevelAct1.resetScene = true;
					Main.instance.transitionToLevel( 1, true, 2.5 );
				}
			}
		}
		
		private function onInteractCasket( event:MouseEvent ):void 
		{
			if ( _player.hasTeddyBear() ) 
			{
				if ( PhysicsUtils.distanceBetween( _player.hitbox, _casketHitbox ) < 300.0 ) 
				{
					_scene["mTeddyBear"].visible = true;
					_teddyBearHitbox.visible = true;
					_player.hideTeddyBear();
					
					TweenLite.killTweensOf( _retryButton );
					TweenLite.to( _retryButton, 0.5, { alpha:0.0 } );
					
					MouseHighlight.addHighlight( _scene["mDoorClosed"], _doorHitbox );
					MouseHighlight.removeHighlight( _scene["mCasket"], _casketHitbox );
				}
			}
		}
		
		private function onInteractDoor( event:MouseEvent ):void 
		{
			if ( !_player.hasTeddyBear() ) 
			{
				if ( PhysicsUtils.distanceBetween( _player.hitbox, _doorHitbox ) < 200.0 ) 
				{
					Main.instance.transitionToLevel( -1 );
					TweenLite.delayedCall( 3.0, endGame );
				}
				
				_scene["mDoorOpen"].visible = true;
				_scene["mDoorClosed"].visible = false;
			}
		}
		
		private function onPromptClick( event:MouseEvent ):void 
		{
			if ( _player.hasTeddyBear() ) 
			{
				if ( PhysicsUtils.distanceBetween( _player.hitbox, _casketHitbox ) < 250.0 ) 
				{
					SceneLevelAct1.resetScene = true;
					Main.instance.transitionToLevel( 1 );
				}
			}
		}
		
		private function endGame():void 
		{
			Main.instance.endGame();
		}
		
	}
	
}