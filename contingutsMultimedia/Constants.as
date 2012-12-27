/*
Project: Pacman
Authors: Marc Pomar & Laura Cotrina.
Description:
	Constants for game.
*/

package contingutsMultimedia{

	import flash.geom.Point;

	public class Constants{

		public static const WALL:String = "Wall";
		public static const PAC:String = "Pac";
		public static const POWERUP:String = "PowerUp";
		public static const NEUTRAL:String = "Neutral";

		public static const UP:Point = new Point(0,-1);
		public static const DOWN:Point = new Point(0,1);
		public static const RIGHT:Point = new Point(1,0);
		public static const LEFT:Point = new Point(-1,0);

		public static const BLINKY:String = "Blinky";
		public static const INKY:String = "Inky";
		public static const PINKY:String = "Pinky";
		public static const CLYDE:String = "Clyde";

		public static const NORMAL:String = "Normal";
		public static const FIGHT:String = "Fight";
		public static const GHOST_FEAR:String = "Fear";
		public static const KILLED:String = "Killed";

		public static const FEAR_TIME:Number = 5000;

		//graficos para fantasmas
		public static const GRAFIC_BLINKY:String = "fantasmica_rojo";
		public static const GRAFIC_INKY:String = "fantasmica_azul";
		public static const GRAFIC_PINKY:String = "fantasmica_rosa";
		public static const GRAFIC_CLYDE:String = "fantasmica_naranja";
		public static const GRAFIC_FEAR:String = "fantasmica_malo";

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