package entities;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import entities.UI;
import flixel.text.FlxText;
import states.PlayState;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup;

typedef ComboState = {
    letter: FlxText,
    key: FlxKey,
    done: Bool
}

typedef BaseSprites = {
    left: FlxSprite,
    mid_left: FlxSprite,
    mid_right: FlxSprite,
    right: FlxSprite
}

class Muffin extends FlxSpriteGroup
{
    public static var BASE_HEIGHT = 150;
    private var combos : Array<ComboState>;
    private var onMistake : Void -> Void;

    private var headSprite : FlxSprite;
    private var selectorSprite : FlxSprite;
    private var baseSprites : BaseSprites;
    private var letters : Array<FlxText>;

    private var selected : Bool;

	public function new()
	{
		super(0, 0);

        //Build the muffin from bottom to top
        selected = false;
        selectorSprite = new FlxSprite(5, 110, "assets/images/unselected.png");

        var baseOffsetX = 15;
        var baseOffsetY = 90;
        baseSprites = {
            left: new FlxSprite(-2 + baseOffsetX, 0 + baseOffsetY, "assets/images/base/left_white.png"),
            mid_left: new FlxSprite(37 + baseOffsetX, 0 + baseOffsetY, "assets/images/base/mid_left_white.png"),
            mid_right: new FlxSprite(52 + baseOffsetX, 1 + baseOffsetY, "assets/images/base/mid_right_white.png"),
            right: new FlxSprite(66 + baseOffsetX, 0 + baseOffsetY, "assets/images/base/right_white.png")
        };

        headSprite = new FlxSprite(0, 0, "assets/images/head.png");
        letters = [
            new FlxText(0, 103, 40, "A\n ", 12),
            new FlxText(0, 103, 40, "S\n ", 12),
            new FlxText(0, 103, 40, "D\n ", 12),
            new FlxText(0, 103, 40, "F\n ", 12)
        ];

        add(selectorSprite);
        add(baseSprites.left);
        add(baseSprites.mid_left);
        add(baseSprites.mid_right);
        add(baseSprites.right);
        add(headSprite);
        for (letter in letters) {
            letter.alpha = 0;
            add(letter);
        }

        reposition_sprite(selectorSprite);
        reposition_sprite(baseSprites.left);
        reposition_sprite(baseSprites.mid_left);
        reposition_sprite(baseSprites.mid_right);
        reposition_sprite(baseSprites.right);
        reposition_sprite(headSprite);
	}

    private function reposition_sprite(sprite : FlxSprite) {
        sprite.scale.set(Main.global_scale, Main.global_scale);
        sprite.x -= (Main.global_scale * sprite.width) / 4;
        sprite.y -= (Main.global_scale * sprite.height) / 4;
    }

    private function get_combo_color(combo : FlxKey) : String {
        if (combo == FlxKey.A) {
            return "red";
        } else if (combo == FlxKey.S) {
            return "pink";
        } else if (combo == FlxKey.D) {
            return "blue";
        } else if (combo == FlxKey.F) {
            return "yellow";
        }
        return "";
    }

