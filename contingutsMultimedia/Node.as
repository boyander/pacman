package contingutsMultimedia {	
	import flash.geom.Point;
	public class Node{
		private var _x:Number;
		private var _y:Number;
		private var _costTravel:Number; // path cost 
		public var _costHeuristic:Number; // heuristic cost
		private var _depth:Number;
		public var parent:Node;
	
		public function Node(x:Number, y:Number){
			_x = x;
			_y = y;
		}

		public function setParent(p:Node){
			_depth = p._depth + 1;
			parent = p;
			return _depth;
		}

		public function setTravelCost(cost:Number){
			_costTravel = cost;
		}
		
		public function getTravelCost(){
			return _costTravel;
		}

		public function setHeuristicCost(cost:Number){
			_costHeuristic = cost;
		}

		public function getHeuristicCost(){
			return _costHeuristic;
		}

		public function setDepth(depth:Number){
			_depth = depth;
		}

		public function getX(){
			return _x;
		}

		public function getY(){
			return _y;
		}
	}
}