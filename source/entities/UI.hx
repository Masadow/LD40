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
    public var healthTxt : FlxText;

    public function new() {
        super();

//        addBackground();

//        var btn = new TouchAction(50, 790);
//        add(btn);

        UI.score = 0;
        addScore();

        UI.health = MAX_HEALTH;
        healthPoints = new Array<FlxSprite>();
        addHealth();
    }

    private function addBackground() {
        var bg = new FlxSprite(0, 0, "assets/images/ui_frame.png");
        add(bg);
    }

    function addScore() {
        scoreTxt = new FlxText(FlxG.width - 400, 55, 310, "0" + "\n ");
        scoreTxt.size = 64;
        scoreTxt.alignment = FlxTextAlign.RIGHT;
        add(scoreTxt);
    }

    function addHealth() {
//        var health = 0;
        healthTxt = new FlxText(FlxG.width - 590, 50, 310, MAX_HEALTH + "\n ");
        healthTxt.size = 64;
        add(healthTxt);
        /*
        while (health++ < MAX_HEALTH) {
            var healthPoint = new FlxSprite(FlxG.width - 93, 260 + health * 90, "assets/images/life_on.png");
            healthPoint.scale.set(Main.global_scale, Main.global_scale);
            healthPoint.health = 2;
            add(healthPoint);
            healthPoints.push(healthPoint);
        }
        */
    }

    public static function loseLife() {
        FlxG.sound.play("assets/sounds/loose_life.wav");
        UI.health -= 1;
        FlxG.camera.shake(0.01, 0.2);
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);

        scoreTxt.text = "" + score + "\n";
        healthTxt.text = health + "\n";

/*
        var i = 0;
        for (healthPoint in healthPoints) {
            if (++i > health) {
                if (healthPoint.health == 2) {
                    healthPoint.health--;
                    healthPoint.loadGraphic("assets/images/life_off.png");
                }
            }
        }
        */
    }
}
