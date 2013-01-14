/*
Project: Pacman
Authors: Marc Pomar & Laura Cotrina.
Description:
	Scoreboard shows lives and score
*/

package contingutsMultimedia {	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import contingutsMultimedia.Constants;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.GlowPlugin;


	import com.gskinner.motion.easing.*;

	public class Scoreboard extends MovieClip{

		// Data 
		public var lives:Number;
		public var score:Number;
		public var level:Number;

		// Displays
		public var scoreText:TextField;
		public var levelText:TextField;
		public var livesArray:Array;
		public var speakerButton:MovieClip;
		public var myformat:TextFormat;

		//Filter
		var glow:GlowFilter;


		public function Scoreboard(){
			// Setup lives
			lives = Constants.GAMESTARTLIVES;

			// Setup score
			score = 0;
			scoreText = new TextField();
			scoreText.mouseEnabled = false;
			scoreText.autoSize = TextFieldAutoSize.LEFT;

			// Setup level
			level = 1;
			levelText = new TextField();
			levelText.mouseEnabled = false;
			levelText.autoSize = TextFieldAutoSize.LEFT;

			// Score & Level text format
			myformat = new TextFormat();
			myformat.color = 0xFFFFFF;
			myformat.size = 30;
			myformat.font = new ScoreFont().fontName;
			scoreText.defaultTextFormat = myformat;
			levelText.defaultTextFormat = myformat;

			// Glow filter
			// Initialize glow plugin
			GlowPlugin.install();
			glow = new GlowFilter();
			glow.color = 0xff0000;
			glow.alpha = 1;
			glow.blurX = 20;
			glow.blurY = 20;
			glow.strength = 0;
			glow.quality = BitmapFilterQuality.MEDIUM;
			levelText.filters=[glow];

			// Speaker button
			speakerButton = new muteClip();
			speakerButton.addEventListener(MouseEvent.CLICK, function(){
				dispatchEvent(new Event("toggleMute"));
			});

			// Add to clip
			this.addChild(scoreText);
			this.addChild(levelText);
			this.addChild(speakerButton);
		}

		public function reset(){
			// Reset data
			score = 0;
			lives = Constants.GAMESTARTLIVES;
			level = 1;
			// Reset score & score positioning
			scoreText.text = "Score: " + String(score);
			scoreText.x = 0;
			scoreText.y = 0;

			// Reset level field
			levelText.text = "Level: " + String(level);
			levelText.x = 200;
			levelText.y = 0;

			// Reset lives
			livesArray = new Array();
			var offset:Point = new Point(stage.stageWidth,0);
			for(var i:uint = 0; i < Constants.GAMESTARTLIVES; i++){
				var liv = new PacmanClip();
				liv.gotoAndStop(4);
				liv.x = offset.x - (25*i) - liv.width;
				liv.y = offset.y;
				livesArray.push(liv);
				this.addChild(liv);
			}

			// Speaker button
			speakerButton.x = offset.x - (25*Constants.GAMESTARTLIVES)- speakerButton.width - 20;
			speakerButton.scale = 0.5;
		}

		public function addScore(s:Number){
			score += s;
			scoreText.text = "Score: " + String(score);
		}

		public function processFilter(e:Event):void{
				scoreText.filters=[glow];
		}

		public function addLevel(){
			level += 1;
			levelText.text = "Level: " + String(level);

			var gTween2:GTween = new GTween(levelText,1,{strength:0},{autoPlay:false,delay:1,ease:Sine.easeOut});
			var gTween:GTween = new GTween(levelText,1,{strength:3},{nextTween:gTween2,ease:Sine.easeIn});
		}

		public function showMeTheScore(p:Point){
			var tween:GTween = new GTween(this.scoreText,3,
				{x:p.x - this.scoreText.width/2,y:p.y},
				{ease:Sine.easeIn}
			);
			var tween2:GTween = new GTween(this.levelText,3,
				{x:p.x - (this.levelText.width/2) ,y:(p.y + this.scoreText.height)},
				{ease:Sine.easeIn}
			);
		}

		public function showMeTheLevel(callback:Function){
			var tween3:GTween = new GTween(this.levelText,1,
				{x:200, y:0},
				{autoPlay:false,delay:1,ease:Sine.easeOut,onComplete:callback}
			);

			var tween2:GTween = new GTween(this.levelText,1,
				{x:(stage.stageWidth/2) - (this.levelText.width/2), 
				 y:(stage.stageHeight/2) - (this.levelText.height/2)
				 },
				{nextTween:tween3,ease:Sine.easeIn}
			);
		}

		public function setMuteBt(b:Boolean){
			if(b){
				speakerButton.gotoAndStop(2);
			}else{
				speakerButton.gotoAndStop(1);
			}
		}

		public function hasLives(){
			return (lives > 0);
		}

		public function removeLive(){
			var liv = livesArray.pop();
			if(liv != null){
				var tween:GTween = new GTween(liv,0.4,
						{alpha:0.0},
						{ease:Sine.easeOut,
						onComplete:function(){
							removeChild(liv);
						}}
					);
				lives--;
			}
		}
	}
}