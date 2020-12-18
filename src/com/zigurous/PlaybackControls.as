package com.zigurous 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.Scene;
	
	final public class PlaybackControls extends Sprite 
	{
		private var _sceneLevel:SceneLevel;
		
		private var _play:Sprite;
		private var _pause:Sprite;
		private var _rewind:Sprite;
		
		private var _playing:Boolean;
		
		public function dispose():void 
		{
			if ( parent != null ) {
				parent.removeChild( this );
			}
			
			if ( _play != null ) 
			{
				_play.removeEventListener( MouseEvent.CLICK, onPlayClick );
				_play = null;
			}
			
			if ( _pause != null ) 
			{
				_pause.removeEventListener( MouseEvent.CLICK, onPlayClick );
				_pause = null;
			}
			
			if ( _rewind != null ) 
			{
				_rewind.removeEventListener( MouseEvent.CLICK, onRewindClick );
				_rewind = null;
			}
			
			_sceneLevel = null;
		}
		
		public function show():void 
		{
			visible = true;
		}
		
		public function hide():void 
		{
			visible = false;
		}
		
		internal function init():void 
		{
			//_play = this.mPlay as Sprite;
			//_pause = this.mPause as Sprite;
			_rewind = this.mRewind as Sprite;
			
			//_play.addEventListener( MouseEvent.CLICK, onPlayClick );
			//_pause.addEventListener( MouseEvent.CLICK, onPauseClick );
			_rewind.addEventListener( MouseEvent.CLICK, onRewindClick );
		}
		
		internal function update( deltaTime:Number ):void 
		{
			if ( _playing ) 
			{
				// increase or decrease current frame
				// check for complete or beginning
			}
		}
		
		internal function setCurrentScene( sceneLevel:SceneLevel ):void 
		{
			_sceneLevel = sceneLevel;
		}
		
		private function onPlayClick( event:MouseEvent ):void 
		{
			_playing = true;
		}
		
		private function onPauseClick( event:MouseEvent ):void 
		{
			_playing = false;
		}
		
		private function onRewindClick( event:MouseEvent ):void 
		{
			_sceneLevel.rewind();
		}
		
	}
	
}