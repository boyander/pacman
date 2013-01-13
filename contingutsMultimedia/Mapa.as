/*
Project: Pacman
Authors: Marc Pomar & Laura Cotrina.
Description:
	Class for loading map and collision assets.
*/

package contingutsMultimedia {

	import flash.events.Event;
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
		public var _mapOffset:Point;

		// Tile Size
		private var _tileSize:Number = 20;

		// Graphics array
		public var mapArray:Array;
		public var gameArray:Array;
		public var graphicsMap:MovieClip;

		// Eat items
		public var avaliableItems:Number;
		public var eatedItems:Number;

		// Cache arrays
		public var _validPosCache:Array;
		public var _jailPosCache:Array;

		var zig:ZigZagMatrix;

		public function Mapa(fileName:String, offset:Point){
			
			// Set map offset
			_mapOffset = offset;

			// Global map array with level
			mapArray = new Array();
			gameArray = new Array();
			avaliableItems = 0;
			eatedItems = 0;

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
		public function parseaMapa(e:Event):void
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
							avaliableItems++;
							_validPosCache.push([column,row]);
						break;
						case ".":
							mapArray[row][column] = new Item(Constants.PAC);
							avaliableItems++;
							_validPosCache.push([column,row]);
						break;
						case "o":
							_jailPosCache.push([column,row]);
							mapArray[row][column] = new Item(Constants.JAIL);
						break;
						case "-":
							mapArray[row][column] = new Item(Constants.JAILDOOR);
						break;
						default:
							mapArray[row][column] = new Item(Constants.NEUTRAL);
						break;
					}
					column++;
				}
			}
			this.resetMap();
			dispatchEvent(new Event("mapaLoaded"));
		}


		public function tileToPixel(x:Number, y:Number){
			var xpos = ((x+1) * _tileSize) - (_tileSize/2);
			var ypos = ((y+1) * _tileSize) - (_tileSize/2);
			return new Point(xpos,ypos);
		}
		public function getTileAtPoint(x:Number, y:Number){
			// If on map limits return neutral space
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
		public function resetMap(){
			var mapW:uint = mapArray.length;
			var mapH:uint = mapArray[0].length;

			// Remove all childs
			while(graphicsMap.numChildren != 0) graphicsMap.removeChildAt(0);
			trace("There are " + avaliableItems +" avaliable items.");
			eatedItems = avaliableItems;
			gameArray = new Array();

			// Draw items and walls
			var i:uint;
			var j:uint;
			for ( i = 0; i < mapW; i++)
			{
				gameArray[i] = new Array();
				for ( j = 0; j < mapH; j++)
				{
					gameArray[i][j] = mapArray[i][j];
					if(gameArray[i][j] != null){
						gameArray[i][j].x = (_tileSize * j) + _mapOffset.x;
						gameArray[i][j].y = (_tileSize * i) + _mapOffset.y;
						graphicsMap.addChild(gameArray[i][j]);
					}
				}
			}
			zig = new ZigZagMatrix(mapArray);
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
			var s:Point = getMapSize();
			if((p.x >= 0 && p.x < s.x) && (p.y >= 0 && p.y < s.y)){
				if(gameArray[p.y][p.x].getType() != Constants.NEUTRAL){
					switch(gameArray[p.y][p.x].getType()){
						case Constants.PAC:
							dispatchEvent(new Event("eatPac"));
						break;
						case Constants.POWERUP:
							dispatchEvent(new Event("eatPowerUp"));
						break;
					}
					graphicsMap.removeChild(gameArray[p.y][p.x]);
					gameArray[p.y][p.x] = new Item(Constants.NEUTRAL);
					eatedItems--;

					if(eatedItems <= 0){
						dispatchEvent(new Event("pacmanWins"));
					}
				}
			}
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