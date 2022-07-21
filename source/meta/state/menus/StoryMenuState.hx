package meta.state.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import gameObjects.userInterface.menu.*;
import meta.MusicBeat.MusicBeatState;
import meta.data.*;
import meta.data.Conductor;
import meta.data.dependency.Discord;
import sys.ssl.Key;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [true, true, true, true, true, true, true];

	var weekCharacters:Array<Dynamic> = [
		['', 'bf', 'gf'],
		['dad', 'bf', 'gf'],
		['spooky', 'bf', 'gf'],
		['pico', 'bf', 'gf'],
		['mom', 'bf', 'gf'],
		['parents-christmas', 'bf', 'gf'],
		['senpai', 'bf', 'gf']
	];

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;
	
	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var upArrow:FlxSprite;
	var downArrow:FlxSprite;

	var bg:FlxSprite;
	var shading:FlxSprite;
	var overlayTOP:FlxSprite;
	var overlayBOTTOM:FlxSprite;
	var overlayCG:FlxSprite;
	var checker1:FlxSprite;
	var checker2:FlxSprite;

	override function create()
	{
		super.create();
		
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		#if !html5
		Discord.changePresence('CREDITS', 'Main Menu');
		#end
		// freeaaaky

		persistentUpdate = persistentDraw = true;

		var ui_tex = Paths.getSparrowAtlas('menus/base/storymenu/campaign_menu_UI_assets');
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
		
		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		for (i in 0...Main.gameWeeks.length)
		{
			var weekThing:MenuItem = new MenuItem(0, 300, i);
			weekThing.x += ((weekThing.width - 1500));
			weekThing.targetY = i;
			grpWeekText.add(weekThing);
			weekThing.credit.screenCenter();
			weekThing.week.x -= 260;
			weekThing.week.y -= 100;
			FlxTween.tween(weekThing.credit, {y: weekThing.credit.y + 10}, 4, {type: FlxTweenType.PINGPONG, ease: FlxEase.sineInOut, loopDelay: 0});
			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
		}

		trace("Line 96");

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		trace("Line 124");

		overlayBOTTOM = new FlxSprite();
		overlayBOTTOM.loadGraphic(Paths.image('menus/base/overlayBOTTOM'));
		overlayBOTTOM.screenCenter();
		overlayBOTTOM.y += 255;
		FlxTween.tween(overlayBOTTOM, {y: 1000}, 1.5, {type: FlxTweenType.BACKWARD, ease: FlxEase.expoOut, loopDelay: 0});
		add(overlayBOTTOM);
		
		leftArrow = new FlxSprite(0, grpWeekText.members[0].y);
		leftArrow.frames = ui_tex;
		leftArrow.screenCenter(X);
		leftArrow.x -= 450;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 220, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		for (i in CoolUtil.difficultyArray)
			sprDifficulty.animation.addByPrefix(i.toLowerCase(), i.toUpperCase());
		sprDifficulty.animation.play('easy');
		changeDifficulty();
		sprDifficulty.visible = false;
		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(0, leftArrow.y);
		rightArrow.screenCenter(X);
		//rightArrow.x += 0;
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);
		
		changeWeek();

		#if android
		addVirtualPad(LEFT_FULL, A_B);
		#end
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		
		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UI_LEFT_P)
					changeWeek(-1);
				else if (controls.UI_RIGHT_P)
					changeWeek(1);

				if (controls.UI_RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.UI_LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');
			}

			/*if (controls.ACCEPT && toggleCode == false)
				selectWeek();*/
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			Main.switchState(this, new MainMenuState());
		}

		if (curWeek == 0)
		{
			leftArrow.visible = false;
		}
		else
			leftArrow.visible = true;

		if (curWeek == 6)
		{
			rightArrow.visible = false;
		}
		else
			rightArrow.visible = true;
		
		super.update(elapsed);
	}
	
	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;
	
	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
				stopspamming = true;
			}

			PlayState.storyPlaylist = Main.gameWeeks[curWeek][0].copy();
			PlayState.isStoryMode = true;
			selectedWeek = true;

		/*	PlayState.storyDifficulty = curDifficulty;

			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase(), PlayState.storyPlaylist[0].toLowerCase());
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				Main.switchState(this, new PlayState());
			}); */
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		sprDifficulty.offset.x = 0;

		var difficultyString = CoolUtil.difficultyFromNumber(curDifficulty).toLowerCase();
		sprDifficulty.animation.play(difficultyString);
		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.offset.x = 20;
				sprDifficulty.offset.y = -100;
			case 1:
				sprDifficulty.offset.x = 70;
				sprDifficulty.offset.y = -100;
			case 2:
				sprDifficulty.offset.x = 20;
				sprDifficulty.offset.y = -100;
			case 3:
				sprDifficulty.offset.x = 85;
				sprDifficulty.offset.y = -70;

		}

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= Main.gameWeeks.length)
			curWeek = Main.gameWeeks.length - 1;
		if (curWeek < 0)
			curWeek = 0;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				FlxTween.tween(item, {alpha: 1}, 0.2, {type: FlxTweenType.ONESHOT, loopDelay: 0});
			else
				FlxTween.tween(item, {alpha: 0}, 0.2, {type: FlxTweenType.ONESHOT, loopDelay: 0});
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}
}
