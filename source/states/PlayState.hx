package states;

import flixel.FlxState;
import entities.Conveyor;
import entities.Muffin;
import entities.Selector;
import entities.UI;
import entities.TouchAction;
import flixel.FlxG;
import states.GameOverState;
import entities.Background;
import flixel.input.keyboard.FlxKey;
import flixel.input.FlxPointer;


class PlayState extends FlxState
{
	public var conveyor : Conveyor;
	public var selector : Selector;
	public var ui : UI;

	override public function create():Void
	{
		super.create();

		ui = new UI();
		selector = new Selector();
		conveyor = new Conveyor(270);

		add(new Background());
		add(conveyor);
		add(ui);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		selector.update(elapsed);

		if (UI.health <= 0) {
			FlxG.switchState(new GameOverState(UI.score));
			return ;
		}
	}
}
