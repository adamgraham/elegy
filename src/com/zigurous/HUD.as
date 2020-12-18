package com.zigurous 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	final public class HUD extends Sprite 
	{
		private var _itemIcons:Vector.<MovieClip>;
		private var _itemClickCallback:Function;
		private var _itemClickedID:int;
		private var _itemCount:int;
		
		static public const ITEM_ICECREAM:int = 2;
		static public const ITEM_BANDAGES:int = 3;
		static public const ITEM_FLOWERS:int = 4;
		static public const ITEM_SHIRT:int = 5;
		
		public function HUD() 
		{
			_itemIcons = new <MovieClip>[this["mItem1"], this["mItem2"], this["mItem3"], this["mItem4"]];
			hideItems();
		}
		
		public function showItems():void 
		{
			var i:uint = _itemIcons.length;
			while ( i-- ) _itemIcons[i].visible = true;
		}
		
		public function hideItems():void 
		{
			var i:uint = _itemIcons.length;
			while ( i-- ) _itemIcons[i].visible = false;
		}
		
		public function addItem( itemID:int ):void 
		{
			_itemIcons[_itemCount].gotoAndStop( itemID );
			_itemIcons[_itemCount].visible = true;
			
			_itemCount++;
			showItems();
		}
		
		public function removeItem( itemID:int ):void 
		{
			if ( itemID > 1 ) 
			{
				var i:uint = _itemIcons.length;
				while ( i-- ) 
				{
					if ( _itemIcons[i].currentFrame == itemID ) 
					{
						_itemIcons[i].gotoAndStop( 1 );
						_itemIcons[i].visible = false;
					}
				}
				
				_itemCount--
				if ( _itemCount == 0 ) hideItems();
			}
		}
		
		public function removeItemBySlot( itemSlot:int ):void 
		{
			if ( itemSlot >= 0 && itemSlot < _itemIcons.length ) {
				removeItem( getItemIDBySlot( itemSlot ) );
			}
		}
		
		public function getItemIDBySlot( itemSlot:int ):int 
		{
			return _itemIcons[itemSlot].currentFrame;
		}
		
		public function addItemClickCallback( callback:Function ):void 
		{
			removeItemClickCallback();
			
			var i:uint = _itemIcons.length;
			while ( i-- ) _itemIcons[i].addEventListener( MouseEvent.CLICK, onItemClick );
			
			_itemClickCallback = callback;
		}
		
		public function removeItemClickCallback():void 
		{
			var i:uint = _itemIcons.length;
			while ( i-- ) _itemIcons[i].removeEventListener( MouseEvent.CLICK, onItemClick );
			
			_itemClickCallback = null;
		}
		
		public function hasItem():Boolean 
		{
			return _itemCount > 0;
		}
		
		private function onItemClick( event:MouseEvent ):void 
		{
			_itemClickedID = 0;
			
			var i:uint = _itemIcons.length;
			while ( i-- ) 
			{
				if ( event.currentTarget == _itemIcons[i] ) 
				{
					_itemClickedID = event.currentTarget.currentFrame;
					break;
				}
			}
			
			if ( _itemClickCallback != null ) {
				_itemClickCallback();
			}
		}
		
		public function get itemCount():int { return _itemCount; }
		public function get itemClickedID():int { return _itemClickedID; }
		
	}
	
}