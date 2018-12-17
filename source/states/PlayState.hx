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
		conveyor = new Conveyor(270);

		add(new Background());
		add(conveyor);
		add(ui);
	}

	public function hasFoundSelection(muffin : Muffin, pointer : FlxPointer) {
		if (muffin.velocity.x > 0) {
			var mox = pointer.x,
				moy = pointer.y,
				mux = muffin.x,
				muy = muffin.y,
				width = 200 * Muffin.SCALE,
				height = 220 * Muffin.SCALE;
			#if FLX_TOUCH
			if (mox < 200)
			{
				return ;
			}
			#end
			if (mox > mux && mox < mux + width && moy > muy && moy < muy + height) {
				muffin.hitCombo(TouchAction.selected.key());
//				selector.select(muffin);
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

		#if FLX_MOUSE
		if (FlxG.mouse.justPressed) {
			conveyor.forEachMuffin(hasFoundSelection, FlxG.mouse);
		}
		#end
		#if FLX_TOUCH
		for (touch in FlxG.touches.list) {
			if (touch.justPressed) {
				conveyor.forEachMuffin(hasFoundSelection, touch);
			}
		}
		#end
	}
}
