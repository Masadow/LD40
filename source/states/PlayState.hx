package states;

import flixel.FlxState;
import entities.Conveyor;
import entities.Muffin;
import entities.Selector;
import entities.UI;
import entities.WorkStation;
import flixel.FlxG;
import states.GameOverState;
import entities.Background;
import flixel.input.keyboard.FlxKey;
import flixel.input.FlxPointer;
import flixel.util.FlxColor;
import entities.SelectionArrow;
import flixel.FlxSprite;
import flixel.FlxBasic;


class PlayState extends FlxState
{
	public static var A_KEY = FlxKey.ONE;
	public static var S_KEY = FlxKey.TWO;
	public static var D_KEY = FlxKey.THREE;
	public static var F_KEY = FlxKey.FOUR;

	public var conveyor : Conveyor;
	public var selector : Selector;
	public var workstations : Array<WorkStation>;
	public var workstation_selected : Int;
	public var ui : UI;
	public var push_button : FlxSprite;

	override public function create():Void
	{
		super.create();

		ui = new UI();
		selector = new Selector();
		workstations = new Array<WorkStation>();
		workstations.push(new WorkStation(A_KEY, FlxColor.RED, 100));
		workstations.push(new WorkStation(S_KEY, FlxColor.MAGENTA, 300));
		workstations.push(new WorkStation(D_KEY, FlxColor.CYAN, 500));
		workstations.push(new WorkStation(F_KEY, FlxColor.ORANGE, 700));
		workstations.push(new WorkStation(A_KEY, FlxColor.RED, 900));
		workstations.push(new WorkStation(S_KEY, FlxColor.MAGENTA, 1100));
		workstations.push(new WorkStation(D_KEY, FlxColor.CYAN, 1300));
		workstations.push(new WorkStation(F_KEY, FlxColor.ORANGE, 1500));
		conveyor = new Conveyor(450);

		workstation_selected = 0;
		workstations[0].select();

		add(new Background());
		for (workstation in workstations) {
			add(workstation);
		}
		add(conveyor);
		add(ui);

		add(new SelectionArrow(this, -1, 1200));
		add(new SelectionArrow(this, 1, 1500));

		push_button = new FlxSprite(200, 780);
		push_button.makeGraphic(150, 150, FlxColor.RED, true);
		add(push_button);
	}

	public function hasFoundSelection(muffin : Muffin, pointer : FlxPointer) {
		if (muffin.velocity.x > 0) {
			var mox = pointer.x,
				moy = pointer.y,
				mux = muffin.x,
				muy = muffin.y,
				width = 200,
				height = 220;
			#if FLX_TOUCH
			if (mox < 200)
			{
				return ;
			}
			#end
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

		#if FLX_MOUSE
		if (FlxG.mouse.justPressed) {
//			conveyor.forEachMuffin(hasFoundSelection, FlxG.mouse);
			if (FlxG.mouse.overlaps(push_button)) {
				triggerWorkstation();
			}
		}
		#end
		#if FLX_TOUCH
		for (touch in FlxG.touches.list) {
			if (touch.justPressed) {
//				conveyor.forEachMuffin(hasFoundSelection, touch);
				if (touch.overlaps(push_button)) {
					triggerWorkstation();
				}
			}
		}
		#end
	}

	public function triggerWorkstation()
	{
		conveyor.belts[0].muffins.forEachAlive(function (basic_muffin : FlxBasic) {
			var muffin : Muffin = cast basic_muffin;
			var muffin_middle = muffin.x + muffin.width / 2;
			if (muffin_middle >= workstations[workstation_selected].x && muffin_middle <= workstations[workstation_selected].x + workstations[workstation_selected].width)
			{
				muffin.hitCombo(workstations[workstation_selected].key);
			}
		});
	}
}
