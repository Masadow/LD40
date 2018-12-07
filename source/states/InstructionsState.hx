package states;

import flixel.FlxState;
import flixel.FlxSprite;
import states.WelcomeState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import entities.Muffin;


class InstructionsState extends FlxState
{
    public function new() {
        super();
    }

	override public function create():Void
	{
		super.create();

        FlxG.sound.playMusic("assets/music/main.ogg", 0.5, true);

        add(new FlxSprite(0, 0, "assets/images/screens/bg.png"));

        add(new FlxSprite(950, 80, "assets/images/screens/title.png"));

        add(new FlxSprite(880, 520, "assets/images/screens/info.png"));

        #if FLX_MOUSE
        add(new FlxText(1300, 900, 800, "(Click to continue)", 42));
        #else
        add(new FlxText(1350, 900, 800, "(Tap to continue)", 42));
        #end
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        #if FLX_MOUSE
        if (FlxG.mouse.justReleased) {
            FlxG.switchState(new WelcomeState());
        }
        #end
        #if FLX_TOUCH
        for (touch in FlxG.touches.list) {
            if (touch.justReleased) {
                FlxG.switchState(new WelcomeState());
            }
        }
        #end
	}
}
