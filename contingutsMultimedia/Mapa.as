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
    import flash.debugger.enterDebugger;

	public class Mapa{
		// Tile Size
		private var _tileSize:Number = 20;

		// Graphics array
		private var mapArray:Array;
		private var gameArray:Array;
		private var graphicsMap:Sprite;

		// Eat items
		public var avaliableItems:Number;
		public var eatedItems:Number;

		// Cache arrays
		private var _validPosCache:Array;
		private var _jailPosCache:Array;

		// Dispatcher
		public var dispatcher:EventDispatcher;

		var zig:ZigZagMatrix;

		var pathPoint:Sprite = new Sprite();

		public function Mapa(fileName:String, offset:Point){
	
			// Global map array with level
			mapArray = new Array();
			gameArray = new Array();
			avaliableItems = 0;
			eatedItems = 0;

			// Cache arrays
			_validPosCache = new Array();
			_jailPosCache = new Array();

			// Inithialize map graphics with offset
			graphicsMap = new Sprite();
			graphicsMap.x = offset.x;
			graphicsMap.y = offset.y;

			// Initialize dispatcher
			dispatcher = new EventDispatcher();

			// Loading handler
			var ldr:URLLoader = new URLLoader();
			ldr.load(new URLRequest(fileName));
			ldr.addEventListener(Event.COMPLETE, parseaMapa);

			/*pathPoint.graphics.lineStyle(1);
			pathPoint.graphics.beginFill(0xFFFFFF);
			pathPoint.graphics.drawCircle(0,0,15);*/
		}

		// Get map size
		public function getMapSize(){
			return new Point(mapArray[0].length,mapArray.length);
		}

		// Parse from txt file to array
		public function parseaMapa(e:Event):void
		{
			var windowsNewline:RegExp = /\r\n/g;
			var rawMap:String = URLLoader(e.target).data.replace(windowsNewline,'\n');
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
			dispatcher.dispatchEvent(new Event("mapaLoaded"));
		}


		public function tileToPixel(x:Number, y:Number){
			var xpos = (x * _tileSize) + (_tileSize/2);
			var ypos = (y * _tileSize) + (_tileSize/2);
			return new Point(xpos,ypos);
		}


		public function pixelToTile(px:Number, py:Number){
			var xpos = Math.floor((px) /_tileSize);
			var ypos = Math.floor((py) / _tileSize);

			return new Point(xpos,ypos);
		}

		public function getTileAtPoint(xpos:Number, ypos:Number){
			// If on map limits return neutral space
			var s:Point = this.getMapSize();
			if((xpos >= 0 && xpos < s.x) && (ypos >= 0 && ypos < s.y)){
				return mapArray[ypos][xpos];
			}
			return new Item(Constants.NEUTRAL);
		}

		public function getTileSize(){
			return _tileSize;
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
					gameArray[i][j] = new Item(mapArray[i][j].getType());
					if(gameArray[i][j] != null){
						gameArray[i][j].x = (_tileSize * j);
						gameArray[i][j].y = (_tileSize * i);
						graphicsMap.addChild(gameArray[i][j]);
					}
				}
			}
			zig = new ZigZagMatrix(mapArray);
			//graphicsMap.addChild(pathPoint);
		}

		public function getRandomPoint(exclude:Point){
			var rdn:Number = Math.abs(Math.round(Math.random() * _validPosCache.length - 1));
			var p:Point = new Point(_validPosCache[rdn][0],_validPosCache[rdn][1]);
			while(p.equals(exclude)){
				rdn = Math.abs(Math.round(Math.random() * _validPosCache.length - 1));
				p = new Point(_validPosCache[rdn][0],_validPosCache[rdn][1]);
			}
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
							dispatcher.dispatchEvent(new Event("eatPac"));
						break;
						case Constants.POWERUP:
							dispatcher.dispatchEvent(new Event("eatPowerUp"));
						break;
					}
					graphicsMap.removeChild(gameArray[p.y][p.x]);
					gameArray[p.y][p.x] = new Item(Constants.NEUTRAL);
					eatedItems--;

					if(eatedItems <= 0){
						dispatcher.dispatchEvent(new Event("pacmanWins"));
					}
				}
			}
		}

		public function getGraphicsImplement(){
			return graphicsMap;
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