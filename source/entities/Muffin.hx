package entities;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import entities.UI;
import flixel.text.FlxText;
import states.PlayState;

typedef ComboState = {
    letter: FlxText,
    key: FlxKey,
    done: Bool
}

typedef BaseSprites = {
    left: FlxSprite,
    mid_left: FlxSprite,
    mid_right: FlxSprite,
    right: FlxSprite
}

class Muffin extends FlxSpriteGroup
{
    public static var BASE_HEIGHT = 150;
    private var combos : Array<ComboState>;
    private var onMistake : Void -> Void;

    private var headSprite : FlxSprite;
    private var selectorSprite : FlxSprite;
    private var baseSprites : BaseSprites;
    private var letters : Array<FlxText>;
    private var toppins : Array<FlxSprite>;

    private var selected : Bool;

	public function new()
	{
		super(0, 0);

        //Build the muffin from bottom to top
        selected = false;
        selectorSprite = new FlxSprite(5, 110, "assets/images/muffin/unselected.png");

        var baseOffsetX = 15;
        var baseOffsetY = 90;
        #if html5
        baseSprites = {
            left: new FlxSprite(-2 + baseOffsetX, 1 + baseOffsetY, "assets/images/muffin/base/left_white.png"),
            mid_left: new FlxSprite(37 + baseOffsetX, 0 + baseOffsetY, "assets/images/muffin/base/mid_left_white.png"),
            mid_right: new FlxSprite(52 + baseOffsetX, 2 + baseOffsetY, "assets/images/muffin/base/mid_right_white.png"),
            right: new FlxSprite(66 + baseOffsetX, 0 + baseOffsetY, "assets/images/muffin/base/right_white.png")
        };
        #else
        baseSprites = {
            left: new FlxSprite(-2 + baseOffsetX, 0 + baseOffsetY, "assets/images/muffin/base/left_white.png"),
            mid_left: new FlxSprite(37 + baseOffsetX, 0 + baseOffsetY, "assets/images/muffin/base/mid_left_white.png"),
            mid_right: new FlxSprite(52 + baseOffsetX, 1 + baseOffsetY, "assets/images/muffin/base/mid_right_white.png"),
            right: new FlxSprite(66 + baseOffsetX, 0 + baseOffsetY, "assets/images/muffin/base/right_white.png")
        };
        #end

        headSprite = new FlxSprite(0, 0, "assets/images/muffin/head.png");
        letters = [
            new FlxText(0, 100, 40, String.fromCharCode(PlayState.A_KEY), 24),
            new FlxText(0, 100, 40, String.fromCharCode(PlayState.S_KEY), 24),
            new FlxText(0, 100, 40, String.fromCharCode(PlayState.D_KEY), 24),
            new FlxText(0, 100, 40, String.fromCharCode(PlayState.F_KEY), 24)
        ];

        toppins = [
            new FlxSprite(10, -40),
            new FlxSprite(0, -65),
            new FlxSprite(-5, -80),
        ];

        add(selectorSprite);
        add(baseSprites.left);
        add(baseSprites.mid_left);
        add(baseSprites.mid_right);
        add(baseSprites.right);
        add(headSprite);
        for (letter in letters) {
            letter.alpha = 0;
            add(letter);
        }
        var scaleMultiplier = 1.;
        for (toppin in toppins) {
            toppin.loadGraphic("assets/images/muffin/topping.png", true, 169, 109);
            toppin.animation.add("run", [4, 6, 8, 1, 5, 9, 12, 13, 2, 0, 10, 14, 16, 17, 18, 20, 21, 22, 3], 15, false);
            toppin.animation.add("idle", [7], 1, false);
            toppin.animation.play("idle");

            add(toppin);

            reposition_sprite(toppin, scaleMultiplier);
            scaleMultiplier *= 0.75;
        }

        reposition_sprite(selectorSprite);
        reposition_sprite(baseSprites.left);
        reposition_sprite(baseSprites.mid_left);
        reposition_sprite(baseSprites.mid_right);
        reposition_sprite(baseSprites.right);
        reposition_sprite(headSprite);
	}

    private function reposition_sprite(sprite : FlxSprite, scaleModifier : Float = 1.) {
        var scale = Main.global_scale * scaleModifier;
        sprite.scale.set(scale, scale);
        sprite.x -= (scale * sprite.width) / 4;
        sprite.y -= (scale * sprite.height) / 4;
    }

    private function get_combo_color(combo : FlxKey) : String {
        if (combo == PlayState.A_KEY) {
            return "red";
        } else if (combo == PlayState.S_KEY) {
            return "pink";
        } else if (combo == PlayState.D_KEY) {
            return "blue";
        } else if (combo == PlayState.F_KEY) {
            return "yellow";
        }
        return "";
    }

