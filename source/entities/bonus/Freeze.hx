package entities.bonus;
import entities.UI;
import states.PlayState;

class Freeze extends Bonus {
    public function new()
    {
        super();
        asset_id = "powerup";
    }

    override public function trigger(ps : PlayState)
    {
        ps.freezeTimer = 3;
    }
}