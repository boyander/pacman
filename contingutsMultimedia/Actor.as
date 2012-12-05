package contingutsMultimedia {	// Generic class for moving object

	import flash.geom.Point;
	import contingutsMultimedia.Mapa;
	import flash.display.MovieClip;
	import contingutsMultimedia.Constants;


	public class Actor{

		public var _speed:Number;
		public var _moveDirection:Point;
		public var _deltaChange:Point;
		public var _position:Point;
		public var map:Mapa;

		public function Actor(speed:Number, moveDir:Point, position:Point){
			_deltaChange = new Point(0,0);
			_speed = speed;
			_moveDirection = moveDir;
			_position = position;
		}

		public function setMoveDirection(x:Number, y:Number){
			_moveDirection.x = x;
			_moveDirection.y = y;
		}

		public function moveActor(go:Point){
			_position.x += go.x;
			_position.y += go.y;
		}

		public function getPosition(){
			return _position;
		}

		// Get pixel position
		public function getPixelPosition(){
			var pixelPosition:Point = map.getTileAtPixel(_position.x, _position.y);
			return new Point(pixelPosition.x + _deltaChange.x ,pixelPosition.y + _deltaChange.y);
		}

		public function canMoveThru(p:Point){
			return true;
		}
	}
}