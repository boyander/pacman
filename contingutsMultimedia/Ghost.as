package contingutsMultimedia{

	import flash.geom.Point;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import contingutsMultimedia.Actor;
	import contingutsMultimedia.Mapa;
	import contingutsMultimedia.Node;
	import contingutsMultimedia.AStar;
	import contingutsMultimedia.Constants;

	import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.Event;


	// Ghost player :-)
	public class Ghost extends Actor {

		// Constants
		public static const GHOSTSPEED:Number = 2;

		// Variables
		private var _status:String;
		private var _inFear:Boolean;
		private var _lastPosition:Point;
		private var _ghostName:String;

		// Path deployment
		public var _star:AStar;
		private var _path:Array;
		private var _pathStep:uint;

		// Timers
		private var _timer:Timer;
		private var _fearTimer:Timer;

		// Pacman clip
		private var _pacman:Actor;

		private var _pathcheck:MovieClip; 

		// Constructor
		public function Ghost(ghostName:String, ghostGraphicsClip:String, pacman:Actor,m:Mapa, pathcheck:MovieClip){
			map = m;
			_star = new AStar(map, this);
			var startPosition:Point = m.getGhostPosition();
			_lastPosition = new Point(startPosition.x, startPosition.y);
			_pacman = pacman;
			_ghostName = ghostName;
			_pathcheck = pathcheck;
			_inFear = false;

			// Set initial status
			_status = Constants.NORMAL;
			// Random timing mode
			switch(_ghostName){
				case Constants.BLINKY:
					_status = Constants.FIGHT;
				break;
				case Constants.INKY:
					_status = Constants.FIGHT;

				break;
				case Constants.PINKY:
					_status = Constants.NORMAL;
				break;
				case Constants.CLYDE:
					_status = Constants.NORMAL;
				break;
				default:
					_status = Constants.NORMAL;
				break;
			}

			// Start timer for ghosts
			this.updateTimers(null);

			var definedImplementation:Class = getDefinitionByName(ghostGraphicsClip) as Class;
      		var ghostClip:MovieClip = new definedImplementation();
			super(ghostClip, GHOSTSPEED, Constants.RIGHT, startPosition);
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
					_lastPosition = new Point(_position.x, _position.y);
					moveActor(_moveDirection);
					_pathStep++;
				}
				if(Math.abs(_deltaChange.y) >= map.getTileSize()) {
					_deltaChange.x = 0;
					_deltaChange.y = 0;
					_lastPosition = new Point(_position.x, _position.y);
					moveActor(_moveDirection);
					_pathStep++;
				}
			}
			this.updateRealMapPosition();
			this.updatePath();
		}

		// Updates ghost path
		public function updatePath(){

			if(_inFear){
				if(needNewPath()){
					_pathStep = 1;
					_path = _star.findPath(this.getPosition(), map.getRandomPoint());
				}
				return;
			}

			if(_status == Constants.NORMAL && needNewPath()){
				_pathStep = 1;
				_path = _star.findPath(this.getPosition(), map.getRandomPoint());
			} else if (_status == Constants.FIGHT){
				_pathStep = 1;
				_path = _star.findPath(this.getPosition(), _pacman.getPosition());
			}

			// Print path on screen
			/*if(_path){
				// Clear graphics object
				while (_pathcheck.numChildren > 0) {			
					_pathcheck.removeChildAt(0);
				}
				for(var i:uint; i < _path.length; i++){
					var cl:MovieClip = new pathChecker();
					var pp:Point = map.getPixelAtPosition(_path[i].getX(),_path[i].getY());
					cl.x = pp.x;
					cl.y = pp.y;
					_pathcheck.addChild(cl);
				}
			}*/
		}

		public function updateTimers(e:Event){

			if (_timer == null){
				_timer = new Timer(1000);
				_timer.addEventListener("timer", updateTimers);
			}

			if(_status == Constants.FIGHT){
				_status = Constants.NORMAL;

				// Random timing mode depending on ghost
				switch(_ghostName){
					case Constants.BLINKY:
						_timer.delay = 3000;
					break;
					case Constants.INKY:
						_timer.delay = 7000;

					break;
					case Constants.PINKY:
						_timer.delay = 10000;
					break;
					case Constants.CLYDE:
						_timer.delay = 12000;
					break;
					default:
						_timer.delay = 4000;
					break;
				}

				_path = null;
				trace("Goes Random ["+_ghostName+"]");
			}else if(_status == Constants.NORMAL){
				_status = Constants.FIGHT;
				
				// Normal timing mode depending on ghost
				switch(_ghostName){
					case Constants.BLINKY:
						_timer.delay = 20000;
					break;
					case Constants.INKY:
						_timer.delay = 10000;

					break;
					case Constants.PINKY:
						_timer.delay = 8000;
					break;
					case Constants.CLYDE:
						_timer.delay = 2000;
					break;
					default:
						_timer.delay = 4000;
					break;
				}
				trace("Goes Fight ["+_ghostName+"]");
			}

			_timer.reset();
			_timer.start();
		}

		// Checks if we need to update path
		public function needNewPath(){
			if(_path == null){
				return true;
			}
			if(_pathStep == _path.length - 1){
				return true;
			}
			return false;
		}

		// Checks if ghost is eated by pacman
		public function imEatedByPacman(){
			if(this._position.equals(_pacman._position)){
				trace("PACMAN EATS GHOST " + _ghostName);
			}
		}

		// Checks if current actor can be moved to position p
		override public function canMoveThru(p:Point){
			
			// Check position on map
			if(map.checkTransversable(p.x, p.y) ){
				return false;
			}
			// If p is equal to last position, we cannot move to this point
			// This causes a ghost to cannot reverse direction
			if(p.equals(_lastPosition) && !_inFear){
				return false;
			}
			return true;
		}

		public function setFear(b:Boolean){
			if(b){
				trace("Fear ON!");
				_timer.stop();
				_graphicsImplement.gotoAndStop(2);
				_inFear = true;
				_path = null;
				_fearTimer = new Timer(Constants.FEAR_TIME, 1);
				_fearTimer.addEventListener("timer", function(){
					setFear(false);
				});
				_fearTimer.start();
			}else{
				trace("Fear off :-( ");
				_timer.start();
				_graphicsImplement.gotoAndStop(1);
				_inFear = false;
				_path = null;
			}
		}

	}
}