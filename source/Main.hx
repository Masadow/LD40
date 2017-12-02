package;

import flixel.FlxGame;
import openfl.display.Sprite;
import states.PlayState;

class Main extends Sprite
{
	public static var global_scale = 1 / 1.5;

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, PlayState));
	}
}
