package com.zigurous 
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import com.greensock.TweenLite;
	
	final public class SceneLevelAct1 extends SceneLevel 
	{
		private var _rain:Rain;
		private var _car:Sprite;
		private var _clouds:Vector.<Sprite>;
		
		private var _cutscenePreCarMovement:Boolean;
		private var _cutsceneSceneMovement:Boolean;
		
		private var _rainGone:Boolean;
		private var _logGone:Boolean;
		
		static public var showCutscene:Boolean = true;
		static public var resetScene:Boolean = true;
		static public var followupLevel:int = 3;
		
		static private const CAR_SPEED:Number = 725.0;
		static private const STAGE_CENTER:Point = new Point( 640.0, 360.0 );
		static private const CLOUD_SPEED:Number = 10.0;
		
		override internal function update( deltaTime:Number ):void 
		{
			if ( _cutscenePreCarMovement ) 
			{
				_car.x += CAR_SPEED * deltaTime;
				
				if ( _car.x > STAGE_CENTER.x ) 
				{
					_car.x = STAGE_CENTER.x;
					
					_cutscenePreCarMovement = false;
					_cutsceneSceneMovement = true;
					
					gotoAndPlay( 2 );
				}
			} 
			else if ( _cutsceneSceneMovement ) {
				_scene.x -= CAR_SPEED * deltaTime;
			}
			
			if ( !_rainGone ) 
			{
				var delta:Number = CLOUD_SPEED * deltaTime;
				_clouds[0].x += delta;
				_clouds[1].x -= delta;
				_clouds[2].x += delta;
				
				var i:uint = _clouds.length;
				while ( i-- ) 
				{
					var cloud:Sprite = _clouds[i];
					if ( cloud.x > 3200.0 ) cloud.x = -1800.0;
					else if ( cloud.x < -1800.0 ) cloud.x = 3200.0;
				}
			}
			
			if ( _logGone ) 
			{
				if ( _player.x >= _stage.stageWidth - 10.0 ) {
					Main.instance.transitionToLevel( 2 );
				}
			}
		}
		
		override protected function onInit():void 
		{
			_bounds = new Rectangle( -1200.0, 0.0, 2500.0, 720.0 );
			
			_rain = new Rain();
			_rain.init( 200, 50, 5, 1280, 720, "left" );
			_rain.visible = false;
			
			_car = this["mCar"];
			
			_clouds = new <Sprite>[_scene["mCloud1"], _scene["mCloud2"], _scene["mCloud3"]];
			
			addChild( _rain );
		}
		
		override protected function onBegin():void 
		{
			alpha = 1.0;
			gotoAndStop( 1 );
			
			_cutscenePreCarMovement = false;
			_cutsceneSceneMovement = false;
			
			if ( resetScene ) 
			{
				_rain.alpha = 1.0;
				_rain.visible = true;
				
				_clouds[0].alpha = 1.0;
				_clouds[0].visible = true;
				
				_clouds[1].alpha = 1.0;
				_clouds[1].visible = true;
				
				_clouds[2].alpha = 1.0;
				_clouds[2].visible = true;
				
				_scene["mSign"].gotoAndStop( 1 );
				_scene["mLog"].alpha = 1.0;
				_scene["mLog"].visible = true;
				
				_rainGone = false;
				_logGone = false;
				
				resetScene = false;
				
				AudioManager.playMusic( "MusicAct1" );
			}
			
			if ( showCutscene ) 
			{
				_playbackControls.hide();
				_player.visible = false;
				_player.disableWASDMovement();
				_scene["mCar"].visible = false;
				_scene.x = 1800.0;
				_car.visible = true;
				_car.x = -1500.0;
				
				startCutscene();
			} 
			else 
			{
				_playbackControls.show();
				_player.y = 705.0;
				_scene["mCar"].visible = true;
				_scene.x = 0.0;
				_car.visible = false;
				
				if ( _scene["mSign"].currentFrame == 1 ) 
				{
					_scene["mSign"].addEventListener( MouseEvent.CLICK, onInteractSign );
					MouseHighlight.addHighlight( _scene["mSign"] );
				}
				
				if ( !_rainGone ) 
				{
					_clouds[0].addEventListener( MouseEvent.CLICK, onInteractCloud1 );
					_clouds[1].addEventListener( MouseEvent.CLICK, onInteractCloud2 );
					_clouds[2].addEventListener( MouseEvent.CLICK, onInteractCloud3 );
					
					MouseHighlight.addHighlight( _clouds[0] );
					MouseHighlight.addHighlight( _clouds[1] );
					MouseHighlight.addHighlight( _clouds[2] );
				}
				
				if ( !_clouds[0].visible && 
					 !_clouds[0].visible && 
					 !_clouds[0].visible && 
					 _scene["mSign"].currentFrame == 2 ) 
				{
					_scene["mLog"].addEventListener( MouseEvent.CLICK, onInteractLog );
					MouseHighlight.addHighlight( _scene["mLog"] );
				}
			}
			
			if ( !_rainGone ) 
			{
				_rain.visible = true;
				AudioManager.playLoopedSound( "SoundRain" );
			}
			
			ColorUtils.desaturate( _player, 1.0 );
		}
		
		override protected function onEnd():void 
		{
			_rain.visible = false;
			
			_scene["mSign"].removeEventListener( MouseEvent.CLICK, onInteractSign );
			_scene["mLog"].removeEventListener( MouseEvent.CLICK, onInteractLog );
			_clouds[0].removeEventListener( MouseEvent.CLICK, onInteractCloud1 );
			_clouds[1].removeEventListener( MouseEvent.CLICK, onInteractCloud2 );
			_clouds[2].removeEventListener( MouseEvent.CLICK, onInteractCloud3 );
			
			MouseHighlight.removeHighlight( _scene["mSign"] );
			MouseHighlight.removeHighlight( _scene["mLog"] );
			MouseHighlight.removeHighlight( _clouds[0] );
			MouseHighlight.removeHighlight( _clouds[1] );
			MouseHighlight.removeHighlight( _clouds[2] );
			
			AudioManager.stopLoopedSound();
		}
		
		override protected function onRewind():void 
		{
			showCutscene = true;
			resetScene = false;
			followupLevel = 1;
			Main.instance.transitionToLevel( 1 );
		}
		
		private function startCutscene():void 
		{
			addEventListener( "CLOSE_CUTSCENE", onCloseCutscene );
			addEventListener( "CAR_SKID", onCarSkid );
			
			_cutscenePreCarMovement = true;
		}
		
		private function onCarSkid( event:Event ):void 
		{
			removeEventListener( "CAR_SKID", onCloseCutscene );
			AudioManager.playSound( "SoundScreechCrash" );
		}
		
		private function onCloseCutscene( event:Event ):void 
		{
			removeEventListener( "CLOSE_CUTSCENE", onCloseCutscene );
			Main.instance.fadeToBlack( 0.35, onFadeOutComplete );
		}
		
		private function onFadeOutComplete():void 
		{
			TweenLite.delayedCall( 7.0, onTransitionDelayComplete );
		}
		
		private function onTransitionDelayComplete():void 
		{
			Main.instance.transitionToLevel( followupLevel, false );
			
			showCutscene = false;
			followupLevel = 3;
		}
		
		private function onInteractSign( event:MouseEvent ):void 
		{
			_scene["mSign"].gotoAndStop( 2 );
			MouseHighlight.removeHighlight( _scene["mSign"] );
		}
		
		private function onInteractCloud1( event:MouseEvent ):void 
		{
			TweenLite.to( _clouds[0], 2.0, { alpha:0.0, onComplete:onCloud1FadeAway } );
		}
		
		private function onCloud1FadeAway():void 
		{
			_clouds[0].visible = false;
			checkForNoRainyClouds();
		}
		
		private function onInteractCloud2( event:MouseEvent ):void 
		{
			TweenLite.to( _clouds[1], 2.0, { alpha:0.0, onComplete:onCloud2FadeAway } );
		}
		
		private function onCloud2FadeAway():void 
		{
			_clouds[1].visible = false;
			checkForNoRainyClouds();
		}
		
		private function onInteractCloud3( event:MouseEvent ):void 
		{
			TweenLite.to( _clouds[2], 2.0, { alpha:0.0, onComplete:onCloud3FadeAway } );
		}
		
		private function onCloud3FadeAway():void 
		{
			_clouds[2].visible = false;
			checkForNoRainyClouds();
		}
		
		private function onInteractLog( event:MouseEvent ):void 
		{
			TweenLite.to( _scene["mLog"], 2.0, { alpha:0.0, onComplete:onLogGone } );
		}
		
		private function onLogGone():void 
		{
			_logGone = true;
		}
		
		private function checkForNoRainyClouds():void 
		{
			if ( _clouds[0].visible == false && 
				 _clouds[1].visible == false && 
				 _clouds[2].visible == false ) 
			{
				TweenLite.to( _scene["mPuddle"], 3.0, { alpha:0.0 } );
				TweenLite.to( _rain, 3.0, { alpha:0.0, onComplete:onRainGone } );
				
				_rainGone = true;
			}
		}
		
		private function onRainGone():void 
		{
			_scene["mPuddle"].visible = false;
			_rain.visible = false;
			
			AudioManager.stopLoopedSound();
		}
		
	}
	
}