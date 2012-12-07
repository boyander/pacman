package contingutsMultimedia{

	import flash.geom.Point;

	public class Constants{
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