package states;

import flixel.FlxState;
import flixel.FlxSprite;
import states.WelcomeState;
import flixel.FlxG;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.effects.FlxFlicker;
import flixel.input.FlxPointer;


class OptionsState extends FlxState
{
    public function new() {
        super();
    }

    private var volume : FlxSprite;
    private var controls : FlxSprite;
    private var back : FlxSprite;
    private var arrow : FlxSprite;
    private var slider : FlxSprite;
    private var sliderDot : FlxSprite;

    // Because scale break everything, I can't use relative positioning
    private var dot_min_x : Float = 580;
    private var dot_width : Float = 460;

    private var a_rect : FlxRect;
    private var s_rect : FlxRect;
    private var d_rect : FlxRect;
    private var f_rect : FlxRect;

    private var aSprite : FlxText;
    private var sSprite : FlxText;
    private var dSprite : FlxText;
    private var fSprite : FlxText;

    private var editing : Int;

    private var flicking : FlxFlicker;

	override public function create():Void
	{
		super.create();

        var bg = new FlxSprite(0, 0, "assets/images/screens/bg.png");
        bg.x = - (Main.global_scale * bg.width) / 4;
        bg.y = - (Main.global_scale * bg.height) / 4;
        bg.scale.set(Main.global_scale, Main.global_scale);
        add(bg);

        volume = new FlxSprite(0, 0, "assets/images/screens/volume.png");
        volume.x = 600 - (Main.global_scale * volume.width) / 4;
        volume.y = 60 - (Main.global_scale * volume.height) / 4;
        volume.scale.set(Main.global_scale, Main.global_scale);
        add(volume);

        slider = new FlxSprite(0, 0, "assets/images/screens/slider_line.png");
        slider.x = 600 - (Main.global_scale * slider.width) / 4;
        slider.y = 180 - (Main.global_scale * slider.height) / 4;
        slider.scale.set(Main.global_scale, Main.global_scale);
        add(slider);

        sliderDot = new FlxSprite(0, 0, "assets/images/screens/slider.png");
        sliderDot.y = slider.y - (Main.global_scale * slider.height) / 4 - 10;
        sliderDot.scale.set(Main.global_scale, Main.global_scale);
        sliderDot.x = slider.x - FlxG.sound.volume * slider.width;
        add(sliderDot);

        controls = new FlxSprite(0, 0, "assets/images/screens/controls.png");
        controls.x = 600 - (Main.global_scale * controls.width) / 4;
        controls.y = 250 - (Main.global_scale * controls.height) / 4;
        controls.scale.set(Main.global_scale, Main.global_scale);
        add(controls);

        var commands = new FlxSprite(0, 0, "assets/images/screens/commands.png");
        commands.x = 650 - (Main.global_scale * commands.width) / 4;
        commands.y = 380 - (Main.global_scale * commands.height) / 4;
        commands.scale.set(Main.global_scale, Main.global_scale);
        add(commands);

        var help = new FlxSprite(0, 0, "assets/images/screens/control_settings.png");
        help.x = 580 - (Main.global_scale * help.width) / 4;
        help.y = 410 - (Main.global_scale * help.height) / 4;
        help.scale.set(Main.global_scale, Main.global_scale);
        add(help);

        back = new FlxSprite(0, 0, "assets/images/screens/back.png");
        back.x = 1020 - (Main.global_scale * back.width) / 4;
        back.y = 580 - (Main.global_scale * back.height) / 4;
        back.scale.set(Main.global_scale, Main.global_scale);
        add(back);

        a_rect = new FlxRect(650, 380, 100, 100);
        s_rect = new FlxRect(765, 380, 100, 100);
        d_rect = new FlxRect(875, 380, 100, 100);
        f_rect = new FlxRect(985, 380, 100, 100);

        arrow = new FlxSprite(0, 0, "assets/images/screens/arrow.png");
        arrow.x = 920 - (Main.global_scale * arrow.width) / 4;
        arrow.y = 300 - (Main.global_scale * arrow.height) / 4;
        arrow.alpha = 0;
        arrow.scale.set(Main.global_scale, Main.global_scale);
        add(arrow);

        editing = -1;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        arrow.alpha = 0;
        #if FLX_MOUSE
        _updateForPointer(FlxG.mouse.pressed, FlxG.mouse.justReleased, FlxG.mouse);
        #end
        #if FLX_TOUCH
        for (touch in FlxG.touches.list) {
            _updateForPointer(touch.pressed, touch.justReleased, touch);
        }
        #end

        sliderDot.x = dot_min_x + FlxG.sound.volume * dot_width;
	}

    private function _updateForPointer(pressed : Bool, clicked : Bool, pointer : FlxPointer)
    {
        if (pointer.overlaps(slider) && pressed) {
            FlxG.sound.volume = (pointer.x - 40 - dot_min_x) / dot_width;
        }
        else if (pointer.overlaps(back)) {
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
