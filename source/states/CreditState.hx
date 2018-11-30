package states;

import flixel.FlxState;
import flixel.FlxSprite;
import states.WelcomeState;
import flixel.FlxG;


class CreditState extends FlxState
{
    public function new() {
        super();
    }

    private var back : FlxSprite;
    private var arrow : FlxSprite;

	override public function create():Void
	{
		super.create();

        add(new FlxSprite(0, 0, "assets/images/screens/bg.png"));

        add(new FlxSprite(900, 100, "assets/images/screens/credit_names.png"));

        back = new FlxSprite(1500, 850, "assets/images/screens/back.png");
        add(back);

        arrow = new FlxSprite(1350, 850, "assets/images/screens/arrow.png");
        arrow.alpha = 0;
        add(arrow);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        arrow.alpha = 0;
        #if FLX_MOUSE
        _updateForPointer(FlxG.mouse.overlaps(back), FlxG.mouse.justReleased);
        #end
        #if FLX_TOUCH
        for (touch in FlxG.touches.list) {
            _updateForPointer(touch.overlaps(back), touch.justReleased);
        }
        #end
	}

    private function _updateForPointer(overlaps_back : Bool, clicked : Bool)
    {
        if (overlaps_back) {
            arrow.alpha = 255;
            arrow.y = back.y;

            if (clicked) {
                FlxG.sound.play("assets/sounds/buttonclick.wav", 1, false, null, false, function () {
                    FlxG.switchState(new WelcomeState());
                });
            }
        }
    } 
}
