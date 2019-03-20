package entities.bonus;
import entities.UI;
import states.PlayState;

class Life extends Bonus {
    public function new()
    {
        super();
        asset_id = "life";
    }

    override public function trigger(ps : PlayState)
    {
        UI.health++;
    }
}