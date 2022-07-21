package meta.state.menus;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import meta.MusicBeat.MusicBeatState;
import meta.data.dependency.Discord;
import meta.data.dependency.FNFSprite;

using StringTools;

/**
	This is the main menu state! Not a lot is going to change about it so it'll remain similar to the original, but I do want to condense some code and such.
	Get as expressive as you can with this, create your own menu!
**/
class MainMenuState extends MusicBeatState
{
	var menuItems:FlxTypedGroup<FNFSprite>;
	var curSelected:Float = 0;

	var bg:FlxSprite; // the background has been separated for more control
	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var shading:FlxSprite;

	var overlayTOP:FlxSprite;
	var overlayBOTTOM:FlxSprite;
	var overlayCG:FlxSprite;
	var credit:FlxSprite;

	var checker1:FlxSprite;
	var checker2:FlxSprite;

	var optionShit:Array<String> = ['freeplay', 'options'];
	var canSnap:Array<Float> = [];

	public static var menuCG:Int;

	// the create 'state'
	override function create()
	{
		super.create();

		menuCG = FlxG.random.int(1, 3);
		// set the transitions to the previously set ones

		// make sure the music is playing
		ForeverTools.resetMenuMusic();

		#if !html5
		Discord.changePresence('MENU SCREEN', 'Main Menu');
		#end

		// uh
		persistentUpdate = persistentDraw = true;

		// background
		bg = new FlxSprite(-85);
		bg.loadGraphic(Paths.image('menus/base/menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		checker1 = new FlxSprite(-85);
		checker1.loadGraphic(Paths.image('menus/base/backgroundMOVING1'));
		checker1.updateHitbox();
		checker1.screenCenter();
		checker1.antialiasing = true;
		FlxTween.tween(checker1, {y: checker1.y - 600}, 8, {type: FlxTweenType.LOOPING, loopDelay: 0});
		FlxTween.tween(checker1, {x: checker1.x + 600}, 32.5, {type: FlxTweenType.LOOPING, loopDelay: 0});
		checker1.alpha = 0.5;
		add(checker1);

		checker2 = new FlxSprite(-85);
		checker2.loadGraphic(Paths.image('menus/base/backgroundMOVING2'));
		checker2.updateHitbox();
		checker2.screenCenter();
		checker2.antialiasing = true;
		FlxTween.tween(checker2, {y: checker2.y + 600}, 8.5, {type: FlxTweenType.LOOPING, loopDelay: 0});
		FlxTween.tween(checker2, {x: checker2.x + 600}, 16.5, {type: FlxTweenType.LOOPING, loopDelay: 0});
		checker2.alpha = 0.5;
		add(checker2);

		shading = new FlxSprite();
		shading.loadGraphic(Paths.image('menus/base/Shading'));
		shading.updateHitbox();
		shading.screenCenter();
		shading.antialiasing = true;
		add(shading);

		overlayTOP = new FlxSprite();
		overlayTOP.loadGraphic(Paths.image('menus/base/overlayTOP'));
		overlayTOP.screenCenter();
		overlayTOP.y -= 255;
		FlxTween.tween(overlayTOP, {y: -500}, 1.5, {type: FlxTweenType.BACKWARD, ease: FlxEase.expoOut, loopDelay: 0});
		add(overlayTOP);

		overlayCG = new FlxSprite();
		switch (ForeverTools.menuNumba)
		{
			case 1:
				overlayCG.loadGraphic(Paths.image('menus/base/overlayCG/overlayCG0'));
			case 2:
				overlayCG.loadGraphic(Paths.image('menus/base/overlayCG/overlayCG1'));
			case 3:
				overlayCG.loadGraphic(Paths.image('menus/base/overlayCG/overlayCG2'));
			case 4:
				overlayCG.loadGraphic(Paths.image('menus/base/overlayCG/overlayCG3'));
			case 5:
				overlayCG.loadGraphic(Paths.image('menus/base/overlayCG/overlayCG4'));
			case 6:
				overlayCG.loadGraphic(Paths.image('menus/base/overlayCG/overlayCG5'));
			case 7:
				overlayCG.loadGraphic(Paths.image('menus/base/overlayCG/overlayCG6'));
		}
		
		overlayCG.screenCenter();
		overlayCG.scale.set(0.5,0.5);
		overlayCG.x += 250;
		FlxTween.tween(overlayCG, {x: 1500}, 2, {type: FlxTweenType.BACKWARD, ease: FlxEase.backOut, loopDelay: 0});
		FlxTween.tween(overlayCG, {y: overlayCG.y + 10}, 4, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut, loopDelay: 0});
		add(overlayCG);

		overlayBOTTOM = new FlxSprite();
		overlayBOTTOM.loadGraphic(Paths.image('menus/base/overlayBOTTOM'));
		overlayBOTTOM.screenCenter();
		overlayBOTTOM.y += 255;
		FlxTween.tween(overlayBOTTOM, {y: 1000}, 1.5, {type: FlxTweenType.BACKWARD, ease: FlxEase.expoOut, loopDelay: 0});
		add(overlayBOTTOM);

		credit = new FlxSprite(0, 500);
		credit.loadGraphic(Paths.image('menus/base/credit'));
		credit.screenCenter(X);
		credit.x += 410;
		add(credit);

		magenta = new FlxSprite(-85).loadGraphic(Paths.image('menus/base/menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);

		// add the camera
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		// add the menu items
		menuItems = new FlxTypedGroup<FNFSprite>();
		add(menuItems);

		// create the menu items themselves
		var tex = Paths.getSparrowAtlas('menus/base/title/FNF_main_menu_assets');

		// loop through the menu options
		for (i in 0...optionShit.length)
		{
			var menuItem:FNFSprite = new FNFSprite(-400, 180 + (i * 200));
			menuItem.frames = tex;
			// add the animations in a cool way (real
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			
			canSnap[i] = -1;
			// set the id
			menuItem.ID = i;
			
			if (menuItem.ID == 1)
				menuItem.addOffset('selected', -20, -40);
			// menuItem.alpha = 0;

			// placements
			// if the id is divisible by 2
			if (menuItem.ID % 2 == 0)
				menuItem.x += 1000;
			else
				menuItem.x -= 1000;

			// actually add the item
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			menuItem.updateHitbox();

			/*
				FlxTween.tween(menuItem, {alpha: 1, x: ((FlxG.width / 2) - (menuItem.width / 2))}, 0.35, {
					ease: FlxEase.smootherStepInOut,
					onComplete: function(tween:FlxTween)
					{
						canSnap[i] = 0;
					}
			});*/
		}

		// set the camera to actually follow the camera object that was created before
		
		var camLerp = Main.framerateAdjust(0.10);
		
		updateSelection();

		// from the base game lol

		//
		menuItems.forEach(function(menuItem:FlxSprite)
		{
			menuItem.screenCenter(X);
			switch(menuItem.ID)
			{
				case 0:
					menuItem.x -= 350;
				case 1:
					menuItem.x -= 440;
			}
		});

		#if android
		addVirtualPad(LEFT_FULL, A_B);
		#end
	}

	// var colorTest:Float = 0;
	var selectedSomethin:Bool = false;
	var counterControl:Float = 0;

	override function update(elapsed:Float)
	{
		// colorTest += 0.125;
		// bg.color = FlxColor.fromHSB(colorTest, 100, 100, 0.5);

		var up = controls.UI_UP;
		var down = controls.UI_DOWN;
		var up_p = controls.UI_UP_P;
		var down_p = controls.UI_DOWN_P;
		var left = controls.UI_LEFT;
		var right = controls.UI_RIGHT;

		var controlArray:Array<Bool> = [up, down, up_p, down_p];

		if ((controlArray.contains(true)) && (!selectedSomethin))
		{
			
			
			for (i in 0...controlArray.length)
			{
				// here we check which keys are pressed
				if (controlArray[i] == true)
				{
					// if single press
					if (i > 1)
					{
						// up is 2 and down is 3
						// paaaaaiiiiiiinnnnn
						if (i == 2)
							curSelected--;
						else if (i == 3)
							curSelected++;

						FlxG.sound.play(Paths.sound('scrollMenu'));
					}
					/* idk something about it isn't working yet I'll rewrite it later
						else
						{
							// paaaaaaaiiiiiiiinnnn
							var curDir:Int = 0;
							if (i == 0)
								curDir = -1;
							else if (i == 1)
								curDir = 1;

							if (counterControl < 2)
								counterControl += 0.05;

							if (counterControl >= 1)
							{
								curSelected += (curDir * (counterControl / 24));
								if (curSelected % 1 == 0)
									FlxG.sound.play(Paths.sound('scrollMenu'));
							}
					}*/

					if (curSelected < 0)
						curSelected = optionShit.length - 1;
					else if (curSelected >= optionShit.length)
						curSelected = 0;
				}
				//
			}
		}
		else
		{
			// reset variables
			counterControl = 0;
		}
		if ((controls.RIGHT) && (!selectedSomethin))
			Main.switchState(this, new StoryMenuState());
		
		if ((controls.ACCEPT) && (!selectedSomethin))
		{
			//
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			menuItems.forEach(function(spr:FlxSprite)
			{
				if (curSelected != spr.ID)
				{
					FlxTween.tween(spr, {x: spr.x - 1000}, 0.5, {
						type: FlxTweenType.ONESHOT,
						ease: FlxEase.backIn,
						onComplete: function(twn:FlxTween)
						{
							spr.kill();
						}
					});
				}
				else
				{
					new FlxTimer().start(1, function(tmr:FlxTimer) {
						var daChoice:String = optionShit[Math.floor(curSelected)];

						switch (daChoice)
						{		
							case 'freeplay':
								Main.switchState(this, new FreeplayState());
							case 'options':
								Main.switchState(this, new OptionsMenuState());
						}
					});
				}
			});
		}

		if (Math.floor(curSelected) != lastCurSelected)
			updateSelection();

		super.update(elapsed);
	}

	var lastCurSelected:Int = 0;

	private function updateSelection()
	{
		// reset all selections
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();
		});

		// set the sprites and all of the current selection
		camFollow.setPosition(menuItems.members[Math.floor(curSelected)].getGraphicMidpoint().x,
			menuItems.members[Math.floor(curSelected)].getGraphicMidpoint().y);

		if (menuItems.members[Math.floor(curSelected)].animation.curAnim.name == 'idle')
			menuItems.members[Math.floor(curSelected)].animation.play('selected');

		menuItems.members[Math.floor(curSelected)].updateHitbox();

		lastCurSelected = Math.floor(curSelected);
	}
}
