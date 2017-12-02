package;

import flixel.FlxState;
import entities.Conveyor;
import entities.Muffin;
import entities.Selector;
import entities.UI;
import flixel.group.FlxGroup;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxBasic;

class PlayState extends FlxState
{
	public var muffins : FlxGroup;
	public var conveyor : Conveyor;
	public var selector : Selector;
	public var ui : UI;

	override public function create():Void
	{
		super.create();

		ui = new UI();
		muffins = new FlxGroup();
		conveyor = new Conveyor(250, muffins);
		selector = new Selector();

		add(ui);
		add(conveyor);
		add(muffins);
		add(selector);
	}

	public function hasFoundSelection(basic_muffin : FlxBasic) {
		var muffin : Muffin = cast(basic_muffin);

		if (FlxG.mouse.overlaps(muffin)) {
			selector.select(muffin);
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed) {
			muffins.forEachAlive(hasFoundSelection);
		}
	}
}
