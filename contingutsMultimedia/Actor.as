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
		public var _mapSize:Point;
		public var _graphicsImplement:MovieClip;
		public var _startPosition:Point;
		public var _name:String;

		public var _actorOffset:Point;

		public function Actor(graphicsClip:MovieClip, speed:Number, moveDir:Point, startPosition:Point){
			
			_deltaChange = new Point(0,0);

			_speed = speed;
			_moveDirection = new Point(0,0); // MarcP, BUG#01-Create new object to not override Constants
			_startPosition = startPosition;
			_position = new Point(startPosition.x,startPosition.y);
			_graphicsImplement = graphicsClip;
			_actorOffset = new Point(_graphicsImplement.width/2,_graphicsImplement.height/2);

			// Start position pixel setup
			var mapTileToPixel:Point = map.tileToPixel(_position.x, _position.y);
			this.setCoordinates(mapTileToPixel.x,mapTileToPixel.y);

			// Add graphics implement to clip
			this.addChild(_graphicsImplement);

			// Cache map size
			_mapSize = map.getMapSize();
		}

		public function resetActor(){
			_position = new Point(_startPosition.x,_startPosition.y);
			setMoveDirection(new Point(0,0));
		}

		public function setMoveDirection(p:Point){

			var checkChange:Boolean = true;
			var current:Point = this.getCoordinates();
			// Avoid cornering, check pushed move
			_deltaChange.x = -1 * ((_position.x * map.getTileSize())-current.x+map.getTileSize()/2);
			_deltaChange.y = -1 * ((_position.y * map.getTileSize())-current.y+map.getTileSize()/2);

			//if(_moveDirection.equals(Constants.DOWN) && dX >= 1) checkChange = false;
			if(_moveDirection.equals(Constants.LEFT) && _deltaChange.x > 0) checkChange = false;
			if(_moveDirection.equals(Constants.RIGHT) && _deltaChange.x < 0) checkChange = false;
			if(_moveDirection.equals(Constants.UP) && _deltaChange.y > 0) checkChange = false;
			if(_moveDirection.equals(Constants.DOWN) && _deltaChange.y < 0) checkChange = false;

			if(!p.equals(_moveDirection) && checkChange){
				this.setCoordinates(_position.x,_position.y);
			}

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

		public function getPosition(){
			return _position;
		}

		public function actorUpdate(){

			this.getNextMoveDirection();
			
			var nextTilePixel:Point =  map.tileToPixel(_position.x + _moveDirection.x, _position.y + _moveDirection.y);
			var p:Point =  new Point(_position.x + _moveDirection.x, _position.y + _moveDirection.y);

			var collisionX = false;
			var collisionY = false;

			var current:Point = this.getCoordinates();
			
			if(_moveDirection.x > 0){
				if(nextTilePixel.x - current.x < map.getTileSize()){
						collisionX = true;
				}
			}else if(_moveDirection.x < 0){
				if(current.x - nextTilePixel.x < map.getTileSize()){
						collisionX = true;
				}
			}

			if(_moveDirection.y > 0){
				if(nextTilePixel.y - current.y < map.getTileSize()){
						collisionY = true;
				}
			}else if (_moveDirection.y < 0){
				if(current.y - nextTilePixel.y < map.getTileSize()){
						collisionY = true;
				}
			}

			// Check overflow and update positioning in X axis
			if(this.canMoveThru(p) && collisionX){
				// Overflowed x direction only, makes pacman passthru corridor
				if(  _position.x < 0 ){
					_position.x = _mapSize.x;
			    	setCoordinates(_position.x,_position.y);
				}else if(_position.x > _mapSize.x-1){
					_position.x = -1;
					setCoordinates(_position.x,_position.y);
				}

				_position.x += _moveDirection.x;
				this.overflowTile();
			}

			// Check overflow and update positioning in Y axis
			if(this.canMoveThru(p) && collisionY){
				_position.y += _moveDirection.y;
				this.overflowTile();
			}
			
			if( _name != "Pacman"){
				this.addCoordinates((_speed * _moveDirection.x), (_speed * _moveDirection.y));
			}else if( (!collisionY || !collisionX)  && this.canMoveThru(p)){
				this.addCoordinates((_speed * _moveDirection.x), (_speed * _moveDirection.y));
			}else{
				this.setCoordinates(_position.x,_position.y);
			}
		}

		private function addCoordinates(xpos:Number,ypos:Number){
			this.x += xpos;
			this.y += ypos;
		}

		private function setCoordinates(_xpos:Number,_ypos:Number){
			var _align:Point = map.tileToPixel(_xpos, _ypos);
			this.x = _align.x - _actorOffset.x + map._mapOffset.x;
			this.y = _align.y - _actorOffset.y + map._mapOffset.y;
		}

		private function getCoordinates(){
			return new Point(this.x + _actorOffset.x + map._mapOffset.x,
							 this.y + _actorOffset.y - map._mapOffset.y);
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