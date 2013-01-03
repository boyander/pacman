/*
Project: Pacman
Authors: Marc Pomar & Laura Cotrina.
Description:
	Main game character implementation (pacman), also handles user moves.
*/

package contingutsMultimedia {

	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	import contingutsMultimedia.Actor;
	import flash.display.MovieClip;
	import contingutsMultimedia.Mapa;
	import contingutsMultimedia.Item;


	// Pacman player :-)
	public class Pacman extends Actor {

		// Constants
		public static const STARTSPEED:Number = 5;

		// Pushed direction
		public var pushedDirection:Point;

		// Constructor
		public function Pacman(pacmanGraphicsClip:String, m:Mapa, startPosition:Point){
			map = m;
			var definedImplementation:Class = getDefinitionByName(pacmanGraphicsClip) as Class;
      		var pacmanClip:MovieClip = new definedImplementation();
      		var startDirection:Point = Constants.RIGHT;
      		pushedDirection = startDirection;
			super(pacmanClip, STARTSPEED, startDirection, startPosition);
			pacmanMoveHead(startDirection);
		}

		// Pacman update movement
		public function updateMovement(p:Point){
			pushedDirection = new Point(p.x,p.y);
		}

		// Act player
		public function actuate(){
			
			// Eat current item
			map.eatItemAt(_position);
			
			// Trigger actor update code			
			this.actorUpdate();

		}


		public function pacmanMoveHead(moveDirection){
			if(moveDirection.equals(Constants.UP)){
				_graphicsImplement.gotoAndStop(1);
			}else if(moveDirection.equals(Constants.DOWN)){
				_graphicsImplement.gotoAndStop(2);
			}else if(moveDirection.equals(Constants.LEFT)){
				_graphicsImplement.gotoAndStop(3);
			}else{
				_graphicsImplement.gotoAndStop(4);
			}
		}
		
		override public function getNextMoveDirection(){
			if(pushedDirection != null){
				var p:Point = new Point(_position.x + pushedDirection.x, _position.y + pushedDirection.y);
				if(canMoveThru(p)){
					this.setMoveDirection(pushedDirection);
					pacmanMoveHead(pushedDirection);
					pushedDirection = null;
				}
			}
		}

		override public function canMoveThru(p:Point){
			var tile:String = map.getTileAtPoint(p.x, p.y).getType();
			if(tile != Constants.WALL && tile != Constants.JAILDOOR){
				return true;
			}
			return false;
		}
	}
}