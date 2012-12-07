package contingutsMultimedia {	// Generic class for moving object

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.geom.Point;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import contingutsMultimedia.Item;

	public class Mapa extends Sprite{

		private var _mapOffset:Point;
		private var _tileSize:Number;
		public var dispatcher:EventDispatcher;

		public var mapArray:Array;
		public var graphicsMap:MovieClip;


		public var _validPosCache:Array;
		public var _jailPosCache:Array;

		public function Mapa(fileName:String, offset:Point){
			_tileSize = 20;	
			dispatcher = new EventDispatcher();
			_mapOffset = offset;

			// Global map array
			mapArray = new Array();

			// Cache arrays
			_validPosCache = new Array();
			_jailPosCache = new Array();

			// Inithialize map graphics
			graphicsMap = new MovieClip();
			this.addChild(graphicsMap);

			// Loading handler
			var ldr:URLLoader = new URLLoader();
			ldr.load(new URLRequest(fileName));
			ldr.addEventListener(Event.COMPLETE, parseaMapa);
		}

		// Get map size
		public function getMapSize(){
			return new Point(mapArray[0].length,mapArray.length);
		}

		// Parse from txt file to array
		private function parseaMapa(e:Event):void
		{
			var rawMap:String = URLLoader(e.target).data;
			var tile;
			var row:Number = 0;
			var column:Number = 0;

			// Assign memory for mapArray
			mapArray[0] = new Array();

			for (var i:uint = 0; i < rawMap.length; i++)
			{
				tile = rawMap.charAt(i);
				if (tile == 0){
					row++;
					column = 0;
					mapArray[row] = new Array();
				}else{
					mapArray[row][column] = null;
					switch(tile){
						case "W":
							mapArray[row][column] = new Item(Constants.WALL);

						break;
						case "*":
							mapArray[row][column] = new Item(Constants.POWERUP);
							_validPosCache.push([column,row]);
						break;
						case ".":
							mapArray[row][column] = new Item(Constants.PAC);
							_validPosCache.push([column,row]);
						break;
						case "o":
							_jailPosCache.push([column,row]);
							mapArray[row][column] = new Item(Constants.NEUTRAL);
						break;
						default:
							mapArray[row][column] = new Item(Constants.NEUTRAL);
						break;
					}
					column++;
				}
			}
			this.drawMap();
			dispatcher.dispatchEvent(new Event("mapaLoaded"));
		}


		public function getPixelAtPosition(x:Number, y:Number){
			var xpos = (_mapOffset.x + x * _tileSize);
			var ypos = (_mapOffset.y + y * _tileSize);
			return new Point(xpos,ypos);
		}
		public function getTileAtPoint(x:Number, y:Number){
			return mapArray[y][x];
		}

		public function getTileSize(){
			return _tileSize;
		}

		public function getOffset(){
			return _mapOffset;
		}

		public function checkTransversable(x:Number,y:Number):Boolean{
			
			// Map limits
			if(x > mapArray[0].length || x < 0 || y > mapArray.length || y < 0){
				trace("overflow");
				return false;
			}
			if (mapArray[y][x].getType() != Constants.WALL){
				return false;
			}
			return true;
		}

		// Draw collision map
		public function drawMap(){
			var mapW:uint = mapArray.length;
			var mapH:uint = mapArray[0].length;
			for (var i:uint = 0; i < mapW; i++)
			{
				for (var j:uint = 0; j < mapH; j++)
				{
					// Draw items
					if(mapArray[i][j] != null){
						mapArray[i][j].x = (_tileSize * j) + _mapOffset.x;
						mapArray[i][j].y = (_tileSize * i) + _mapOffset.y;
						graphicsMap.addChild(mapArray[i][j]);
					}

				}
			}
		}

		public function getGhostPosition():Point{
			return new Point(14,14);
		}

		public function getRandomPoint(){
			var rdn:Number = Math.abs(Math.round(Math.random() * _validPosCache.length - 1));
			var p:Point = new Point(_validPosCache[rdn][0],_validPosCache[rdn][1]);
			return p;
		}

		public function getJailPosition():Point{
			var rdn:Number = Math.abs(Math.round(Math.random() * _jailPosCache.length - 1));
			var p:Point = new Point(_jailPosCache[rdn][0],_jailPosCache[rdn][1]);
			return p;
		}

		public function getSizeInPixels(){
			var p:Point = this.getMapSize();
			return new Point(p.x * _tileSize, p.y * _tileSize);
		}

		public function eatItemAt(p:Point){
			if(mapArray[p.y][p.x].getType() != Constants.NEUTRAL){
				switch(mapArray[p.y][p.x].getType()){
					case Constants.PAC:
						dispatcher.dispatchEvent(new Event("eatPac"));
					break;
					case Constants.POWERUP:
						dispatcher.dispatchEvent(new Event("eatPowerUp"));
					break;
				}
				graphicsMap.removeChild(mapArray[p.y][p.x]);
				mapArray[p.y][p.x] = new Item(Constants.NEUTRAL);
			}
		}
	}
}