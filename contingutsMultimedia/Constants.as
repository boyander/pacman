/*
Project: Pacman
Authors: Marc Pomar & Laura Cotrina.
Description:
	Constants for gameplay.
*/

package contingutsMultimedia{

	import flash.geom.Point;

	public class Constants{

		// Scoreboard constants
		public static const GAMESTARTLIVES:Number = 3;

		// Map tiles collision constants
		public static const WALL:String = "Wall";
		public static const PAC:String = "Pac";
		public static const POWERUP:String = "PowerUp";
		public static const NEUTRAL:String = "Neutral";
		public static const JAIL:String = "Jail";
		public static const JAILDOOR:String = "JailDoor";

		// Valid directions
		public static const UP:Point = new Point(0,-1);
		public static const DOWN:Point = new Point(0,1);
		public static const RIGHT:Point = new Point(1,0);
		public static const LEFT:Point = new Point(-1,0);

		// Ghost Names
		public static const BLINKY:String = "Blinky";
		public static const INKY:String = "Inky";
		public static const PINKY:String = "Pinky";
		public static const CLYDE:String = "Clyde";

		// Ghost Status
		public static const NORMAL:String = "Normal";
		public static const FIGHT:String = "Fight";
		public static const GHOST_FEAR:String = "Fear";
		public static const GO_INSIDE_JAIL:String = "Killed";

		// Ghost times on status
		public static const FEAR_TIME:Number = 5000;
		public static const JAIL_TIME:Number = 5000;

		// Ghost graphics (MovieClip name's)
		public static const GRAFIC_BLINKY:String = "fantasmica_rojo";
		public static const GRAFIC_INKY:String = "fantasmica_azul";
		public static const GRAFIC_PINKY:String = "fantasmica_rosa";
		public static const GRAFIC_CLYDE:String = "fantasmica_naranja";
		public static const GRAFIC_FEAR:String = "fantasmica_malo";

		// Constant to function to return defined implementation
		public static function graficImplementation(fantasma:String){
			switch (fantasma){
				case BLINKY:
					return GRAFIC_BLINKY;
				case INKY:
					return GRAFIC_INKY;
				case PINKY:
					return GRAFIC_PINKY;
				case CLYDE:
					return GRAFIC_CLYDE;
				default:
					return GRAFIC_INKY;
			}
		}
	
		// Returns reversed from any direction
		public static function reverse(direction:Point):Point{
			if(direction.equals(UP)){
				return DOWN;
			}else if(direction.equals(DOWN)){
				return UP;
			}else if(direction.equals(LEFT)){
				return RIGHT;
			}else if(direction.equals(RIGHT)){
				return LEFT;
			}
			return null;
		}
	}
}