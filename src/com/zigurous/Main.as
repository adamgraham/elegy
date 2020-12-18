package com.zigurous 
{
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.media.Sound;
	import com.greensock.TweenLite;
	
	public class Main extends MovieClip 
	{
		static private var _instance:Main;
		
		private var _levels:Vector.<SceneLevel>;
		private var _screenFade:Shape;
		
		private var _mainMenu:MainMenu;
		private var _creditsMenu:CreditsMenu;
		
		private var _player:Player;
		private var _currentLevel:SceneLevel;
		
		private var _playbackControls:PlaybackControls;
		private var _hud:HUD;
		
		private var _transitionLevelIndex:int;
		private var _transitionFade:Boolean;
		private var _transitionDuration:Number;
		
		static public function get instance():Main { return _instance; }
		public function get stageRef():Stage { return stage; }
		public function get mainMenu():MainMenu { return _mainMenu; }
		public function get creditsMenu():CreditsMenu { return _creditsMenu; }
		public function get player():Player { return _player; }
		public function get currentLevel():SceneLevel { return _currentLevel; }
		public function get playbackControls():PlaybackControls { return _playbackControls; }
		public function get hud():HUD { return _hud; }
		
		public function Main() 
		{
			if ( !_instance ) 
			{
				_instance = this;
				
				stop();
				
				if ( stage != null ) init( null );
				else addEventListener( Event.ADDED_TO_STAGE, init );
			}
		}
		
		public function transitionToLevel( levelIndex:int, fade:Boolean = true, duration:Number = 1.0 ):void 
		{
			if ( _currentLevel != null ) 
			{
				_transitionLevelIndex = levelIndex;
				_transitionFade = fade;
				_transitionDuration = duration;
				
				endLevel();
			}
		}
		
		public function fadeToBlack( duration:Number, callback:Function = null ):void 
		{
			_screenFade.visible = true;
			_screenFade.alpha = 0.0;
			_screenFade.parent.setChildIndex( _screenFade, _screenFade.parent.numChildren - 1 );
			
			TweenLite.to( _screenFade, duration, { alpha:1.0, onComplete:callback } );
		}
		
		public function fadeFromBlack( duration:Number, callback:Function = null ):void 
		{
			_screenFade.visible = true;
			_screenFade.alpha = 1.0;
			_screenFade.parent.setChildIndex( _screenFade, _screenFade.parent.numChildren - 1 );
			
			TweenLite.to( _screenFade, duration, { alpha:0.0, onComplete:callback } );
		}
		
		internal function startGame():void 
		{
			startLevel( 1 );
		}
		
		internal function endGame():void 
		{
			endLevel();
			
			_creditsMenu.visible = true;
			_creditsMenu.show();
			
			fadeFromBlack( 1.0 );
		}
		
		private function init( event:Event ):void 
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
			gotoAndStop( 2 );
			
			stage.scaleMode = StageScaleMode.NO_BORDER;
			
			FrameRate.start( stage );
			AudioManager.init();
			addSounds();
			
			_screenFade = new Shape();
			_screenFade.graphics.beginFill( 0, 1.0 );
			_screenFade.graphics.drawRect( 0.0, 0.0, stage.stageWidth, stage.stageHeight );
			_screenFade.graphics.endFill();
			_screenFade.visible = false;
			_screenFade.alpha = 0.0;
			
			stage.addChild( _screenFade );
			
			_mainMenu = new MainMenu();
			_mainMenu.show();
			
			_creditsMenu = new CreditsMenu();
			_creditsMenu.visible = false;
			
			_levels = new <SceneLevel>[new SceneLevelAct1(), new SceneLevelAct2(), new SceneLevelAct3()];
			_player = new Player();
			
			_playbackControls = new PlaybackControls();
			_playbackControls.scaleX = _playbackControls.scaleY = 0.5;
			
			_hud = new HUD();
			
			_player.init( stage );
			_playbackControls.init();
		}
		
		private function update( event:Event ):void 
		{
			var deltaTime:Number = FrameRate.deltaTime;
			
			_player.update( deltaTime );
			_currentLevel.update( deltaTime );
			_playbackControls.update( deltaTime );
		}
		
		private function startLevel( levelIndex:int ):void 
		{
			_currentLevel = _levels[levelIndex - 1];
			_playbackControls.setCurrentScene( _currentLevel );
			_player.setCurrentScene( _currentLevel );
			_currentLevel.init( stage );
			_currentLevel.begin();
			_transitionLevelIndex = -1;
			
			addChild( _currentLevel );
			addChild( _playbackControls );
			addChild( _hud );
			
			removeEventListener( Event.ENTER_FRAME, update );
			addEventListener( Event.ENTER_FRAME, update );
			
			_currentLevel.visible = true;
			
			fadeFromBlack( 1.0, onStartLevelComplete );
		}
		
		private function onStartLevelComplete():void 
		{
			_screenFade.visible = false;
			//_player.enableWASDMovement();
		}
		
		private function endLevel():void 
		{
			if ( _currentLevel != null ) 
			{
				_currentLevel.end();
				
				removeChild( _playbackControls );
				removeEventListener( Event.ENTER_FRAME, update );
				
				if ( _transitionFade ) fadeToBlack( _transitionDuration, onEndLevelComplete );
				else TweenLite.delayedCall( _transitionDuration, onEndLevelComplete );
			}
		}
		
		private function onEndLevelComplete():void 
		{
			removeChild( _currentLevel );
			_currentLevel = null;
			
			if ( _transitionLevelIndex != -1 ) {
				startLevel( _transitionLevelIndex );
			}
		}
		
		private function addSounds():void 
		{
			// Global
			AudioManager.add( new SoundPoof as Sound, "SoundPoof" );
			AudioManager.add( new SoundRewind as Sound, "SoundRewind" );
			
			// Act1
			AudioManager.add( new MusicAct1 as Sound, "MusicAct1" );
			AudioManager.add( new SoundRain as Sound, "SoundRain" );
			AudioManager.add( new SoundScreechCrash as Sound, "SoundScreechCrash" );
			
			// Act 2
			AudioManager.add( new MusicAct2 as Sound, "MusicAct2" );
			AudioManager.add( new SoundHeartMonitor as Sound, "SoundHeartMonitor" );
			AudioManager.add( new SoundFlatline as Sound, "SoundFlatline" );
			AudioManager.add( new SoundBandages as Sound, "SoundBandages" );
			AudioManager.add( new SoundBear as Sound, "SoundBear" );
			AudioManager.add( new SoundIcicle as Sound, "SoundIcicle" );
			AudioManager.add( new SoundSuperhero as Sound, "SoundSuperhero" );
			
			// Act 3
			AudioManager.add( new MusicAct3 as Sound, "MusicAct3" );
		}
		
	}
	
}