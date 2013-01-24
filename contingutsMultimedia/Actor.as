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
	import flash.display.Sprite;
	import contingutsMultimedia.Constants;

	public class Actor extends Sprite{

		public var _speed:Number;
		private var _moveDirection:Point;
		public var _position:Point;
		public var map:Mapa;
		public var _mapSize:Point;
		public var _graphicsImplement:MovieClip;
		public var _startPosition:Point;
		public var _name:String;
		public var _ray:Point;
		public var _actorOffset:Point;

		public var _pixelCoordinates:Point;

		public function Actor(graphicsClip:MovieClip, m:Mapa, speed:Number, startPosition:Point, name:String){
			
			_speed = speed;
			_name = name;
			map = m;
			_pixelCoordinates = new Point(0,0);
			_moveDirection = new Point(0,0); // MarcP, BUG#01-Create new object to not override Constants
			_startPosition = startPosition;
			_position = new Point(startPosition.x,startPosition.y);
			_graphicsImplement = graphicsClip;
			_actorOffset = new Point(_graphicsImplement.width/2,_graphicsImplement.height/2);

			_ray = new Point(0,0);
			// Start position pixel setup
			this.setCoordinatesTiled(_position.x,_position.y);

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


			//var checkChange:Boolean = true;
			var nextTilePixel:Point =  map.tileToPixel(_position.x, _position.y);
			var current:Point = this.getCoordinates();
			var _deltaChange:Point = new Point(nextTilePixel.x - current.x,nextTilePixel.y - current.y);

			var checkChange:Boolean = true;

			var pushedTile:Point = new Point(_position.x + p.x, _position.y + p.y);
			if(!canMoveThru(pushedTile)) checkChange = false;

			if (p.x != _moveDirection.x || p.y != _moveDirection.y){
				if(_moveDirection.equals(Constants.LEFT) && _deltaChange.x < 0) checkChange = false;
				if(_moveDirection.equals(Constants.RIGHT) && _deltaChange.x > 0) checkChange = false;
				if(_moveDirection.equals(Constants.UP) && _deltaChange.y < 0) checkChange = false;
				if(_moveDirection.equals(Constants.DOWN) && _deltaChange.y > 0) checkChange = false;
			}
			
			// Change moveDirection an return true if suceeded
			if(checkChange){
				_moveDirection.x = p.x;
				_moveDirection.y = p.y;
				return true;
			}else{
				//trace("CANNOT to " + p + " moveDirection -> " + _moveDirection);
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
			
			var current:Point = this.getCoordinates();

			var currentS:Point = new Point(	current.x + (map.getTileSize()/2 * _moveDirection.x),
											current.y + (map.getTileSize()/2 * _moveDirection.y));
			var nextPos:Point = new Point(	currentS.x + (_speed * _moveDirection.x),
											currentS.y + (_speed * _moveDirection.y));

			var a:Point = map.pixelToTile(currentS.x,currentS.y);

			// Ray cast
			if(!this.castRay( currentS, nextPos, map.getTileSize()) && canMoveThru(a)){
				this.setCoordinates( current.x + (_speed * _moveDirection.x),
									 current.y + (_speed * _moveDirection.y));
				current = this.getCoordinates();

				var nextPosition:Point = map.pixelToTile(current.x,current.y);
				var lastPos:Point = _position;

				if(!nextPosition.equals(_position)){
					_position = nextPosition;
					this.overflowTile(lastPos);
				}
			}else{
				// Collision with wall
				this.setCoordinatesTiled( _position.x,_position.y);
			}

			// if overflows
			var s:Point = map.getMapSize();
			if( current.x > (s.x * map.getTileSize()) + 2 ){
				this.setCoordinates( -map.getTileSize() + (_speed * _moveDirection.x),
									 current.y + (_speed * _moveDirection.y));
			}else if( current.x < - map.getTileSize() ){
				this.setCoordinates( s.x * map.getTileSize() + (_speed * _moveDirection.x)+1,
									 current.y + (_speed * _moveDirection.y));
			}
		}


		//Ray casting technique described in paper:
		//A Fast Voxel Traversal Algorithm for Ray Tracing - John Amanatides, Andrew Woo
		//http://www.cse.yorku.ca/~amana/research/grid.pdf
		
		public function castRay( p1Original:Point, p2Original:Point, tileSize:int = 20):Boolean
		{
			//INITIALISE//////////////////////////////////////////
 
			// normalise the points
			var p1:Point = new Point( p1Original.x / tileSize, p1Original.y / tileSize);
			var p2:Point = new Point( p2Original.x / tileSize, p2Original.y / tileSize);
		
			if ( int( p1.x ) == int( p2.x ) && int( p1.y ) == int( p2.y ) ) {
				//since it doesn't cross any boundaries, there can't be a collision
				_ray = p2Original;
				return false;
			}
			
			//find out which direction to step, on each axis
			var stepX:int = ( p2.x > p1.x ) ? 1 : -1;  
			var stepY:int = ( p2.y > p1.y ) ? 1 : -1;
 
			var rayDirection:Point = new Point( p2.x - p1.x, p2.y - p1.y );
 
			//find out how far to move on each axis for every whole integer step on the other
			var ratioX:Number = rayDirection.x / rayDirection.y;
			var ratioY:Number = rayDirection.y / rayDirection.x;
 
			var deltaY:Number = p2.x - p1.x;
			var deltaX:Number = p2.y - p1.y;
			//faster than Math.abs()...
			deltaX = deltaX < 0 ? -deltaX : deltaX;
			deltaY = deltaY < 0 ? -deltaY : deltaY;
 
			//initialise the integer test coordinates with the coordinates of the starting tile, in tile space ( integer )
			//Note: using noralised version of p1
			var testX:int = int(p1.x); 
			var testY:int = int(p1.y);
 
			//initialise the non-integer step, by advancing to the next tile boundary / ( whole integer of opposing axis )
			//if moving in positive direction, move to end of curent tile, otherwise the beginning
			var maxX:Number = deltaX * ( ( stepX > 0 ) ? ( 1.0 - (p1.x % 1) ) : (p1.x % 1) ); 
			var maxY:Number = deltaY * ( ( stepY > 0 ) ? ( 1.0 - (p1.y % 1) ) : (p1.y % 1) );
	
			var endTileX:int = int(p2.x);
			var endTileY:int = int(p2.y);
			
			//TRAVERSE//////////////////////////////////////////
	
			var hit:Boolean;
			var collisionPoint:Point = new Point();
			while( testX != endTileX || testY != endTileY ) {

				if (  maxX < maxY ) {
				
					maxX += deltaX;
					testX += stepX;
					if ( map.checkTransversable( testX, testY )) {
						collisionPoint.x = testX;
						if ( stepX < 0 ) collisionPoint.x += 1.0; //add one if going left
						collisionPoint.y = p1.y + ratioY * ( collisionPoint.x - p1.x);	
						collisionPoint.x *= tileSize;//scale up
						collisionPoint.y *= tileSize;
						_ray = collisionPoint;
						return true;
					}
				
				} else {
					
					maxY += deltaY;
					testY += stepY;
	
					if ( map.checkTransversable( testX, testY )) {
						collisionPoint.y = testY;
						if ( stepY < 0 ) collisionPoint.y += 1.0; //add one if going up
						collisionPoint.x = p1.x + ratioX * ( collisionPoint.y - p1.y);
						collisionPoint.x *= tileSize;//scale up
						collisionPoint.y *= tileSize;
						_ray = collisionPoint;
						return true;
					}
				}
		
			}
			//no intersection found, just return end point:
			_ray = p2Original;
			return false;
		}

		private function setCoordinatesTiled(xpos:Number, ypos:Number){
			var p:Point = map.tileToPixel(xpos, ypos);
			_pixelCoordinates.x = p.x;
			_pixelCoordinates.y = p.y;
			this.x = p.x - _actorOffset.x;
			this.y = p.y - _actorOffset.y;
			return new Point(this.x,this.y);
		}

		private function setCoordinates(xpos:Number, ypos:Number){
			_pixelCoordinates.x = xpos;
			_pixelCoordinates.y = ypos;
			this.x = xpos - _actorOffset.x;
			this.y = ypos - _actorOffset.y;
			return _pixelCoordinates;
		}

		public function getCoordinates(){
			return new Point(_pixelCoordinates.x, _pixelCoordinates.y);
		}


		public function setSpeed(s:Number){
			_speed = s;
		}

		public function overflowTile(lastPos:Point){
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