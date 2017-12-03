package states;

import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import states.PlayState;
import flixel.FlxG;


class GameOverState extends FlxState
{
    private var score : Int;

    public function new(score : Int) {
        super();
        this.score = score;
    }

	override public function create():Void
	{
		super.create();

        var title = new FlxText();
        title.text = "GAME OVER !\n ";
        title.size = 64;
        title.screenCenter();
        title.y -= 130;
        add(title);

        var score = new FlxText();
        score.text = "SCORE " + this.score + "\n ";
        score.size = 48;
        score.screenCenter();
        add(score);

        var replay = new FlxButton();
        replay.text = "REPLAY\n ";
        replay.onUp.callback = function () {
            FlxG.switchState(new PlayState());
        };
        replay.screenCenter();
        replay.y += 200;
        add(replay);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
