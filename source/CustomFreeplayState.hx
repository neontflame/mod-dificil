package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.addons.transition.FlxTransitionableState;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
#if desktop
import Discord.DiscordClient;
#end

class CustomFreeplayState extends MusicBeatState
{
	var songs:Array<SongMeta> = [];
	
	var curSelected:Int = 0;
	
	var songNameText:FlxText;
	var scoreText:FlxText;
	var descText:FlxText;
	var portraitFoda:FlxSprite;
	
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	
	override public function create():Void
	{	

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		
		addSong('tutorial', 'tutorial', '"aprenda a como funkar"\nSOURCE: Jogo Base');		
		addSong('mod-dificil', 'mod-dificil', '"esse ai e dificil"');
		addSong('mod-ereto', 'mod-ereto', '"esse ai tb e dificil"');
		addSong('mod-ereto-ereto', 'mod-max-ereto', '"esse ai nem te conto"\nCOMPOSITOR: Dex Dousky');
		addSong('jack', 'jack', '"Aff... ¬¬ Tudo é indireta hoje em dia"');
		addSong('no-refunds', 'no-refunds', '"narigao extorna 30 quid da yotsuba e sai ileso"\nSOURCE: Gartic Phone');
		addSong('scratch-things', 'scratch-things', '"Ola novamente gente!"\nSOURCE: Coisas do Scratch');
		addSong('cbat', 'cbat', '"KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK"\nSOURCE: Hudson Mohawke - Cbat');


		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		// put in the fuckin background!!! bitch
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBGBlue'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var magenta:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBGMagenta'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.antialiasing = true;
		magenta.visible = false;
		add(magenta);
		
		// OS FUNNY LA DO MENU FREEPLAY EPICO
		// saca so
		var bagulho:FlxSprite = new FlxSprite(394, 82).loadGraphic(Paths.image('menu/outroBagulho'));
		bagulho.screenCenter(X);
		bagulho.antialiasing = true;
		
		songNameText = new FlxText(610, 384, 0, "", 32);
		songNameText.setFormat(Paths.font("donegal.ttf"), 48, FlxColor.BLACK, LEFT);
		
		scoreText = new FlxText(680, 448, 0, "", 32);
		scoreText.setFormat(Paths.font("donegal.ttf"), 48, FlxColor.BLACK, LEFT);
		
		descText = new FlxText(FlxG.width * 0.5, 542, 0, "", 32);
		descText.setFormat(Paths.font("donegal.ttf"), 32, FlxColor.BLACK, CENTER);
		
		portraitFoda = new FlxSprite(427, 122);
		portraitFoda.frames = Paths.getSparrowAtlas('menu/freeplayPortraits');
		
		for (i in 0...songs.length)
		{
			portraitFoda.animation.addByPrefix(Std.string(songs[i].songBanner), Std.string(songs[i].songBanner), 60, false);
		}
		
		portraitFoda.animation.play(Std.string(songs[0].songBanner));
		portraitFoda.antialiasing = true;
		portraitFoda.screenCenter(X);
		portraitFoda.scrollFactor.set();
		
		add(bagulho);
		add(portraitFoda);
		
		add(songNameText);
		add(scoreText);
		add(descText);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		
		// CODIGO FODA UHUUUUUUUUUUUU
		if (songNameText.text != songs[curSelected].songName) {
			songNameText.text = songs[curSelected].songName;
		}
		
		if (songNameText.width > 274) {
			songNameText.scale.x = 274 / songNameText.width;
			songNameText.x = 610 - ((songNameText.width - 274)/2);
		} else {
			songNameText.scale.x = 1;
			songNameText.x = 610;
		}
		
		if (portraitFoda.animation.curAnim.name != Std.string(songs[curSelected].songBanner)) {
			portraitFoda.animation.play(Std.string(songs[curSelected].songBanner));
		}
		
		if (descText.text != (songs[curSelected].songDesc)) {
			descText.text = songs[curSelected].songDesc;
			descText.screenCenter(X);
		}
		// texto de pontuaçao
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		
		// loophole epico pro bagulho achar q tem Texto Real (nao tem)
		scoreText.text = Std.string(lerpScore);

		// controles epico
		if (controls.LEFT_P)
			changeSelection(-1);
		if (controls.RIGHT_P)
			changeSelection(1);

		if (controls.ACCEPT)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);
			FlxFlicker.flicker(magenta, 1.1, 0.15, false);
					
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), 1);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = 1;
			PlayState.storyWeek = 0;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState());
		}
		
		// volta pro menu
		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}
	}
	
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;
		intendedScore = Highscore.getScore(songs[curSelected].songName, 1);
		// lerpScore = 0;

		#if PRELOAD_ALL
		//Conductor.changeBPM(Song.loadFromJson(Highscore.formatSong(songs[curSelected].songName, 1), songs[curSelected].songName.toLowerCase()).bpm);
		//FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;
	}
	
	public function addSong(songName:String, songBanner:String, songDesc:String)
	{
		songs.push(new SongMeta(songName, songBanner, songDesc));
	}
}

class SongMeta
{
	public var songName:String = "";
	public var songBanner:String = "";
	public var songDesc:String = "";
	
	public function new(song:String, songBanner:String, songDesc:String)
	{
		this.songName = song;
		this.songBanner = songBanner;
		this.songDesc = songDesc;
	}
}

