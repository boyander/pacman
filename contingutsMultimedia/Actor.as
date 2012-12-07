package contingutsMultimedia {	// Generic class for moving object

	import flash.geom.Point;
	import contingutsMultimedia.Mapa;
	import flash.display.MovieClip;
	import contingutsMultimedia.Constants;

	public class Actor extends MovieClip{

		public var _speed:Number;
		public var _moveDirection:Point;
		public var _deltaChange:Point;
		public var _position:Point;
		public var map:Mapa;
		public var _graphicsImplement:MovieClip;

		public function Actor(graphicsClip:MovieClip, speed:Number, moveDir:Point, position:Point){
			_deltaChange = new Point(0,0);
			_speed = speed;
			_moveDirection = moveDir;
			_position = position;
			_graphicsImplement = graphicsClip;
			this.addChild(graphicsClip);
		}

		public function setMoveDirection(p:Point){
			_moveDirection.x = p.x;
			_moveDirection.y = p.y;
		}

		public function moveActor(go:Point){
			var _sizeM:Point = map.getMapSize();
			var _currX = (_position.x + go.x) % (_sizeM.x-1);
			var _currY = (_position.y + go.y) % (_sizeM.y-1);

			if(  _currX < 0 ){
				_currX = (_sizeM.x-2) - _currX;
			}
			if( _currY < 0 ){
				_currY = (_sizeM.x-2) - _currY;
			}

			_position.x = _currX;
			_position.y = _currY;
		}

		public function getPosition(){
			return _position;
		}

		public function updateRealMapPosition(){
			var pixelPosition:Point = map.getPixelAtPosition(_position.x, _position.y);
			var pos:Point = new Point(pixelPosition.x + _deltaChange.x ,pixelPosition.y + _deltaChange.y);
			this.x = pos.x;
			this.y = pos.y;
		}

		public function setSpeed(s:Number){
			_speed = s;
		}

		public function canMoveThru(p:Point){
			return true;
		}
	}
}