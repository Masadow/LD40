package states;

import flixel.FlxState;
//import entities.Conveyor;
import entities.Muffin;
import entities.BaseMuffin;
import entities.Spikey;
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
import entities.bonus.Bonus;


class PlayState extends FlxState
{
//	public var conveyor : Conveyor;
//	public var selector : Selector;
	public var ui : UI;
	public var pause : FlxSprite;
	private var muffins : List<BaseMuffin>;
	private var muffinPool : FlxGroup;

    public static var level : Int; 

    var INIT_PROB = 0.70;
    var PROB_DECR = 0.075;
    var current_prob = 0.;
    var clearMuffin = new List<BaseMuffin>();
    var fastForwardMuffin = new List<BaseMuffin>();
    var touched = new List<BaseMuffin>();
    var goodSwipe : Bool;


    var last_id = 0;
    var cur_count = 1;
    var cur_length = 1;
    var cur_bonus : Bonus = null;
    private static var current_combo_idx = -1; 
	public function prepareNextMuffin()
    {
        var bm : BaseMuffin;
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

            // Spawn a bonus only on BONUS_TRIGGER length rows
            cur_bonus = cur_length == GameConst.BONUS_TRIGGER ? Type.createInstance(GameConst.BONUSES[FlxG.random.int(0, GameConst.BONUSES.length - 1)], []) : null;
            if (cur_bonus != null) {
                cur_bonus.idx = ++current_combo_idx;
            }
        }
        if (cur_length == 1) {
            //Spawn a nasty spikey
            bm = cast muffinPool.recycle(Spikey);
			muffins.push(bm);
        } else {
            //Spawn a regular cupcake
            bm = cast muffinPool.recycle(Muffin);
			muffins.push(bm);
            var m : Muffin = cast bm;
            m.bonus = cur_bonus;
            m.goal = GameConst.COLORS[last_id];
            if (cur_bonus != null) {
                cur_bonus.addMuffin(cast bm);
            }
        }
        return bm;
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

		muffins = new List<BaseMuffin>();
		muffinPool = new FlxGroup();
//		add(muffinPool);

//		pause = new FlxSprite(FlxG.width - 200, FlxG.height - 200);
		pause = new FlxSprite(0, 0);
		pause.makeGraphic(150, 150, FlxColor.WHITE);
		add(pause);

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

    private function resetTouched()
    {
        for (muffin in touched) {
            muffin.selected = false;
            muffin.color = FlxColor.WHITE;
        }
        touched.clear();
        goodSwipe = true;
    }

    public function validateMuffins(validMuffins : List<BaseMuffin>)
    {
        //Then no mistakes have been done
        //Check bonuses
        //it might be possible to clear out several bonuses in a single shot with combos)
        //That's why we use a Map here
        var bonusCount = new Map<Int, Int>();
        for (muffin in validMuffins) {
            if (muffin.canCombo()) {
                var m : Muffin = cast muffin;
                if (m.bonus != null) {
                    if (!bonusCount.exists(m.bonus.idx)) {
                        bonusCount.set(m.bonus.idx, 0);
                    }
                    bonusCount.set(m.bonus.idx, bonusCount.get(m.bonus.idx) + 1);
                }
            }
        }
        for (muffin in validMuffins) {
            muffin.hit();
            if (muffin.canCombo()) {
                var m : Muffin = cast muffin;
                if (m.bonus != null) {
                    var bc = bonusCount.get(m.bonus.idx);
                    if (bc == GameConst.BONUS_TRIGGER) {
                        //Bonus completed
                        m.bonus.trigger();
                        bonusCount.remove(m.bonus.idx);
                    } else if (bc != null) {
                        //Check it it's the current spawning combo and cancel future bonus spawn if needed
                        if (m.bonus.idx == current_combo_idx) {
                            cur_bonus = null;
                        }
                        //Bonus is not completed so we cancel it
                        m.bonus.cancel();
                    }
                    //Otherwise, bonus already counted
                    //so we do nothing
                }
            }
        }
        UI.score += validMuffins.length * validMuffins.length * 10;
    }

