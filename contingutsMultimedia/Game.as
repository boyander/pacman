package contingutsMultimedia {	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import contingutsMultimedia.Pacman;
	import contingutsMultimedia.Ghost;
	import contingutsMultimedia.Mapa;
	import contingutsMultimedia.Constants;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;


	public class Game extends MovieClip{

		private var _mapa:Mapa;
		private var _offset:Point;
		public var pacman:Pacman;
		public var ghosts:Array;
		public var names:Array = [Constants.BLINKY, Constants.INKY, Constants.PINKY, Constants.CLYDE];

		private var pchecker:MovieClip = new MovieClip();

		// Global score
		public var score:Number;


		public function Game(gameMap:String){
			_offset = new Point(25,25);
			_mapa = new Mapa(gameMap, _offset);
			this.addChild(_mapa);
			_mapa.dispatcher.addEventListener("mapaLoaded", mapaCargado);
			ghosts = new Array();
			score = 0;
		}

		public function mapaCargado(e:Event){
			
			this.addChild(pchecker);

			pacman = new Pacman("PacmanClip", _mapa, new Point(1,1));
			this.addChild(pacman);

			// Create ghost		
			for(var i:uint; i < names.length; i++){
				var ghost:Ghost = new Ghost(names[i], "GhostClip", pacman, _mapa, pchecker);
				ghost.addEventListener("eatGhost", eatEvent);
				ghosts.push(ghost);
				stage.addChild(ghost);
			}

			_mapa.dispatcher.addEventListener("eatPac", eatEvent);
			_mapa.dispatcher.addEventListener("eatPowerUp", eatEvent);

			
			// Objects updater
			this.addEventListener(Event.ENTER_FRAME, frameUpdate);
			
			// Keyboard controller
			stage.addEventListener(KeyboardEvent.KEY_DOWN, detectKey);
		}

		// Updates all objects of game
		public function frameUpdate(e:Event){
			
			// Update pacman
			pacman.actuate();
			
			// Update ghosts
			for(var i:uint; i < ghosts.length; i++){
				ghosts[i].actuate();
			}

			// Redraw Map
			_mapa.draw();
		}

		// Eat event
		public function eatEvent(e:Event){
			if(e.type == "eatPac"){
				score += 10;
			}else if (e.type == "eatPowerUp"){
				score += 50;
				for(var i:uint; i < ghosts.length; i++){
					ghosts[i].setFear(true);
				}
			}else if (e.type == "eatGhost"){
				trace("Eat ghost");
				score += 200;
			}
			trace("Score is -> " + score);
		}


		// Detects key press
		public function detectKey(event:KeyboardEvent):void{
			switch (event.keyCode){
				case Keyboard.DOWN :
					pacman.setMoveDirection(Constants.DOWN);
					break;
				case Keyboard.UP :
					pacman.setMoveDirection(Constants.UP);
					break;
				case Keyboard.LEFT :
					pacman.setMoveDirection(Constants.LEFT);
					break;
				case Keyboard.RIGHT :
					pacman.setMoveDirection(Constants.RIGHT);
					break;
			}
		}

	}
}