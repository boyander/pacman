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

	import flash.text.TextField;
	import flash.text.TextFormat;

	import flash.media.Sound;
	import flash.net.URLRequest;


	public class Game extends MovieClip{

		private var _mapa:Mapa;
		private var _offset:Point;
		public var pacman:Pacman;
		public var ghosts:Array;
		public var names:Array = [Constants.BLINKY, Constants.INKY, Constants.PINKY, Constants.CLYDE];

		private var pchecker:MovieClip = new MovieClip();

		// Sound objects
		var soundFX:Sound;

		// Global score
		public var score:Number;
		public var scoreText:TextField;

		public function Game(gameMap:String){
			_offset = new Point(0,25);
			_mapa = new Mapa(gameMap, _offset);
			this.addChild(_mapa);
			_mapa.dispatcher.addEventListener("mapaLoaded", mapaCargado);
			ghosts = new Array();
			this.setupScoreBoard();

			// Load chili sound
			soundFX = new Sound();
			soundFX.load(new URLRequest("audios/chili.mp3"));
			var soundBG:Sound = new Sound();
			soundBG.load(new URLRequest("audios/bg_theme.mp3"));
			//soundBG.play();

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
			_mapa.animateSlices();
		}

		// Eat event
		public function eatEvent(e:Event){
			if(e.type == "eatPac"){
				this.addScore(10);
			}else if (e.type == "eatPowerUp"){
				this.addScore(50);
				trace("UUUUH CHILIII");
				soundFX.play();
				for(var i:uint; i < ghosts.length; i++){
					ghosts[i].setFear(true);
				}
			}else if (e.type == "eatGhost"){
				trace("Eat ghost");
				this.addScore(200);
			}
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

		public function addScore(s:Number){
			score += s;
			scoreText.text = "Score: " + String(score);
		}

		public function setupScoreBoard(){
			score = 0;
			scoreText = new TextField();
			scoreText.name = "title";
			scoreText.mouseEnabled = false;

			var myformat:TextFormat = new TextFormat();
			myformat.color = 0x336699;
			myformat.size = 20;
			scoreText.defaultTextFormat = myformat;
			this.addChild(scoreText);
		}

	}
}