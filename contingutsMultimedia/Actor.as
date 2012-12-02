package contingutsMultimedia {	// Generic class for moving object

	import flash.geom.Point;
	import flash.display.MovieClip;

	public class Actor{

		public var _speed:Number;
		public var _moveDirection:Point;
		public var _deltaChange:Point;
		public var _position:Point;

		public function Actor(speed:Number, moveDir:Point, position:Point){
			_deltaChange = new Point(0,0);
			_speed = speed;
			_moveDirection = moveDir;
			_position = position;
		}
		public function setMoveDirection(x:Number, y:Number){
			_moveDirection.x = x;
			_moveDirection.y = y;
		}
	}
}