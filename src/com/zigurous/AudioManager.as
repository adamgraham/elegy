package com.zigurous 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import com.greensock.TweenMax;
	
	final public class AudioManager 
	{
		static private var _sounds:Dictionary;
		static private var _loopedSound:SoundChannel;
		static private var _musicChannel:SoundChannel;
		
		static public function init():void 
		{
			if ( !_sounds ) 
			{
				_sounds = new Dictionary();
			}
		}
		
		static public function add( sound:Sound, cue:String ):void 
		{
			_sounds[cue] = sound;
		}
		
		static public function remove( cue:String ):void 
		{
			delete _sounds[cue];
		}
		
		static public function playSound( cue:String, volume:Number = 1.0, loop:Boolean = false ):void 
		{
			var sound:Sound = _sounds[cue] as Sound;
			if ( sound != null ) {
				sound.play( 0.0, 0, (volume != 1.0) ? new SoundTransform( volume ) : null );
			}
		}
		
		static public function playLoopedSound( cue:String, volume:Number = 1.0 ):void 
		{
			var sound:Sound = _sounds[cue] as Sound;
			if ( sound != null ) {
				_loopedSound = sound.play( 0.0, int.MAX_VALUE, (volume != 1.0) ? new SoundTransform( volume ) : null );
			}
		}
		
		static public function stopLoopedSound():void 
		{
			if ( _loopedSound != null ) 
			{
				TweenMax.to( _loopedSound, 1.0, { volume:0.0, onComplete:onFadeOutLoopedSoundComplete( _loopedSound ) } );
				_loopedSound = null;
			}
		}
		
		static private function onFadeOutLoopedSoundComplete( channel:SoundChannel ):Function 
		{
			return function ():void 
			{
				if ( channel != null ) channel.stop();
			}
		}
		
		static public function playMusic( cue:String, volume:Number = 1.0, loop:Boolean = true ):void 
		{
			stopMusic();
			
			var music:Sound = _sounds[cue] as Sound;
			if ( music != null ) 
			{
				_musicChannel = music.play( 0.0, loop ? int.MAX_VALUE : 0, new SoundTransform( 0.0 ) );
				
				TweenMax.to( _musicChannel, 1.0, { "volume":volume } );
			}
		}
		
		static public function stopMusic():void 
		{
			if ( _musicChannel != null ) 
			{
				TweenMax.to( _musicChannel, 1.0, { volume:0.0, onComplete:onFadeOutMusicComplete( _musicChannel ) } );
				_musicChannel = null;
			}
		}
		
		static private function onFadeOutMusicComplete( channel:SoundChannel ):Function 
		{
			return function ():void 
			{
				if ( channel != null ) channel.stop();
			}
		}
		
	}
	
}