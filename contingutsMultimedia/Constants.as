package contingutsMultimedia{

	import flash.geom.Point;

	public class Constants{
		public static const UP:Point = new Point(0,-1);
		public static const DOWN:Point = new Point(0,1);
		public static const RIGHT:Point = new Point(1,0);
		public static const LEFT:Point = new Point(-1,0);
	
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