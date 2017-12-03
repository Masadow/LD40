package entities;

import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;

class UI extends FlxGroup {

    private static var MAX_HEALTH = 5;
    public static var score : Int;
    public static var health : Int;
    public var scoreTxt : FlxText;
    public var healthPoints : Array<FlxSprite>;

    public function new() {
        super();

        addBackground();

        addAction(140, 20, "A");
        addAction(305, 20, "S");
        addAction(465, 20, "D");
        addAction(625, 20, "F");

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
        txt.size = 20;
        add(txt);
    }

    function addScore() {
        scoreTxt = new FlxText(FlxG.width - 380, 42, 310, "0" + "\n ");
        scoreTxt.size = 20;
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
