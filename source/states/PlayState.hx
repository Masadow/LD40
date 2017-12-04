package states;

import flixel.FlxState;
import entities.Conveyor;
import entities.Muffin;
import entities.Selector;
import entities.UI;
import flixel.FlxG;
import states.GameOverState;
import entities.Background;
import flixel.input.keyboard.FlxKey;

class PlayState extends FlxState
{
	public static var A_KEY = FlxKey.ONE;
	public static var S_KEY = FlxKey.TWO;
	public static var D_KEY = FlxKey.THREE;
	public static var F_KEY = FlxKey.FOUR;

	public var conveyor : Conveyor;
	public var selector : Selector;
	public var ui : UI;

	override public function create():Void
	{
		super.create();

		ui = new UI();
		selector = new Selector();
		conveyor = new Conveyor(180);

		add(new Background());
		add(conveyor);
		add(ui);
	}

	public function hasFoundSelection(muffin : Muffin) {
		if (muffin.velocity.x > 0) {
			var mox = FlxG.mouse.x,
				moy = FlxG.mouse.y,
				mux = muffin.x,
				muy = muffin.y,
				width = 130,
				height = 150;
			if (mox > mux && mox < mux + width && moy > muy && moy < muy + height) {
				selector.select(muffin);
			}
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		selector.update(elapsed);

		if (UI.health <= 0) {
			FlxG.switchState(new GameOverState(UI.score));
			return ;
		}

		if (FlxG.mouse.justPressed) {
			conveyor.forEachMuffin(hasFoundSelection);
		}
	}
}
