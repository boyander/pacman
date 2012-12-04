package contingutsMultimedia{

	import flash.geom.Point;
	import contingutsMultimedia.Actor;
	import contingutsMultimedia.Mapa;
	import contingutsMultimedia.Node;
	import contingutsMultimedia.AStar;
	import contingutsMultimedia.Constants;


	// Ghost player :-)
	public class Ghost extends Actor {

		// Constants
		public static const GHOSTSPEED:Number = 3;

		// Variables
		private var _inFear:Boolean;
		private var _path:Array;
		private var _pathStep:uint;

		// Path deployment
		public var _star:AStar;
		var path:Array;

		// Constructor
		public function Ghost(ghostName:String,m:Mapa, startPosition:Point){
			map = m;
			_star = new AStar(map, this);
			super(GHOSTSPEED, new Point(1,0), startPosition);
		}

		// Act ghost
		public function actuate(){
			
			if(_path != null && _pathStep < _path.length){
				var currentStep:Node = _path[_pathStep];
				if(currentStep.getY() - _position.y < 0){
					_moveDirection = Constants.UP;
				}else if(currentStep.getY() - _position.y > 0){
					_moveDirection = Constants.DOWN;
				}else if(currentStep.getX() - _position.x > 0){
					_moveDirection = Constants.RIGHT;
				}else{
					_moveDirection = Constants.LEFT;
				}

				//Check direction to avoid "cornering" effect
				_deltaChange.x += _speed * _moveDirection.x;
				_deltaChange.y += _speed * _moveDirection.y;

				if(Math.abs(_deltaChange.x) >= map.getTileSize()) {
					_deltaChange.x = 0;
					_deltaChange.y = 0;
					moveActor(_moveDirection);
					_pathStep++;
				}
				if(Math.abs(_deltaChange.y) >= map.getTileSize()) {
					_deltaChange.x = 0;
					_deltaChange.y = 0;
					moveActor(_moveDirection);
					_pathStep++;
				}
			}
		}

		// Updates ghost path
		public function updatePath(newPath:Array){
			_pathStep = 1;
			_path = newPath;
		}

		public function Update(pacman:Actor){
			//if(this.isInJuncntion()){
				this.deployPath(pacman);
			//}
		}

		public function deployPath(pacman:Actor){
			path = _star.findPath(this.getPosition(), pacman.getPosition());
			this.updatePath(path);
		}

		override public function canMoveThru(p:Point){
			if( map.checkTransversable(p.x, p.y) ){
				return false;
			}/*else if(p.equals()){
				return false;
			}*/
			return true;
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