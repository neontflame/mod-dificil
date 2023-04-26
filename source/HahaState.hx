package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
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

class HahaState extends MusicBeatState
{
    override public function create():Void
    {
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("teste foda epico eu acho", null);
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
		
		// fazer um engraçado
		var fodase:FlxText = new FlxText(FlxG.width/3, FlxG.height/2, 0, "Caralho", 30);
		fodase.scrollFactor.set();
		fodase.setFormat("VCR OSD Mono", 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fodase);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
		
		// volta pro menu
		if (controls.BACK)
			{
				FlxG.switchState(new MainMenuState());
			}
    }
}