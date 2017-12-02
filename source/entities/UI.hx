package entities;

import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;

class UI extends FlxGroup {

    public static var score : Int;
    public var scoreTxt : FlxText;

    public function new() {
        super();

        addAction(40, 40, "A", FlxColor.RED);
        addAction(80, 40, "S", FlxColor.BROWN);
        addAction(120, 40, "D", FlxColor.GREEN);
        addAction(160, 40, "F", FlxColor.PURPLE);

        UI.score = 0;
        addScore();
    }

    private function addAction(x : Float, y : Float, letter : String, color : FlxColor) : Void {
        var txt = new FlxText(x, y, 40, letter);
        txt.color = color;
        txt.size = 32;
        add(txt);
    }

    function addScore() {
        scoreTxt = new FlxText(FlxG.width - 200, 40, 200, "0");
        scoreTxt.size = 32;
        add(scoreTxt);
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);

        scoreTxt.text = "" + score;
    }
}
