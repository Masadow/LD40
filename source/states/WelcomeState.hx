package states;

import flixel.FlxState;
import flixel.FlxSprite;
import states.PlayState;
import flixel.FlxG;


class WelcomeState extends FlxState
{
    public function new() {
        super();
    }

    private var play : FlxSprite;
    private var arrow : FlxSprite;

	override public function create():Void
	{
		super.create();

        FlxG.sound.playMusic("assets/music/main.ogg", 1, true);

        var bg = new FlxSprite(0, 0, "assets/images/welcome/bg.png");
        bg.x = - (Main.global_scale * bg.width) / 4;
        bg.y = - (Main.global_scale * bg.height) / 4;
        bg.scale.set(Main.global_scale, Main.global_scale);
        add(bg);

        play = new FlxSprite(0, 0, "assets/images/welcome/play.png");
        play.x = 720 - (Main.global_scale * play.width) / 4;
        play.y = 400 - (Main.global_scale * play.height) / 4;
        play.scale.set(Main.global_scale, Main.global_scale);
        add(play);

        arrow = new FlxSprite(0, 0, "assets/images/welcome/arrow.png");
        arrow.x = 620 - (Main.global_scale * arrow.width) / 4;
        arrow.y = 400 - (Main.global_scale * arrow.height) / 4;
        arrow.alpha = 0;
        arrow.scale.set(Main.global_scale, Main.global_scale);
        add(arrow);

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if (FlxG.mouse.overlaps(play)) {
            arrow.alpha = 255;

            if (FlxG.mouse.justReleased) {
                FlxG.switchState(new PlayState());
            }
        } else {
            arrow.alpha = 0;
        }
	}
}
