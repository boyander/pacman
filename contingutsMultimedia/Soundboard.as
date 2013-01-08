/*
Project: Pacman
Authors: Marc Pomar & Laura Cotrina.
Description:
	Manages soundFX
*/

package contingutsMultimedia {	
	import flash.utils.Dictionary;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	class Soundboard{

		// SoundFX dictionarynew Dictionary();
		private var soundFX:Dictionary;
		// Sound channel
		var channel:SoundChannel;
		// Sound transform for volume control
		var volumeAdjust:SoundTransform;


		public function Soundboard(){
			soundFX = new Dictionary();
			channel = new SoundChannel();
			volumeAdjust = new SoundTransform();
		}

		public function addSound(e:String,file:String){
			var s:Sound = new Sound();
			s.load(new URLRequest(file));
			soundFX[e] = s;
		}

		public function playSound(e:String){
			channel = soundFX[e].play();
			// After start playing scale to current volume and mute if necessary
			channel.soundTransform = volumeAdjust;
		}

		public function setMute(b:Boolean){
			if(b){
				trace("Mute audio")
				volumeAdjust.volume = 0.0;
			}else{
				trace("Un-mute audio")
				volumeAdjust.volume = 1.0;
			}
			// Set volume adjust in case play were started early
			channel.soundTransform = volumeAdjust;
		}

		public function loadSounds(){
			this.addSound(Constants.EVENT_EATPOWERUP,"audios/chili.mp3");
			this.addSound(Constants.EVENT_GAMEOVER,"audios/nucelar.mp3");
			this.addSound(Constants.EVENT_EATPAC,"audios/eat_pac.mp3");
			this.addSound(Constants.EVENT_PACMANDIES,"audios/pacman_dies.mp3");

			//this.addSound('BGS',"audios/bg_theme.mp3");
		}

	}

}