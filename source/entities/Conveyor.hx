package entities;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup;
import entities.Muffin;
import flixel.input.keyboard.FlxKey;
import flixel.FlxBasic;

class Conveyor extends FlxGroup
{
    private var elapsedTotal : Float;
    private var lastPopped : Float;
    private var randomizer : FlxRandom;
    private var probabilityBoost : Float;
    private var muffins : FlxGroup;
    private static var SPEED = 100;
    private var maxCombo : Int;
    private var y : Float;
    private var height : Float;

	public function new(?Y:Float = 0, muffins : FlxGroup)
	{
        super();
        y = Y;

        addConveyors();

        elapsedTotal = 0;
        lastPopped = 0;
        randomizer = new FlxRandom();
        probabilityBoost = 0;
        maxCombo = 1;
        this.muffins = muffins;
        popMuffin();
	}

    public function addConveyors() : Void {
        var x = 0., y = this.y, y_incr = 0.;

        var conveyor_scale = 0.75 * Main.global_scale;

        var i = 0;
        while (i++ < 3) {
            x = 0;
            while (x < FlxG.width) {
                var sprite = new FlxSprite(x, y);
                sprite.loadGraphic("assets/images/belt2.png", true, 259, 231);
                sprite.animation.add("run", [0, 1, 2, 3, 4, 5, 6, 7], 15);
                sprite.animation.play("run");
                sprite.x -= (Main.global_scale * sprite.width) / 4;
                sprite.y -= (Main.global_scale * sprite.height) / 4;
                sprite.scale.set(Main.global_scale, Main.global_scale);
                x += Main.global_scale * sprite.width;
                y_incr = Main.global_scale * sprite.height;
                add(sprite);
            }

            y += y_incr - 30;
        }

        height = y - this.y;
    }

    public function popMuffin() : Void {
        var comboSize = randomizer.int(1, maxCombo);
        var combo = [FlxKey.A, FlxKey.S, FlxKey.D, FlxKey.F];
        while (comboSize++ < 4) {
            combo.splice(randomizer.int(0, combo.length - 1), 1);
        }
        randomizer.shuffle(combo);
        var m : Muffin = cast muffins.recycle(Muffin);
        m.init(randomizer.float(this.y, this.y + this.height - Muffin.SIZE), SPEED, combo, popMuffin);
        muffins.add(m);
    }

    public function popMuffins() : Void {
//        var probability = Math.pow((elapsedTotal + 100) / 90, 3) + 15;
        var probability = (elapsedTotal / 5) + 15 + probabilityBoost;
        var c = 0;

        while (probability > 100) {
            probability -= 100;
            c++;
        }

        if (randomizer.bool(probability)) {
            c++;
        }

        c = c == 0 && muffins.countLiving() == 0 ? 1 : c;

//        probabilityBoost = c == 0 ? probabilityBoost + 5 : 0;

        while (c-- > 0) {
            popMuffin();
        }
    }

    private function checkMuffins() : Void
    {
        muffins.forEachAlive(function (basic_muffin : FlxBasic) {
            var muffin : Muffin = cast basic_muffin;

            if (muffin.x > FlxG.width) {
                muffin.alive = false;
                muffin.velocity.x = 0;
                UI.health -= 1;
            }
        });
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        lastPopped += elapsed;
        elapsedTotal += elapsed;

        if (lastPopped > 0.5) {
            lastPopped -= 0.5;
            popMuffins();
        }

        if (elapsedTotal > 30) {
            maxCombo = 3;
        } else if (elapsedTotal > 10) {
            maxCombo = 2;
        }

        checkMuffins();
	}
}
