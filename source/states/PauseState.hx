package states;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.FlxSprite;
import flixel.util.FlxColor;

class PauseState extends FlxSubState
{
	override public function create():Void
	{
		super.create();

        var overlay = new FlxSprite(0, 0);
        overlay.makeGraphic(FlxG.width, FlxG.height, new FlxColor(0xaa000000));
        add(overlay);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		for (touch in FlxG.touches.list) {
			if (touch.justPressed) {
                close();
			}
		}
	}
}
