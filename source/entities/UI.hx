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
    public static var actionButton : Array<TouchAction>;

    public function new() {
        super();

        addBackground();

        #if FLX_KEYBOARD
        addAction(225, 32, String.fromCharCode(PlayState.A_KEY));
        addAction(465, 32, String.fromCharCode(PlayState.S_KEY));
        addAction(705, 32, String.fromCharCode(PlayState.D_KEY));
        addAction(945, 32, String.fromCharCode(PlayState.F_KEY));
        #end
        #if FLX_TOUCH
        actionButton = new Array<TouchAction>();
        addTouch(100, 250, PlayState.A_KEY, FlxColor.RED);
        addTouch(100, 400, PlayState.S_KEY, FlxColor.PURPLE);
        addTouch(100, 550, PlayState.D_KEY, FlxColor.CYAN);
        addTouch(100, 700, PlayState.F_KEY, FlxColor.YELLOW);
        #end

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

    private function addAction(x : Float, y : Float, letter : String) : Void {
        var txt = new FlxText(x, y, 60, letter + "\n ");
        txt.color = FlxColor.WHITE;
        txt.size = 42;
        add(txt);
    }

    private function addTouch(x : Float, y : Float, key : Int, color : FlxColor) : Void {
        var btn = new TouchAction(x, y, color, key);
        actionButton.push(btn);
        add(btn);
    }

    function addScore() {
        scoreTxt = new FlxText(FlxG.width - 400, 55, 310, "0" + "\n ");
        scoreTxt.size = 64;
        scoreTxt.alignment = FlxTextAlign.RIGHT;
        add(scoreTxt);
    }

    function addHealth() {
        var health = 0;
        while (health++ < MAX_HEALTH) {
            var healthPoint = new FlxSprite(FlxG.width - 93, 260 + health * 90, "assets/images/life_on.png");
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
