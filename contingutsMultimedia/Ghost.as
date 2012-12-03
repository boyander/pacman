package contingutsMultimedia{

	import flash.geom.Point;
	import contingutsMultimedia.Actor;
	import contingutsMultimedia.Mapa;
	import contingutsMultimedia.Node;


	// Ghost player :-)
	public class Ghost extends Actor {

		// Constants
		public static const GHOSTSPEED:Number = 4;

		// Variables
		private var _inFear:Boolean;
		private var _path:Array;
		private var _pathStep:uint;

		// Constructor
		public function Ghost(ghostName:String,m:Mapa, startPosition:Point){
			map = m;
			super(GHOSTSPEED, new Point(1,0), startPosition);
		}

		// Act ghost
		public function actuate(){
			
			if(_path != null && _pathStep < _path.length){
				var currentStep:Node = _path[_pathStep];
				if(currentStep.getY() - _position.y < 0){
					_moveDirection = UP;
				}else if(currentStep.getY() - _position.y > 0){
					_moveDirection = DOWN;
				}else if(currentStep.getX() - _position.x > 0){
					_moveDirection = RIGHT;
				}else{
					_moveDirection = LEFT;
				}

				//Check direction to avoid "cornering" effect
				_deltaChange.x += _speed * _moveDirection.x;
				_deltaChange.y += _speed * _moveDirection.y;

				if(Math.abs(_deltaChange.x) >= map.getTileSize()) {
					_deltaChange.x = 0;
					moveActor(_moveDirection);
					_pathStep++;
				}
				if(Math.abs(_deltaChange.y) >= map.getTileSize()) {
					_deltaChange.y = 0;
					moveActor(_moveDirection);
					_pathStep++;
				}
				/*switch(_moveDirection){
					case UP:
						_deltaChange.x = 0;
						_deltaChange.y -= GHOSTSPEED;
						// The delta has surpassed the # of pixels for the cell, meaning we can officially change the coordinate
						if(Math.abs(_deltaChange.x) >= map.getTileSize()) {
							_deltaChange.y = 0;
							moveActor(_moveDirection);
							nextStepIdx++;
						}
					break;
					case DOWN:
				}*/
			}

			trace(_moveDirection);
		}

		// Updates ghost path
		public function updatePath(newPath:Array){
			_pathStep = 1;
			_path = newPath;
		}

		// Is current ghost in fear?
		public function isGhostInFear(){
			return _inFear;
		}

		public function setFear(fe:Boolean){
			_inFear = fe;
		}

	}
}