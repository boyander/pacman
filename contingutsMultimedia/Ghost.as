/*
Project: Pacman
Authors: Marc Pomar & Laura Cotrina.
Description:
	Ghost implementation for Inky, Blinky, Pinky and Clyde.
*/

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

		// Variables
		private var _status:String;
		private var _lastPosition:Point;
		private var _ghostName:String;

		// Path deployment
		public var _star:AStar;
		private var _path:Array;
		private var _pathStep:uint;			
		private var _pathcheck:MovieClip; // Debug variable path checker

		// Timer for normal/fight
		private var _timer:Timer;
		// Timer for ghost fear mode
		private var _fearTimer:Timer;
		// Timer for jail
		private var _jailTimer:Timer;

		public var _tryReverse:Boolean;

		// Pacman clip
		private var _pacman:Actor;

		// Ghost graphics
		var _ghostFearGraphic:MovieClip;
		var _ghostNormalGraphic:MovieClip;
		var _ghostEyesGraphic:MovieClip;


		// Constructor
		public function Ghost(ghostName:String, ghostGraphicsClip:String, pacman:Actor,m:Mapa, pathcheck:MovieClip){
			map = m;
			_star = new AStar(map, this);
			var startPosition:Point = m.getJailPosition();
			_lastPosition = new Point(startPosition.x, startPosition.y);
			_pacman = pacman;
			_ghostName = ghostName;
			_pathcheck = pathcheck;

			this.initializeGhosts();

			_tryReverse = false;
			// Start timer for ghosts
			this.updateTimers(null);

			// Initialize ghost graphics
			_ghostFearGraphic = new fantasmica_malo();
			_ghostEyesGraphic = new fantasmica_ojos();
			var definedImplementation:Class = getDefinitionByName(ghostGraphicsClip) as Class;
      		_ghostNormalGraphic = new definedImplementation();

      		// Scaled ghosts
      		var scale:Number =  map.getTileSize() * 1.2 / _ghostNormalGraphic.width;
      		_ghostNormalGraphic.scaleX = _ghostNormalGraphic.scaleY = scale;
      		_ghostFearGraphic.scaleX = _ghostFearGraphic.scaleY = scale;
      		_ghostEyesGraphic.scaleX = _ghostEyesGraphic.scaleY = scale;


			super(_ghostNormalGraphic, Constants.GHOST_SPEED, Constants.RIGHT, startPosition);
		}

		public function initializeGhosts(){
			// Set initial status
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
		}

		// Reset ghost behaviour
		public function resetGhost(){
			// Set initial status
			_status = Constants.NORMAL;
			// Normal ghost
			setGraphicsImplement(_ghostNormalGraphic);

			// Reset speed
			setSpeed(Constants.GHOST_SPEED);

			// Reset positioning
			this.resetActor();

			// Reset timer
			_timer.stop();
			_timer = null;
			//this.updateTimers(null);
		}

		// Act ghost
		public function actuate(){
			

			// Update actor
			this.actorUpdate();

			// Checks jail timer and releases ghost
			this.checkJail();

			// Updates ghost behaviour depending on state
			this.updateGhostBehaviour();
		}

		public function checkGameCollisions(){
			// Check collision with pacman and dispatches events on collision
			if(_position.equals(_pacman._position)){
				if(_status == Constants.GHOST_FEAR){
					dispatchEvent(new Event("eatGhost"));
					debugGhost("Pacman eats");
					_status = Constants.GO_INSIDE_JAIL;
					this.setSpeed(Constants.GHOST_SPEED * 2);
				}else if(_status == Constants.FIGHT || _status == Constants.NORMAL){
					dispatchEvent(new Event("killPacman"));
				}
			}
		}

		override public function getNextMoveDirection(){
			// Update ghost moveDirection based on next direction and current position
			if(_path != null && _pathStep < _path.length){
				var currentStep:Node = _path[_pathStep];
				var pushedDirection:Point;
				if(currentStep.getY() - _position.y < 0){
					pushedDirection = Constants.UP;
				}else if(currentStep.getY() - _position.y > 0){
					pushedDirection = Constants.DOWN;
				}else if(currentStep.getX() - _position.x > 0){
					pushedDirection = Constants.RIGHT;
				}else{
					pushedDirection = Constants.LEFT;
				}
				_lastPosition = new Point(_position.x, _position.y);
				// Update ghost eyes
				moveEyes(pushedDirection);
				// Setup direction
				this.setMoveDirection(pushedDirection);
			}
		}
		
		override public function overflowTile(){
			// Increment path step counter
			if(_path != null && _pathStep < _path.length){
				_pathStep++;
			}
		}

		// Moves Ghost eyes to current moving direction
		public function moveEyes(moveDirection){
			if(moveDirection.equals(Constants.UP)){
				_graphicsImplement.ojos.gotoAndStop(2);
			}else if(moveDirection.equals(Constants.DOWN)){
				_graphicsImplement.ojos.gotoAndStop(1);
			}else if(moveDirection.equals(Constants.LEFT)){
				_graphicsImplement.ojos.gotoAndStop(3);
			}else{
				_graphicsImplement.ojos.gotoAndStop(4);
			}
		}

		public function setupPathTo(p:Point, ignoreNew:Boolean=false){
			if(needNewPath() || ignoreNew){
				if(_tryReverse){
					_path = _star.findPath(this.getPosition(), p, _tryReverse);
					_tryReverse = false;
				}else{
					_path = _star.findPath(this.getPosition(), p);
				}
				_pathStep = 1;
			}
		}

		// Updates ghost path
		public function updateGhostBehaviour(){

			switch(_status){
				case Constants.NORMAL:
					this.setupPathTo(map.getRandomPoint());
					setGraphicsImplement(_ghostNormalGraphic);
					break;
				case Constants.GHOST_FEAR:
					this.setupPathTo(map.getRandomPoint());
					setGraphicsImplement(_ghostFearGraphic);
					break;
				case Constants.FIGHT:
					this.setupPathTo(_pacman.getPosition(),true);
					break;
				case Constants.GO_INSIDE_JAIL:
					this.setupPathTo(map.getJailPosition());
					setGraphicsImplement(_ghostEyesGraphic);
					break;
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
						_timer.delay = 6000;
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
						_timer.delay = 6000;
					break;
				}

				_path = null;
				debugGhost("Goes Random");
			}else if(_status == Constants.NORMAL){
				_status = Constants.FIGHT;
				
				// Normal timing mode depending on ghost
				switch(_ghostName){
					case Constants.BLINKY:
						_timer.delay = 15000;
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
				debugGhost("Goes Fight");
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

		// Checks if current actor can be moved to position p
		override public function canMoveThru(p:Point){
			
			// Check position on map
			if(map.checkTransversable(p.x, p.y) ){
				return false;
			}
			// If p is equal to last position, we cannot move to this point
			// This causes a ghost to cannot reverse direction
			if(p.equals(_lastPosition) && _status != Constants.GO_INSIDE_JAIL){
				return false;
			}
			return true;
		}

		public function checkJail(){
			//debugGhost(map.getTileAtPoint(_position.x, _position.y).getType());

			// Check if ghost is currently inside the jail		
			if(_status == Constants.GO_INSIDE_JAIL && map.getTileAtPoint(_position.x, _position.y).getType() == Constants.JAIL){
				debugGhost("Jail timer starts!");
				_jailTimer = new Timer(Constants.JAIL_TIME, 1);
				_jailTimer.addEventListener("timer", function(){
					_status = Constants.NORMAL;
					setSpeed(Constants.GHOST_SPEED);
					debugGhost("Bye Jail!");
				});
				_jailTimer.start();
			}
		}


		public function setFear(){

			// Reset timer if ghost is on fear and another fear event is called
			if(_status == Constants.GHOST_FEAR){
				_fearTimer.reset();
			}

			// If not in jail, go to fear mode and start timer
			if(_status != Constants.GO_INSIDE_JAIL){
				debugGhost("Fear ON!");
				_status = Constants.GHOST_FEAR;
				_timer.stop();
				_fearTimer = new Timer(Constants.FEAR_TIME, 1);
				_fearTimer.addEventListener("timer", function(){
					if(_status == Constants.GHOST_FEAR){
						_status = Constants.NORMAL;
						debugGhost("Fear off :-( ");
						_tryReverse = true;
						_timer.start();
					}
				});
				_fearTimer.start();
			}
		}

		public function debugGhost(s:String){
			trace("Ghost ["+_ghostName+"] s["+_status+"] -> "+ s);
		}

	}
}