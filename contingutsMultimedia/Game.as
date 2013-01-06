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
	import contingutsMultimedia.Soundboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.filters.BlurFilter;

	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.*;
	import com.gskinner.motion.plugins.BlurPlugin;

	public class Game extends MovieClip{

		private var _mapa:Mapa;
		private var _offset:Point;
		public var pacman:Pacman;
		public var ghosts:Array;
		public var names:Array = [Constants.BLINKY, Constants.INKY, Constants.PINKY, Constants.CLYDE];
		public var paused:Boolean;

		// DEBUG: Path checker 
		private var pchecker:MovieClip = new MovieClip();

		// Start position pacman
		var startPositionPacman:Point;

		// Sound objects
		var soundboard:Soundboard;

		// Scoreboard
		public var scoreboard:Scoreboard;

		// Graphics
		var gameOverGraphic:MovieClip;
		var replayButton:MovieClip;


		public function Game(gameMap:String){

			// Initialize blur plugin
			BlurPlugin.install();

			// DEBUG: Path checker
			this.addChild(pchecker);

			// Initialize ghosts
			ghosts = new Array();

			// Start map instance with map offset
			_offset = new Point(0,25);
			_mapa = new Mapa(gameMap, _offset);
			_mapa.addEventListener("eatPac", eventProcessor);
			_mapa.addEventListener("eatPowerUp", eventProcessor);
			_mapa.addEventListener("mapaLoaded", function(e:Event){
				// When map loaded reset game and spawn characters
				resetGame();
			});
			this.addChild(_mapa); // Add map clip and start listeners

			// Setup scoreboard (counts lives and scores)
			scoreboard = new Scoreboard();
			this.addChild(scoreboard);

			// Soundboard
			soundboard = new Soundboard();
			soundboard.loadSounds();

		}

		public function resetGame(){

			trace("---- Reseting characters ----");

			// Unpause game
			paused = false;
			
			// Pacman start position
			startPositionPacman = new Point(13,23);

			// Setup new pacman character
			if(pacman){
				this.removeChild(pacman);
				pacman = null;
			}
			pacman = new Pacman("PacmanClip", _mapa, startPositionPacman);
			this.addChild(pacman);

			// Remove current ghosts & listeners
			removeGhosts();

			// Create ghosts
			var ghost:Ghost;	
			for(var i:uint; i < names.length; i++){
				ghost = new Ghost(names[i], Constants.graficImplementation(names[i]), pacman, _mapa, pchecker);
				ghost.addEventListener("eatGhost", eventProcessor);
				ghost.addEventListener("killPacman", eventProcessor);
				ghosts.push(ghost);
				this.addChild(ghost);
			}

			// Update characters and objects
			this.addEventListener(Event.ENTER_FRAME, frameUpdate);
		}




		// Updates all objects of game
		public function frameUpdate(e:Event){
			if(!paused){
				// Update ghosts
				for(var i:uint; i < ghosts.length; i++){
					ghosts[i].actuate();
				}
				// Update pacman
				pacman.actuate();

				// Map bright animation
				_mapa.animateSlices();
			}
		}

		// Eat event
		public function eventProcessor(e:Event){
			if(e.type == "eatPac"){
				scoreboard.addScore(10);
			}else if (e.type == "eatPowerUp"){
				scoreboard.addScore(50);
				trace("PowerUp!");
				soundboard.playSound(Constants.EVENT_EATPOWERUP);
				for(var i:uint; i < ghosts.length; i++){
					ghosts[i].setFear();
				}
			}else if (e.type == "eatGhost"){
				trace("Eat ghost +200");
				scoreboard.addScore(200);
			}else if (e.type == "killPacman"){
				trace("Ohh, sorry pacman!");
				paused = true;
				pacman.diePacman();
				removeGhosts();
				scoreboard.removeLive();
				pacman.addEventListener("pacmanDies", function(e:Event){
					if(scoreboard.hasLives()){
						resetGame();
					}else{
						gameOver();
					}					
				});
			}
		}

		public function removeGhosts(){
			// Remove current ghosts & listeners
			var ghost:Ghost;
			while(ghost = ghosts.pop()){
				ghost.resetGhost(); // Make sure garbage collector removes timers
				ghost.removeEventListener("eatGhost", eventProcessor);
				ghost.removeEventListener("killPacman", eventProcessor);
				this.removeChild(ghost);
			}
		}

		public function gameOver(){
			trace("GAME OVER");

			// Game over sound
			soundboard.playSound(Constants.EVENT_GAMEOVER);

			// Invisible pacman
			if(pacman){
				pacman.visible = false;
			}

			// Play gameover animation
			gameOverGraphic = new gameOverClip();
			this.addChild(gameOverGraphic);
			// Place in topcenter
			gameOverGraphic.x = (stage.stageWidth/2) - (gameOverGraphic.width/2);
			gameOverGraphic.y = -gameOverGraphic.height;

			// Tween gameover
			var tween:GTween = new GTween(gameOverGraphic,3.5,{y:(stage.stageHeight/2)-(gameOverGraphic.height/2)},
				{ease:Elastic.easeOut,
				onComplete: function(){
					// Add replay button
					replayButton = new replayBT();
					replayButton.x = (stage.stageWidth/2) - (replayButton.width/2);
					replayButton.y = (stage.stageHeight/2) + (gameOverGraphic.height/2) + 30;
					addChild(replayButton);
					replayButton.addEventListener(MouseEvent.CLICK, restartGame);
				}
			});

			// Blur tween for _mapa
			var blur:BlurFilter = new BlurFilter(0, 0, 2);
			_mapa.filters = new Array(blur);
			var tween2:GTween = new GTween(_mapa,1,{blur:25},{ease:Sine.easeIn});

			// Tween for score
			scoreboard.showMeTheScore(new Point(
				(stage.stageWidth/2),
				(stage.stageHeight/2) + (gameOverGraphic.height/2)
			));
		}

		public function restartGame(e:Event){
			trace("RESTARTING GAME...");

			// Remove filters;
			_mapa.filters = new Array();

			// Remove gameover
			removeChild(gameOverGraphic);
			removeChild(replayButton);

			resetGame();
			scoreboard.reset();
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