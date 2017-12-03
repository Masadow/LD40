package entities;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import entities.UI;
import flixel.text.FlxText;
import states.PlayState;
import flixel.math.FlxPoint;

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
    private var colorWidth: Float;
    private var onMistake : Void -> Void;

    private var headSprite : FlxSprite;
    private var selectorSprite : FlxSprite;
    private var baseSprites : BaseSprites;

    private var selected : Bool;

	public function new()
	{
		super(0, 0);

        this.width = 199 * Main.global_scale;
        this.height = 220 * Main.global_scale;
        this._halfSize = FlxPoint.get(this.width / 2, this.height / 2);

        //Build the muffin from bottom to top
        selected = false;
        selectorSprite = new FlxSprite(5, 110, "assets/images/unselected.png");

        var baseOffsetX = 22;
        var baseOffsetY = 90;
        baseSprites = {
            left: new FlxSprite(0 + baseOffsetX, 0 + baseOffsetY, "assets/images/base/left_white.png"),
            mid_left: new FlxSprite(30 + baseOffsetX, 0 + baseOffsetY, "assets/images/base/mid_left_white.png"),
            mid_right: new FlxSprite(45 + baseOffsetX, 1 + baseOffsetY, "assets/images/base/mid_right_white.png"),
            right: new FlxSprite(59 + baseOffsetX, 1 + baseOffsetY, "assets/images/base/right_white.png")
        };

        headSprite = new FlxSprite(0, 0, "assets/images/head.png");

        add(selectorSprite);
        add(baseSprites.left);
        add(baseSprites.mid_left);
        add(baseSprites.mid_right);
        add(baseSprites.right);
        add(headSprite);

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
        x = -width;
        y = Y;

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
 
        colorWidth = width / combos.length;
        var x = 0.;
        for (combo in combos) {
            var sletter = "";
            if (combo == FlxKey.A) {
                sletter = "A";
            } else if (combo == FlxKey.S) {
                sletter = "S";
            } else if (combo == FlxKey.D) {
                sletter = "D";
            } else if (combo == FlxKey.F) {
                sletter = "F";
            }
            var letter : FlxText = cast PlayState.letters.recycle(FlxText);
            letter.y = y + 103;
            letter.text = sletter + "\n ";
            letter.size = 12;
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
 
//        for (combo)
        // Visually mark a combo as done
//        FlxSpriteUtil.drawRect(this, x, 0, colorWidth, height, FlxColor.WHITE);
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

        for (combo in combos) {
            combo.letter.kill();
        }
    }

    public function positionLetters() {
        if (combos.length == 1) {
            combos[0].letter.x = baseSprites.mid_right.x - 5;
        } else if (combos.length == 2) {
            combos[0].letter.x = baseSprites.mid_left.x - 5;
            combos[1].letter.x = baseSprites.right.x - 3;
        } else if (combos.length == 3) {
            combos[0].letter.x = baseSprites.left.x + 22;
            combos[1].letter.x = baseSprites.mid_right.x - 5;
            combos[2].letter.x = baseSprites.right.x + 5;
        }
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        positionLetters();

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