	public function handleSwipe()
	{
        var isSwiping = false;
        for (touch in FlxG.touches.list) {
            isSwiping = true;
            if (touch.justPressed) {
                resetTouched();
            } else if (touch.justReleased) {
                if (touched.length == 1) {
                    // Single tap, nothing happen
                } else if (goodSwipe && touched.length > 1) {
                    validateMuffins(touched);
                    FlxG.sound.play(FlxG.random.bool() ? "assets/sounds/right_cream.wav" : "assets/sounds/right_cream_yes.wav");
                } else {
                    //UI.loseLife();
                    FlxG.sound.play("assets/sounds/wrong_cream.wav");
//                    UI.score = Std.int(Math.max(0, UI.score - touched.length * 10));
                }
                resetTouched();
            } else if (touch.pressed) {
                for (muffin in muffins) {
					if (muffin.alive) {
						var mox = touch.x,
							moy = touch.y,
							width = muffin.width * GameConst.CUPCAKE_SCALE,
							height = muffin.height * GameConst.CUPCAKE_SCALE;

                        if (muffin.selected && !goodSwipe) {
                            muffin.color = FlxColor.RED;
                        }

						if (mox > muffin.x && mox < muffin.x + width && moy > muffin.y && moy < muffin.y + height) {
                            if (!muffin.selected) {
                                //Means it's a new selection
                                touched.push(cast muffin);
                                if (!muffin.canCombo() || (cast touched.last()).goal != (cast muffin).goal) {
                                    //The newly swiped cupcake is wrong, tint it in red
                                    goodSwipe = false;
                                }
                            }
							muffin.selected = true;
						}
					}
                }
            }
        }
        return isSwiping;
	}

    public function handleCombos()
    {
        //First check for combos
        var cur_color = FlxColor.TRANSPARENT;
        var streak = new List<BaseMuffin>();
        var hadCombo = false;
        for (muffin in muffins) {
            if (muffin.alive) {
                if (muffin.isForward() && muffin.canCombo() && (cast muffin).goal == cur_color) {
                    streak.push(muffin);
                }
                else {
                    if (streak.length >= GameConst.COMBO_TRIGGER) {
                        validateMuffins(streak);
                        hadCombo = true;
                    }
                    streak.clear();
                    if (muffin.isForward() && muffin.canCombo()) {
                        cur_color = (cast muffin).goal;
                        streak.push(muffin);
                    } else {
                        cur_color = FlxColor.TRANSPARENT;
                    }
                }
            }
        }
        if (streak.length >= GameConst.COMBO_TRIGGER) {
            //There is a combo streak
            for (m_streak in streak) {
                m_streak.hit();
                UI.score += streak.length * streak.length * 10;
                hadCombo = true;
            }
        }
        if (hadCombo) {
            FlxG.sound.play(FlxG.random.bool() ? "assets/sounds/right_cream.wav" : "assets/sounds/right_cream_yes.wav");
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
            var first : BaseMuffin = muffins.first();
			var x_offset = muffins.length > 0 ? muffins.first().path_progress - GameConst.SPAWN_GAP : 0;
            var next = prepareNextMuffin();
			next.resetPath();
			next.x += x_offset;
            next.path_progress += x_offset;
            next.active = false;
            next.rightMuffin = first;
            if (first != null) {
                first.leftMuffin = next;
            }
		}

        if (!handleSwipe()) {
            handleCombos();            
        }

//        trace("Update starts");
        var i = 0;
        clearMuffin.clear();
        for (muffin in muffins) {
            muffin.updateNextDirection();
            if (muffin.isFastForward()) {
                trace("fast forward detected");
                fastForwardMuffin.push(muffin);
            } else {
                muffin.update(elapsed);
                while (!fastForwardMuffin.isEmpty()) {
                    fastForwardMuffin.pop().update(elapsed);
                }
            }
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
