package entities;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup;
import entities.Muffin;
import states.PlayState;
import flixel.FlxBasic;
import entities.ResetXSprite;
import flixel.input.FlxPointer;

typedef Belt = {
    y: Float,
    busyTimer : Float,
    queue : Int,
    muffins: FlxTypedGroup<Muffin>,
    edge: FlxSprite,
    speed: Float,
    convs: Array<FlxSprite>,
    lastPopped: Muffin
}


class Conveyor extends FlxGroup
{
    private var elapsedTotal : Float;
    private var lastPopped : Float;
    private var randomizer : FlxRandom;
    private var probabilityBoost : Float;
    private static var SPEED = 130;
    private static var ANIM_SPEED_FACTOR = 15 / 162;
    private static var SPEEDUP_TIMER = 10;
    private static var SPEEDUP_FACTOR = 1.0;
    private static var BUSY_TIMEOUT = 1.5;
    private static var GAP_SIZE = 240;
    private static var BELT_COUNT = 2;
    private static var BELT_Y_GAP = 30;
    private static var SPAWN_INTERVAL = 2;
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
            var sprite = new FlxSprite(x, y + 185 * BELT_COUNT - 59 + (BELT_COUNT - 1) * BELT_Y_GAP, "assets/images/conveyor/belt_shadow.png");
            x += sprite.width;
            add(sprite);
        }

        var i = 0;
        while (i++ < BELT_COUNT) {
            var convs = new Array<FlxSprite>();
            x = 0;
            while (x < FlxG.width) {
                var sprite = new FlxSprite(x, y);
                sprite.loadGraphic("assets/images/conveyor/belt_no_anim.png", false, 259, 231);
//                sprite.loadGraphic("assets/images/conveyor/belt.png", true, 259, 231);
//                sprite.animation.add("run", [4, 0, 3, 1, 6, 7, 2, 5], Math.round(SPEED * ANIM_SPEED_FACTOR));
//                sprite.animation.play("run");
//                sprite.x -= (Main.global_scale * sprite.width) / 4;
//                sprite.y -= (Main.global_scale * sprite.height) / 4;
                x += sprite.width;
                y_incr = sprite.height + BELT_Y_GAP;
                add(sprite);
//                convs.push(sprite);
            }

            x = -120;
            while (x < FlxG.width) {
                var sprite = new ResetXSprite(x, y);
                sprite.loadGraphic("assets/images/conveyor/belt_line.png", false, 30, 185);
                x += sprite.width * 4;
                sprite.velocity.x = SPEED;
                add(sprite);
                convs.push(sprite);
            }

            var edge = new FlxSprite(FlxG.width - 160 - i * 10, y - 59, "assets/images/conveyor/edge.png");

            y += y_incr - 45;

            belts.push({
                y: y - 10 - BELT_Y_GAP,
                busyTimer: 0,
                queue: 0,
                muffins: new FlxTypedGroup<Muffin>(),
                edge: edge,
                speed: SPEED,
                convs: convs,
                lastPopped: null
            });
        }

        for (belt in belts) {
            add(belt.muffins); //Ensure correct draw order
            add(belt.edge);
        }

        height = y - this.y;
    }

    private function popOnBelt(belt : Belt) : Void {
        var comboSize : Int= cast Math.min(randomizer.weightedPick([60, 30, 10]) + 1, maxCombo);
        var combo : Array<Int> = [PlayState.A_KEY, PlayState.S_KEY, PlayState.D_KEY, PlayState.F_KEY];

        //Prevents three muffins with same combo in a row
        if (belt.muffins.countLiving() >= 2) {
            var muffin_1 : Muffin = null;
            var muffin_2 : Muffin = null;
            belt.muffins.forEachAlive(function (m : FlxBasic) {
                if (muffin_1 == null) {
                    muffin_1 = cast m;
                } else if (muffin_2 == null) {
                    muffin_2 = cast m;
                }
            });
            if (muffin_1.getNextCombo() == muffin_2.getNextCombo()) {
                combo.remove(muffin_1.getNextCombo());
            }
        }

        while (combo.length > comboSize) {
            combo.splice(randomizer.int(0, combo.length - 1), 1);
        }
        randomizer.shuffle(combo);
        belt.lastPopped = cast belt.muffins.recycle(Muffin);
        belt.lastPopped.init(belt.y - Muffin.BASE_HEIGHT, belt.speed, combo, popMuffin);
        //Sort muffins from left to right
        belt.muffins.sort(function (_:Int, left:FlxBasic, right:FlxBasic) return (cast left).x - (cast right).x);
    }

    public function popMuffin() : Void {
//        belts[randomizer.int(0, 2)].queue++;
//        belts[1].queue++;
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
            belt.muffins.forEachAlive(function (muffin : Muffin) {
                if (muffin.x > belt.edge.x + 30) {
                    FlxG.sound.play("assets/sounds/loose_life.wav");
                    muffin.alive = false;
                    muffin.velocity.x = 0;
//                    UI.health -= 1;
                    FlxG.camera.shake(0.01, 0.2);
                }
            });
        }
    }

    public function forEachMuffin(callback : Muffin -> FlxPointer -> Void, pointer : FlxPointer) {
        for (belt in belts) {
            belt.muffins.forEachAlive(function (basic : FlxBasic) {
		        callback(cast basic, pointer);
            });
        }
    }

    public function checkGaps(belt : Belt)
    {
        var idx : Int = 0;
        var leftMuffin : Muffin = null;
        var fillGap = false;

        belt.muffins.forEachAlive(function (muffin : Muffin) {
            //Muffins with 0 x velocity are muffins completed
            if (muffin.velocity.x > 0) {
                if (!fillGap && leftMuffin != null) {
//                    if (leftMuffin.getNextCombo() == muffin.getNextCombo()) {
                        //Same muffin should be next to each other
                        if (muffin.x - leftMuffin.x > (GAP_SIZE + 5) * Muffin.SCALE) {
                            //Otherwise, we'll move all the muffins at the right to the left to fill the gap
                            fillGap = true;
                        }
//                    }
                }
                if (fillGap) {
                    muffin.x -= GAP_SIZE * Muffin.SCALE;
                }
                leftMuffin = muffin;
            }
        });
    }

    public function checkAutoremove(belt : Belt)
    {
        var killCombo : Int = -1;
        var left_1 : Muffin = null;
        var left_2 : Muffin = null;
        belt.muffins.forEachAlive(function (muffin : Muffin) {
            if (killCombo == -2) return ; //We have find a combo so we won't search for another one this loop
            //Muffins with 0 x velocity are muffins completed
            if (muffin.velocity.x > 0) {
                if (killCombo >= 0) {
                    if (muffin.getNextCombo() == killCombo) {
                        muffin.hitCombo(killCombo);
                    } else {
                        killCombo = -2;
                    }
                }
                else if (left_1 != null && left_2 != null) {
                    if (left_1.getNextCombo() == left_2.getNextCombo() && left_2.getNextCombo() == muffin.getNextCombo()) {
                        //Three in a row, starts demolition
                        killCombo = left_1.getNextCombo();
                        left_1.hitCombo(killCombo);
                        left_2.hitCombo(killCombo);
                        muffin.hitCombo(killCombo);
                    }
                }
                left_2 = left_1;
                left_1 = muffin;
            }
        });
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        lastPopped += elapsed;
        elapsedTotal += elapsed;
        timerBeforeSpeedUp -= elapsed;

        if (timerBeforeSpeedUp < 0) {
            timerBeforeSpeedUp = SPEEDUP_TIMER;
//            var belt = belts[randomizer.int(0, 2)];
            var belt = belts[1];
            belt.speed *= SPEEDUP_FACTOR;
            for (muffin in belt.muffins) {
                (cast muffin).velocity.x = belt.speed;
            }
            for (conv in belt.convs) {
//                conv.animation.getByName("run").frameRate = Math.round(belt.speed * ANIM_SPEED_FACTOR);
                conv.velocity.x = belt.speed;
            }
        }

/*
        if (lastPopped > SPAWN_INTERVAL) {
            lastPopped -= SPAWN_INTERVAL;
            for (belt in belts) {
                popOnBelt(belt);
            }
        }
*/

        for (belt in belts) {
            checkGaps(belt);
            checkAutoremove(belt);
            if (belt.lastPopped == null) {
                popOnBelt(belt);
            } else if (belt.lastPopped.x > 0 || belt.lastPopped.velocity.x == 0) {
                var x_ref = belt.lastPopped.x;
                popOnBelt(belt);
                belt.lastPopped.x = x_ref - GAP_SIZE * Muffin.SCALE;
            }
        }

        /*
        if (elapsedTotal > 30) {
            maxCombo = 3;
        } else if (elapsedTotal > 10) {
            maxCombo = 2;
        }
        */

/*
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
*/

        checkMuffins();
	}
}
