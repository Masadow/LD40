package entities;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.group.FlxGroup;
import entities.Muffin;
import entities.UI;
import flixel.util.FlxColor;
import flixel.FlxBasic;
import entities.ResetXSprite;
import flixel.input.FlxPointer;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;

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
    private static var ANIM_SPEED_FACTOR = 15 / 162;
    private static var SPEEDUP_TIMER = 10;
    private static var SPEEDUP_FACTOR = 1.0;
    private static var BUSY_TIMEOUT = 1.5;
    private static var GAP_SIZE = 240;
    private static var BELT_Y_GAP = 30;
    private static var SPAWN_INTERVAL = 2;
    private var maxCombo : Int;
    private var y : Float;
    private var height : Float;
    private var timerBeforeSpeedUp : Float;
    private var speed : Float;

    private var muffins : FlxTypedGroup<Muffin>;
    private var sortedMuffins : List<Muffin>;


	public function new(?Y:Float = 0)
	{
        super();
        y = Y;

//        addConveyors();

        speed = GameConst.SPEED;

        muffins = new FlxTypedGroup<Muffin>();
        sortedMuffins = new List<Muffin>();

        var conv = new FlxSprite(0, 0);
        conv.makeGraphic(1920, 1080, FlxColor.TRANSPARENT);

        var size = 30;
        var i = 0;
        while (i < GameConst.CUPCAKES_PATH.length - 1) {
            var topLeft : FlxPoint;
            var bottomRight : FlxPoint;
            if (GameConst.CUPCAKES_PATH[i].x > GameConst.CUPCAKES_PATH[i + 1].x
            || GameConst.CUPCAKES_PATH[i].y > GameConst.CUPCAKES_PATH[i + 1].y)
            {
                topLeft = GameConst.CUPCAKES_PATH[i + 1];
                bottomRight = GameConst.CUPCAKES_PATH[i];
            } else {
                topLeft = GameConst.CUPCAKES_PATH[i];
                bottomRight = GameConst.CUPCAKES_PATH[i + 1];
            }
            FlxSpriteUtil.drawRect(conv,
                topLeft.x - 30,
                topLeft.y + 30,
                Math.abs(topLeft.x - bottomRight.x) + size + 170,
                Math.abs(topLeft.y - bottomRight.y) + size + 150, FlxColor.BLACK);
            i++;
        }

        var edge = new FlxSprite(FlxG.width - 160, GameConst.CUPCAKES_PATH[GameConst.CUPCAKES_PATH.length - 1].y - 59, "assets/images/conveyor/edge.png");


        add(conv);
        add(muffins);
        add(edge);


        elapsedTotal = 0;
        lastPopped = 0;
        randomizer = new FlxRandom();
        probabilityBoost = 0;
        maxCombo = 1;
        timerBeforeSpeedUp = SPEEDUP_TIMER;
	}

    public function addConveyors() : Void {
        var x = 0., y = this.y, y_incr = 0.;

        // Position shadow
        x = 0;
        while (x < FlxG.width) {
            var sprite = new FlxSprite(x, y + 185 - 59, "assets/images/conveyor/belt_shadow.png");
            x += sprite.width;
            add(sprite);
        }

        var i = 0;
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
            sprite.velocity.x = GameConst.SPEED;
            add(sprite);
            convs.push(sprite);
        }

        var edge = new FlxSprite(FlxG.width - 160 - i * 10, y - 59, "assets/images/conveyor/edge.png");

        y += y_incr - 45;

/*
        belt = {
            y: y - 10 - BELT_Y_GAP,
            busyTimer: 0,
            queue: 0,
            muffins: new FlxTypedGroup<Muffin>(),
            edge: edge,
            speed: SPEED,
            convs: convs,
            lastPopped: null
        };
*/

