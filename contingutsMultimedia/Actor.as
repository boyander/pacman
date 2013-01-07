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
		private var _pushedDirection:Point;
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
			_pushedDirection = new Point(moveDir.x,moveDir.y);
			_startPosition = startPosition;
			_position = new Point(startPosition.x,startPosition.y);
			_graphicsImplement = graphicsClip;
			_actorOffset = new Point(_graphicsImplement.width/2,_graphicsImplement.height/2);

			// Start position pixel setup
			var mapTileToPixel:Point = map.tileToPixel(_position.x, _position.y);
			this.x = mapTileToPixel.x + _deltaChange.x - _actorOffset.x;
			this.y = mapTileToPixel.y + _deltaChange.y - _actorOffset.y;

			// Add graphics implement to clip
			this.addChild(_graphicsImplement);
		}

		public function resetActor(){
			_position = new Point(_startPosition.x,_startPosition.y);
			setMoveDirection(new Point(0,0));
			moveActor();
		}

		public function setMoveDirection(p:Point){
			var checkChange:Boolean = true;
			
			// Avoid cornering, check pushed move
			if(_moveDirection.equals(Constants.LEFT) && _deltaChange.x > 0) checkChange = false;
			if(_moveDirection.equals(Constants.RIGHT) && _deltaChange.x < 0) checkChange = false;
			if(_moveDirection.equals(Constants.UP) && _deltaChange.y > 0) checkChange = false;
			if(_moveDirection.equals(Constants.DOWN) && _deltaChange.y < 0) checkChange = false;

			// Change moveDirection an return true if suceeded
			if(checkChange){
				_moveDirection.x = p.x;
				_moveDirection.y = p.y;
				return true;
			}else{
				return false;
			}
		}

		public function getMoveDirection(){
			return _moveDirection;
		}

		public function setGraphicsImplement(graphicsClip){
			this.removeChild(_graphicsImplement);
			_graphicsImplement = graphicsClip;
			this.addChild(_graphicsImplement);
		}

		public function moveActor(){

			// Reset deltas
			_deltaChange.x = -1 * (map.getTileSize()/2) * _moveDirection.x;
			_deltaChange.y = -1 * (map.getTileSize()/2) * _moveDirection.y;

			/* Check if current _position overflows map, this code allows pacman to cross from
			one side of map to another */
			var _sizeM:Point = map.getMapSize();
			var _currX = (_position.x + _moveDirection.x) % (_sizeM.x);
			var _currY = (_position.y + _moveDirection.y) % (_sizeM.y);

			if(  _currX < 0 ){
			       _currX = (_sizeM.x-2) - _currX;
			}
			if( _currY < 0 ){
			       _currY = (_sizeM.x-2) - _currY;
			}

			// Finally change positioning on map tiles
			_position.x = _currX;
			_position.y = _currY;
		}

		public function getPosition(){
			return _position;
		}

		public function actorUpdate(){

			this.getNextMoveDirection();

			var p:Point =  new Point(_position.x + _moveDirection.x, _position.y + _moveDirection.y);

			var checkChange:Boolean = true;

			if(!this.canMoveThru(p)){
				if(_moveDirection.equals(Constants.LEFT) && _deltaChange.x <= 0) checkChange = false;
				if(_moveDirection.equals(Constants.RIGHT) && _deltaChange.x >= 0) checkChange = false;
				if(_moveDirection.equals(Constants.UP) && _deltaChange.y <= 0) checkChange = false;
				if(_moveDirection.equals(Constants.DOWN) && _deltaChange.y >= 0) checkChange = false;
			}
			
			if(checkChange){
				_deltaChange.x += _speed * _moveDirection.x;
				_deltaChange.y += _speed * _moveDirection.y;
			}

			// Update map relative position if delta overflows
			if(Math.abs(_deltaChange.x) >= map.getTileSize()/2 || Math.abs(_deltaChange.y) >= map.getTileSize()/2){
				this.overflowTile();
				moveActor();
			}

			// Change pixel positioning depending on current tile and deltas
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