package entities;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;

typedef BaseSprites = {
    left: FlxSprite,
    mid_left: FlxSprite,
    mid_right: FlxSprite,
    right: FlxSprite
}

class Muffin extends FlxSpriteGroup
{
    public static var SCALE = GameConst.CUPCAKE_SCALE;
    public static var BASE_HEIGHT = 225 * SCALE;
    private var _color : FlxColor;
    private var onMistake : Void -> Void;

    private var headSprite : FlxSprite;
    private var selectorSprite : FlxSprite;
    private var baseSprites : BaseSprites;
    private var letters : Array<FlxText>;
    private var toppin : FlxSprite;

    public var selected : Bool;
    private var displaySelected : Bool;

    private var path_step : Int;

    private var dimensions : FlxPoint;
    public var area : FlxSprite;

	public function new()
	{
		super(0, 0);

        //Build the muffin from bottom to top
        selected = false;
        displaySelected = false;
        selectorSprite = new FlxSprite(10, 160, "assets/images/muffin/unselected.png");

        baseSprites = {
            left: new FlxSprite(0, 0, "assets/images/muffin/base/left_white.png"),
            mid_left: new FlxSprite(0, 0, "assets/images/muffin/base/mid_left_white.png"),
            mid_right: new FlxSprite(0, 0, "assets/images/muffin/base/mid_right_white.png"),
            right: new FlxSprite(0, 0, "assets/images/muffin/base/right_white.png")
        };

        headSprite = new FlxSprite(0, 0, "assets/images/muffin/head.png");

        toppin = new FlxSprite(15, -60);

        add(selectorSprite);
        add(baseSprites.left);
        add(baseSprites.mid_left);
        add(baseSprites.mid_right);
        add(baseSprites.right);
        add(headSprite);

        toppin.loadGraphic("assets/images/muffin/topping.png", true, 169, 109);
        toppin.animation.add("run", [4, 6, 8, 1, 5, 9, 12, 13, 2, 0, 10, 14, 16, 17, 18, 20, 21, 22, 3], 15, false);
        toppin.animation.add("idle", [7], 1, false);
        toppin.animation.play("idle");
        add(toppin);

        dimensions = new FlxPoint(200, 220);

        area = new FlxSprite(0, 0);
        area.makeGraphic(Std.int(dimensions.x), Std.int(dimensions.y), FlxColor.TRANSPARENT);
        FlxSpriteUtil.drawRect(area, 30, 0, 200 - 60, 220, FlxColor.TRANSPARENT, {
            thickness: 3,
            color: FlxColor.WHITE
        });
        add(area);

        position_sprites();
	}

    private function position_sprites() {
        var saveX = x;
        var saveY = y;
        x = 0;
        y = 0;

        var baseOffsetX = 18;
        var baseOffsetY = 135;
        var selectorOffsetX = 10;
        var selectorOffsetY = 160;
        
        headSprite.origin.set(0, 0);
        headSprite.scale.set(SCALE, SCALE);
        headSprite.x = 0;
        headSprite.y = 0;

        baseSprites.left.origin.set(0, 0);
        baseSprites.left.scale.set(SCALE, SCALE);
        baseSprites.left.x = SCALE * baseOffsetX;
        baseSprites.left.y = SCALE * baseOffsetY; 

        baseSprites.mid_left.origin.set(0, 0);
        baseSprites.mid_left.scale.set(SCALE, SCALE);
        baseSprites.mid_left.x = baseSprites.left.x + SCALE * baseSprites.left.width;
        baseSprites.mid_left.y = SCALE * baseOffsetY;

        baseSprites.mid_right.origin.set(0, 0);
        baseSprites.mid_right.scale.set(SCALE, SCALE);
        baseSprites.mid_right.x = baseSprites.mid_left.x + SCALE * baseSprites.mid_left.width;
        baseSprites.mid_right.y = SCALE * (baseOffsetY + 2);

        baseSprites.right.origin.set(0, 0);
        baseSprites.right.scale.set(SCALE, SCALE);
        baseSprites.right.x = baseSprites.mid_right.x + SCALE * baseSprites.mid_right.width;
        baseSprites.right.y = SCALE * (baseOffsetY + 1);

        selectorSprite.origin.set(0, 0);
        selectorSprite.scale.set(SCALE, SCALE);
        selectorSprite.x = SCALE * selectorOffsetX;
        selectorSprite.y = SCALE * selectorOffsetY;

        area.x = -15;
        area.y = -15;
        area.scale.set(SCALE, SCALE);

        x = saveX;
        y = saveY;
    }

