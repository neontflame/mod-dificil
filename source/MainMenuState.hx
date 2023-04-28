package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	var curMenuEpico:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var musicShitYeah:Array<String> = ['mod-dificil', 'story mode', 'story mode', 'story mode'];

	var optionShit:Array<String> = ['freeplay', 'options'];

	var newGaming:FlxText;
	var newGaming2:FlxText;
	var newInput:Bool = true;

	public static var kadeEngineVer:String = "1.3.1";
	public static var gameVer:String = "0.2.7.1";

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	// the menu funny
	var menuFunny:FlxSprite;
	var menuestTextFunny:FlxSprite;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBGBlue'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuBGMagenta'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		// add(menuItems);

		// the uhh awesome
		var menuFunnyTex = Paths.getSparrowAtlas('menu/bagulhoEuAcho');

		menuFunny = new FlxSprite(248, -230);
		menuFunny.frames = menuFunnyTex;
		menuFunny.animation.addByPrefix('menu0', 'menuepico', 60, false);
		menuFunny.animation.addByPrefix('menu1', 'restoepico', 60, false);
		menuFunny.animation.play('menu0');
		menuFunny.antialiasing = true;
		menuFunny.screenCenter();
		menuFunny.scrollFactor.set();
		add(menuFunny);

		// os texto foda
		var textestMostLikely = Paths.getSparrowAtlas('menu/textoDoMenu');

		menuestTextFunny = new FlxSprite(348, 230);
		menuestTextFunny.frames = textestMostLikely;
		menuestTextFunny.animation.addByPrefix('menu00', 'menuParte1', 60, false);
		menuestTextFunny.animation.addByPrefix('menu01', 'menuParte2', 60, false);
		menuestTextFunny.animation.addByPrefix('menu02', 'menuParte3', 60, false);
		menuestTextFunny.animation.addByPrefix('menu10', 'menuPar1', 60, false);
		menuestTextFunny.animation.addByPrefix('menu11', 'menuPar2', 60, false);
		menuestTextFunny.animation.play('menu00');
		menuestTextFunny.antialiasing = true;
		menuestTextFunny.scrollFactor.set();
		add(menuestTextFunny);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "mod difííííc´l rhgahhj!!!! v3 - " + kadeEngineVer + " Kade Engine", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
				menuestTextFunny.animation.play('menu' + curMenuEpico + curSelected);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
				menuestTextFunny.animation.play('menu' + curMenuEpico + curSelected);
			}

			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItemFunny(0);
				menuFunny.animation.play('menu0');
				menuestTextFunny.animation.play('menu' + curMenuEpico + curSelected);
			}

			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItemFunny(1);
				menuFunny.animation.play('menu1');
				menuestTextFunny.animation.play('menu' + curMenuEpico + curSelected);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					#if linux
					Sys.command('/usr/bin/xdg-open', ["https://ninja-muffin24.itch.io/funkin", "&"]);
					#else
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
					#end
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = musicShitYeah[curSelected];

								if (curMenuEpico == 0)
								{
									daChoice = musicShitYeah[0];
								}

								if (curMenuEpico == 1)
								{
									daChoice = optionShit[curSelected];
								}

								switch (daChoice)
								{
									// codigo???? eu acho???????? sao 3:29 da manha eu preciso dormir
									case 'mod-dificil':
										PlayState.storyPlaylist = ['mod-dificil'];
										PlayState.isStoryMode = true;
										PlayState.storyDifficulty = 1;
										PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase(), PlayState.storyPlaylist[0].toLowerCase());
										LoadingState.loadAndSwitchState(new PlayState(), true);
										trace("GRRRRRR Selected");

									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");

									case 'freeplay':
										FlxG.switchState(new CustomFreeplayState());

										trace("Freeplay Menu Selected");

									case 'options':
										FlxG.switchState(new OptionsMenu());
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curMenuEpico == 0)
			if (curSelected >= musicShitYeah.length - 1)
				curSelected = 0;
		if (curSelected < 0)
			curSelected = musicShitYeah.length - 2;

		if (curMenuEpico == 1)
			if (curSelected >= optionShit.length)
				curSelected = 0;
		if (curSelected < 0)
			curSelected = optionShit.length - 1;
	}

	function changeItemFunny(huh:Int = 0)
	{
		curMenuEpico = huh;
		curSelected = 0;
	}
}
