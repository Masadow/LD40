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
    var last_id = -1;
    var last_length = 0;
    var last_last_length = 0;
    var first : Muffin;
    var clearMuffin = new List<Muffin>();

	public function getNextGoal():Int
    {
        var x = FlxG.random.float();
        if (last_id < 0) {
            current_prob = INIT_PROB;
            last_length = 1;
            if (x <= 0.33) {
                return (last_id = 0);
            } else if (x <= 0.67) {
                return (last_id = 1);
            } else {
                return (last_id = 2);
            }
        } else {
            if (last_last_length == 1 || (last_length < 8 && (x < current_prob || (last_length >= 2 && last_length <= 3)))) {
                last_last_length = -1; // This is used to make sure we won't have two singles in a row
                current_prob -= PROB_DECR;
                last_length++;
                return last_id;
            } else {
                last_id += x - current_prob >= (1 - current_prob) / 2 ? 1 : -1;
                if (last_id == -1) {
                    last_id = 2;
                } else if (last_id > 2) {
                    last_id = 0;
                }
                current_prob = INIT_PROB;
                last_last_length = last_length;
                last_length = 1;
                return last_id;
            }
            return 0;
        }
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
		add(muffinPool);

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
            belt.makeGraphic(Std.int(Math.abs(dest.x - origin.x)) + GameConst.CUPCAKE_WIDTH, Std.int(Math.abs(dest.y - origin.y)) + GameConst.CUPCAKE_HEIGHT, FlxColor.BLACK, true);
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

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (muffins.length == 0 || muffins.first().path_progress >= GameConst.SPAWN_GAP) {
			var x_offset = muffins.length > 0 ? muffins.first().path_progress - GameConst.SPAWN_GAP : 0;
			muffins.push(cast muffinPool.recycle(Muffin));
			muffins.first().goal = GameConst.COLORS[getNextGoal()];
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