    public function getColor() : FlxColor {
        return _color;
    }

    private function _get_color() : String {
        if (_color == FlxColor.RED) {
            return "red";
        } else if (_color == FlxColor.MAGENTA) {
            return "pink";
        } else if (_color == FlxColor.CYAN) {
            return "blue";
        } else if (_color == FlxColor.ORANGE) {
            return "yellow";
        }
        return "";
    }

    public function init(speed:Float, newColor:FlxColor, onMistake : Void -> Void) : Void {
        _color = newColor;

        velocity.y = 0;

        path_step = 1;

        toppin.animation.play("idle");

        this.onMistake = onMistake;

        velocity.x = speed;

        baseSprites.left.loadGraphic("assets/images/muffin/base/left_"+ _get_color() +".png");
        baseSprites.mid_left.loadGraphic("assets/images/muffin/base/mid_left_"+ _get_color() +".png");
        baseSprites.mid_right.loadGraphic("assets/images/muffin/base/mid_right_"+ _get_color() +".png");
        baseSprites.right.loadGraphic("assets/images/muffin/base/right_"+ _get_color() +".png");

        position_sprites();
    }

    public function hit() {
        unselect();
        velocity.y = -3 * GameConst.SPEED;
        velocity.x = 0;
        toppin.animation.play("run");
        alive = false; //No longer alive but still update to go to heaven
//            this.onMistake();
    }

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

        if (alive) {
            /*
            for (touch in FlxG.touches.list) {
                if (touch.pressed) {
                    var mox = touch.x,
                        moy = touch.y,
                        width = 200 * Muffin.SCALE,
                        height = 220 * Muffin.SCALE;
                    if (mox > x && mox < x + width && moy > y && moy < y + height) {
                        hit(TouchAction.currentColor);
                    }
                }
            }

            selected = _color == TouchAction.currentColor;
            if (selected != displaySelected)
            {
                if (selected)
                {
                    select();
                } else {
                    unselect();
                }
            }
            */
        
            if (velocity.x > 0 && x > GameConst.CUPCAKES_PATH[path_step].x) {
                y += x - GameConst.CUPCAKES_PATH[path_step].x;
                x = GameConst.CUPCAKES_PATH[path_step].x;
                if (++path_step == GameConst.CUPCAKES_PATH.length) {
                    kill();
                    return ;
                }
                velocity.y = velocity.x;
                velocity.x = 0;
            } else if (velocity.y > 0 && y > GameConst.CUPCAKES_PATH[path_step].y) {
                var next_x = GameConst.CUPCAKES_PATH[path_step + 1].x;
                if (next_x > x) {
                    x += y - GameConst.CUPCAKES_PATH[path_step].y;
                    y = GameConst.CUPCAKES_PATH[path_step].y;
                    path_step++;
                    velocity.x = velocity.y;
                    velocity.y = 0;
                } else {
                    x -= y - GameConst.CUPCAKES_PATH[path_step].y;
                    y = GameConst.CUPCAKES_PATH[path_step].y;
                    path_step++;
                    velocity.x = -velocity.y;
                    velocity.y = 0;
                }
            } else if (velocity.x < 0 && x < GameConst.CUPCAKES_PATH[path_step].x) {
                y += GameConst.CUPCAKES_PATH[path_step].x - x;
                x = GameConst.CUPCAKES_PATH[path_step].x;
                path_step++;
                velocity.y = -velocity.x;
                velocity.x = 0;
            }
        }

        if (y + 150 < 0) {
            kill();
            return ;
        }
	}

    public function select() {
        FlxG.sound.play("assets/sounds/select_muffin.wav");
        displaySelected = true;
        selected = true;
        selectorSprite.loadGraphic("assets/images/muffin/selected.png");
        headSprite.loadGraphic("assets/images/muffin/head_selected.png");
        position_sprites();
    }

    public function unselect() {
        displaySelected = false;
        selected = false;
        selectorSprite.loadGraphic("assets/images/muffin/unselected.png");
        headSprite.loadGraphic("assets/images/muffin/head.png");
        position_sprites();
    }
}
