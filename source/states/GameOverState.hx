package states;

import flixel.FlxState;
import flixel.text.FlxText;
import states.PlayState;
import flixel.FlxSprite;
import flixel.FlxG;
import openfl.Lib;
import openfl.system.System;


class GameOverState extends FlxState
{
    private var arrow_retry : FlxSprite;
    private var retry : FlxSprite;
    private var arrow_quit : FlxSprite;
    private var quit : FlxSprite;

    private var score : Int;

    public function new(score : Int) {
        super();
        this.score = score;
    }

	override public function create():Void
	{
		super.create();

        var bg = new FlxSprite(0, 0, "assets/images/screens/game_over_bg.png");
        bg.x = - (Main.global_scale * bg.width) / 4;
        bg.y = - (Main.global_scale * bg.height) / 4;
        bg.scale.set(Main.global_scale, Main.global_scale);
        add(bg);

        var text = new FlxSprite(600, 100, "assets/images/screens/gameover.png");
        text.x -= (Main.global_scale * text.width) / 4;
        text.y -= (Main.global_scale * text.height) / 4;
        text.scale.set(Main.global_scale, Main.global_scale);
        add(text);

        var score = new FlxText();
        score.text = this.score + "";
        score.size = 75;
        score.screenCenter();
        score.x += 250;
        add(score);

        retry = new FlxSprite(0, 0, "assets/images/screens/retry.png");
        retry.x = 940 - (Main.global_scale * retry.width) / 4;
        retry.y = 480 - (Main.global_scale * retry.height) / 4;
        retry.scale.set(Main.global_scale, Main.global_scale);
        add(retry);

        arrow_retry = new FlxSprite(0, 0, "assets/images/screens/arrow.png");
        arrow_retry.x = 840 - (Main.global_scale * arrow_retry.width) / 4;
        arrow_retry.y = 480 - (Main.global_scale * arrow_retry.height) / 4;
        arrow_retry.alpha = 0;
        arrow_retry.scale.set(Main.global_scale, Main.global_scale);
        add(arrow_retry);

        quit = new FlxSprite(0, 0, "assets/images/screens/quit.png");
        quit.x = 1020 - (Main.global_scale * quit.width) / 4;
        quit.y = 580 - (Main.global_scale * quit.height) / 4;
        quit.scale.set(Main.global_scale, Main.global_scale);
        add(quit);

        arrow_quit = new FlxSprite(0, 0, "assets/images/screens/arrow.png");
        arrow_quit.x = 920 - (Main.global_scale * arrow_quit.width) / 4;
        arrow_quit.y = 580 - (Main.global_scale * arrow_quit.height) / 4;
        arrow_quit.alpha = 0;
        arrow_quit.scale.set(Main.global_scale, Main.global_scale);
        add(arrow_quit);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        arrow_quit.alpha = 0;
        arrow_retry.alpha = 0;
        #if FLX_MOUSE
        updateForInput(FlxG.mouse.overlaps(retry), FlxG.mouse.overlaps(quit), FlxG.mouse.justReleased);
        #end
        #if FLX_TOUCH
        for (touch in FlxG.touches.list)
        {
            updateForInput(touch.overlaps(retry), touch.overlaps(quit), touch.justReleased);
        }
        #end
	}

    public function updateForInput(overlaps_retry : Bool, overlaps_quit : Bool, clicked : Bool)
    {
        if (overlaps_retry) {
            arrow_retry.alpha = 255;

            if (clicked) {
                FlxG.sound.play("assets/sounds/buttonclick.wav", 1, false, null, false, function () {
                    FlxG.switchState(new PlayState());
                });
            }
        }

        if (overlaps_quit) {
            arrow_quit.alpha = 255;

            if (clicked) {
                FlxG.sound.play("assets/sounds/buttonclick.wav", 1, false, null, false, function () {
                    #if html5
                    FlxG.switchState(new states.InstructionsState());
                    #elseif android
                    System.exit(0);
                    #else
                    Lib.close();
                    #end
                });
            }
        }
    }
}
