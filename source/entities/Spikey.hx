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

    private override function getNextDirection()
    {
        return 1;
    }

    public override function getType() : String {
        return "spikey";
    }
}
