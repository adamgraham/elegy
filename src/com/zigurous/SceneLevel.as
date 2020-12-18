package com.zigurous 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	
	public class SceneLevel extends MovieClip 
	{
		protected var _stage:Stage;
		protected var _scene:MovieClip;
		protected var _bounds:Rectangle;
		protected var _walls:Vector.<DisplayObject>;
		protected var _player:Player;
		protected var _playbackControls:PlaybackControls;
		protected var _began:Boolean;
		
		static protected var STAGE_CENTER:Point = new Point( 640.0, 360.0 );
		
		final public function dispose():void 
		{
			end();
			onDispose();
			
			_stage = null;
			_scene = null;
			_bounds = null;
			_walls = null;
			_player = null;
			_playbackControls = null;
		}
		
		final public function begin():void 
		{
			if ( !_began ) 
			{
				_began = true;
				_player.faceRight();
				_player.enableWASDMovement();
				
				onBegin();
			}
		}
		
		final public function end():void 
		{
			if ( _began ) 
			{
				_began = false;
				_player.disableWASDMovement();
				
				onEnd();
			}
		}
		
		protected function onInit():void 
		{
			// override
		}
		
		protected function onDispose():void 
		{
			// override
		}
		
		protected function onBegin():void 
		{
			// override
		}
		
		protected function onEnd():void 
		{
			// override
		}
		
		protected function onRewind():void 
		{
			// override
		}
		
		internal function init( stage:Stage ):void 
		{
			_stage = stage;
			
			_scene = this["mScene"] as MovieClip;
			_bounds = new Rectangle( -1280.0, 0.0, 2560.0, 720.0 );
			_walls = new <DisplayObject>[];
			
			_playbackControls = Main.instance.playbackControls;
			
			_player = Main.instance.player;
			_player.visible = true;
			_player.x = _stage.stageWidth * 0.5;
			_player.y = 685.0;
			_player.setGround();
			
			addChild( _player );
			
			onInit();
		}
		
		final internal function rewind():void 
		{
			onRewind();
		}
		
		internal function update( deltaTime:Number ):void 
		{
			// override
		}
		
		internal function move( dx:Number ):void 
		{
			var wallCollider:DisplayObject = checkForPlayerWallCollsion();
			
			if ( wallCollider != null ) 
			{
				if ( PhysicsUtils.isTargetLeftOf( wallCollider, _player ) && _player.isMovingLeft() ||
					 PhysicsUtils.isTargetRightOf( wallCollider, _player ) && _player.isMovingRight() ) {
					dx *= -1.0; // bounce off wall
				}
			}
			
			if ( _player.x == STAGE_CENTER.x || _bounds.width == 0.0 )
			{
				var newPosition:Number = _scene.x + dx;
				
				if ( -newPosition < _bounds.left ) 
				{
					_scene.x = -_bounds.left;
					
					_player.x -= dx;
					checkForPlayerBoundsCollision();
				}
				else if ( -newPosition > _bounds.right ) 
				{
					_scene.x = -_bounds.right;
					
					_player.x -= dx;
					checkForPlayerBoundsCollision();
				} 
				else 
				{
					_scene.x = newPosition;
				}
			} 
			else 
			{
				_player.x -= dx;
				checkForPlayerBoundsCollision( true );
			}
		}
		
		private function checkForPlayerWallCollsion():DisplayObject 
		{
			var collider:DisplayObject;
			
			var i:uint = _walls.length;
			while ( i-- ) 
			{
				var wall:DisplayObject = _walls[i];
				if ( PhysicsUtils.isCollidingAABB( _player, wall ) ) 
				{
					collider = _walls[i];
					break;
				}
			}
			
			return collider;
		}
		
		private function checkForPlayerBoundsCollision( checkForCenter:Boolean = false ):void 
		{
			if ( _player.x < 0.0 ) _player.x = 0.0;
			else if ( _player.x > _stage.stageWidth ) _player.x = _stage.stageWidth;
			
			if ( checkForCenter ) 
			{
				var left:Boolean = _scene.x > 0.0;
				
				if ( left ) 
				{
					if ( _player.x > STAGE_CENTER.x ) {
						_player.x = STAGE_CENTER.x;
					}
				} 
				else // right
				{
					if ( _player.x < STAGE_CENTER.x ) {
						_player.x = STAGE_CENTER.x;
					}
				}
			}
		}
		
	}
	
}