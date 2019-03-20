package entities;

import entities.BaseMuffin;
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

class Spikey extends BaseMuffin
{
	public function new()
	{
		super(0, 0);

        loadGraphic("assets/images/muffin/stickey.png");
        origin.set(0, 0);
        scale.set(GameConst.CUPCAKE_SCALE, GameConst.CUPCAKE_SCALE);
	}

    private override function _getSpriteId() : String
    {
        return null;
    }

    public override function canCombo()
    {
        return false;
    }

    public override function updateNextDirection()
    {
        /*
        var onlySpikey = true;
        var nextRight : BaseMuffin = rightMuffin;
        while (nextRight != null) {
            if (nextRight.getType() != "spikey") {
                onlySpikey = false;
                break;
            }
            nextRight = nextRight.rightMuffin;
        }
        return onlySpikey || leftMuffin == null || (leftMuffin.forward > 0 && path_progress - leftMuffin.path_progress <= GameConst.SPAWN_GAP + 1) ? 1 : -GameConst.BACKWARD_SPEED_FACTOR;
        */
        forward = 1;
    }

    public override function getType() : String {
        return "spikey";
    }
}
