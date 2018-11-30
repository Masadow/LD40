package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.InstructionsState;
import flixel.system.FlxAssets;

class Main extends Sprite
{
	public static var global_scale = 1 / 1.5;

	public function new()
	{
		super();
		FlxAssets.FONT_DEFAULT = "assets/fonts/Vanilla.ttf";
		addChild(new FlxGame(1920, 1080, InstructionsState, 1, 60, 60, true, false));
	}
}
