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

        var bg = new FlxSprite(0, 0, "assets/images/screens/bg.png");
        bg.x = - (Main.global_scale * bg.width) / 4;
        bg.y = - (Main.global_scale * bg.height) / 4;
        bg.scale.set(Main.global_scale, Main.global_scale);
        add(bg);

        var text = new FlxSprite(600, 60, "assets/images/screens/credit_names.png");
        text.x -= (Main.global_scale * text.width) / 4;
        text.y -= (Main.global_scale * text.height) / 4;
        text.scale.set(Main.global_scale, Main.global_scale);
        add(text);

        back = new FlxSprite(0, 0, "assets/images/screens/back.png");
        back.x = 1020 - (Main.global_scale * back.width) / 4;
        back.y = 580 - (Main.global_scale * back.height) / 4;
        back.scale.set(Main.global_scale, Main.global_scale);
        add(back);

        arrow = new FlxSprite(0, 0, "assets/images/screens/arrow.png");
        arrow.x = 920 - (Main.global_scale * arrow.width) / 4;
        arrow.y = 300 - (Main.global_scale * arrow.height) / 4;
        arrow.alpha = 0;
        arrow.scale.set(Main.global_scale, Main.global_scale);
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
