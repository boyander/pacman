/*
Project: Pacman
Authors: Marc Pomar & Laura Cotrina.
Description:
	Main game class, manages game objects, score, sound FX, etc.
*/

package contingutsMultimedia {	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import contingutsMultimedia.Pacman;
	import contingutsMultimedia.Ghost;
	import contingutsMultimedia.Mapa;
	import contingutsMultimedia.Constants;
	import contingutsMultimedia.Scoreboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import flash.media.Sound;
	import flash.net.URLRequest;

	public class Game extends MovieClip{

		private var _mapa:Mapa;
		private var _offset:Point;
		public var pacman:Pacman;
		public var ghosts:Array;
		public var names:Array = [Constants.BLINKY, Constants.INKY, Constants.PINKY, Constants.CLYDE];
		public var paused:Boolean;
		// DEBUG: Path checker 
		private var pchecker:MovieClip = new MovieClip();

		// Sound objects
		var soundFX:Sound;

		// Scoreboard
		public var scoreboard:Scoreboard;

		public function Game(gameMap:String){
			_offset = new Point(0,25);
			_mapa = new Mapa(gameMap, _offset);
			_mapa.dispatcher.addEventListener("mapaLoaded", mapaCargado);
			ghosts = new Array();

			paused = false;

			// Setup lives and score
			scoreboard = new Scoreboard();
			scoreboard.addEventListener("gameOver", gameOver);

			this.addChild(scoreboard);

			// Load chili sound
			soundFX = new Sound();
			soundFX.load(new URLRequest("audios/chili.mp3"));
			var soundBG:Sound = new Sound();
			soundBG.load(new URLRequest("audios/bg_theme.mp3"));
			//soundBG.play();

		}

		public function mapaCargado(e:Event){
			
			// Add map to game clip			
			this.addChild(_mapa);

			// DEBUG: Path checker
			this.addChild(pchecker);

			// Pacman start position
			var startPositionPacman = new Point(13,23);

			// Setup new pacman character
			pacman = new Pacman("PacmanClip", _mapa, startPositionPacman);
			this.addChild(pacman);

			// Create ghost		
			for(var i:uint; i < names.length; i++){
				var ghost:Ghost = new Ghost(names[i], Constants.graficImplementation(names[i]), pacman, _mapa, pchecker);
				ghost.addEventListener("eatGhost", eatEvent);
				ghost.addEventListener("killPacman", eatEvent);
				ghosts.push(ghost);
				this.addChild(ghost);
			}

			_mapa.dispatcher.addEventListener("eatPac", eatEvent);
			_mapa.dispatcher.addEventListener("eatPowerUp", eatEvent);

			// Objects updater
			this.addEventListener(Event.ENTER_FRAME, frameUpdate);
		}

		// Updates all objects of game
		public function frameUpdate(e:Event){
			
			if(!paused){
				// Update pacman
				pacman.actuate();
				
				// Update ghosts
				for(var i:uint; i < ghosts.length; i++){
					ghosts[i].actuate();
				}
				_mapa.animateSlices();
			}
		}

		// Eat event
		public function eatEvent(e:Event){
			if(e.type == "eatPac"){
				scoreboard.addScore(10);
			}else if (e.type == "eatPowerUp"){
				scoreboard.addScore(50);
				trace("PowerUp!");
				soundFX.play();
				for(var i:uint; i < ghosts.length; i++){
					ghosts[i].setFear();
				}
			}else if (e.type == "eatGhost"){
				trace("Eat ghost +200");
				scoreboard.addScore(200);
			}else if (e.type == "killPacman"){
				trace("Ohh, sorry pacman!");
				scoreboard.removeLive();
			}
		}

		public function gameOver(e:Event){
			trace("GAME OVER");
			paused = true;
		}

		// Detects key press
		public function detectKey(event:KeyboardEvent):void{
			switch (event.keyCode){
				case Keyboard.DOWN :
					pacman.updateMovement(Constants.DOWN);
					break;
				case Keyboard.UP :
					pacman.updateMovement(Constants.UP);
					break;
				case Keyboard.LEFT :
					pacman.updateMovement(Constants.LEFT);
					break;
				case Keyboard.RIGHT :
					pacman.updateMovement(Constants.RIGHT);
					break;
			}
		}
	}
}