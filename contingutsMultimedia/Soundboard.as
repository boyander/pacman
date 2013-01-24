/*
Project: Pacman
Authors: Marc Pomar & Laura Cotrina.
Description:
	Manages soundFX
*/

package contingutsMultimedia {	
	import flash.utils.Dictionary;
	import flash.media.Sound;
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.media.SoundMixer;

	class Soundboard{

		// SoundFX dictionary of sound arrays;
		private var soundFX:Dictionary;
		// Sound channel
		var channel:SoundChannel;
		// Sound transform for volume control
		var volumeAdjust:SoundTransform;


		public function Soundboard(){
			soundFX = new Dictionary();
			channel = new SoundChannel();
			volumeAdjust = new SoundTransform();
			volumeAdjust.volume = 1.0;
		}

		public function addSound(e:String,files:Array){
			soundFX[e] = new Array();
			for(var i:uint; i < files.length; i++){
				var file = files[i];
				var s:Sound = new Sound();
				s.load(new URLRequest(file));
				soundFX[e].push(s);
			}
		}

		public function playSound(e:String,loop:Boolean=false){
			// Get a random audio file and assign to channel
			var rnd = Math.floor(Math.random()*(soundFX[e].length));
			channel = soundFX[e][rnd].play();
			if(loop){
				channel.addEventListener(Event.SOUND_COMPLETE, function(){
					playSound(e,loop);
				});
			}
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

		public function stopAll(){
			SoundMixer.stopAll();
		}

		public function loadSounds(){
			this.addSound(Constants.EVENT_EATPOWERUP,["audios/chili.mp3"]);
			this.addSound(Constants.EVENT_EATPAC,["audios/eat_pac.mp3"]);
			this.addSound(Constants.EVENT_PACMANDIES,["audios/pacman_dies.mp3"]);
			this.addSound(Constants.EVENT_EATGHOST,["audios/eat_pac2.mp3"]);
			this.addSound(Constants.EVENT_GAMEOVER,[
										"audios/nucelar.mp3",
										"audios/poli_prostituta.mp3",
										"audios/trabajo_por_dinero.mp3",
										"audios/pilas.mp3",
										"audios/homer_malo.mp3",
										"audios/bocadillo.mp3",
										"audios/corre_platano.mp3",
										"audios/homer_feliz.mp3",
										"audios/tu_patata.mp3",
										"audios/tipo_de_incognito.mp3",
										"audios/vamonos_atomos.mp3",
										]);
			this.addSound('BGS',["audios/pacman_bgsound_marc.mp3"]);
		}

	}

}