package entities;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup;
import entities.Muffin;
import states.PlayState;
import flixel.FlxBasic;
import entities.ResetXSprite;

typedef Belt = {
    y: Float,
    busyTimer : Float,
    queue : Int,
    muffins: FlxGroup,
    edge: FlxSprite,
    speed: Float,
    convs: Array<FlxSprite>
}


class Conveyor extends FlxGroup
{
    private var elapsedTotal : Float;
    private var lastPopped : Float;
    private var randomizer : FlxRandom;
    private var probabilityBoost : Float;
    private static var SPEED = 100;
    private static var ANIM_SPEED_FACTOR = 15 / 162;
    private static var SPEEDUP_TIMER = 10;
    private static var SPEEDUP_FACTOR = 1.1;
    private static var BUSY_TIMEOUT = 1;
    private var maxCombo : Int;
    private var y : Float;
    private var height : Float;
    private var belts : Array<Belt>;
    private var timerBeforeSpeedUp : Float;

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
        timerBeforeSpeedUp = SPEEDUP_TIMER;
        popMuffin();
	}

    public function addConveyors() : Void {
        belts = new Array<Belt>();
        var x = 0., y = this.y, y_incr = 0.;

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
            var convs = new Array<FlxSprite>();
            x = 0;
            while (x < FlxG.width) {
                var sprite = new FlxSprite(x, y);
                sprite.loadGraphic("assets/images/conveyor/belt_no_anim.png", false, 259, 231);
                sprite.x -= (Main.global_scale * sprite.width) / 4;
                sprite.y -= (Main.global_scale * sprite.height) / 4;
//                sprite.loadGraphic("assets/images/conveyor/belt.png", true, 259, 231);
//                sprite.animation.add("run", [4, 0, 3, 1, 6, 7, 2, 5], Math.round(SPEED * ANIM_SPEED_FACTOR));
//                sprite.animation.play("run");
//                sprite.x -= (Main.global_scale * sprite.width) / 4;
//                sprite.y -= (Main.global_scale * sprite.height) / 4;
                sprite.scale.set(Main.global_scale, Main.global_scale);
                x += Main.global_scale * sprite.width;
                y_incr = Main.global_scale * sprite.height;
                add(sprite);
//                convs.push(sprite);
            }

            x = -80;
            while (x < FlxG.width) {
                var sprite = new ResetXSprite(x, y);
                sprite.loadGraphic("assets/images/conveyor/belt_line.png", false, 30, 185);
                sprite.x -= (Main.global_scale * sprite.width) / 4;
                sprite.y -= (Main.global_scale * sprite.height) / 4;
                sprite.scale.set(Main.global_scale, Main.global_scale);
                x += Main.global_scale * sprite.width * 4;
                sprite.velocity.x = SPEED;
                add(sprite);
                convs.push(sprite);
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
                edge: edge,
                speed: SPEED,
                convs: convs
            });
        }

        for (belt in belts) {
            add(belt.muffins); //Ensure correct draw order
            add(belt.edge);
        }

        height = y - this.y;
    }

    private function popOnBelt(beltId : Int) : Void {
        var comboSize : Int= cast Math.min(randomizer.weightedPick([60, 30, 10]) + 1, maxCombo);
        var combo = [PlayState.A_KEY, PlayState.S_KEY, PlayState.D_KEY, PlayState.F_KEY];
        while (comboSize++ < 4) {
            combo.splice(randomizer.int(0, combo.length - 1), 1);
        }
        randomizer.shuffle(combo);
        var belt = belts[beltId];
        var m : Muffin = cast belt.muffins.recycle(Muffin);
        m.init(belt.y - Muffin.BASE_HEIGHT, belt.speed, combo, popMuffin);
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

        probabilityBoost = c == 0 ? probabilityBoost + 5 : 0;

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
                    FlxG.sound.play("assets/sounds/loose_life.wav");
                    muffin.alive = false;
                    muffin.velocity.x = 0;
                    UI.health -= 1;
                    FlxG.camera.shake(0.01, 0.2);
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
        timerBeforeSpeedUp -= elapsed;

        if (timerBeforeSpeedUp < 0) {
            timerBeforeSpeedUp = SPEEDUP_TIMER;
            var belt = belts[randomizer.int(0, 2)];
            belt.speed *= SPEEDUP_FACTOR;
            for (muffin in belt.muffins) {
                (cast muffin).velocity.x = belt.speed;
            }
            for (conv in belt.convs) {
//                conv.animation.getByName("run").frameRate = Math.round(belt.speed * ANIM_SPEED_FACTOR);
                conv.velocity.x = belt.speed;
            }
        }

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
