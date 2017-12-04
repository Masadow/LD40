package entities;

import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import states.PlayState;

class UI extends FlxGroup {

    private static var MAX_HEALTH = 5;
    public static var score : Int;
    public static var health : Int;
    public var scoreTxt : FlxText;
    public var healthPoints : Array<FlxSprite>;

    public function new() {
        super();

        addBackground();

        addAction(140, 15, String.fromCharCode(PlayState.A_KEY));
        addAction(305, 15, String.fromCharCode(PlayState.S_KEY));
        addAction(465, 15, String.fromCharCode(PlayState.D_KEY));
        addAction(625, 15, String.fromCharCode(PlayState.F_KEY));

        UI.score = 0;
        addScore();

        UI.health = MAX_HEALTH;
        healthPoints = new Array<FlxSprite>();
        addHealth();
    }

    private function addBackground() {
        var bg = new FlxSprite(0, 0, "assets/images/ui_frame.png");
        bg.x = - (Main.global_scale * bg.width) / 4;
        bg.y = - (Main.global_scale * bg.height) / 4;
        bg.scale.set(Main.global_scale, Main.global_scale);
        add(bg);
    }

    private function addAction(x : Float, y : Float, letter : String) : Void {
        var txt = new FlxText(x, y, 60, letter + "\n ");
        txt.color = FlxColor.WHITE;
        txt.size = 42;
        add(txt);
    }

    function addScore() {
        scoreTxt = new FlxText(FlxG.width - 380, 37, 310, "0" + "\n ");
        scoreTxt.size = 42;
        scoreTxt.alignment = FlxTextAlign.RIGHT;
        add(scoreTxt);
    }

    function addHealth() {
        var health = 0;
        while (health++ < MAX_HEALTH) {
            var healthPoint = new FlxSprite(FlxG.width - 75, 150 + health * 70, "assets/images/life_on.png");
            healthPoint.scale.set(Main.global_scale, Main.global_scale);
            healthPoint.health = 2;
            add(healthPoint);
            healthPoints.push(healthPoint);
        }
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);

        scoreTxt.text = "" + score + "\n ";

        var i = 0;
        for (healthPoint in healthPoints) {
            if (++i > health) {
                if (healthPoint.health == 2) {
                    healthPoint.health--;
                    healthPoint.loadGraphic("assets/images/life_off.png");
                }
            }
        }
    }
}
