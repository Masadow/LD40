package states;

import flixel.FlxState;
import flixel.FlxSprite;
import states.PlayState;
import states.CreditState;
import states.OptionsState;
import flixel.FlxG;
import flixel.input.FlxPointer;


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

        add(new FlxSprite(0, 0, "assets/images/screens/bg.png"));

        add(new FlxSprite(950, 80, "assets/images/screens/title.png"));

        play = new FlxSprite(1100, 500, "assets/images/screens/play.png");
        add(play);

        options = new FlxSprite(1100, 675, "assets/images/screens/options.png");
        add(options);

        credits = new FlxSprite(1100, 850, "assets/images/screens/credits.png");
        add(credits);

        arrow = new FlxSprite(950, 0, "assets/images/screens/arrow.png");
        arrow.alpha = 0;
        add(arrow);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        arrow.alpha = 0;
        #if FLX_MOUSE
        _updateForPointer(FlxG.mouse.justReleased, FlxG.mouse);
        #end
        #if FLX_TOUCH
        for (touch in FlxG.touches.list) {
            _updateForPointer(touch.justReleased, touch);
        }
        #end
	}

    private function _updateForPointer(clicked : Bool, pointer : FlxPointer)
    {
        if (pointer.overlaps(play)) {
            arrow.alpha = 255;
            arrow.y = play.y;

            if (clicked) {
                FlxG.sound.play("assets/sounds/buttonclick.wav", 1, false, null, false, function () {
                    FlxG.switchState(new PlayState());
                });
            }
        } else if (pointer.overlaps(options)) {
            arrow.alpha = 255;
            arrow.y = options.y;

            if (clicked) {
                FlxG.sound.play("assets/sounds/buttonclick.wav", 1, false, null, false, function () {
                    FlxG.switchState(new OptionsState());
                });
            }
        } else if (pointer.overlaps(credits)) {
            arrow.alpha = 255;
            arrow.y = credits.y;

            if (clicked) {
                FlxG.sound.play("assets/sounds/buttonclick.wav", 1, false, null, false, function () {
                    FlxG.switchState(new CreditState());
                });
            }
        }
    }
}
