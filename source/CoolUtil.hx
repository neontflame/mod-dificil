package;

import flixel.FlxG;
import lime.utils.Assets;
import openfl.utils.Assets as OpenFLAssets;
import openfl.system.System;
import flixel.system.FlxSound;
import flixel.system.FlxAssets.FlxSoundAsset;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = ['EASY', "NORMAL", "HARD"];

	public static function difficultyString():String
	{
		return difficultyArray[PlayState.storyDifficulty];
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function coolStringFile(path:String):Array<String>
	{
		var daList:Array<String> = path.trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}

		return daList;
	}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
	}
	
	/**
	 * Clears all images and sounds from the cache.
	 * @author swordcube
	 * modified by neon a tad lil bit to fit my use case a bit more
	 */
	public inline static function clearCache(assets:Bool = true, bitmaps:Bool = true, sounds:Bool = false, garbageCollector:Bool = true) {
		
		if (assets) {
			// Clear OpenFL & Lime Assets
			OpenFLAssets.cache.clear();
			Assets.cache.clear();
			trace('asset cache cleared i think');
		} 
		
		if (bitmaps) {
			// Clear all Flixel bitmaps
			FlxG.bitmap.dumpCache();
			FlxG.bitmap.clearCache();
			trace('bitmap cache cleared too');
		}
		
		if (sounds) {
			// Clear all Flixel sounds
			FlxG.sound.list.forEach((sound:FlxSound) -> {
				sound.stop();
				sound.kill();
				sound.destroy();
				trace('fuck you sound');
			});
			FlxG.sound.list.clear();
			FlxG.sound.destroy(false);
		trace('sound cache cleared mhm');
		}
		
		if (garbageCollector) {
			// Run garbage collector just in case none of that worked
			System.gc();
			trace('here comes the garbage truck woo');
			}
	}
}
