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
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.easing.*;

	public class Scoreboard extends MovieClip{

		// Data 
		public var lives:Number;
		public var score:Number;
		public var level:Number;

		// Displays
		public var scoreText:TextField;
		public var livesArray:Array;


		public function Scoreboard(){
			// Setup lives
			lives = Constants.GAMESTARTLIVES;

			// Setup score
			score = 0;
			scoreText = new TextField();
			scoreText.mouseEnabled = false;
			scoreText.autoSize=TextFieldAutoSize.LEFT;

			// Score text format
			var myformat:TextFormat = new TextFormat();
			myformat.color = 0xFFFFFF;
			myformat.size = 30;
			myformat.font = new ScoreFont().fontName;
			scoreText.defaultTextFormat = myformat;

			// Reset Scoreboard
			this.reset();

			// Add to clip
			this.addChild(scoreText);
		}

		public function reset(){
			// Reset data
			score = 0;
			lives = Constants.GAMESTARTLIVES;
			// Reset score & score positioning
			scoreText.text = "Score: " + String(score);
			scoreText.x = 0;
			scoreText.y = 0;

			// Reset lives
			livesArray = new Array();
			var offset:Point = new Point(480,0);
			for(var i:uint = 0; i < Constants.GAMESTARTLIVES; i++){
				var liv = new PacmanClip();
				liv.gotoAndStop(4);
				liv.x = offset.x + (25*i);
				liv.y = offset.y;
				livesArray.push(liv);
				this.addChild(liv);
			}
		}

		public function addScore(s:Number){
			score += s;
			scoreText.text = "Score: " + String(score);
		}

		public function showMeTheScore(p:Point){
			var tween:GTween = new GTween(this.scoreText,3,
				{x:p.x - this.scoreText.width/2,y:p.y},
				{ease:Elastic.easeOut}
			);
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