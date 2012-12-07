package contingutsMultimedia {	// Generic class for moving object

	import flash.display.MovieClip;
	import contingutsMultimedia.Constants;
	import flash.display.Sprite;


	public class Item extends Sprite{

		private var _type:String;
		private var _graphics:String;

		public function Item(type:String){
			_type = type;
			switch(type){
				case Constants.WALL:
					this.addChild(new wallClip());
				break;
				case Constants.PAC:
					this.addChild(new pacClip());
				break;
				case Constants.POWERUP:
					this.addChild(new powerUpClip());
				break;
				case Constants.NEUTRAL:
				break;
			}
		}

		public function getType(){
			return _type;
		}
	}
}