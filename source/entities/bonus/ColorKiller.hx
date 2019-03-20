package entities.bonus;

import entities.UI;
import states.PlayState;

class ColorKiller extends Bonus {
    public function new()
    {
        super();
        asset_id = "powerup";
    }

    override public function trigger(ps : PlayState)
    {
        var goal = muffins.first().goal;
        var toKill = new List<BaseMuffin>();
        var skipFirst = true;

        //Turn all cupcakes to the bonus color
        for (muffin in ps.muffins) {
            if (skipFirst) {
                skipFirst = false;
            }
            else if (muffin.alive && muffin.getType() == "muffin" && (cast muffin).goal == goal) {
                toKill.push(muffin);
            }
        }

        ps.validateMuffins(toKill);
    }
}