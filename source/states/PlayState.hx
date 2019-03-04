package states;

import flixel.FlxState;
//import entities.Conveyor;
import entities.Muffin;
//import entities.Selector;
import entities.UI;
//import entities.TouchAction;
import flixel.FlxG;
import states.GameOverState;
import entities.Background;
import flixel.input.keyboard.FlxKey;
import flixel.input.FlxPointer;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;


class PlayState extends FlxState
{
//	public var conveyor : Conveyor;
//	public var selector : Selector;
	public var ui : UI;
	public var pause : FlxSprite;
	private var muffins : List<Muffin>;
	private var muffinPool : FlxGroup;

    public static var level : Int; 

    var INIT_PROB = 0.70;
    var PROB_DECR = 0.075;
    var current_prob = 0.;
    var last_id = 0;
    var last_length = 0;
    var last_last_length = 0;
    var first : Muffin;
    var clearMuffin = new List<Muffin>();


    var cur_count = 0;
    var cur_length = 1;
	public function prepareNextMuffin(m : Muffin)
    {
        if (cur_count++ == cur_length) {
            if (cur_length == 1) {
                //Forbids two singles in a row
                while ((cur_length = FlxG.random.weightedPick(GameConst.LENGTH_PROBS) + 1) == 1) {}
            } else {
                cur_length = FlxG.random.weightedPick(GameConst.LENGTH_PROBS) + 1;
            }
            cur_count = 1;
            var color_id = FlxG.random.int(0, GameConst.COLORS.length - 2);
            last_id = color_id >= last_id ? color_id + 1 : color_id;
            trace(cur_length);
        }
        m.goal = GameConst.COLORS[last_id];
    }

    public function new(level : Int = 0)
    {
        super();
        PlayState.level = level;
    }

	override public function create():Void
	{
		super.create();

//		FlxG.debugger.visible = true;

		ui = new UI();
//		selector = new Selector();
//		conveyor = new Conveyor(270);

//		add(new Background());
//		add(conveyor);

		add(new FlxSprite(0, 0, "assets/images/bg_full.png"));
		add(new FlxSprite(0, 0, "assets/images/ui_header.png"));

        constructBelts();

		muffins = new List<Muffin>();
		muffinPool = new FlxGroup();
//		add(muffinPool);

//		pause = new FlxSprite(FlxG.width - 200, FlxG.height - 200);
		pause = new FlxSprite(0, 0);
		pause.makeGraphic(150, 150, FlxColor.WHITE);
		add(pause);

        first = null;

		add(ui);
	}

    public function constructBelts()
    {
        var path = GameConst.CUPCAKES_PATH[level];

        var i = 1;
        while (i < path.length) {
            var origin = path[i - 1];
            var dest = path[i];

            var belt = new FlxSprite(Math.min(dest.x, origin.x), Math.min(dest.y, origin.y));
            belt.makeGraphic(Std.int(Math.abs(dest.x - origin.x)) + Std.int(GameConst.CUPCAKE_WIDTH * GameConst.CUPCAKE_SCALE), Std.int(Math.abs(dest.y - origin.y)) + Std.int(GameConst.CUPCAKE_HEIGHT * GameConst.CUPCAKE_SCALE), FlxColor.BLACK, true);
            add(belt);

            i++;
        }
    }

	public function handleSwipe()
	{
        for (touch in FlxG.touches.list) {
            if (touch.justReleased) {
                var good = true;
                var color : FlxColor = FlxColor.TRANSPARENT;
                var touched = new List<Muffin>();
                for (muffin in muffins) {
                    if (muffin.selected) {
                        muffin.selected = false;
                        touched.push(muffin);
                        if (color != FlxColor.TRANSPARENT && color != muffin.goal) {
                            good = false;
                        }
                        color = muffin.goal;
                    }
                }
                if (touched.length == 1) {
                    // Single tap, nothing happen
                } else if (good && touched.length > 1) {
                    //Then no mistakes have been done
                    for (muffin in touched) {
                        muffin.hit();
                    }
                    UI.score += touched.length * touched.length * 10;
                    FlxG.sound.play(FlxG.random.bool() ? "assets/sounds/right_cream.wav" : "assets/sounds/right_cream_yes.wav");
                } else {
                    UI.loseLife();
//                    FlxG.sound.play("assets/sounds/wrong_cream.wav");
//                    UI.score = Std.int(Math.max(0, UI.score - touched.length * 10));
                }
            } else if (touch.pressed) {
                for (muffin in muffins) {
					if (muffin.alive) {
						var mox = touch.x,
							moy = touch.y,
							width = muffin.width * GameConst.CUPCAKE_SCALE,
							height = muffin.height * GameConst.CUPCAKE_SCALE;
						if (mox > muffin.x && mox < muffin.x + width && moy > muffin.y && moy < muffin.y + height) {
							muffin.selected = true;
						}
					}
                }
            }
        }
	}

    override public function draw():Void
    {
        super.draw();

        //First draw alive cupcakes
        for (muffin in muffins) {
            if (muffin.alive && muffin.exists)
                muffin.draw();
        }

        //Then draw dead cupcakes on top of everything
        for (muffin in muffins) {
            if (!muffin.alive && muffin.exists)
                muffin.draw();
        }
        
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (muffins.length == 0 || muffins.first().path_progress >= GameConst.SPAWN_GAP) {
			var x_offset = muffins.length > 0 ? muffins.first().path_progress - GameConst.SPAWN_GAP : 0;
			muffins.push(cast muffinPool.recycle(Muffin));
            prepareNextMuffin(muffins.first());
			muffins.first().resetPath();
			muffins.first().x += x_offset;
            muffins.first().path_progress += x_offset;
            muffins.first().active = false;
            muffins.first().rightMuffin = first;
            if (first != null) {
                first.leftMuffin = muffins.first();
            }
            first = muffins.first();
		}

		handleSwipe();

        var i = 0;
        clearMuffin.clear();
        for (muffin in muffins) {
            muffin.update(elapsed);
            if (!muffin.exists) {
                clearMuffin.push(muffin);
            }
        }
        for (muffin in clearMuffin) {
            muffins.remove(muffin);
        }

		for (touch in FlxG.touches.list) {
			if (touch.justPressed) {
				if (touch.x > pause.x && touch.x < pause.x + pause.width && touch.y > pause.y && touch.y < pause.y + pause.height) {
					openSubState(new PauseState());
				}
			}
		}

        if (UI.health <= 0) {
            FlxG.switchState(new GameOverState(UI.score));
        }
	}
}
