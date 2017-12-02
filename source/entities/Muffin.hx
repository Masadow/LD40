package entities;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import entities.Selector;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxSpriteUtil;
import flixel.FlxG;
import entities.UI;

typedef ComboState = {
    key: FlxKey,
    done: Bool,
    x: Float
}

class Muffin extends FlxSprite
{
    public static var SIZE = 64;
    public var selector : Selector;
    private var combos : Array<ComboState>;
    private var colorWidth: Float;
    private var onMistake : Void -> Void;

	public function new()
	{
		super(0, 0);
        makeGraphic(SIZE, SIZE, 0, true);
	}

    public function init(Y:Float, speed:Float, combos:Array<FlxKey>, onMistake : Void -> Void) : Void {
        super.reset(0, Y);

        this.onMistake = onMistake;

        velocity.x = speed;

        colorWidth = SIZE / combos.length;
        var x = 0.;
        this.combos = new Array<ComboState>();
        for (combo in combos) {
            var comboColor : FlxColor = null;
            if (combo == FlxKey.A) {
                comboColor = FlxColor.RED;
            } else if (combo == FlxKey.S) {
                comboColor = FlxColor.BROWN;
            } else if (combo == FlxKey.D) {
                comboColor = FlxColor.GREEN;
            } else if (combo == FlxKey.F) {
                comboColor = FlxColor.PURPLE;
            }
            FlxSpriteUtil.drawRect(this, x, 0, colorWidth, SIZE, comboColor);
            this.combos.push({
                key: combo,
                x: x,
                done: false
            });
            x += colorWidth;
        }
    }

    private function drawCombo(x : Float) {
        // Visually mark a combo as done
        FlxSpriteUtil.drawRect(this, x, 0, colorWidth, SIZE, FlxColor.WHITE);
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

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if (selector != null) {
            selector.x = x;
            selector.y = y;

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

    public function select(selector : Selector) {
        this.selector = selector;
    }

    public function unselect() {
        selector = null;
    }
}