//        add(belt.muffins); //Ensure correct draw order
//        add(belt.edge);

        height = y - this.y;
    }

    private function popMuffin() : Void {
        var randoms = [
            [1, 2],
            [3, 5],
            [6, 8]
        ];
        var islong = randomizer.weightedPick([0.3, 0.5, 0.2]);
        var count = randomizer.int(randoms[islong][0], randoms[islong][1]);

        //Pick the next color
        var i = 0;
        if (sortedMuffins.length == 0) {
            i = randomizer.int(0, GameConst.COLORS.length - 1);
        } else {
            var idx = randomizer.int(0, GameConst.COLORS.length - 2);
            for (color in GameConst.COLORS) {
                if (GameConst.COLORS[i] != sortedMuffins.first().getColor()) {
                    if (idx > 0) {
                        idx--;
                    } else {
                        break ;
                    }
                }
                ++i;
            }
        }
        var color : FlxColor = GameConst.COLORS[i];

        while (count-- != 0) {
            var muffin : Muffin = cast muffins.recycle(Muffin);
            muffin.init(speed, color, onMistake);
            muffin.x = sortedMuffins.length == 0 ?
                GameConst.CUPCAKES_PATH[0].x
                :
                sortedMuffins.first().x - GameConst.CUPCAKES_GAP;
            muffin.y = GameConst.CUPCAKES_PATH[0].y;
            //Sort muffins from left to right
//            muffins.sort(function (_:Int, left:FlxBasic, right:FlxBasic) return (cast left).x - (cast right).x);
            sortedMuffins.push(muffin);
        }
    }

    public function onMistake() : Void {

    }

    private function checkMuffins() : Void
    {
        for (muffin in sortedMuffins)
        {
            if (muffin.x >FlxG.width - 130) {
                FlxG.sound.play("assets/sounds/loose_life.wav");
                muffin.kill();
                muffin.velocity.x = 0;
//                    UI.health -= 1;
                FlxG.camera.shake(0.01, 0.2);
            }
        }
    }

    public function checkGaps(belt : Belt)
    {
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

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        //Remove all killed muffins
        sortedMuffins = sortedMuffins.filter(function (m : Muffin) {
            return m.alive;
        });

        for (touch in FlxG.touches.list) {
            if (touch.justReleased) {
                var good = true;
                var color : FlxColor = FlxColor.TRANSPARENT;
                var touched = new List<Muffin>();
                for (muffin in sortedMuffins) {
                    if (muffin.selected) {
                        muffin.unselect();
                        touched.push(muffin);
                        if (color != FlxColor.TRANSPARENT && color != muffin.getColor()) {
                            good = false;
                        }
                        color = muffin.getColor();
                    }
                }
                if (good && touched.length > 0) {
                    //Then no mistakes have been done
                    for (muffin in touched) {
                        muffin.hit();
                    }
                    UI.score += touched.length * touched.length * 10;
                    FlxG.sound.play(FlxG.random.bool() ? "assets/sounds/right_cream.wav" : "assets/sounds/right_cream_yes.wav");
                } else {
                    FlxG.sound.play("assets/sounds/wrong_cream.wav");
                    UI.score = Std.int(Math.max(0, UI.score - touched.length * 10));
                }
            } else if (touch.pressed) {
                for (muffin in sortedMuffins) {
                    var mox = touch.x,
                        moy = touch.y,
                        width = muffin.area.width * Muffin.SCALE,
                        height = muffin.area.height * Muffin.SCALE;
                    if (mox > muffin.area.x && mox < muffin.area.x + width && moy > muffin.area.y && moy < muffin.area.y + height) {
                        muffin.select();
                    }
                }
            }
        }


        lastPopped += elapsed;
        elapsedTotal += elapsed;
        timerBeforeSpeedUp -= elapsed;

/*
        if (timerBeforeSpeedUp < 0) {
            timerBeforeSpeedUp = SPEEDUP_TIMER;
            var belt = belts[randomizer.int(0, BELT_COUNT - 1)];
            belt.speed *= SPEEDUP_FACTOR;
            for (muffin in belt.muffins) {
                (cast muffin).velocity.x = belt.speed;
            }
            for (conv in belt.convs) {
//                conv.animation.getByName("run").frameRate = Math.round(belt.speed * ANIM_SPEED_FACTOR);
                conv.velocity.x = belt.speed;
            }
        }
*/

//            checkGaps(belt);
        if (sortedMuffins.length == 0) {
            popMuffin();
        } else if (sortedMuffins.first().x > 0) {
            popMuffin();
        }

        checkMuffins();
	}
}
