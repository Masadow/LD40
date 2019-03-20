package entities;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.math.FlxPoint;
import flixel.graphics.frames.FlxFrame;
import openfl.geom.Point;
import states.PlayState;
import entities.bonus.Bonus;

typedef BaseSprites = {
    left: FlxSprite,
    mid_left: FlxSprite,
    mid_right: FlxSprite,
    right: FlxSprite
}

class BaseMuffin extends FlxSprite
{
    static var cacheGraphics : Map<String, FlxSprite> = new Map<String, FlxSprite>(); 

    private var path_step : Int;
    public var path_progress : Float;
    private var forward : Int;
    public var selected(default, set) : Bool;

    public var rightMuffin : BaseMuffin;
    public var leftMuffin : BaseMuffin;

	private function new(x : Int = 0, y : Int = 0)
	{
		super(x, y);

        selected = false;
	}

    public function hit()
    {
        alive = false;
        velocity.y = -GameConst.SPEED;
        velocity.x = 0;
        var tmpRight = rightMuffin;
        if (rightMuffin != null) {
            rightMuffin.leftMuffin = leftMuffin;
        }
        if (leftMuffin != null) {
            leftMuffin.rightMuffin = tmpRight;
        }
        leftMuffin = null;
        rightMuffin = null;
    }

    private function distanceMadeOnPath()
    {
        var path = GameConst.CUPCAKES_PATH[PlayState.level][path_step - 1];
        if (path.x == x) {
            return y - path.y;
        } else if (path.x > x) {
            return path.x - x;
        } else {
            return x - path.x;
        }
    }

    private function distanceLeftOnPath()
    {
        var path = GameConst.CUPCAKES_PATH[PlayState.level][path_step];
        if (path.x == x) {
            return path.y - y;
        } else if (path.x > x) {
            return path.x - x;
        } else {
            return x - path.x;
        }
    }

    override public function kill()
    {
        super.kill();
        var tmpRight = rightMuffin;
        if (rightMuffin != null) {
            rightMuffin.leftMuffin = leftMuffin;
        }
        if (leftMuffin != null) {
            leftMuffin.rightMuffin = tmpRight;
        }
        leftMuffin = null;
        rightMuffin = null;
    }

    static public function pathDistanceBetween(leftMuffin : BaseMuffin, rightMuffin : BaseMuffin) : Float
    {
        if (rightMuffin.path_step - leftMuffin.path_step > 1) {
            return 1000; // A bit hacky but I don't mind precision when cupcakes are so far from each other
        } else if (rightMuffin.path_step != leftMuffin.path_step) {
            var right_path = rightMuffin.distanceMadeOnPath();
            var left_path = leftMuffin.distanceLeftOnPath();
            return left_path + right_path;
        } else {
            var right_path = rightMuffin.distanceMadeOnPath();
            var left_path = leftMuffin.distanceMadeOnPath();
            return right_path - left_path;
        }
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if (alive) {
            forward = getNextDirection();
            updateVelocity(elapsed);
            if (path_step == GameConst.CUPCAKES_PATH[PlayState.level].length) {
                onPathEnd();
                return ;
            }

            // It won't change orientation till next loop
        } else if (y < -height * GameConst.CUPCAKE_SCALE) {
            kill();
        }
    }

    private function onPathEnd()
    {
        kill();
    }

    private function getNextDirection()
    {
        return leftMuffin == null || (leftMuffin.forward > 0 && path_progress - leftMuffin.path_progress <= GameConst.SPAWN_GAP + 1) ? 1 : -GameConst.BACKWARD_SPEED_FACTOR;
    }

    private function updateVelocity(elapsed : Float)
    {
        var to_move = Math.abs(GameConst.SPEED * elapsed * forward);
        if (forward < 0) {
            to_move = Math.min(to_move, path_progress - (leftMuffin.path_progress + GameConst.SPAWN_GAP));
        }

        path_progress += to_move * (forward > 0 ? 1 : -1);

        while (to_move > 0 && path_step < GameConst.CUPCAKES_PATH[PlayState.level].length) {
            var origin = GameConst.CUPCAKES_PATH[PlayState.level][path_step - (forward > 0 ? 1 : 0)];
            var dest = GameConst.CUPCAKES_PATH[PlayState.level][path_step - (forward > 0 ? 0 : 1)];

            if (origin.x != dest.x) {
                x += origin.x < dest.x ? to_move : -to_move;
                if ((origin.x < dest.x && x > dest.x) || (origin.x > dest.x && x < dest.x)) {
                    to_move = origin.x < dest.x ? x - dest.x : dest.x - x;
                    x = dest.x;
                    path_step += forward > 0 ? 1 : -1;
                } else {
                    to_move = 0;
                }
            } else {
                y += origin.y < dest.y ? to_move : -to_move;
                if ((origin.y < dest.y && y > dest.y) || (origin.y > dest.y && y < dest.y)) {
                    to_move = origin.y < dest.y ? y - dest.y : dest.y - y;
                    y = dest.y;
                    path_step += forward > 0 ? 1 : -1;
                } else {
                    to_move = 0;
                }
            }
        }
    }

