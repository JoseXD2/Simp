package gameObjects.userInterface.menu;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class MenuItem extends FlxSpriteGroup
{
	public var targetY:Float = 0;
	public var week:FlxSprite;
	public var credit:FlxSprite;

	public function new(x:Float, y:Float, weekNum:Int = 0)
	{
		super(x, y);
		credit = new FlxSprite().loadGraphic(Paths.image('menus/base/creditCG/overlayCG' + weekNum));
		credit.scale.set(0.5, 0.5);
		
		add(credit);
		week = new FlxSprite().loadGraphic(Paths.image('menus/base/storymenu/weeks/week' + weekNum));
		add(week);
	}

	var fakeFramerate:Int = Math.round((1 / FlxG.elapsed) / 10);

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		var lerpVal = Main.framerateAdjust(0.17);
		x = FlxMath.lerp(x, (targetY * 480) + 400, lerpVal);
	}
}

