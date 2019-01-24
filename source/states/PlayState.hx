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
import flixel.FlxSprite;
import flixel.util.FlxColor;


class PlayState extends FlxState
{
	public var conveyor : Conveyor;
	public var selector : Selector;
	public var ui : UI;
	public var pause : FlxSprite;

	override public function create():Void
	{
		super.create();

		FlxG.debugger.visible = true;

		ui = new UI();
		selector = new Selector();
		conveyor = new Conveyor(270);

		add(new Background());
		add(conveyor);
		add(ui);

		pause = new FlxSprite(FlxG.width - 200, FlxG.height - 200);
		pause.makeGraphic(150, 150, FlxColor.WHITE);
		add(pause);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		selector.update(elapsed);

		if (UI.health <= 0) {
			FlxG.switchState(new GameOverState(UI.score));
			return ;
		}

		for (touch in FlxG.touches.list) {
			if (touch.justPressed) {
				if (touch.x > pause.x && touch.x < pause.x + pause.width && touch.y > pause.y && touch.y < pause.y + pause.height) {
					openSubState(new PauseState());
				}
			}
		}
	}
}
