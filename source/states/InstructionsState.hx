package states;

import flixel.FlxState;
import flixel.FlxSprite;
//import states.PlayState;
import flixel.FlxG;
import flixel.text.FlxText;
import entities.Muffin;
import flixel.math.FlxRect;
import flixel.graphics.frames.FlxFrame;
import flixel.util.FlxColor;
import openfl.geom.Point;
import entities.bonus.Bonus;

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

        add(new FlxText(1350, 900, 800, "(Tap to continue)", 42));

/*
        var sequences = 0;
        var seq_len = 1;
        var short_sequences = 0;
        var mid_sequences = 0;
        var long_sequences = 0;
        var current_seq = getNextId();
        for (i in 0...999) {
            var x = getNextId();
            if (x != current_seq) {
                sequences++;
                current_seq = x;
                if (seq_len <= 2) {
                    short_sequences++;
                } else if (seq_len <= 5) {
                    mid_sequences++;
                } else {
                    long_sequences++;
                }
                seq_len = 1;
            } else {
                seq_len++;
            }
        }

        trace("Average sequence length: ", 1000 / sequences);
        trace("Short sequences: ", short_sequences / sequences);
        trace("Mid sequences: ", mid_sequences / sequences);
        trace("Long sequences: ", long_sequences / sequences);
*/

//        Muffin.buildAssets();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        for (touch in FlxG.touches.list) {
            if (touch.justReleased) {
                FlxG.switchState(new PlayState(4));
            }
        }
	}
}
