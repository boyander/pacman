package contingutsMultimedia {

	import flash.geom.Point;
	import contingutsMultimedia.Actor;
	import contingutsMultimedia.Mapa;

	// Pacman player :-)
	public class Pacman extends Actor {

		// Constants
		public static const STARTSPEED:Number = 4;

		// Hold map copy to check against colision with walls
		private var map:Mapa;

		// Real direction where pacman moves
		private var _realDirection:Point;


		// Constructor
		public function Pacman(m:Mapa, startPosition:Point){
			_realDirection = new Point(1,0);
			map = m;
			super(STARTSPEED, new Point(1,0), startPosition);

		}

		// Act player
		public function actuate(){
			
			// Check next tile based on next position
			var nextTile = map.getTileAtPoint(_position.x + _moveDirection.x, _position.y + _moveDirection.y);
			var nextTileR = map.getTileAtPoint(_position.x + _realDirection.x, _position.y + _realDirection.y);
			// Avoid movement change to hit a wall, this disables pacman to stop in the middle of a corridor
			if((_realDirection.x != _moveDirection.x) || (_realDirection.y != _moveDirection.y)){
				if(nextTile != 'W'){
					nextTileR = nextTile;
					_realDirection.x = _moveDirection.x;
					_realDirection.y = _moveDirection.y;
				}
			}
			
			// If tile is not a wall, stand still
			if( nextTileR != 'W'){
				
				//Check direction to avoid "cornering" effect
				if(_realDirection.y == 0){
					_deltaChange.x += _speed * _realDirection.x;
					_deltaChange.y = 0;
				}
				if(_realDirection.x == 0){
					_deltaChange.y += _speed * _realDirection.y;
					_deltaChange.x = 0;
				}
				
				// Check if delta causes a tileChange and update pacman position on map
				if(Math.abs(_deltaChange.x) >= map.getTileSize()){
					_deltaChange.x = 0;
					_deltaChange.y = 0;
					_position.x += _realDirection.x;
				}
				if(Math.abs(_deltaChange.y) >= map.getTileSize()){
					_deltaChange.x = 0;
					_deltaChange.y = 0;
					_position.y += _realDirection.y;
				}
			}
		}

		// Get pacman pixel position
		public function getPixelPosition(){
			var pixelPosition:Point = map.getTileAtPixel(_position.x, _position.y);
			return new Point(pixelPosition.x + _deltaChange.x ,pixelPosition.y + _deltaChange.y);
		}
	}
}