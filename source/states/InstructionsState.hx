package states;

import flixel.FlxState;
import flixel.FlxSprite;
import states.WelcomeState;
import flixel.FlxG;
import flixel.text.FlxText;


class InstructionsState extends FlxState
{
    public function new() {
        super();
    }

    private var play : FlxSprite;
    private var arrow : FlxSprite;

	override public function create():Void
	{
		super.create();

        FlxG.sound.playMusic("assets/music/main.ogg", 0.5, true);

        var bg = new FlxSprite(0, 0, "assets/images/screens/bg.png");
        bg.x = - (Main.global_scale * bg.width) / 4;
        bg.y = - (Main.global_scale * bg.height) / 4;
        bg.scale.set(Main.global_scale, Main.global_scale);
        add(bg);

        var title = new FlxSprite(630, 50, "assets/images/screens/title.png");
        title.x -= (Main.global_scale * title.width) / 4;
        title.y -= (Main.global_scale * title.height) / 4;
        title.scale.set(Main.global_scale, Main.global_scale);
        add(title);

        var text = new FlxSprite(600, 350, "assets/images/screens/info.png");
        text.x -= (Main.global_scale * text.width) / 4;
        text.y -= (Main.global_scale * text.height) / 4;
        text.scale.set(Main.global_scale, Main.global_scale);
        add(text);

        var click = new FlxText(750, 580, 800, "(Click to continue)", 42);
        add(click);
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
