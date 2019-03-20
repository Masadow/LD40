package entities.bonus;
import entities.UI;
import states.PlayState;

class ColorSwapper extends Bonus {
    public function new()
    {
        super();
        asset_id = "powerup";
    }

    override public function trigger(ps : PlayState)
    {
        var goal = muffins.first().goal;

        //Turn all cupcakes to the bonus color
        for (muffin in ps.muffins) {
            if (muffin.getType() == "muffin") {
                var m : Muffin = cast muffin;
                m.goal = goal;
            }
        }

        //Also turn current spawn color to the bonus color
        //It is useful to prevent mixed color for a bonus that is currently spawning
        var nid = 0;
        for (c in GameConst.COLORS) {
            if (c == goal) {
                ps.last_id = nid;
                break;
            }
            nid++;
        }
    }
}