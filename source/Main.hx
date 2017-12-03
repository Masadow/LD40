package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.WelcomeState;
import flixel.system.FlxAssets;

class Main extends Sprite
{
	public static var global_scale = 1 / 1.5;

	public function new()
	{
		super();
		FlxAssets.FONT_DEFAULT = "assets/fonts/jelly_crazies.ttf";
		addChild(new FlxGame(0, 0, WelcomeState, 1, 60, 60, true, false));
	}
}
