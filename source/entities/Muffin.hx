package entities;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import entities.Selector;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
import entities.UI;
import flixel.text.FlxText;
import states.PlayState;
import flixel.math.FlxPoint;

typedef ComboState = {
    letter: FlxText,
    key: FlxKey,
    done: Bool,
    x: Float
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
            left: new FlxSprite(0 + baseOffsetX, 0 + baseOffsetY, "assets/images/base_1.png"),
            mid_left: new FlxSprite(30 + baseOffsetX, 0 + baseOffsetY, "assets/images/base_2.png"),
            mid_right: new FlxSprite(45 + baseOffsetX, 1 + baseOffsetY, "assets/images/base_3.png"),
            right: new FlxSprite(59 + baseOffsetX, 1 + baseOffsetY, "assets/images/base_4.png")
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

    public function init(Y:Float, speed:Float, combos:Array<FlxKey>, onMistake : Void -> Void) : Void {
//        super.reset(0, Y);
        x = 0;
        y = Y;

        this.onMistake = onMistake;

        velocity.x = speed;

        colorWidth = width / combos.length;
        var x = 0.;
        this.combos = new Array<ComboState>();
        for (combo in combos) {
            var comboColor : FlxColor = null;
            var sletter = "";
            if (combo == FlxKey.A) {
                comboColor = FlxColor.RED;
                sletter = "A";
            } else if (combo == FlxKey.S) {
                comboColor = FlxColor.BROWN;
                sletter = "S";
            } else if (combo == FlxKey.D) {
                comboColor = FlxColor.GREEN;
                sletter = "D";
            } else if (combo == FlxKey.F) {
                comboColor = FlxColor.PURPLE;
                sletter = "F";
            }
//            FlxSpriteUtil.drawRect(this, x, 0, colorWidth, SIZE, comboColor);
            var letter : FlxText = cast PlayState.letters.recycle(FlxText);
            letter.y = y + _halfSize.y;
            letter.x = this.x + x + colorWidth / 2 - 8;
            letter.text = sletter;
            letter.size = 24;
            this.combos.push({
                letter: letter,
                key: combo,
                x: x,
                done: false
            });
            x += colorWidth;
        }
    }

    private function drawCombo(x : Float) {
        // Visually mark a combo as done
        FlxSpriteUtil.drawRect(this, x, 0, colorWidth, height, FlxColor.WHITE);
    }

    private function hitCombo(key:FlxKey) {
        for (combo in combos) {
            if (combo.done) {
                continue;
            }
            if (combo.key == key) {
                combo.done = true;
                drawCombo(combo.x);
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

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        return ;

        for (combo in combos) {
            combo.letter.x = x + combo.x + colorWidth / 2 - 8;
        }

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
