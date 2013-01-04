/*
Project: Pacman
Authors: Marc Pomar & Laura Cotrina.
Description:
	Generic class for moving object
*/

package contingutsMultimedia {

	import flash.geom.Point;
	import contingutsMultimedia.Mapa;
	import flash.display.MovieClip;
	import contingutsMultimedia.Constants;

	public class Actor extends MovieClip{

		public var _speed:Number;
		private var _moveDirection:Point;
		public var _deltaChange:Point;
		public var _position:Point;
		public var map:Mapa;
		public var _graphicsImplement:MovieClip;
		public var _startPosition:Point;

		public var _actorOffset:Point;

		public function Actor(graphicsClip:MovieClip, speed:Number, moveDir:Point, startPosition:Point){
			_deltaChange = new Point(0,0);
			_speed = speed;
			_moveDirection = new Point(moveDir.x,moveDir.y); // MarcP, BUG#01-Create new object to not override Constants
			_startPosition = startPosition;
			_position = new Point(startPosition.x,startPosition.y);
			_graphicsImplement = graphicsClip;
			_actorOffset = new Point(_graphicsImplement.width/2,_graphicsImplement.height/2);
			this.addChild(_graphicsImplement);
		}

		public function resetActor(){
			_position = new Point(_startPosition.x,_startPosition.y);
			setMoveDirection(new Point(0,0));
			moveActor();
		}

		public function setMoveDirection(p:Point){
			_moveDirection.x = p.x;
			_moveDirection.y = p.y;
		}

		public function setGraphicsImplement(graphicsClip){
			this.removeChild(_graphicsImplement);
			_graphicsImplement = graphicsClip;
			this.addChild(_graphicsImplement);
		}

		public function moveActor(){

			// Reset deltas
			_deltaChange.x = 0;
			_deltaChange.y = 0;

			var _sizeM:Point = map.getMapSize();
			var _currX = (_position.x + _moveDirection.x) % (_sizeM.x);
			var _currY = (_position.y + _moveDirection.y) % (_sizeM.y);

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

		public function actorUpdate(){

			this.getNextMoveDirection();

			var p:Point =  new Point(_position.x + _moveDirection.x, _position.y + _moveDirection.y);

			// Check if we can passthru
			if(this.canMoveThru(p)){

				if(_moveDirection.x != 0){
					_deltaChange.x += _speed * _moveDirection.x;
					_moveDirection.y = 0;
				}
				if(_moveDirection.y != 0){
					_deltaChange.y += _speed * _moveDirection.y;
					_moveDirection.x = 0;
				}

				// Update map relative position if delta overflows
				if(Math.abs(_deltaChange.x) >= map.getTileSize() || Math.abs(_deltaChange.y) >= map.getTileSize()){
					this.overflowTile();
					moveActor();
				}
			}

			var mapTileToPixel:Point = map.tileToPixel(_position.x, _position.y);
			this.x = mapTileToPixel.x + _deltaChange.x - _actorOffset.x;
			this.y = mapTileToPixel.y + _deltaChange.y - _actorOffset.y;
		}

		public function setSpeed(s:Number){
			_speed = s;
		}

		public function overflowTile(){
			return true;
		}

		public function canMoveThru(p:Point){
			return true;
		}

		public function getNextMoveDirection(){
			return _moveDirection;
		}
	}
}