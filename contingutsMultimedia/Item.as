/*
Project: Pacman
Authors: Marc Pomar & Laura Cotrina.
Description:
	Generic class for item in game (a pac or a powerUp)
*/

package contingutsMultimedia {

	import flash.display.MovieClip;
	import contingutsMultimedia.Constants;
	import flash.display.Sprite;


	public class Item extends Sprite{

		private var _type:String;
		private var _graphics:MovieClip;

		public function Item(type:String){
			_type = type;
			switch(type){
				case Constants.WALL:
					_graphics = new wallClip();
				break;
				case Constants.PAC:
					_graphics = new pacClip();
				break;
				case Constants.POWERUP:
					_graphics = new powerUpClip();
				break;
				case Constants.NEUTRAL:
				break;
			}
			if(_graphics){
				this.addChild(_graphics);
			}
		}

		public function animate(){
			if(_graphics){
				this._graphics.gotoAndPlay(2);
			}
		}

		public function getType(){
			return _type;
		}
	}
}