    public function init(Y:Float, speed:Float, combos:Array<FlxKey>, onMistake : Void -> Void) : Void {
        x = -130;
        y = Y;

        for (letter in letters) {
            letter.alpha = 0;
        }

        this.onMistake = onMistake;

        velocity.x = speed;

        this.combos = new Array<ComboState>();
        if (combos.length == 1) {
            baseSprites.left.loadGraphic("assets/images/base/left_"+ get_combo_color(combos[0]) +".png");
            baseSprites.mid_left.loadGraphic("assets/images/base/mid_left_"+ get_combo_color(combos[0]) +".png");
            baseSprites.mid_right.loadGraphic("assets/images/base/mid_right_"+ get_combo_color(combos[0]) +".png");
            baseSprites.right.loadGraphic("assets/images/base/right_"+ get_combo_color(combos[0]) +".png");
        } else if (combos.length == 2) {
            baseSprites.left.loadGraphic("assets/images/base/left_"+ get_combo_color(combos[0]) +".png");
            baseSprites.mid_left.loadGraphic("assets/images/base/mid_left_"+ get_combo_color(combos[0]) +".png");
            baseSprites.mid_right.loadGraphic("assets/images/base/mid_right_"+ get_combo_color(combos[1]) +".png");
            baseSprites.right.loadGraphic("assets/images/base/right_"+ get_combo_color(combos[1]) +".png");
        } else if (combos.length == 3) {
            baseSprites.left.loadGraphic("assets/images/base/left_"+ get_combo_color(combos[0]) +".png");
            baseSprites.mid_left.loadGraphic("assets/images/base/mid_left_"+ get_combo_color(combos[1]) +".png");
            baseSprites.mid_right.loadGraphic("assets/images/base/mid_right_"+ get_combo_color(combos[1]) +".png");
            baseSprites.right.loadGraphic("assets/images/base/right_"+ get_combo_color(combos[2]) +".png");
        }
 
        var x = 0.;
        for (combo in combos) {
            var idx = 0;
            if (combo == FlxKey.A) {
                idx = 0;
            } else if (combo == FlxKey.S) {
                idx = 1;
            } else if (combo == FlxKey.D) {
                idx = 2;
            } else if (combo == FlxKey.F) {
                idx = 3;
            }
            var letter : FlxText = letters[idx];
            letter.alpha = 255;
            this.combos.push({
                letter: letter,
                key: combo,
                done: false
            });
        }

        positionLetters();
    }

    private function drawCombo(idx : Int) {
        if (combos.length == 1) {
            baseSprites.left.loadGraphic("assets/images/base/left_white.png");
            baseSprites.mid_left.loadGraphic("assets/images/base/mid_left_white.png");
            baseSprites.mid_right.loadGraphic("assets/images/base/mid_right_white.png");
            baseSprites.right.loadGraphic("assets/images/base/right_white.png");
        } else if (combos.length == 2) {
            if (idx == 0) {
                baseSprites.left.loadGraphic("assets/images/base/left_white.png");
                baseSprites.mid_left.loadGraphic("assets/images/base/mid_left_white.png");
            } else {
                baseSprites.mid_right.loadGraphic("assets/images/base/mid_right_white.png");
                baseSprites.right.loadGraphic("assets/images/base/right_white.png");
            }
        } else if (combos.length == 3) {
            if (idx == 0) {
                baseSprites.left.loadGraphic("assets/images/base/left_white.png");
            } else if (idx == 1) {
                baseSprites.mid_left.loadGraphic("assets/images/base/mid_left_white.png");
                baseSprites.mid_right.loadGraphic("assets/images/base/mid_right_white.png");
            } else {
                baseSprites.right.loadGraphic("assets/images/base/right_white.png");
            }
        }
    }

    private function hitCombo(key:FlxKey) {
        var i = 0;
        for (combo in combos) {
            if (combo.done) {
                ++i;
                continue;
            }
            if (combo.key == key) {
                combo.done = true;
                drawCombo(i);
            } else {
                this.onMistake();
                return ;
            }
        }
        UI.score += [10, 50, 100, 250][combos.length - 1];
        unselect();
        kill();
    }

    override public function kill():Void {
        super.kill();
    }

    public function positionLetters() {
        if (combos.length == 1) {
            combos[0].letter.x = -75;
        } else if (combos.length == 2) {
            combos[0].letter.x = -90;
            combos[1].letter.x = -60;
        } else if (combos.length == 3) {
            combos[0].letter.x = -97;
            combos[1].letter.x = -75;
            combos[2].letter.x = -50;
        }
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

//        positionLetters();

        if (selected) {
            if (FlxG.keys.justPressed.A) {
                hitCombo(FlxKey.A);
            }
            if (FlxG.keys.justPressed.S) {
                hitCombo(FlxKey.S);
            }
            if (FlxG.keys.justPressed.D) {
                hitCombo(FlxKey.D);
            }
            if (FlxG.keys.justPressed.F) {
                hitCombo(FlxKey.F);
            }
        }
	}

    public function select() {
        selected = true;
        selectorSprite.loadGraphic("assets/images/selected.png");
    }

    public function unselect() {
        selected = false;
        selectorSprite.loadGraphic("assets/images/unselected.png");
    }
}
