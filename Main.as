package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import contingutsMultimedia.Game;
	import flash.events.KeyboardEvent;

	public class Main extends MovieClip {
	
		private var mapFile:String = "levels/level1.txt";
		private var game:Game;

		public function Main() {
			trace("Starting game with file \"" + mapFile + "\"");
			game = new Game(mapFile);
			addChild(game);

			// Keyboard controller
			stage.addEventListener(KeyboardEvent.KEY_DOWN, detectKey);
		}

		// Detects key press
		public function detectKey(event:KeyboardEvent):void{
			game.detectKey(event);
		}
	}

}