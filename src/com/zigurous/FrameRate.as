package com.zigurous 
{
	/////////////
	// IMPORTS //
	/////////////
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	final public class FrameRate 
	{
		///////////////
		// VARIABLES //
		///////////////
		
		/** The time in milliseconds at initialization. */
		static private var _initTime:Number;
		/** The time in milliseconds at the current frame. */
		static private var _currTime:Number;
		/** The time in milliseconds at the previous frame. */
		static private var _prevTime:Number;
		/** The time elapsed in milliseconds since the last framerate refresh. */
		static private var _intrTime:Number;
		
		/** The current frames per second since the last framerate refresh. */
		static private var _fps:Number;
		
		/** The number of frames processed since the last refresh. */
		static private var _frameCount:int;
		/** The number of frames processed since initialization. */
		static private var _totalCount:int;
		/** The number of frames that have to be processed before the framerate refreshes. */
		static private var _refreshCount:int;
		
		/** The reference to the stage of the SWF being monitored. */
		static private var _swf:Stage;
		
		/** The time in milliseconds it takes to refresh the framerate. */
		static public const REFRESH_RATE:Number = 1000.0;
		
		///////////////////////
		// GETTERS / SETTERS //
		///////////////////////
		
		/** The time elapsed in seconds since the previous frame. */
		static public function get deltaTime():Number { return (_currTime - _prevTime) * 0.001; }
		/** The time elapsed in seconds since initialization. */
		static public function get runningTime():Number { return (_currTime - _initTime) * 0.001; }
		
		/** The current frames per second. */
		static public function get fps():Number { return _fps; }
		/** The average frames per second since initializtion. */
		static public function get fpsAverage():Number { return _totalCount / runningTime; }
		
		/** The target frames per second of the SWF. 
		 * The actual SWF may be running slower than this depending on computer performance. 
		 * This is just the frames per second the SWF is continuously trying to reach. */
		static public function get frameRate():Number { return _swf.frameRate; }
		
		////////////////////
		// PUBLIC METHODS //
		////////////////////
		
		static public function start( stage:Stage ):void 
		{
			if ( !_swf ) 
			{
				_swf = stage;
				_swf.addEventListener( Event.ENTER_FRAME, update, false, 999 );
			}
			
			restartResults();
		}
		
		/*
		static public function stop():void 
		{
			if ( _swf ) 
			{
				_swf.removeEventListener( Event.ENTER_FRAME, update );
				_swf = null;
			}
		}
		*/
		
		static public function restartResults():void 
		{
			_initTime = getTimer();
			_intrTime = _initTime;
			_currTime = _intrTime;
			_prevTime = _currTime;
			
			_fps = 0.0;
			
			_frameCount = 0;
			_totalCount = 0;
			_refreshCount = int(REFRESH_RATE / (1000.0 / _swf.frameRate));
		}
		
		/////////////////////
		// PRIVATE METHODS //
		/////////////////////
		
		static private function update( event:Event ):void 
		{
			_frameCount++;
			_totalCount++;
			
			_prevTime = _currTime;
			_currTime = getTimer();
			
			if ( _frameCount >= _refreshCount ) 
			{
				_fps = (_frameCount / (_currTime - _intrTime)) * 1000.0;
				_intrTime = _currTime;
				_frameCount = 0;
			}
		}
		
	}
	
}