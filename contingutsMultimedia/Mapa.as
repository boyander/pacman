/*
Project: Pacman
Authors: Marc Pomar & Laura Cotrina.
Description:
	Class for loading map and collision assets.
*/

package contingutsMultimedia {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.geom.Point;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import contingutsMultimedia.Item;
	import contingutsMultimedia.ZigZagMatrix;
	import flash.utils.Timer;
    import flash.events.TimerEvent;

	public class Mapa extends Sprite{

		// Offset for all map tiles
		private var _mapOffset:Point;

		// Tile Size
		private var _tileSize:Number = 20;

		// Event dispatcher
		public var dispatcher:EventDispatcher = new EventDispatcher();

		// Graphics array
		public var mapArray:Array;
		public var graphicsMap:MovieClip;

		// Cache arrays
		public var _validPosCache:Array;
		public var _jailPosCache:Array;

		var zig:ZigZagMatrix;

		public function Mapa(fileName:String, offset:Point){
			
			// Set map offset
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
			// If on map limits return no wall
			if (x > mapArray[0].length-1 || x < 0 || y > mapArray.length-1 || y < 0){
				return new Item(Constants.NEUTRAL);
			}
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
			if(x > mapArray[0].length-1 || x < 0 || y > mapArray.length-1 || y < 0){
				trace("overflow");
				return true;
			}
			if (mapArray[y][x].getType() != Constants.WALL){
				return false;
			}
			return true;
		}

		// Assign positons to map objects
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
			animate();
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

		public function animate(){
			zig = new ZigZagMatrix(mapArray);
		}

		public function animateSlices():void{
			zig.getCurrentSlice();
			//var sliceItems:Array = zig.getCurrentSlice();
			/*for(var i:uint = 0; i < sliceItems.length; i++ ){
				sliceItems[i].animate();
			}*/
		}
	}
}