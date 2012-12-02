package contingutsMultimedia{

	import flash.geom.Point;
	import Actor;
	import Mapa;

	// Ghost player :-)
	public class Ghost extends Actor {

		// Constants
		public static const GHOSTSPEED:Number = 4;

		// Variables
		private var inFear:Boolean;
		private var path:Path;


		// Hold map copy to check against colision with walls
		private var map:Mapa;

		// Constructor
		public function Pacman(ghostName:GName,m:Mapa, startPosition:Point){
			map = m;
			super(GHOSTSPEED, new Point(1,0), startPosition);
		}

		// Act ghost
		public function actuate(){
			
		}

		// Is current ghost in fear?
		public function isGhostInFear(){
			return inFear;
		}
		public function setFear(fe:Boolean){
			inFear = fe;
		}

	}
}