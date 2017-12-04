package states;

import flixel.FlxState;
import flixel.FlxSprite;
import states.PlayState;
import states.CreditState;
import states.OptionsState;
import flixel.FlxG;


class WelcomeState extends FlxState
{
    public function new() {
        super();
    }

    private var play : FlxSprite;
    private var options : FlxSprite;
    private var credits : FlxSprite;
    private var arrow : FlxSprite;

	override public function create():Void
	{
		super.create();

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

        play = new FlxSprite(0, 0, "assets/images/screens/play.png");
        play.x = 720 - (Main.global_scale * play.width) / 4;
        play.y = 340 - (Main.global_scale * play.height) / 4;
        play.scale.set(Main.global_scale, Main.global_scale);
        add(play);

        options = new FlxSprite(0, 0, "assets/images/screens/options.png");
        options.x = 720 - (Main.global_scale * options.width) / 4;
        options.y = 460 - (Main.global_scale * options.height) / 4;
        options.scale.set(Main.global_scale, Main.global_scale);
        add(options);

        credits = new FlxSprite(0, 0, "assets/images/screens/credits.png");
        credits.x = 720 - (Main.global_scale * credits.width) / 4;
        credits.y = 580 - (Main.global_scale * credits.height) / 4;
        credits.scale.set(Main.global_scale, Main.global_scale);
        add(credits);

        arrow = new FlxSprite(0, 0, "assets/images/screens/arrow.png");
        arrow.x = 620 - (Main.global_scale * arrow.width) / 4;
        arrow.y = 300 - (Main.global_scale * arrow.height) / 4;
        arrow.alpha = 0;
        arrow.scale.set(Main.global_scale, Main.global_scale);
        add(arrow);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if (FlxG.mouse.overlaps(play)) {
            arrow.alpha = 255;
            arrow.y = play.y;

            if (FlxG.mouse.justReleased) {
                FlxG.switchState(new PlayState());
            }
        } else if (FlxG.mouse.overlaps(options)) {
            arrow.alpha = 255;
            arrow.y = options.y;

            if (FlxG.mouse.justReleased) {
                FlxG.switchState(new OptionsState());
            }
        } else if (FlxG.mouse.overlaps(credits)) {
            arrow.alpha = 255;
            arrow.y = credits.y;

            if (FlxG.mouse.justReleased) {
                FlxG.switchState(new CreditState());
            }
        } else {
            arrow.alpha = 0;
        }
	}
}
