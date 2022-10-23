package;

import flixel.FlxG;
import flixel.system.FlxSound;
import meta.data.*;
import meta.state.menus.MainMenuState;
import openfl.utils.Assets;
import sys.FileSystem;

/**
	This class is used as an extension to many other forever engine stuffs, please don't delete it as it is not only exclusively used in forever engine
	custom stuffs, and is instead used globally.
**/
class ForeverTools
{
	public static var menuNumba:Int;
	// set up maps and stuffs
	public static function resetMenuMusic(resetVolume:Bool = false)
	{
		// make sure the music is playing
		if (((FlxG.sound.music != null) && (!FlxG.sound.music.playing)) || (FlxG.sound.music == null))
		{
			
			var song = (Paths.music(''));
			menuNumba = FlxG.random.int(1, 4);
			
			switch (menuNumba)
			{
				case 2, 4, 6:
					song = (Paths.music('menu/freakyMenuDRAZ'));
					FlxG.sound.playMusic(song, (resetVolume) ? 0 : 0.7);
				default:
					song = (Paths.music('menu/freakyMenu'));
					FlxG.sound.playMusic(song, (resetVolume) ? 0 : 0.7);
					
			}
			if (resetVolume)
				FlxG.sound.music.fadeIn(4, 0, 0.7);
			// placeholder bpm
			Conductor.changeBPM(160);
		}
		//
	}

	public static function returnSkinAsset(asset:String, assetModifier:String = 'base', changeableSkin:String = 'default', baseLibrary:String,
			?defaultChangeableSkin:String = 'default', ?defaultBaseAsset:String = 'base'):String
	{
		var realAsset = '$baseLibrary/$changeableSkin/$assetModifier/$asset';
		if (!Assets.exists(Paths.getPath('images/' + realAsset + '.png', IMAGE)))
		{
			realAsset = '$baseLibrary/$defaultChangeableSkin/$assetModifier/$asset';
			if (!Assets.exists(Paths.getPath('images/' + realAsset + '.png', IMAGE)))
				realAsset = '$baseLibrary/$defaultChangeableSkin/$defaultBaseAsset/$asset';
		}

		return realAsset;
	}

	public static function killMusic(songsArray:Array<FlxSound>)
	{
		// neat function thing for songs
		for (i in 0...songsArray.length)
		{
			// stop
			songsArray[i].stop();
			songsArray[i].destroy();
		}
	}
}