    public function init(Y:Float, speed:Float, combos:Array<FlxKey>, onMistake : Void -> Void) : Void {
        x = -130;
        y = Y;

        velocity.y = 0;

        for (letter in letters) {
            letter.alpha = 0;
        }

        for (toppin in toppins) {
            toppin.animation.play("idle");
        }

        this.onMistake = onMistake;

        velocity.x = speed;

        this.combos = new Array<ComboState>();
        if (combos.length == 1) {
            baseSprites.left.loadGraphic("assets/images/muffin/base/left_"+ get_combo_color(combos[0]) +".png");
            baseSprites.mid_left.loadGraphic("assets/images/muffin/base/mid_left_"+ get_combo_color(combos[0]) +".png");
            baseSprites.mid_right.loadGraphic("assets/images/muffin/base/mid_right_"+ get_combo_color(combos[0]) +".png");
            baseSprites.right.loadGraphic("assets/images/muffin/base/right_"+ get_combo_color(combos[0]) +".png");
        } else if (combos.length == 2) {
            baseSprites.left.loadGraphic("assets/images/muffin/base/left_"+ get_combo_color(combos[0]) +".png");
            baseSprites.mid_left.loadGraphic("assets/images/muffin/base/mid_left_"+ get_combo_color(combos[0]) +".png");
            baseSprites.mid_right.loadGraphic("assets/images/muffin/base/mid_right_"+ get_combo_color(combos[1]) +".png");
            baseSprites.right.loadGraphic("assets/images/muffin/base/right_"+ get_combo_color(combos[1]) +".png");
        } else if (combos.length == 3) {
            baseSprites.left.loadGraphic("assets/images/muffin/base/left_"+ get_combo_color(combos[0]) +".png");
            baseSprites.mid_left.loadGraphic("assets/images/muffin/base/mid_left_"+ get_combo_color(combos[1]) +".png");
            baseSprites.mid_right.loadGraphic("assets/images/muffin/base/mid_right_"+ get_combo_color(combos[1]) +".png");
            baseSprites.right.loadGraphic("assets/images/muffin/base/right_"+ get_combo_color(combos[2]) +".png");
        }
 
        var x = 0.;
        for (combo in combos) {
            var idx = 0;
            if (combo == PlayState.A_KEY) {
                idx = 0;
            } else if (combo == PlayState.S_KEY) {
                idx = 1;
            } else if (combo == PlayState.D_KEY) {
                idx = 2;
            } else if (combo == PlayState.F_KEY) {
                idx = 3;
            }
            var letter : FlxText = letters[idx];
            letter.alpha = 255;
            this.combos.push({
                letter: letter,
                key: combo,
                done: false
            });
        }

        positionLetters();
    }

    private function drawCombo(idx : Int) {
        toppins[idx].animation.play("run");
        if (combos.length == 1) {
            baseSprites.left.loadGraphic("assets/images/muffin/base/left_white.png");
            baseSprites.mid_left.loadGraphic("assets/images/muffin/base/mid_left_white.png");
            baseSprites.mid_right.loadGraphic("assets/images/muffin/base/mid_right_white.png");
            baseSprites.right.loadGraphic("assets/images/muffin/base/right_white.png");
        } else if (combos.length == 2) {
            if (idx == 0) {
                baseSprites.left.loadGraphic("assets/images/muffin/base/left_white.png");
                baseSprites.mid_left.loadGraphic("assets/images/muffin/base/mid_left_white.png");
            } else {
                baseSprites.mid_right.loadGraphic("assets/images/muffin/base/mid_right_white.png");
                baseSprites.right.loadGraphic("assets/images/muffin/base/right_white.png");
            }
        } else if (combos.length == 3) {
            if (idx == 0) {
                baseSprites.left.loadGraphic("assets/images/muffin/base/left_white.png");
            } else if (idx == 1) {
                baseSprites.mid_left.loadGraphic("assets/images/muffin/base/mid_left_white.png");
                baseSprites.mid_right.loadGraphic("assets/images/muffin/base/mid_right_white.png");
            } else {
                baseSprites.right.loadGraphic("assets/images/muffin/base/right_white.png");
            }
        }
    }

    private function hitCombo(key:FlxKey) {
        var i = 0;
        for (combo in combos) {
            if (combo.done) {
                ++i;
                continue;
            }
            if (combo.key == key) {
                combo.done = true;
                drawCombo(i);
                if (i == combos.length - 1) {
                    FlxG.sound.play(/*FlxG.random.bool() ? */"assets/sounds/right_cream.wav"/* : "assets/sounds/right_cream_yes.wav"*/);
                } else {
                    FlxG.sound.play("assets/sounds/combo_cream.wav");
                }
                break ;
            } else {
                FlxG.sound.play("assets/sounds/wrong_cream.wav");
                this.onMistake();
                return ;
            }
        }
        if (i == combos.length - 1) {
            UI.score += [10, 50, 100, 250][combos.length - 1];
            unselect();
            velocity.y = -3 * velocity.x;
            velocity.x = 0;
        }
    }

    override public function kill():Void {
        super.kill();
    }

    public function positionLetters() {
        if (combos.length == 1) {
            combos[0].letter.x = -75;
        } else if (combos.length == 2) {
            combos[0].letter.x = -90;
            combos[1].letter.x = -60;
        } else if (combos.length == 3) {
            combos[0].letter.x = -97;
            combos[1].letter.x = -75;
            combos[2].letter.x = -50;
        }
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if (y + 150 < 0) {
            kill();
        } else if (selected) {
            if (FlxG.keys.anyJustPressed([PlayState.A_KEY])) {
                hitCombo(PlayState.A_KEY);
            }
            if (FlxG.keys.anyJustPressed([PlayState.S_KEY])) {
                hitCombo(PlayState.S_KEY);
            }
            if (FlxG.keys.anyJustPressed([PlayState.D_KEY])) {
                hitCombo(PlayState.D_KEY);
            }
            if (FlxG.keys.anyJustPressed([PlayState.F_KEY])) {
                hitCombo(PlayState.F_KEY);
            }
        }
	}

    public function select() {
        FlxG.sound.play("assets/sounds/select_muffin.wav");
        selected = true;
        selectorSprite.loadGraphic("assets/images/muffin/selected.png");
        headSprite.loadGraphic("assets/images/muffin/head_selected.png");
    }

    public function unselect() {
        selected = false;
        selectorSprite.loadGraphic("assets/images/muffin/unselected.png");
        headSprite.loadGraphic("assets/images/muffin/head.png");
    }
}
