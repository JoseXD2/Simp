package gameObjects;

import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import gameObjects.background.*;
import meta.CoolUtil;
import meta.data.Conductor;
import meta.data.dependency.FNFSprite;
import meta.state.PlayState;

using StringTools;

/**
	This is the stage class. It sets up everything you need for stages in a more organised and clean manner than the
	base game. It's not too bad, just very crowded. I'll be adding stages as a separate
	thing to the weeks, making them not hardcoded to the songs.
**/
class Stage extends FlxTypedGroup<FlxBasic>
{
	var halloweenBG:FNFSprite;
	var phillyCityLights:FlxTypedGroup<FNFSprite>;
	var phillyTrain:FNFSprite;
	var trainSound:FlxSound;

	public var limo:FNFSprite;

	public var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;

	var fastCar:FNFSprite;

	var upperBoppers:FNFSprite;
	var bottomBoppers:FNFSprite;
	var santa:FNFSprite;

	var bgGirls:BackgroundGirls;

	public var curStage:String;

	var daPixelZoom = PlayState.daPixelZoom;

	public var foreground:FlxTypedGroup<FlxBasic>;

	public static var ftween:FlxTween;

	public static var bg:FNFSprite;
	public static var stageFront:FNFSprite;
	public static var grid:FNFSprite;
	public static var grid2:FNFSprite;

	public function new(curStage)
	{
		super();
		this.curStage = curStage;

		/// get hardcoded stage type if chart is fnf style
		if (PlayState.determinedChartType == "FNF")
		{
			// this is because I want to avoid editing the fnf chart type
			// custom stage stuffs will come with forever charts
			switch (CoolUtil.spaceToDash(PlayState.SONG.song.toLowerCase()))
			{
				default:
					curStage = 'stage';
			}

			PlayState.curStage = curStage;
		}

		// to apply to foreground use foreground.add(); instead of add();
		foreground = new FlxTypedGroup<FlxBasic>();

		//
		switch (curStage)
		{
			default:
				PlayState.defaultCamZoom = 0.9;
				curStage = 'stage';
				bg = new FNFSprite(-150, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/Background'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.5, 0.5);
				bg.active = false;

				// add to the final array
				add(bg);

				var flash:FNFSprite = new FNFSprite(-150, -200).loadGraphic(Paths.image('backgrounds/' + curStage + '/flash'));
				flash.antialiasing = true;
				flash.scale.set(3000, 3000);
				flash.screenCenter(XY);
				flash.active = false;
				flash.alpha = 0.25;
				ftween = FlxTween.tween(flash, {alpha: 0}, 2, {type: FlxTweenType.PERSIST, ease: FlxEase.sineOut});

				add(flash);

				stageFront = new FNFSprite(0, 600).loadGraphic(Paths.image('backgrounds/' + curStage + '/Floor'));
				stageFront.scale.set(10, 10);
				stageFront.updateHitbox();
				stageFront.screenCenter(X);
				stageFront.antialiasing = true;
				stageFront.active = false;

				// add to the final array
				add(stageFront);

				grid = new FNFSprite(-400, -400).loadGraphic(Paths.image('backgrounds/' + curStage + '/grid'));
				grid.antialiasing = true;
				grid.scrollFactor.set(0.5, 0.5);
				grid.active = false;
				grid.alpha = 0;
				FlxTween.tween(grid, {y: -200}, 2, {type: FlxTweenType.LOOPING});

				add(grid);

				grid2 = new FNFSprite(-400, -400).loadGraphic(Paths.image('backgrounds/' + curStage + '/grid'));
				grid2.antialiasing = true;
				grid2.scrollFactor.set(0.1, 0.1);
				grid2.active = false;
				grid2.alpha = 0;
				FlxTween.tween(grid2, {y: -600}, 2, {type: FlxTweenType.LOOPING});

				add(grid2);
		}
	}

	// return the girlfriend's type
	public function returnGFtype(curSong)
	{
		var gfVersion:String = 'gf';

		switch (PlayState.SONG.song.toLowerCase())
		{
			
			case 'infatuated':
				gfVersion = 'itsumi';
			case 'heartbeat':
				gfVersion = 'biddlegf';
			default:
				gfVersion = 'gf';
		}

		return gfVersion;
	}

	// get the dad's position
	public function dadPosition(curStage, boyfriend:Character, dad:Character, gf:Character, camPos:FlxPoint):Void
	{
		var characterArray:Array<Character> = [dad, boyfriend];
		for (char in characterArray) {
			switch (char.curCharacter)
			{
				case 'gf':
					char.setPosition(gf.x, gf.y);
					gf.visible = false;			
			}
		}
	}

	public function repositionPlayers(curStage, boyfriend:Character, dad:Character, gf:Character):Void
	{
		// REPOSITIONING PER STAGE
		switch (curStage)
		{
			case 'highway':
				boyfriend.y -= 220;
				boyfriend.x += 260;
			case 'mall':
				boyfriend.x += 200;
				dad.x -= 400;
				dad.y += 20;
			case 'mallEvil':
				boyfriend.x += 320;
			case 'school':
				boyfriend.x += 200;
				boyfriend.y += 220;
				dad.x += 200;
				dad.y += 580;
				gf.x += 200;
				gf.y += 320;
			case 'schoolEvil':
				dad.x -= 150;
				dad.y += 50;
				boyfriend.x += 200;
				boyfriend.y += 220;
				gf.x += 180;
				gf.y += 300;

		}
	}

	var curLight:Int = 0;
	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var startedMoving:Bool = false;

	public function stageUpdate(curBeat:Int, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{
		// trace('update backgrounds');
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'heartbeat':
				switch (curBeat)
				{
					case 159, 287:
						FlxTween.tween(bg, {alpha: 0}, 0.2, {type: ONESHOT});
						FlxTween.tween(stageFront, {alpha: 0}, 0.2, {type: ONESHOT});
					case 160, 288:
						FlxTween.tween(grid, {alpha: 1}, 1, {type: ONESHOT});
						FlxTween.tween(grid2, {alpha: 1}, 1, {type: ONESHOT});
					case 224:
						FlxTween.tween(bg, {alpha: 1}, 1, {type: ONESHOT});
						FlxTween.tween(stageFront, {alpha: 1}, 1, {type: ONESHOT});
						FlxTween.tween(grid, {alpha: 0}, 1, {type: ONESHOT});
						FlxTween.tween(grid2, {alpha: 0}, 1, {type: ONESHOT});
					case 352:
						FlxTween.tween(grid, {alpha: 0}, 1, {type: ONESHOT});
						FlxTween.tween(grid2, {alpha: 0}, 1, {type: ONESHOT});
				}
		}
	}

	public function stageUpdateConstant(elapsed:Float, boyfriend:Boyfriend, gf:Character, dadOpponent:Character)
	{		
	}

	// PHILLY STUFFS!
	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	function updateTrainPos(gf:Character):Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset(gf);
		}
	}

	function trainReset(gf:Character):Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	override function add(Object:FlxBasic):FlxBasic
	{
		if (Init.trueSettings.get('Disable Antialiasing') && Std.isOfType(Object, FlxSprite))
			cast(Object, FlxSprite).antialiasing = false;
		return super.add(Object);
	}
}
