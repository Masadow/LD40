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
        add(bg);

        var text = new FlxSprite(850, 150, "assets/images/screens/gameover.png");
        add(text);

        var score = new FlxText();
        score.text = this.score + "";
        score.size = 90;
        score.screenCenter();
        score.x += 350;
        add(score);

        retry = new FlxSprite(1400, 700, "assets/images/screens/retry.png");
        add(retry);

        arrow_retry = new FlxSprite(1250, 700, "assets/images/screens/arrow.png");
        arrow_retry.alpha = 0;
        add(arrow_retry);

        quit = new FlxSprite(1530, 850, "assets/images/screens/quit.png");
        add(quit);

        arrow_quit = new FlxSprite(1380, 850, "assets/images/screens/arrow.png");
        arrow_quit.alpha = 0;
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
                    FlxG.switchState(new PlayState(4));
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
