package states;

import flixel.FlxState;
//import entities.Conveyor;
import entities.Muffin;
//import entities.Selector;
//import entities.UI;
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
//	public var ui : UI;
	public var pause : FlxSprite;
	private var muffins : List<Muffin>;
	private var muffinPool : FlxGroup;

    var INIT_PROB = 0.80;
    var PROB_DECR = 0.05;
    var current_prob = 0.;
    var last_id = -1;

	public function getNextGoal():Int
    {
        var x = FlxG.random.float();
        if (last_id < 0) {
            current_prob = 0.8;
            if (x <= 0.33) {
                return (last_id = 0);
            } else if (x <= 0.67) {
                return (last_id = 1);
            } else {
                return (last_id = 2);
            }
        } else {
            if (x < current_prob) {
                current_prob -= PROB_DECR;
                return last_id;
            } else {
                last_id += x - current_prob >= (1 - current_prob) / 2 ? 1 : -1;
                if (last_id == -1) {
                    last_id = 2;
                } else if (last_id > 2) {
                    last_id = 0;
                }
                current_prob = INIT_PROB;
                return last_id;
            }
            return 0;
        }
    }

	override public function create():Void
	{
		super.create();

//		FlxG.debugger.visible = true;

//		ui = new UI();
//		selector = new Selector();
//		conveyor = new Conveyor(270);

//		add(new Background());
//		add(conveyor);
//		add(ui);

		add(new FlxSprite(0, 0, "assets/images/belt_layer.jpg"));
		add(new FlxSprite(0, 0, "assets/images/ui_header.png"));

		muffins = new List<Muffin>();
		muffinPool = new FlxGroup();
		add(muffinPool);

		pause = new FlxSprite(FlxG.width - 200, FlxG.height - 200);
		pause.makeGraphic(150, 150, FlxColor.WHITE);
		add(pause);
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
                if (good && touched.length > 0) {
                    //Then no mistakes have been done
                    for (muffin in touched) {
                        muffin.hit();
                    }
//                    UI.score += touched.length * touched.length * 10;
                    FlxG.sound.play(FlxG.random.bool() ? "assets/sounds/right_cream.wav" : "assets/sounds/right_cream_yes.wav");
                } else {
                    FlxG.sound.play("assets/sounds/wrong_cream.wav");
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

			var it = muffins.iterator();

			if (it.hasNext()) {
				var first = it.next();
				first.leftMuffin = null;
				if (it.hasNext()) {
					var second = it.next();
					first.rightMuffin = second;
					second.leftMuffin = first;
				} else {
					first.rightMuffin = null;
				}
			}
		}

		handleSwipe();

		for (touch in FlxG.touches.list) {
			if (touch.justPressed) {
				if (touch.x > pause.x && touch.x < pause.x + pause.width && touch.y > pause.y && touch.y < pause.y + pause.height) {
					openSubState(new PauseState());
				}
			}
		}
	}
}
