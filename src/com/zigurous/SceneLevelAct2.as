package com.zigurous 
{	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import com.greensock.TweenLite;
	
	final public class SceneLevelAct2 extends SceneLevel 
	{
		private var _platforms:Vector.<Sprite>;
		
		private var _child:MovieClip;
		private var _childHitbox:Sprite;
		
		private var _itemIcecreamHitbox:Sprite;
		private var _itemBandagesHitbox:Sprite;
		private var _itemFlowersHitbox:Sprite;
		private var _itemShirtHitbox:Sprite;
		
		private var _itemsGiven:int;
		private var _delayedCall:TweenLite;
		
		private var _heartMonitor:MovieClip;
		private var _heartrateTimer:Timer;
		private var _dieing:Boolean;
		private var _dead:Boolean;
		
		private var _icecreamGrounded:Boolean;
		private var _icecreamFalling:Boolean;
		
		static private const CHILD_BREATHING_FRAME:int = 1;
		static private const CHILD_DIEING_FRAME:int = 6;
		
		static private const HEARTRATE_BASE:Number = 60000.0 / 20.0; // 20 BPM
		static private const HEARTRATE_GIVE_ITEM:Number = 60000.0 / 100.0; // 100 BPM
		
		override internal function update( deltaTime:Number ):void 
		{
			if ( _player.isFalling() ) 
			{
				var i:uint = _platforms.length;
				while ( i-- ) 
				{
					var platform:Sprite = _platforms[i];
					if ( PhysicsUtils.isCollidingAABB( _player.hitbox, platform ) ) 
					{
						if ( _player.y >= platform.y && _player.y <= platform.y + platform.height ) 
						{
							_player.y = platform.y;
							_player.land( platform );
							
							break;
						}
					}
				}
			}
			
			if ( _dead ) 
			{
				if ( _player.x <= 10.0 || _player.x >= _stage.stageWidth - 10.0 ) 
				{
					SceneLevelAct3.allowEnding = true;
					Main.instance.transitionToLevel( 3 );
				}
			}
		}
		
		override protected function onInit():void 
		{
			_platforms = new <Sprite>[];
			_platforms.push( _scene["mCollider01"] );
			_platforms.push( _scene["mCollider02"] );
			_platforms.push( _scene["mCollider03"] );
			_platforms.push( _scene["mCollider04"] );
			_platforms.push( _scene["mCollider05"] );
			_platforms.push( _scene["mCollider06"] );
			_platforms.push( _scene["mCollider07"] );
			_platforms.push( _scene["mCollider08"] );
			_platforms.push( _scene["mCollider09"] );
			_platforms.push( _scene["mCollider10"] );
			_platforms.push( _scene["mCollider11"] );
			_platforms.push( _scene["mCollider12"] );
			_platforms.push( _scene["mCollider13"] );
			_platforms.push( _scene["mCollider14"] );
			
			_child = _scene["mChild"];
			_childHitbox = _scene["mHitboxChild"];
			
			_itemIcecreamHitbox = _scene["mHitboxIcecream"];
			_itemBandagesHitbox = _scene["mHitboxBandages"];
			_itemFlowersHitbox = _scene["mHitboxFlowers"];
			_itemShirtHitbox = _scene["mHitboxShirt"];
			
			_heartMonitor = _scene["mHeartMonitor"];
			_heartrateTimer = new Timer( HEARTRATE_BASE );
		}
		
		override protected function onDispose():void 
		{
			if ( _platforms != null ) 
			{
				_platforms.length = 0;
				_platforms = null;
			}
			
			_child = null;
			_childHitbox = null;
			_itemIcecreamHitbox = null;
			_itemBandagesHitbox = null;
			_itemFlowersHitbox = null;
			_itemShirtHitbox = null;
			_heartMonitor = null;
			_heartrateTimer = null;
		}
		
		override protected function onBegin():void 
		{
			_bounds = new Rectangle( -1280.0, 0.0, 2560.0, 720.0 );
			_walls = new <DisplayObject>[];
			
			_playbackControls.hide();
			
			_player.y = 705.0;
			_player.faceLeft();
			_player.setGround();
			
			_dead = false;
			_dieing = false;
			_icecreamGrounded = false;
			_itemsGiven = 0;
			
			_childHitbox.addEventListener( MouseEvent.CLICK, onInteractChild );
			_itemIcecreamHitbox.addEventListener( MouseEvent.CLICK, onInteractIcecream );
			_itemBandagesHitbox.addEventListener( MouseEvent.CLICK, onInteractBandages );
			_itemFlowersHitbox.addEventListener( MouseEvent.CLICK, onInteractFlowers );
			_itemShirtHitbox.addEventListener( MouseEvent.CLICK, onInteractShirt );
			
			_scene["mIcecream"].scaleX = 0.70;
			_scene["mIcecream"].scaleY = 0.75;
			_scene["mIcecream"].rotation = 0.0;
			_scene["mIcecream"].y = -10.0;
			
			_itemIcecreamHitbox.scaleX = _itemIcecreamHitbox.scaleY = 1.0;
			_itemIcecreamHitbox.rotation = 0.0;
			_itemIcecreamHitbox.y = _scene["mIcecream"].y + 40.0;
			
			_itemIcecreamHitbox.visible = true;
			_itemBandagesHitbox.visible = true;
			_itemFlowersHitbox.visible = true;
			_itemShirtHitbox.visible = true;
			
			_scene["mIcecream"].visible = true;
			_scene["mBandages"].visible = true;
			_scene["mFlowers"].visible = true;
			_scene["mShirt"].visible = true;
			
			_scene["mChildIcecream"].visible = false;
			_scene["mChildBandages"].visible = false;
			_scene["mChildFlowers"].visible = false;
			_scene["mChildShirt"].visible = false;
			_scene["mWall01"].visible = false;
			_scene["mWall02"].visible = false;
			
			_scene["mChildIcecream"].rotation = 22.0;
			_scene["mChildIcecream"].x = 602.0;
			_scene["mChildIcecream"].y = 585.0;
			
			_heartMonitor.gotoAndStop( 1 );
			_heartrateTimer.addEventListener( TimerEvent.TIMER, onHeartrateTick );
			_heartrateTimer.delay = HEARTRATE_BASE;
			_heartrateTimer.reset();
			_heartrateTimer.start();
			
			AudioManager.playMusic( "MusicAct2" );
			ColorUtils.desaturate( _player, 0.5 );
			
			MouseHighlight.addHighlight( _child, _childHitbox );
			MouseHighlight.addHighlight( _scene["mIcecream"], _itemIcecreamHitbox );
			MouseHighlight.addHighlight( _scene["mBandages"], _itemBandagesHitbox );
			MouseHighlight.addHighlight( _scene["mFlowers"], _itemFlowersHitbox );
			MouseHighlight.addHighlight( _scene["mShirt"], _itemShirtHitbox );
			
			Main.instance.hud.addItemClickCallback( onInteractChild );
		}
		
		override protected function onEnd():void 
		{
			_childHitbox.removeEventListener( MouseEvent.CLICK, onInteractChild );
			_itemIcecreamHitbox.removeEventListener( MouseEvent.CLICK, onInteractIcecream );
			_itemBandagesHitbox.removeEventListener( MouseEvent.CLICK, onInteractBandages );
			_itemFlowersHitbox.removeEventListener( MouseEvent.CLICK, onInteractFlowers );
			_itemShirtHitbox.removeEventListener( MouseEvent.CLICK, onInteractShirt );
			
			_heartrateTimer.removeEventListener( TimerEvent.TIMER, onHeartrateTick );
			_heartrateTimer.stop();
			
			AudioManager.stopMusic();
			ColorUtils.desaturate( _player, 1.0 );
			
			MouseHighlight.removeHighlight( _child, _childHitbox );
			MouseHighlight.removeHighlight( _scene["mIcecream"], _itemIcecreamHitbox );
			MouseHighlight.removeHighlight( _scene["mBandages"], _itemBandagesHitbox );
			MouseHighlight.removeHighlight( _scene["mFlowers"], _itemFlowersHitbox );
			MouseHighlight.removeHighlight( _scene["mShirt"], _itemShirtHitbox );
			
			Main.instance.hud.removeItemClickCallback();
		}
		
		private function onHeartrateTick( event:TimerEvent ):void 
		{
			_child.gotoAndPlay( CHILD_BREATHING_FRAME );
			_child.play();
			
			AudioManager.playSound( "SoundHeartMonitor" );
			
			if ( _dieing && _heartMonitor.currentFrame == 1 ) 
			{
				_heartrateTimer.delay += 1000.0;
				
				if ( _heartrateTimer.delay >= 6000.0 ) {
					childDeath();
				}
			}
		}
		
		private function childDeath():void 
		{
			_heartMonitor.gotoAndStop( 3 );
			_heartrateTimer.stop();
			_child.gotoAndPlay( CHILD_DIEING_FRAME );
			
			AudioManager.playSound( "SoundFlatline", 0.20 );
			TweenLite.delayedCall( 4.0, onChildDeathComplete );
			
			TweenLite.to( _scene["mChildIcecream"], 1.5, { y:800.0, rotation:235.0 } );
		}
		
		private function onChildDeathComplete():void 
		{
			_walls = new <DisplayObject>[];
			_dead = true;
		}
		
		private function onChildHigherBPMOver():void 
		{
			_heartMonitor.gotoAndStop( 1 );
			_heartrateTimer.delay = HEARTRATE_BASE;
		}
		
		private function onInteractChild( event:MouseEvent = null ):void 
		{
			if ( Main.instance.hud.hasItem() ) 
			{
				if ( PhysicsUtils.distanceBetween( _player.hitbox, _childHitbox ) < 300.0 ) 
				{
					_itemsGiven++;
					
					var itemID:int;
					if ( event == null ) itemID = Main.instance.hud.itemClickedID;
					else itemID = Main.instance.hud.getItemIDBySlot( Main.instance.hud.itemCount - 1 );
					
					Main.instance.hud.removeItem( itemID );
					
					if ( itemID == HUD.ITEM_ICECREAM ) {
						_scene["mChildIcecream"].visible = true;
					} 
					else if ( itemID == HUD.ITEM_BANDAGES ) {
						_scene["mChildBandages"].visible = true;
					} 
					else if ( itemID == HUD.ITEM_FLOWERS ) {
						_scene["mChildFlowers"].visible = true;
					} 
					else if ( itemID == HUD.ITEM_SHIRT ) {
						_scene["mChildShirt"].visible = true;
					}
					
					AudioManager.playSound( "SoundPoof", 0.5 );
					
					if ( _itemsGiven == 4 ) 
					{
						_dieing = true;
						
						_walls.push( _scene["mWall01"] );
						_walls.push( _scene["mWall02"] );
						
						_scene["mWall01"].alpha = 0.0;
						_scene["mWall01"].visible = true;
						
						_scene["mWall02"].alpha = 0.0;
						_scene["mWall02"].visible = true;
						
						TweenLite.to( _scene["mWall01"], 8.0, { alpha: 1.0 } );
						TweenLite.to( _scene["mWall02"], 8.0, { alpha: 1.0 } );
						
						MouseHighlight.removeHighlight( _child, _childHitbox );
					}
					
					_heartMonitor.gotoAndStop( 2 );
					_heartrateTimer.delay = HEARTRATE_GIVE_ITEM;
					
					if ( _delayedCall != null ) _delayedCall.kill();
					_delayedCall = TweenLite.delayedCall( 10.0, onChildHigherBPMOver );
				}
			}
		}
		
		private function onInteractIcecream( event:MouseEvent ):void 
		{
			if ( !_icecreamFalling ) 
			{
				if ( !_icecreamGrounded ) 
				{
					_icecreamFalling = true;
					
					TweenLite.to( _scene["mIcecream"], 0.75, { y:220.0, scaleX:0.23, scaleY:0.25, onComplete:onIcecreamFallingComplete } );
					TweenLite.to( _scene["mIcecream"], 0.6, { rotation:75.0, delay:0.15 } );
					AudioManager.playSound( "SoundIcicle", 0.25 );
				} 
				else 
				{
					if ( PhysicsUtils.distanceBetween( _player.hitbox, _itemIcecreamHitbox ) < 150.0 ) 
					{
						_itemIcecreamHitbox.visible = false;
						_scene["mIcecream"].visible = false;
						
						Main.instance.hud.addItem( HUD.ITEM_ICECREAM );
					}
				}
			}
		}
		
		private function onIcecreamFallingComplete():void 
		{
			_icecreamGrounded = true;
			_icecreamFalling = false;
			_itemIcecreamHitbox.scaleX = _itemIcecreamHitbox.scaleY = 0.35;
			_itemIcecreamHitbox.rotation = 75.0;
			_itemIcecreamHitbox.y = _scene["mIcecream"].y;
		}
		
		private function onInteractBandages( event:MouseEvent ):void 
		{
			if ( PhysicsUtils.distanceBetween( _player.hitbox, _itemBandagesHitbox ) < 200.0 ) 
			{
				_itemBandagesHitbox.visible = false;
				_scene["mBandages"].visible = false;
				
				Main.instance.hud.addItem( HUD.ITEM_BANDAGES );
				//AudioManager.playSound( "SoundBandages", 0.5 );
			}
		}
		
		private function onInteractFlowers( event:MouseEvent ):void 
		{
			if ( PhysicsUtils.distanceBetween( _player.hitbox, _itemFlowersHitbox ) < 200.0 ) 
			{
				_itemFlowersHitbox.visible = false;
				_scene["mFlowers"].visible = false;
				
				Main.instance.hud.addItem( HUD.ITEM_FLOWERS );
				//AudioManager.playSound( "SoundBear" );
			}
		}
		
		private function onInteractShirt( event:MouseEvent ):void 
		{
			if ( PhysicsUtils.distanceBetween( _player.hitbox, _itemShirtHitbox ) < 150.0 ) 
			{
				_itemShirtHitbox.visible = false;
				_scene["mShirt"].visible = false;
				
				Main.instance.hud.addItem( HUD.ITEM_SHIRT );
				//AudioManager.playSound( "SoundSuperhero" );
			}
		}
		
	}
	
}