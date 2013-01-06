/*
Project: Pacman
Authors: Marc Pomar & Laura Cotrina.
Description:
	Manages soundFX
*/

package contingutsMultimedia {	
	import flash.utils.Dictionary;
	import flash.media.Sound;
	import flash.net.URLRequest;

	class Soundboard{

		//SoundFX dictionarynew Dictionary();
		private var soundFX:Dictionary;


		public function Soundboard(){

			soundFX = new Dictionary();
		}

		public function addSound(e:String,file:String){
			var s:Sound = new Sound();
			s.load(new URLRequest(file));
			soundFX[e] = s;
		}

		public function playSound(e:String){
			soundFX[e].play();
		}

		public function loadSounds(){
			this.addSound(Constants.EVENT_EATPOWERUP,"audios/chili.mp3");
			this.addSound(Constants.EVENT_GAMEOVER,"audios/nucelar.mp3");
			this.addSound('BGS',"audios/bg_theme.mp3");
		}

	}

}