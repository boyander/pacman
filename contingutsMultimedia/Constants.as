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
		public static const NORMAL:String = "GH-Normal";
		public static const FIGHT:String = "GH-Fight";
		public static const GHOST_FEAR:String = "GH-Fear";
		public static const GO_INSIDE_JAIL:String = "GH-Killed";

		// Ghost times on status
		public static const FEAR_TIME:Number = 7000;
		public static const JAIL_TIME:Number = 5000;

		// Ghost graphics (MovieClip name's)
		public static const GRAFIC_BLINKY:String = "fantasmica_rojo";
		public static const GRAFIC_INKY:String = "fantasmica_azul";
		public static const GRAFIC_PINKY:String = "fantasmica_rosa";
		public static const GRAFIC_CLYDE:String = "fantasmica_naranja";
		public static const GRAFIC_FEAR:String = "fantasmica_malo";

		// Speeds for player and ghosts
		public static const PACMAN_SPEED:Number = 5;
		public static const GHOST_SPEED:Number = 4;

		// Events
		public static const EVENT_EATPOWERUP:String = "evt_eatpowerup";
		public static const EVENT_EATPAC:String = "evt_eatpac";
		public static const EVENT_EATGHOST:String = "evt_eatghost";
		public static const EVENT_PACMANDIES:String = "evt_pacmandies";
		public static const EVENT_GAMEOVER:String = "evt_gameover";


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

		// Constant to function to return ghost color
		public static function ghostColor(fantasma:String){
			switch (fantasma){
				case BLINKY:
					return "0xFF4E50";
				case INKY:
					return "0x69D2E7";
				case PINKY:
					return "0xF7477D";
				case CLYDE:
					return "0xF9D423";
				default:
					return "0x336699";
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