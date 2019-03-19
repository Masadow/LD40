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

class Muffin extends BaseMuffin
{
    public var goal(default, set) : Null<FlxColor>;
    public var bonus(default, set) : Bonus;

	public function new(color : Null<FlxColor> = null)
	{
		super(0, 0);

        bonus = null;
        goal = color;
	}

    private override function _getSpriteId() : String
    {
        if (goal != null) {
            var selected_str = (selected ? "" : "un") + "selected";
            var bonus_str = bonus != null ? (bonus.id + "_") : "";
            return "muffin_" + bonus_str + selected_str + "_" + BaseMuffin._get_color(goal);
        }
        return null;
    }

    private function set_goal(new_val : Null<FlxColor>) : Null<FlxColor>
    {
        if (goal != new_val) {
            goal = new_val;
            refresh_sprite();
        }
        return new_val;
    }

    private function set_bonus(new_val : Bonus) : Bonus
    {
        if (bonus != new_val) {
            bonus = new_val;
            refresh_sprite();
        }
        return new_val;
    }

    public override function getType() : String {
        return "muffin";
    }

    private override function onPathEnd() {
        UI.loseLife();
        super.onPathEnd();
    }
}