    public function resetPath()
    {
        path_step = 1;
        x = GameConst.CUPCAKES_PATH[PlayState.level][0].x;
        y = GameConst.CUPCAKES_PATH[PlayState.level][0].y;
        velocity.x = 0;
        velocity.y = 0;
        forward = 1;
        path_progress = 0;
    }

    public function canCombo() {
        return true;
    }

    private function _getSpriteId() : String
    {
        return null;
    }

    private function refresh_sprite()
    {
        var spriteId = _getSpriteId();
        if (spriteId != null) {
            loadGraphicFromSprite(cacheGraphics.get(spriteId));
            origin.set(0, 0);
            scale.set(GameConst.CUPCAKE_SCALE, GameConst.CUPCAKE_SCALE);
        }
    }

    private function set_selected(new_val : Bool) : Bool
    {
        if (selected != new_val) {
            selected = new_val;
            refresh_sprite();
        }
        return new_val;
    }

    private static function buildAsset(key : String, base : FlxSprite, face : FlxSprite, selector : FlxSprite, bonus : FlxSprite)
    {
        var muffin = new FlxSprite(0, 0);

        muffin.makeGraphic(GameConst.CUPCAKE_WIDTH, GameConst.CUPCAKE_HEIGHT, FlxColor.TRANSPARENT, true, key);

        if (selector != null) {
            muffin.pixels.copyPixels(selector.pixels, selector.pixels.rect, new Point(0, 0), null, null, true);
        }
        muffin.pixels.copyPixels(base.pixels, base.pixels.rect, new Point(0, 0), null, null, true);
        muffin.pixels.copyPixels(face.pixels, face.pixels.rect, new Point(0, 0), null, null, true);
        if (bonus != null) {
            muffin.pixels.copyPixels(bonus.pixels, bonus.pixels.rect, new Point(0, 0), null, null, true);
        }

        cacheGraphics.set(key, muffin);
    }

    private static function _get_color(color : FlxColor) : String {
        if (color == FlxColor.RED) {
            return "red";
        } else if (color == FlxColor.GREEN) {
            return "green";
        } else if (color == FlxColor.BLUE) {
            return "blue";
        } else if (color == FlxColor.YELLOW) {
            return "yellow";
        }
        return "";
    }

    public static function buildAssets()
    {
//        var headSprite = new FlxSprite(0, 0, "assets/images/muffin/head.png");
//        var selectorSprite = new FlxSprite(0, 0, "assets/images/muffin/unselected.png");
//        var headSprite2 = new FlxSprite(0, 0, "assets/images/muffin/head_selected.png");
        var selectorSprite2 = new FlxSprite(0, 0, "assets/images/muffin/selected_cupcake.png");
        var smile = new FlxSprite(0, 0, "assets/images/muffin/face_heart.png");
        var smile_selected = new FlxSprite(0, 0, "assets/images/muffin/face_select.png");
        for (color in GameConst.COLORS) {
            var base = new FlxSprite(0, 0, "assets/images/muffin/" + _get_color(color) + ".png");
            buildAsset("muffin_unselected_" + _get_color(color), base, smile, null, null);
            buildAsset("muffin_selected_" + _get_color(color), base, smile_selected, selectorSprite2, null);

            for (bonus in GameConst.BONUSES) {
                var bonus_id = Type.getClassName(bonus).split(".").pop().toLowerCase();
                var bonus_asset = new FlxSprite(0, 0, "assets/images/bonus/" + bonus_id + ".png");
                buildAsset("muffin_" + bonus_id + "_unselected_" + _get_color(color), base, smile, null, bonus_asset);
                buildAsset("muffin_" + bonus_id + "_selected_" + _get_color(color), base, smile_selected, selectorSprite2, bonus_asset);

                /*
                buildAsset("muffin_unselected_" + _get_color(color), headSprite, selectorSprite,
                    new FlxSprite(0, 0, "assets/images/muffin/base/left_" + _get_color(color) + ".png"),
                    new FlxSprite(0, 0, "assets/images/muffin/base/mid_left_" + _get_color(color) + ".png"),
                    new FlxSprite(0, 0, "assets/images/muffin/base/mid_right_" + _get_color(color) + ".png"),
                    new FlxSprite(0, 0, "assets/images/muffin/base/right_" + _get_color(color) + ".png"));

                buildAsset("muffin_selected_" + _get_color(color), headSprite2, selectorSprite2,
                    new FlxSprite(0, 0, "assets/images/muffin/base/left_" + _get_color(color) + ".png"),
                    new FlxSprite(0, 0, "assets/images/muffin/base/mid_left_" + _get_color(color) + ".png"),
                    new FlxSprite(0, 0, "assets/images/muffin/base/mid_right_" + _get_color(color) + ".png"),
                    new FlxSprite(0, 0, "assets/images/muffin/base/right_" + _get_color(color) + ".png"));
                */
            }
        }
    }

    public function isForward() {
        return forward > 0;
    }

    public function getType() : String {
        return null;
    }
}