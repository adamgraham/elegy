package com.zigurous 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	final public class Player extends MovieClip 
	{
		private var _stage:Stage;
		private var _scene:SceneLevel;
		private var _model:MovieClip;
		private var _modelScale:Point;
		private var _hitbox:Sprite;
		
		private var _wasd:Boolean;
		private var _left:Boolean;
		private var _right:Boolean;
		private var _jumping:Boolean;
		private var _falling:Boolean;
		private var _canJump:Boolean;
		
		private var _platformed:Boolean;
		private var _platform:Sprite;
		
		private var _velocity:Number;
		private var _previousY:Number;
		private var _groundY:Number;
		
		static private const BASE_SPEED:Number = 300.0;
		static private const JUMP_SPEED:Number = 900.0;
		static private const GRAVITY:Number = 2500.0;
		
		static private var IDLE_FRAME:int = 1;
		static private var WALK_FRAME:int = 2;
		static private var JUMP_FRAME:int = 17;
		
		public function get hitbox():Sprite { return _hitbox; }
		
		public function showTeddyBear():void 
		{
			IDLE_FRAME = 18;
			WALK_FRAME = 19;
			JUMP_FRAME = 34;
			
			_model.gotoAndStop( IDLE_FRAME );
		}
		
		public function hideTeddyBear():void 
		{
			IDLE_FRAME = 1;
			WALK_FRAME = 2;
			JUMP_FRAME = 17;
			
			_model.gotoAndStop( IDLE_FRAME );
		}
		
		public function hasTeddyBear():Boolean 
		{
			return IDLE_FRAME == 18;
		}
		
		public function enableWASDMovement( enableJumping:Boolean = true ):void 
		{
			if ( !_wasd ) 
			{
				_stage.removeEventListener( KeyboardEvent.KEY_DOWN, onKeysDown );
				_stage.removeEventListener( KeyboardEvent.KEY_UP, onKeysUp );
				
				_stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeysDown );
				_stage.addEventListener( KeyboardEvent.KEY_UP, onKeysUp );
				
				_wasd = true;
				_left = false;
				_right = false;
				
				_canJump = enableJumping;
			}
		}
		
		public function disableWASDMovement():void 
		{
			if ( _wasd ) 
			{
				_stage.removeEventListener( KeyboardEvent.KEY_DOWN, onKeysDown );
				_stage.removeEventListener( KeyboardEvent.KEY_UP, onKeysUp );
				
				_wasd = false;
				_left = false;
				_right = false;
				_canJump = false;
				
				idle();
			}
		}
		
		public function enableJumping():void 
		{
			_canJump = true;
		}
		
		public function disableJumping():void 
		{
			_canJump = false;
		}
		
		public function setGround():void 
		{
			_groundY = y;
		}
		
		public function idle():void 
		{
			_model.gotoAndStop( IDLE_FRAME );
		}
		
		public function faceLeft():void 
		{
			_model.scaleX = _modelScale.x;
		}
		
		public function faceRight():void 
		{
			_model.scaleX = -_modelScale.x;
		}
		
		public function land( platform:Sprite = null ):void 
		{
			_jumping = false;
			_falling = false;
			_platform = platform;
			_platformed = _platform != null;
			
			idle();
		}
		
		public function isJumping():Boolean 
		{
			return _jumping;
		}
		
		public function isFalling():Boolean 
		{
			return _falling;
		}
		
		public function isMovingLeft():Boolean 
		{
			return _left;
		}
		
		public function isMovingRight():Boolean
		{
			return _right;
		}
		
		internal function init( stage:Stage ):void 
		{
			_stage = stage;
			_model = this["mModel"] as MovieClip;
			_modelScale = new Point( _model.scaleX, _model.scaleY );
			_hitbox = this["mHitbox"] as Sprite;
		}
		
		internal function setCurrentScene( scene:SceneLevel ):void 
		{
			_scene = scene;
		}
		
		internal function update( deltaTime:Number ):void 
		{
			if ( _left ) 
			{
				_scene.move( BASE_SPEED * deltaTime );
				
				faceLeft();
				
				if ( !_model.isPlaying && !_jumping && !_falling ) {
					_model.gotoAndPlay( WALK_FRAME );
				}
			}
			else if ( _right ) 
			{
				_scene.move( -BASE_SPEED * deltaTime );
				
				faceRight();
				
				if ( !_model.isPlaying && !_jumping && !_falling ) {
					_model.gotoAndPlay( WALK_FRAME );
				}
			} 
			else 
			{
				if ( !_jumping && !_falling ) {
					idle();
				}
			}
			
			if ( _jumping || _falling ) 
			{
				y -= _velocity * deltaTime;
				
				if ( y > _groundY ) 
				{
					y = _groundY;
					land();
				} 
				else 
				{
					_velocity -= GRAVITY * deltaTime;
					
					if ( _velocity <= 0.0 ) 
					{
						_falling = true;
						_jumping = false;
					}
				}
			} 
			else if ( _platformed ) 
			{
				if ( !PhysicsUtils.isCollidingAABB( _hitbox, _platform ) ) {
					fall();
				}
			}
		}
		
		private function jump():void 
		{
			if ( _canJump && !_jumping && !_falling ) 
			{
				_jumping = true;
				_velocity = JUMP_SPEED;
				_model.gotoAndStop( JUMP_FRAME );
			}
		}
		
		private function fall():void 
		{
			_jumping = false;
			_falling = true;
			_platformed = false;
			_platform = null;
			_velocity = 0.0;
			_model.gotoAndStop( JUMP_FRAME );
		}
		
		private function onKeysDown( event:KeyboardEvent ):void 
		{
			if ( event.keyCode == Keyboard.A || event.keyCode == Keyboard.LEFT ) {
				_left = true;
			} else if ( event.keyCode == Keyboard.D || event.keyCode == Keyboard.RIGHT ) {
				_right = true;
			} else if ( event.keyCode == Keyboard.W || event.keyCode == Keyboard.SPACE ) {
				jump();
			}
		}
		
		private function onKeysUp( event:KeyboardEvent ):void 
		{
			if ( event.keyCode == Keyboard.A || event.keyCode == Keyboard.LEFT ) {
				_left = false;
			} else if ( event.keyCode == Keyboard.D || event.keyCode == Keyboard.RIGHT ) {
				_right = false;
			} 
		}
		
	}
	
}