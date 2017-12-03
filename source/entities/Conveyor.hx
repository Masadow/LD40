package entities;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup;
import entities.Muffin;
import flixel.input.keyboard.FlxKey;
import flixel.FlxBasic;

typedef Belt = {
    y: Float,
    busyTimer : Float,
    queue : Int,
    muffins: FlxGroup,
    edge: FlxSprite
}


class Conveyor extends FlxGroup
{
    private var elapsedTotal : Float;
    private var lastPopped : Float;
    private var randomizer : FlxRandom;
    private var probabilityBoost : Float;
    private static var SPEED = 150;
    private static var BUSY_TIMEOUT = 1;
    private var maxCombo : Int;
    private var y : Float;
    private var height : Float;
    private var belts : Array<Belt>;

	public function new(?Y:Float = 0)
	{
        super();
        y = Y;

        addConveyors();

        elapsedTotal = 0;
        lastPopped = 0;
        randomizer = new FlxRandom();
        probabilityBoost = 0;
        maxCombo = 1;
        popMuffin();
	}

    public function addConveyors() : Void {
        belts = new Array<Belt>();
        var x = 0., y = this.y, y_incr = 0.;

        var conveyor_scale = 0.75 * Main.global_scale;


        // Position shadow
        x = 0;
        while (x < FlxG.width) {
            var sprite = new FlxSprite(x, 513, "assets/images/conveyor/belt_shadow.png");
            sprite.x -= (Main.global_scale * sprite.width) / 4;
            sprite.y -= (Main.global_scale * sprite.height) / 4;
            sprite.scale.set(Main.global_scale, Main.global_scale);
            x += Main.global_scale * sprite.width;
            add(sprite);
        }

        var i = 0;
        while (i++ < 3) {
            x = 0;
            while (x < FlxG.width) {
                var sprite = new FlxSprite(x, y);
                sprite.loadGraphic("assets/images/conveyor/belt.png", true, 259, 231);
                sprite.animation.add("run", [0, 1, 2, 3, 4, 5, 6, 7], Math.round(15));
                sprite.animation.play("run");
                sprite.x -= (Main.global_scale * sprite.width) / 4;
                sprite.y -= (Main.global_scale * sprite.height) / 4;
                sprite.scale.set(Main.global_scale, Main.global_scale);
                x += Main.global_scale * sprite.width;
                y_incr = Main.global_scale * sprite.height;
                add(sprite);
            }

            var edge = new FlxSprite(FlxG.width - 100 - i * 10, y - 40, "assets/images/conveyor/edge.png");
            edge.x -= (Main.global_scale * edge.width) / 4;
            edge.y -= (Main.global_scale * edge.height) / 4;
            edge.scale.set(Main.global_scale, Main.global_scale);

            y += y_incr - 30;

            belts.push({
                y: y - 10,
                busyTimer: 0,
                queue: 0,
                muffins: new FlxGroup(),
                edge: edge
            });
        }

        for (belt in belts) {
            add(belt.muffins); //Ensure correct draw order
            add(belt.edge);
        }

        height = y - this.y;
    }

    private function popOnBelt(beltId : Int) : Void {
        var comboSize = randomizer.int(1, maxCombo);
        var combo = [FlxKey.A, FlxKey.S, FlxKey.D, FlxKey.F];
        while (comboSize++ < 4) {
            combo.splice(randomizer.int(0, combo.length - 1), 1);
        }
        randomizer.shuffle(combo);
        var m : Muffin = cast belts[beltId].muffins.recycle(Muffin);
        m.init(belts[beltId].y - Muffin.BASE_HEIGHT, SPEED, combo, popMuffin);
    }

    public function popMuffin() : Void {
        belts[randomizer.int(0, 2)].queue++;
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

        var living : Int = 0; 
        for (belt in belts) {
            living += cast Math.max(belt.muffins.countLiving(), 0);
        }
        c = c == 0 && living == 0 ? 1 : c;

//        probabilityBoost = c == 0 ? probabilityBoost + 5 : 0;

        while (c-- > 0) {
            popMuffin();
        }
    }

    private function checkMuffins() : Void
    {
        for (belt in belts) {
            belt.muffins.forEachAlive(function (basic_muffin : FlxBasic) {
                var muffin : Muffin = cast basic_muffin;

                if (muffin.x > belt.edge.x + 30) {
                    muffin.alive = false;
                    muffin.velocity.x = 0;
                    UI.health -= 1;
                }
            });
        }
    }

    public function forEachMuffin(callback : Muffin -> Void) {
        for (belt in belts) {
            belt.muffins.forEachAlive(function (basic : FlxBasic) {
		        callback(cast basic);
            });
        }
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

        var beltIdx = 0;
        for (belt in belts) {
            belt.busyTimer = Math.max(0, belt.busyTimer - elapsed);
            if (belt.queue > 0 && belt.busyTimer == 0) {
                belt.queue--;
                belt.busyTimer = BUSY_TIMEOUT;
                popOnBelt(beltIdx);
            }
            ++beltIdx;
        }

        checkMuffins();
	}
}
