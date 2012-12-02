package contingutsMultimedia {

	/*
	Author: MarcP
	Implementation of A* (a-star) algorithm on AS3 for Continguts Multimedia (Pacman project)
	See more at http://en.wikipedia.org/wiki/A*_search_algorithm
	*/

	public class AStar{

		public function AStar(){

		}

		// Heuristic cost function for A-star search algorithm
		public function getCost(current:Point, target:Point) {		
			var dx:Number = target.x - current.x;
			var dy:Number = target.y - current.y;
			return Math.sqrt( (dx * dx) + (dy * dy) );
		}
	}
}