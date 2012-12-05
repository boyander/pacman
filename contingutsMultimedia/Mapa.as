package contingutsMultimedia {	// Generic class for moving object

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.geom.Point;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	public class Mapa extends Sprite{

		private var _mapArray:Array;
		private var _itemArray:Array;
		private var _mapOffset:Point;
		private var _tileSize:Number;
		public var dispatcher:EventDispatcher;

		public function Mapa(fileName:String, offset:Point){
			_tileSize = 15;	
			dispatcher = new EventDispatcher();
			_mapArray = new Array();
			_itemArray = new Array();
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
			_itemArray[0] = new Array();
			for (var i:uint = 0; i < rawMap.length; i++)
			{
				tile = rawMap.charAt(i);
				if (tile == 0)
				{
					row++;
					_mapArray[row] = new Array();
					_itemArray[row] = new Array();
					column = 0;
				}
				else
				{
					_mapArray[row][column] = null;
					_itemArray[row][column] = null;
					switch(tile){
						case "W":
							_mapArray[row][column] = "W";
						break;
						case "*":
							_itemArray[row][column] = '.';
						break;
						case ".":
							_itemArray[row][column] = '.';
						break;
					}
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

		public function getRandomPoint(){
			var xx:Number = Math.round(Math.random() * _mapArray[0].length);
			var yy:Number = Math.round(Math.random() * _mapArray.length);
			return new Point(xx,yy);
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

		public function draw(){

			// TODO: Clear map

			var mapW:uint = _mapArray.length;
			var mapH:uint = _mapArray[0].length;
			var i,j;
			for (i = 0; i < mapW; i++)
			{
				for (j = 0; j < mapH; j++)
				{
					var bgClip:MovieClip = null;
					// Draw wall
					if (_mapArray[i][j] == "W")
					{
						bgClip = new wallClip();
					}
					
					// Draw "pac"
					if (_itemArray[i][j] == ".")
					{
						bgClip = new pacClip();
					}

					// Draw powerup
					if (_itemArray[i][j] == "*"){
						bgClip = new powerUpClip();
					}

					if(bgClip != null){
						bgClip.x = (_tileSize * j) + _mapOffset.x;
						bgClip.y = (_tileSize * i) + _mapOffset.y;
						this.addChild(bgClip);
					}
				}
			}
		}

		public function eatItemAt(p:Point){
			_itemArray[p.y][p.x] = null;
		}
	}
}