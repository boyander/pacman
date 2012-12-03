package contingutsMultimedia {	// Generic class for moving object

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.geom.Point;
	import flash.display.MovieClip;

	public class Mapa{

		private var _mapArray:Array;
		private var _mapOffset:Point;
		private var _tileSize:Number;
		public var dispatcher:EventDispatcher;

		public function Mapa(fileName:String, offset:Point){
			_tileSize = 15;	
			dispatcher = new EventDispatcher();
			_mapArray = new Array();
			_mapOffset = offset;
			// Loading handler
			var ldr:URLLoader = new URLLoader();
			ldr.load(new URLRequest(fileName));
			ldr.addEventListener(Event.COMPLETE, parseaMapa);
		}

		// Get map size
		public function getMapSize(){
			return new Point(_mapArray[0].length,_mapArray.length);
		}

		// Parse from txt file to array
		private function parseaMapa(e:Event):void
		{
			var rawMap:String = URLLoader(e.target).data;
			var tile;
			var row:Number = 0;
			var column:Number = 0;
			_mapArray[0] = new Array();
			for (var i:uint = 0; i < rawMap.length; i++)
			{
				tile = rawMap.charAt(i);
				if (tile == 0)
				{
					row++;
					_mapArray[row] = new Array();
					column = 0;
				}
				else
				{
					_mapArray[row][column] = tile;
					column++;
				}
			}
			dispatcher.dispatchEvent(new Event("mapaLoaded"));
		}


		public function getTileAtPixel(x:Number, y:Number){
			var xpos = (_mapOffset.x + x * _tileSize);
			var ypos = (_mapOffset.y + y * _tileSize);
			return new Point(xpos,ypos);
		}
		public function getTileAtPoint(x:Number, y:Number){
			return _mapArray[y][x];
		}

		public function getTileSize(){
			return _tileSize;
		}

		public function getOffset(){
			return _mapOffset;
		}

		public function checkTransversable(x:Number,y:Number):Boolean{
			
			// Map limits
			if(x > _mapArray[0].length || x < 0 || y > _mapArray.length || y < 0){
				return false;
			}
			if (_mapArray[y][x] != 'W'){
				return false;
			}
			return true;
		}

		public function draw(stage){
			var mapW:uint = _mapArray.length;
			var mapH:uint = _mapArray[0].length;
			var i,j;
			for (i = 0; i < mapW; i++)
			{
				for (j = 0; j < mapH; j++)
				{
					var bgClip:MovieClip;
					// Draw wall
					if (_mapArray[i][j] == "W")
					{
						bgClip = new wallClip();
					}
					// Draw "pac"
					if (_mapArray[i][j] == "." || _mapArray[i][j] == "*")
					{
						bgClip = new pacClip();
					}
					bgClip.x = (_tileSize * j) + _mapOffset.x;
					bgClip.y = (_tileSize * i) + _mapOffset.y;
					stage.addChild(bgClip);
				}
			}
		}
	}
}