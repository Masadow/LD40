package entities.bonus;
import entities.UI;

class Life extends Bonus {
    public function new()
    {
        super();
        id = "life";
    }

    override public function trigger()
    {
        UI.health++;
    }
}